#pragma once
#include "NetManage.h"
using namespace std;

#include "CCLuaEngine.h"
#include "Lua_extensions_CCB.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

class CNetWork
{
public:
	CNetWork(void);
	~CNetWork(void);


	//创建网络
//	static void CreatNetWork();		

	//初始化
	bool init();
	//销毁网络
	void DestroyNetWork();	

	//心跳
	void update();

	//注册给lua的方法
	void RegFunction();	

	//封装通讯层的接口
	int NetOP_InitNetWork();
	void NetOP_DestroyNetWork();

	int NetOP_CnnGateServer(const char* szSrvIP, int nPort);
	int NetOP_CnnLogicServer(const char* szSrvIP, int nPort);

	void NetOP_DisconnetServer(int fd);	
	void NetOP_SendPackage(int nSocket, int nCmd1, int nCmd2, int nCmd3, int nCmd4, const char* szSendBuffer, int nLen);	

private:
	
	

	//检查网络数据
	void CheckNetData_rapidjson(const char* pchar,int isize);	

	//调用lua接口 把包数据传给lua解析jason格式
	bool Lua_RecPacket(int nCmd1, int nCmd2, int nCmd3, int nCmd4, int nSocket, int nLen, const char* stringValue);	
	
		
	CNetManage m_NetWorkOP;
};

extern CNetWork* g_NetWork;