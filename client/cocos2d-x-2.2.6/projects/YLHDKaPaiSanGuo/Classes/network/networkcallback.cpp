
#include "networkcallback.h"



using namespace cocos2d;

CNetWork* g_NetWork = NULL;

//这里写所有给lua注册的方法 

int C_To_Lua_SendPack(lua_State* tolua_S)
{  
	tolua_Error tolua_err;

	if (!tolua_isnumber(tolua_S,1,0,&tolua_err)||
		!tolua_isnumber(tolua_S,2,0,&tolua_err)||
		!tolua_isnumber(tolua_S,3,0,&tolua_err)|| 
		!tolua_isnumber(tolua_S,4,0,&tolua_err)|| 
		!tolua_isnumber(tolua_S,5,0,&tolua_err)|| 
		!tolua_isnumber(tolua_S,6,0,&tolua_err)|| 
		!tolua_isstring(tolua_S,7,0,&tolua_err))
	{
		
		tolua_error(tolua_S,"#ferror in function 'C_To_Lua_SendPack'.",&tolua_err);
		return 0;
	}

	int nCmd1 = tolua_tonumber(tolua_S, 1, 0);
	int nCmd2 = tolua_tonumber(tolua_S, 2, 0);
	int nCmd3 = tolua_tonumber(tolua_S, 3, 0);
	int nCmd4 = tolua_tonumber(tolua_S, 4, 0);
	int nSelectSrv = tolua_tonumber(tolua_S, 5, 0);	
	int nSendLen =  tolua_tonumber(tolua_S, 6, 0);	
	const char* pSendBuffer = tolua_tostring(tolua_S, 7, "");

	if (nSelectSrv <= 0)
	{		
		return 0;
	}
	
	g_NetWork->NetOP_SendPackage(nSelectSrv, nCmd1, nCmd2, nCmd3, nCmd4, pSendBuffer, nSendLen);
	return 1;	
}

int C_To_Lua_UpNetWork(lua_State* tolua_S)
{  
	if (g_NetWork)
	{		
		g_NetWork->update();
	}
	return 1; 	
}

int C_To_Lua_CnnGS(lua_State* tolua_S)
{
	tolua_Error tolua_err;

	if (!tolua_isstring(tolua_S,1,0,&tolua_err) || !tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{

		tolua_error(tolua_S,"#ferror in function 'C_To_Lua_CnnGS'.",&tolua_err);

		tolua_pushnumber(tolua_S,(lua_Number)0);

		return 0;
	}

	const char* pGSIP = tolua_tostring(tolua_S, 1, "");

	int nGSPort  =  tolua_tonumber(tolua_S,2,0);	
	
	if(pGSIP == NULL || nGSPort <= 0)
	{		
		tolua_pushnumber(tolua_S,(lua_Number)0);
		return 0;
	}	


	int nGSSocket = g_NetWork->NetOP_CnnGateServer(pGSIP, nGSPort);

	if( nGSSocket > 0)
	{		
		tolua_pushnumber(tolua_S,(lua_Number)nGSSocket);			
	}
	else
	{		
		tolua_pushnumber(tolua_S,(lua_Number)0);		
	}	
	
	return 1;
}

int C_To_Lua_CnnMS(lua_State* tolua_S)
{
	tolua_Error tolua_err;

	if (!tolua_isstring(tolua_S,1,0,&tolua_err) || !tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{

		tolua_error(tolua_S,"#ferror in function 'C_To_Lua_CnnGS'.",&tolua_err);

		tolua_pushnumber(tolua_S,(lua_Number)0);

		return 0;
	}

	
	const char* pMSIP = lua_tostring(tolua_S, 1);
	int nMSPort = lua_tonumber(tolua_S, 2);
	if(pMSIP == NULL || nMSPort <= 0 )
	{
		tolua_pushnumber(tolua_S,(lua_Number)0);
		return 0;
	}
	
	int nMSSocket = g_NetWork->NetOP_CnnLogicServer(pMSIP, nMSPort);

	if(nMSSocket)
	{
		tolua_pushnumber(tolua_S,(lua_Number)nMSSocket);	
	}
	else
	{
		tolua_pushnumber(tolua_S,(lua_Number)0);
	}	
	
	return 1;
}

//为什么要lua层来初始化网络层 这个应该代码只初始化一次！！！！
int C_To_Lua_InitNetWork(lua_State *L)
{
	
	if(g_NetWork->NetOP_InitNetWork())
	{
		tolua_pushnumber(L,(lua_Number)1);
	}
	else
	{
		tolua_pushnumber(L,(lua_Number)0);
	}
	
	return 1;
}

int C_To_Lua_DisconnectServer(lua_State *tolua_S)
{
	tolua_Error tolua_err;

	if (!tolua_isnumber(tolua_S,1,0,&tolua_err))
	{

		tolua_error(tolua_S,"#ferror in function 'C_To_Lua_DisconnectServer'.",&tolua_err);

		tolua_pushnumber(tolua_S,(lua_Number)0);

		return 0;
	}

	int nDF = lua_tonumber(tolua_S, 1);

	g_NetWork->NetOP_DisconnetServer(nDF);

	return 1;
}

//为什么lua调用？？？
int C_To_Lua_DestroyNetWork(lua_State *tolua_S)
{	
	g_NetWork->NetOP_DestroyNetWork();
	return 1;
}

void CNetWork::RegFunction()
{
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();

	lua_register(tolua_s, "SendPack", C_To_Lua_SendPack);	
	lua_register(tolua_s, "UpNetWork", C_To_Lua_UpNetWork);
	lua_register(tolua_s, "InitNetWork", C_To_Lua_InitNetWork);
	lua_register(tolua_s, "CnnGS", C_To_Lua_CnnGS);
	lua_register(tolua_s, "CnnMS", C_To_Lua_CnnMS);
	lua_register(tolua_s, "DisconnectServer", C_To_Lua_DisconnectServer);
	lua_register(tolua_s, "DestroyNetWork", C_To_Lua_DestroyNetWork);
	//加载脚本--add by sxin 这里不再加载network.lua！！！！
	//pEngine->executeScriptFile("Script/Network/network.lua");
}

// 初始化变量
CNetWork::CNetWork(void)
{

}


CNetWork::~CNetWork(void)
{
	DestroyNetWork();	
}


//void CNetWork::CreatNetWork()
//{
//	if (!g_NetWork)
//	{
//		g_NetWork = new CNetWork;	
//
//		g_NetWork->init();
//	}
//}


void CNetWork::DestroyNetWork()
{
	m_NetWorkOP.DestroyNetWork();
}

void CNetWork::update()
{
	if (!m_NetWorkOP.IsStopThread())
	{				
		return;
	}
	
	SNetStream *pNetStream = m_NetWorkOP.GetRecvNode();
	if (pNetStream)
	{
		int nCmd1 = -1, nCmd2 = -1, nCmd3 = -1, nCmd4 = -1;
		char* pBuffer = NULL;
		*pNetStream >> nCmd1 >> nCmd2 >> nCmd3 >> nCmd4 >> pBuffer;
		//cocos2d::CCLog("send to lua:cmd1(%d) cmd2(%d) info(%s)\n", nCmd1, nCmd2, pBuffer);
		Lua_RecPacket(nCmd1, nCmd2, nCmd3, nCmd4, 0, pNetStream->GetMsgLen(), pBuffer); 
		m_NetWorkOP.DelRecvNode(pNetStream);
	}	

	// 判断是否是断线
	if (m_NetWorkOP.IsNetDisConnect())
	{
		m_NetWorkOP.SetNetState(E_NetState_None);
		//要把收到的包都处理了
		while(true)
		{
			pNetStream = m_NetWorkOP.GetRecvNode();
			if (pNetStream)
			{
				int nCmd1 = -1, nCmd2 = -1, nCmd3 = -1, nCmd4 = -1;
				char* pBuffer = NULL;
				*pNetStream >> nCmd1 >> nCmd2 >> nCmd3 >> nCmd4 >> pBuffer;
				//cocos2d::CCLog("send to lua:cmd1(%d) cmd2(%d) info(%s)\n", nCmd1, nCmd2, pBuffer);
				Lua_RecPacket(nCmd1, nCmd2, nCmd3, nCmd4, 0, pNetStream->GetMsgLen(), pBuffer); 
				m_NetWorkOP.DelRecvNode(pNetStream);
			}	
			else
			{
				break;
			}

		}

		if (m_NetWorkOP.Lua_NetWorkError() == false)
		{
			m_NetWorkOP.DestroyNetWork();
		}		
	}
	

}


//初始化
bool CNetWork::init()
{	
	RegFunction();
	return true;
}

//检查网络数据
void CNetWork::CheckNetData_rapidjson(const char* pchar,int isize)
{

}

//调用lua接口 把包数据传给lua解析jason格式
bool CNetWork::Lua_RecPacket(int nCmd1, int nCmd2, int nCmd3, int nCmd4, int nSocket, int nLen, const char* stringValue)
{
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();

	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();
	lua_getglobal(tolua_s, "luarecv");       /* query function by name, stack: function */	
	if (!lua_isfunction(tolua_s, -1))
	{
		lua_pop(tolua_s, 1);
		return 0;
	}
	pStack->pushInt(nCmd1);
	pStack->pushInt(nCmd2);
	pStack->pushInt(nCmd3);
	pStack->pushInt(nCmd4);
	pStack->pushInt(nSocket);
	pStack->pushInt(nLen);
	pStack->pushString(stringValue);
	pStack->executeFunction(7);
	pStack->clean();
	return true;
}

void CNetWork::NetOP_SendPackage(int nSocket, int nCmd1, int nCmd2, int nCmd3, int nCmd4, const char* szSendBuffer, int nLen)
{
	m_NetWorkOP.SendPackage(nSocket,nCmd1,nCmd2,nCmd3,nCmd4,szSendBuffer,nLen);
}

int CNetWork::NetOP_InitNetWork()
{
	return m_NetWorkOP.InitNetWork();
}

void CNetWork::NetOP_DestroyNetWork()
{
	m_NetWorkOP.DestroyNetWork();
}

int CNetWork::NetOP_CnnGateServer(const char* szSrvIP, int nPort)
{
	return m_NetWorkOP.CnnGateServer(szSrvIP,nPort);
}

int CNetWork::NetOP_CnnLogicServer(const char* szSrvIP, int nPort)
{
	return m_NetWorkOP.CnnLogicServer(szSrvIP,nPort);
}

void CNetWork::NetOP_DisconnetServer(int fd)
{
	m_NetWorkOP.DisconnetServer(fd);
}

