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


	//��������
//	static void CreatNetWork();		

	//��ʼ��
	bool init();
	//��������
	void DestroyNetWork();	

	//����
	void update();

	//ע���lua�ķ���
	void RegFunction();	

	//��װͨѶ��Ľӿ�
	int NetOP_InitNetWork();
	void NetOP_DestroyNetWork();

	int NetOP_CnnGateServer(const char* szSrvIP, int nPort);
	int NetOP_CnnLogicServer(const char* szSrvIP, int nPort);

	void NetOP_DisconnetServer(int fd);	
	void NetOP_SendPackage(int nSocket, int nCmd1, int nCmd2, int nCmd3, int nCmd4, const char* szSendBuffer, int nLen);	

private:
	
	

	//�����������
	void CheckNetData_rapidjson(const char* pchar,int isize);	

	//����lua�ӿ� �Ѱ����ݴ���lua����jason��ʽ
	bool Lua_RecPacket(int nCmd1, int nCmd2, int nCmd3, int nCmd4, int nSocket, int nLen, const char* stringValue);	
	
		
	CNetManage m_NetWorkOP;
};

extern CNetWork* g_NetWork;