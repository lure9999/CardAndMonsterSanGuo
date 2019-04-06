#ifndef  __UpdateManager__
#define  __UpdateManager__

#include "CCApplication.h"
#include "cocos2d.h"
#include "MyAssetsManager.h"
USING_NS_CC;
// ��Ҫ�����Զ����¼�Ԥ������ع���
class UpdateManager : public MyAssetsManagerDelegateProtocol, public CCObject
{
public:
    UpdateManager();
    ~UpdateManager();
    virtual bool init();
    
	std::string getAllVersion(const char* url);
    void ckeckUpdate(const char* verUrl);
	void update();
    virtual void onError(MyAssetsManager::MYErrorCode errorCode);
    virtual void onProgress(int percent);
    virtual void onSuccess();
	// Ԥ������� add by:jjc
	void loadingCallBack(CCObject *obj);
	void loadingCallBack(float percent);
	int m_nCurCount; 
	int m_nAllCount;
private:
    //MyAssetsManager* getMyAssetsManager();
	MyAssetsManager* pMyAssetsManager;
    void createDownloadedDir();
    
    std::string pathToSave;
};

extern UpdateManager* g_UpdateManager;

#endif // __UpdateManager__

