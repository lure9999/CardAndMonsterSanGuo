#pragma once
#include "NetStream.h"
#include "Buffer_Net.h"
#include <string.h>
#include<list>

#include "pthread.h"

#include "NetSocket.h"

#include "ObjPool.h"

// ERROR DEFINE
#define UNSUCESSD			0 
#define SUCESSD				1 
#define CONNECT_ERROR		2    // 服务器无法连接
//#define REPEAT

enum SocketState
{ 	
	E_SocketState_NONE = 0,	
	E_SocketState_GS ,
	E_SocketState_MS,
	E_SocketState_Max,
};

enum SocketEvent
{ 
	E_SocketEvent_None = 0,
	E_SocketEvent_Send_GS = E_SocketState_GS,
	E_SocketEvent_Send_MS = E_SocketState_MS,
	E_SocketEvent_Creat,
	E_SocketEvent_Close,
	E_SocketEvent_Connect,

	E_SocketEvent_Max,
};

enum NetState
{ 	
	E_NetState_None = 0,
	E_NetState_Disconnect,	
	E_NetState_Connect ,
	E_NetState_Error,	
	E_NetState_Max,
};

struct Recv_Node
{	
	SNetStream* m_pNetStream;
	Recv_Node()
	{
		m_pNetStream = NULL;
	}
};

struct Event_Node
{
	SocketEvent m_nSocketEvent;
	SNetStream* m_pNetStream;
	Event_Node()
	{
		m_nSocketEvent = E_SocketEvent_Max;
		m_pNetStream = NULL;
	}
};

typedef std::list<Recv_Node>	RecvList;
typedef std::list<Event_Node>	EventList;

class CNetManage
{
public:
	CNetManage(void);
	~CNetManage(void);

	int InitNetWork();
	void DestroyNetWork();

	int CnnGateServer(const char* szSrvIP, int nPort);
	int CnnLogicServer(const char* szSrvIP, int nPort);

	void DisconnetServer(int ESocketState);

	SNetStream* GetRecvNode();

	void DelRecvNode(SNetStream *pStream);

	void SendPackage(int ESocketState, int nCmd1, int nCmd2, int nCmd3, int nCmd4, const char* szSendBuffer, int nLen);	

	int RecvPackage(char* pBuf, int nLen);

	bool processSocketStream();	

	int IsStopThread();

	
	// 网络中端
	bool Lua_NetWorkError();

	bool IsNetDisConnect();
	
	void SetNetState(NetState eState);

private:

	bool _select();
	bool _processInput();
	bool _processOutput();
	bool _processExcept();
	bool _processEvent();	

	//费阻塞模式链接检查是否成功
	bool _CheckConnect();

	bool CreatNetWorkThread();
	bool DestroyNetWorkThread();

	int InitWinSocketDll();	
	int OnRead(char* pBuf, int nLen);
	bool CnnServer(const char* szSrvIP, int nPort);


	

#if defined (__WINDOWS__) || defined (WIN32)
	HANDLE m_NetWorkhThread;
#else
	pthread_t m_NetWorkhThreadID;
#endif

	
	pthread_mutex_t m_RecvMutex;
	pthread_mutex_t m_EventMutex;

	RecvList m_RecvList;	
	EventList m_EventList;	
	
	CBuffer<4096 * 10>	m_RecvBuf;

	//Read Handle
	fd_set					m_ReadFD;
	//Write Handle
	fd_set					m_WriteFD;
	//Excetption Handle
	fd_set					m_ExceptFD;

	CNetSocket m_Socket;

	SocketState m_SocketState;

	CObjPool< SNetStream, true >	m_SNetStreamPool;

	int m_nStopThread;

	//add by sxin 增加断线状态
	pthread_mutex_t m_ENetStateMutex;
	NetState m_ENetState;
};

