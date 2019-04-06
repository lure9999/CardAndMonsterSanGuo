#include "NetManage.h"

#if defined (__WINDOWS__) || defined (WIN32)
#include <process.h>
#else
#include <errno.h>
//#include <sys/signal.h>
#include <pthread.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <arpa/inet.h>
#define Sleep(x) usleep(x*1000)
#endif

#include "CCLuaEngine.h"
#include "Lua_extensions_CCB.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif
using namespace cocos2d;

#if defined (__WINDOWS__) || defined (WIN32)
unsigned __stdcall NetManageThread( void* pParam )
#else 
void* NetManageThread(void * pParam)
#endif
{
	CNetManage* pNetManage = reinterpret_cast<CNetManage*>(pParam);

	while(true)
	{
		if (!pNetManage->IsStopThread())
		{
			return NULL;
		}
		
		if(!pNetManage->processSocketStream())
		{
			//错误了自动连接不退出线程
			//设置状态断线放到lua线程处理
			pNetManage->SetNetState(E_NetState_Error);		

		}
		
		Sleep(100);
	}
}

CNetManage::CNetManage(void)
{	
	pthread_mutex_init(&m_RecvMutex, NULL);
	pthread_mutex_init(&m_EventMutex, NULL);
	pthread_mutex_init(&m_ENetStateMutex, NULL);
	m_SNetStreamPool.Init(50, 10);
	m_SocketState = E_SocketState_NONE;
	m_ENetState = E_NetState_None;
	InitWinSocketDll();
	CreatNetWorkThread();
}


CNetManage::~CNetManage(void)
{
	DestroyNetWorkThread();	
	pthread_mutex_destroy(&m_RecvMutex);
	pthread_mutex_destroy(&m_EventMutex);
	pthread_mutex_destroy(&m_ENetStateMutex);	
	m_SNetStreamPool.UnInit();
	m_SocketState = E_SocketState_NONE;
}

bool CNetManage::CreatNetWorkThread()
{
	m_nStopThread = 0;
#if defined (__WINDOWS__) || defined (WIN32)
	unsigned threadID;

	m_NetWorkhThread = (HANDLE)_beginthreadex( NULL, 0, NetManageThread, ( LPVOID )this, 0,&threadID );

	if(m_NetWorkhThread == INVALID_HANDLE_VALUE)
	{
		// 开启接收线程失败，重拾		
		return false;
	}
#else
	int nResult = 0;
	nResult = pthread_create(&m_NetWorkhThreadID, 0, NetManageThread, (void *)this);
	if (nResult != 0)
	{
		// 开启接收线程失败，重拾
		return false;
	}		
#endif

	m_nStopThread = 1;

	return true;
}


bool CNetManage::DestroyNetWorkThread()
{
	m_nStopThread = 0;
#if defined (__WINDOWS__) || defined (WIN32)

	WaitForSingleObject(m_NetWorkhThread, 500);
	WSACleanup();
	DWORD dwError = 0;

#else
	void *tret;
	pthread_join(m_NetWorkhThreadID, &tret);

#endif
	return true;
}

int CNetManage::InitNetWork()
{
	// 线程里做
	/*m_Socket.create();
	m_Socket.setNonBlocking();*/

	Event_Node _EventNode;	
	_EventNode.m_nSocketEvent = E_SocketEvent_Creat;	
	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_EventNode);
	pthread_mutex_unlock(&m_EventMutex);
	
	return 1;
}

void CNetManage::DestroyNetWork()
{
	// 在线程里做
	/*m_Socket.close();
	m_GSRecvBuf.Clear();
	m_MSRecvBuf.Clear();*/

	Event_Node _EventNode;	
	_EventNode.m_nSocketEvent = E_SocketEvent_Close;	
	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_EventNode);
	pthread_mutex_unlock(&m_EventMutex);
	cocos2d::CCLog("DestroyNetWork");

}

int CNetManage::CnnGateServer(const char* szSrvIP, int nPort)
{
	// 在线程里做
	//m_Socket.connect(szSrvIP,nPort);
	//m_SocketState = E_SocketState_GS;

	Event_Node _EventNode;	
	_EventNode.m_nSocketEvent = E_SocketEvent_Connect;

	SNetStream* pNetStream = LD_POOL_NEW(m_SNetStreamPool);
	int iSocketState = E_SocketState_GS;
	*pNetStream << iSocketState << szSrvIP << nPort << end;
	_EventNode.m_pNetStream = pNetStream;
	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_EventNode);
	pthread_mutex_unlock(&m_EventMutex);

	return iSocketState;
}

int CNetManage::CnnLogicServer(const char* szSrvIP, int nPort)
{
	// 在线程里做
	//m_Socket.connect(szSrvIP,nPort);
	//m_SocketState = E_SocketState_MS;

	Event_Node _EventNode;	
	_EventNode.m_nSocketEvent = E_SocketEvent_Connect;

	SNetStream* pNetStream = LD_POOL_NEW(m_SNetStreamPool);
	int iSocketState = E_SocketState_MS;
	*pNetStream << iSocketState << szSrvIP << nPort << end;
	_EventNode.m_pNetStream = pNetStream;
	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_EventNode);
	pthread_mutex_unlock(&m_EventMutex);

	return iSocketState;
}

void CNetManage::DisconnetServer(int ESocketState)
{
	// 在线程里做
	// m_Socket.close();
	// m_SocketState = E_SocketState_NONE;

	if (m_SocketState != (SocketState )ESocketState)
	{
		cocos2d::CCLog("DisconnetServer err m_SocketState 不对");
	}
	

	Event_Node _EventNode;	
	_EventNode.m_nSocketEvent = E_SocketEvent_Close;	
	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_EventNode);
	pthread_mutex_unlock(&m_EventMutex);
}

SNetStream* CNetManage::GetRecvNode()
{
	pthread_mutex_lock(&m_RecvMutex);
	RecvList::iterator iter = m_RecvList.begin();
	if (iter == m_RecvList.end())
	{
		pthread_mutex_unlock(&m_RecvMutex);
		return NULL;
	}
	SNetStream* pStream = iter->m_pNetStream;
	m_RecvList.erase(iter);
	pthread_mutex_unlock(&m_RecvMutex);
	return pStream;

}

void CNetManage::DelRecvNode(SNetStream *pStream)
{
	m_SNetStreamPool.Delete(pStream);
}

void CNetManage::SendPackage(int ESocketState, int nCmd1, int nCmd2, int nCmd3, int nCmd4, const char* szSendBuffer, int nLen)
{
	SNetStream *pNetStream = LD_POOL_NEW(m_SNetStreamPool);
	*pNetStream << nCmd1 << nCmd2 << nCmd3 << nCmd4 << szSendBuffer << end;

	Event_Node _SendNode;
	_SendNode.m_nSocketEvent = (SocketEvent)ESocketState;
	_SendNode.m_pNetStream = pNetStream;
	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_SendNode);
	pthread_mutex_unlock(&m_EventMutex);
}

int CNetManage::RecvPackage(char* pBuf, int nLen)
{
	int nRead = OnRead(pBuf, nLen);

	return nRead;
}


int CNetManage::InitWinSocketDll()
{
#if defined (__WINDOWS__) || defined (WIN32)
	//Init winsocket
	WSADATA wsaData;
	if(0!=WSAStartup( MAKEWORD( 2, 2 ), &wsaData)  ||
		(LOBYTE( wsaData.wVersion ) != 2 ||	HIBYTE( wsaData.wVersion ) != 2 ) )
	{
		WSACleanup();		
		cocos2d::CCLog("Could not find a usable WinSock DLL!");
		return 0;
	}
#endif
	return 1;
}

int CNetManage::OnRead(char* pBuf, int nLen)
{
	static const int SIZEHEADER = 8;
	int nRemainLen = nLen;
	int nTimes = 0;
	while( nRemainLen >= 2 )
	{
		nTimes++;
		unsigned short wPacketLen = *( unsigned short* )pBuf;
		if ( wPacketLen < SIZEHEADER || wPacketLen > 4096)
		{
			return -1;
		}

		if (wPacketLen > (unsigned short)nRemainLen)
		{
			break;
		}

		if (*(unsigned short* )(&pBuf[ wPacketLen - 2])!= (unsigned short)~wPacketLen)
		{
			// 非法包，末尾不是长度的反码

			return -2;
		}
		{
			SNetStream* pNetStream = LD_POOL_NEW(m_SNetStreamPool);
			pNetStream->CopyMsgBuf(pBuf, wPacketLen);
			Recv_Node _RecvNode;			
			_RecvNode.m_pNetStream = pNetStream;

			pthread_mutex_lock(&m_RecvMutex);
			m_RecvList.push_back(_RecvNode);
			pthread_mutex_unlock(&m_RecvMutex);
		}
		// 指针到下一个包位置
		nRemainLen -= wPacketLen;
		pBuf += wPacketLen;
	}
	//printf("=========================================\n");
	//printf("last len = (%d)\n", nLen - nRemainLen);
	//printf("last info = (%s)\n", pBuf);
	//printf("=========================================\n");
	return ( nLen - nRemainLen );

}

bool CNetManage::CnnServer(const char* szSrvIP, int nPort)
{
	SNetStream* pNetStream = LD_POOL_NEW(m_SNetStreamPool);
	*pNetStream << szSrvIP << nPort << end;

	Event_Node _EventNode;	
	_EventNode.m_nSocketEvent = E_SocketEvent_Connect;
	_EventNode.m_pNetStream = pNetStream;

	pthread_mutex_lock(&m_EventMutex);
	m_EventList.push_back(_EventNode);
	pthread_mutex_unlock(&m_EventMutex);

	return true;
}

bool CNetManage::processSocketStream()
{
	if (IsNetDisConnect())
	{
		return true;
	}
	
	if(!_processEvent())
	{
		return true;
	}
	if(!m_Socket.isValid())
	{
		return true;
	}
	//socket stream
	if(!_select() || !_processExcept() || !_processInput() || !_processOutput())
	{		
		return false;
	}
	return true;
}

bool CNetManage::_select()
{
	FD_ZERO(&(m_ReadFD));
	FD_ZERO(&(m_WriteFD));
	FD_ZERO(&(m_ExceptFD));

	FD_SET(m_Socket.getSOCKET(), &(m_ReadFD));
	FD_SET(m_Socket.getSOCKET(), &(m_WriteFD));
	FD_SET(m_Socket.getSOCKET(), &(m_ExceptFD));

	timeval	Timeout ;
	Timeout.tv_sec = 0 ;
	Timeout.tv_usec = 0 ;

	int result;

#if defined (__WINDOWS__) || defined (WIN32)
	result = select(0, &m_ReadFD, &m_WriteFD, &m_ExceptFD, &Timeout);   
	if(-1 == result) 
	{
		int nErr = WSAGetLastError();
		cocos2d::CCLog("select  errno = %d errinfo = %s", nErr, strerror(nErr));
		return false;
	}
#else			
	result = select(((int)m_Socket.getSOCKET() + 1), &m_ReadFD, &m_WriteFD, &m_ExceptFD, &Timeout);    
	if(-1 == result) 
	{				
		cocos2d::CCLog("select  errno = %d errinfo = %s", errno, strerror(errno));
		return false;
	}
#endif
	
	return true;
}

bool CNetManage::_processInput()
{
	
	if(FD_ISSET(m_Socket.getSOCKET(), &(m_ReadFD)))
	{	
		bool ret = false;

		int nRecvTimeLen = m_Socket.receive(m_RecvBuf.GetIdleBuffer(),m_RecvBuf.GetIdleLength());			
				
		if (nRecvTimeLen == 0)
		{
			// disconnet to server
#if defined (__WINDOWS__) || defined (WIN32)
			int nErr = WSAGetLastError();
			cocos2d::CCLog("Socket recv = 0 errno = %d errinfo = %s", nErr, strerror(nErr));
#else
			cocos2d::CCLog("Socket recv = 0 errno = %d errinfo = %s", errno, strerror(errno));
						
#endif						
			
		}
		else if (nRecvTimeLen < 0 )
		{
#if defined (__WINDOWS__) || defined (WIN32)
			int nErr = WSAGetLastError();
			cocos2d::CCLog("****S==ReceiveThread Gs Error  nRecvTimeLen <0 err = %d **** \n",nErr);
			if (nErr == WSAEWOULDBLOCK)
			{							
				//continue;
			}
			else //if (nErr == WSAENETDOWN || nErr == WSAECONNRESET || nErr == WSAENOTSOCK)
			{
				
				
			}					
#else
		//	cocos2d::CCLog("****S==ReceiveThread Gs Error  nRecvTimeLen <0 err = %d **** \n",errno);
			if(errno == EINTR || errno == EAGAIN)
			{							
				//continue;
			}
				else if(errno == 107)
				{
					/* 107是你创建了socket但是没有调用connect就是用的时候会出现。
					EIO其实很不正常，一般很是出现。*/
				//continue;
				}
			else
			{			
				
			}
					
#endif
		}
		else if (nRecvTimeLen > 0)
		{
			m_RecvBuf.AddBuffer( nRecvTimeLen );

			int iRead = RecvPackage(m_RecvBuf.GetBuffer(), m_RecvBuf.GetLength( ));
			if (iRead)
			{
				m_RecvBuf.ReleaseBuffer(iRead);
			}

			ret = true;
		}
		
		if(ret == false)
		{			
			m_Socket.close();
			m_RecvBuf.Clear();	
			//DestroyNetWork();
		}

		return ret;
	}
	return true;
}

bool CNetManage::_processEvent()
{
	while(true)
	{
		pthread_mutex_lock(&(m_EventMutex));
		EventList::iterator iter = m_EventList.begin();
		if (iter == m_EventList.end())
		{
			pthread_mutex_unlock(&(m_EventMutex));	
			return true;
		}
		else
		{
			switch(iter->m_nSocketEvent)
			{		
			case E_SocketEvent_Creat:
				{						
					m_EventList.erase(iter);
					pthread_mutex_unlock(&(m_EventMutex));

					m_Socket.create();
					//非阻塞
					m_Socket.setNonBlocking();

					////阻塞
					//m_Socket.setNonBlocking(false);

					cocos2d::CCLog("_processEvent: E_SocketEvent_Creat");
					
				}
				break;
			case E_SocketEvent_Close:
				{
					m_EventList.erase(iter);
					pthread_mutex_unlock(&(m_EventMutex));

					m_Socket.close();
					m_RecvBuf.Clear();	
					
					SetNetState(E_NetState_Disconnect);
					cocos2d::CCLog("_processEvent: E_SocketEvent_Close");
				}
				break;
			case E_SocketEvent_Connect:
				{
					cocos2d::CCLog("_processEvent: E_SocketEvent_Connect");
					SNetStream *pNetStream = iter->m_pNetStream;	
					m_EventList.erase(iter);
					pthread_mutex_unlock(&(m_EventMutex));

					int iSocketState = E_SocketState_NONE;
					char* szSrvIP = NULL;
					int nPort = 0;

					*pNetStream >> iSocketState >> szSrvIP >> nPort >> end;	

					if (m_Socket.isNonBlocking())
					{
						//非阻塞
						cocos2d::CCLog("isNonBlocking == true ");
						m_Socket.connect(szSrvIP,nPort);
						while(!_CheckConnect() )
						{
							cocos2d::CCLog("connect error ");
							Sleep(1000);
							m_Socket.connect(szSrvIP,nPort);
						}
					}
					else
					{
						//阻塞的写法
						cocos2d::CCLog("isNonBlocking == false ");
						while(!m_Socket.connect(szSrvIP,nPort))
						{
							cocos2d::CCLog("connect error ");
							Sleep(1000);						
						}
					}
					
					m_SocketState = (SocketState)iSocketState;
					cocos2d::CCLog("connect ok ");
					SetNetState(E_NetState_Connect);
				}
				break;
			case E_SocketEvent_Send_GS:
			case E_SocketEvent_Send_MS:
				{
					if (m_Socket.isValid())
					{
						pthread_mutex_unlock(&(m_EventMutex));	
						return true;
					}
					else
					{
						m_EventList.erase(iter);
						pthread_mutex_unlock(&(m_EventMutex));	
					}					
						
				}
				break;
			default:
				{
					cocos2d::CCLog("_processEvent default  nSocketEvent = %d",(int)(iter->m_nSocketEvent));
					m_EventList.erase(iter);
					pthread_mutex_unlock(&(m_EventMutex));						
					//return true;
				}
				break;	
			}
		}
	}

	return true;
}

bool CNetManage::_processOutput()
{
	if(FD_ISSET(m_Socket.getSOCKET(), &(m_WriteFD)))
	{
		int nSendTimes = 5;	
		pthread_mutex_lock(&(m_EventMutex));
		EventList::iterator iter = m_EventList.begin();
		if (iter == m_EventList.end())
		{
			pthread_mutex_unlock(&(m_EventMutex));			
		}
		else
		{	
			switch(iter->m_nSocketEvent)
			{
			case E_SocketEvent_Send_GS:
			case E_SocketEvent_Send_MS:
				{
					int nSendSocketState = (int)iter->m_nSocketEvent;

					if (nSendSocketState != m_SocketState)
					{
						//说明发包的socket标示错了容错丢掉这个包
						SNetStream *pNetStream = iter->m_pNetStream;		
						int cmd1 = pNetStream->GetCmdA();
						int cmd2 = pNetStream->GetCmdB();
						cocos2d::CCLog("send error nSendSocketState != m_SocketState CmdA= %d CmdB = %d ",cmd1,cmd2);

						m_SNetStreamPool.Delete(iter->m_pNetStream);
						m_EventList.erase(iter);
						pthread_mutex_unlock(&(m_EventMutex));
					}
					else
					{
						SNetStream *pNetStream = iter->m_pNetStream;			
						m_EventList.erase(iter);
						pthread_mutex_unlock(&(m_EventMutex));

						int cmd1 = pNetStream->GetCmdA();
						int cmd2 = pNetStream->GetCmdB();
						int nLen = pNetStream->GetMsgLen();
						char* szSendbuffer = pNetStream->GetMsgBuf();
						int nSendHave = 0;
						while (nLen)
						{					
							int nSendLen = m_Socket.send(szSendbuffer + nSendHave,nLen);
							if (nSendLen < 0)
							{
                    
#if defined (__WINDOWS__) || defined (WIN32)
								int nErr = WSAGetLastError();
								cocos2d::CCLog("****SendingThread Error  nSendLen <0 err = %d **** \n",nErr);
								if (nErr == WSAEWOULDBLOCK)
								{
									Sleep(100);
									if (!nSendTimes )
									{	
										m_SNetStreamPool.Delete(pNetStream);
										m_Socket.close();
										m_RecvBuf.Clear();	
										//DestroyNetWork();
										return false;
									}
									nSendTimes--;
									continue;
								}
								else if (nErr == WSAENETDOWN || nErr == WSAECONNRESET || nErr == WSAENOTSOCK)
								{	
									m_SNetStreamPool.Delete(pNetStream);
									m_Socket.close();
									m_RecvBuf.Clear();	
									//DestroyNetWork();
									return false;
								}
					
#else
								cocos2d::CCLog("****SendingThread Error  nSendLen <0  err = %d **** \n",errno);
								if(errno == EINTR || errno == EWOULDBLOCK || errno == EAGAIN)
								{
									Sleep(100);
									if (!nSendTimes)
									{
										m_SNetStreamPool.Delete(pNetStream);
										m_Socket.close();
										m_RecvBuf.Clear();	
										//DestroyNetWork();
										return false;
									}
									nSendTimes--;
									continue;
								}
								 else if(errno == 107 || errno == 32)
								 {
									 /* 107是你创建了socket但是没有调用connect就是用的时候会出现。
									 EIO其实很不正常，一般很是出现。*/

									/*32 这个错误发生在当client端close了当前与你的server端的socket连接，但是你的server端在忙着发送数据给一个已经断开连接的socket。*/
									 m_SNetStreamPool.Delete(pNetStream);	
									 m_Socket.close();
									 m_RecvBuf.Clear();	
									// DestroyNetWork();
									 return false;
						 
								 }
								else
								{	
									m_SNetStreamPool.Delete(pNetStream);	
									m_Socket.close();
									m_RecvBuf.Clear();	
									//DestroyNetWork();
									return false;
								}
					
#endif
					
							}
							else if (nSendLen == 0)
							{
								cocos2d::CCLog("****SendingThread Error  nSendLen ==0  \n");
								m_SNetStreamPool.Delete(pNetStream);
								m_Socket.close();
								m_RecvBuf.Clear();	
								//DestroyNetWork();
								return false;
							}

							nSendHave += nSendLen;
							nLen -= nSendLen;
						}
						m_SNetStreamPool.Delete(pNetStream);
					}		
				}
				break;	
			default:
				{
					pthread_mutex_unlock(&(m_EventMutex));	
					return true;
				}
				break;	

			}

			
		}
		
	}
	return true;
}

bool CNetManage::_processExcept()
{
	if(FD_ISSET(m_Socket.getSOCKET(), &(m_ExceptFD)))
	{		
		cocos2d::CCLog("_processExcept Error \n");
		m_Socket.close() ;
		m_RecvBuf.Clear();	
		//DestroyNetWork();
		return false;
	}
	return true;
}

bool CNetManage::_CheckConnect()
{
	FD_ZERO(&(m_ReadFD));
	FD_ZERO(&(m_WriteFD));
	FD_ZERO(&(m_ExceptFD));

	FD_SET(m_Socket.getSOCKET(), &(m_ReadFD));
	FD_SET(m_Socket.getSOCKET(), &(m_WriteFD));
	FD_SET(m_Socket.getSOCKET(), &(m_ExceptFD));

	timeval	Timeout ;
	Timeout.tv_sec = 0 ;
	Timeout.tv_usec = 0 ;

	int result;

#if defined (__WINDOWS__) || defined (WIN32)
	result = select(0, &m_ReadFD, &m_WriteFD, &m_ExceptFD, &Timeout);   
	if(-1 == result) 
	{
		int nErr = WSAGetLastError();
		cocos2d::CCLog("_CheckConnect select  errno = %d errinfo = %s", nErr, strerror(nErr));
		return false;
	}
#else			
	result = select(((int)m_Socket.getSOCKET() + 1), &m_ReadFD, &m_WriteFD, &m_ExceptFD, &Timeout);    
	if(-1 == result) 
	{				
		cocos2d::CCLog("_CheckConnect select  errno = %d errinfo = %s", errno, strerror(errno));
		return false;
	}
#endif

	cocos2d::CCLog("_CheckConnect select  result = %d ", result);	

	if(FD_ISSET(m_Socket.getSOCKET(), &(m_ExceptFD)))
	{		
		cocos2d::CCLog("_processExcept Error \n");
		
		return false;
	}

	//if(FD_ISSET(m_Socket.getSOCKET(), &(m_WriteFD)))
	//{
	//	
	//}

	//if(FD_ISSET(m_Socket.getSOCKET(), &(m_ReadFD)))
	//{

	//}

	if (result != 1 )
	{
		cocos2d::CCLog("_CheckConnect select Error \n");
		return false;
	}	

	return true;
}

int CNetManage::IsStopThread()
{
	return m_nStopThread;	
}

bool CNetManage::IsNetDisConnect()
{
	pthread_mutex_lock(&m_ENetStateMutex);	
	
	if (m_ENetState == E_NetState_Error)
	{
		pthread_mutex_unlock(&m_ENetStateMutex);
		return true;
	}
	
	pthread_mutex_unlock(&m_ENetStateMutex);
	return false;
}

void CNetManage::SetNetState(NetState eState)
{
	pthread_mutex_lock(&m_ENetStateMutex);
	m_ENetState = eState;
	pthread_mutex_unlock(&m_ENetStateMutex);
}

bool CNetManage::Lua_NetWorkError()
{
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();

	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();
	lua_getglobal(tolua_s, "LuaNetWorkerror");       /* query function by name, stack: function */	
	if (!lua_isfunction(tolua_s, -1))
	{
		lua_pop(tolua_s, 1);
		return false;
	}

	pStack->executeFunction(0);	
	pStack->clean();
	return true;
}


