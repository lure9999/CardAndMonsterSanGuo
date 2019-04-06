//
//  AssetsManagerTestAppDelegate.cpp
//  AssetsManagerTest
//

extern "C" {
#include "tolua_fix.h"
}

#include "UpdateManager.h"

#include "cocos2d.h"
#include "SimpleAudioEngine.h"

#include "CCLuaEngine.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <dirent.h>
#include <sys/stat.h>
#endif
#include "CocoStudio/Armature/utils/CCArmatureDataManager.h"

USING_NS_CC;
USING_NS_CC_EXT;
using namespace CocosDenshion;

UpdateManager* g_UpdateManager = NULL;

/* 注册给lua用的方法 */
int getAllUpdateVersion(lua_State* tolua_S)
{	
	tolua_Error tolua_err;
	if (tolua_isstring(tolua_S,1,0,&tolua_err))
	{
		const char* url = tolua_tostring(tolua_S, 1, "");
		if (g_UpdateManager != NULL)
		{
			std::string strAllVer = g_UpdateManager->getAllVersion(url);			
			tolua_pushstring(tolua_S,strAllVer.c_str());
		}
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'getAllUpdateVersion'.",&tolua_err);
		return 0;
	}
	
	return 1;
}

// 在线更新相关 add by:jjc
void ShowDownLoadLayer( int nCurSize, int nAllSize, int nState )
{
	//int sum;
	//lua_State* L = CCLuaEngine::defaultEngine()->getLuaStack()->getLuaState();
	///* the function name */
	//lua_getglobal(L, "ShowDownLoadLayer");

	///* the first argument */
	//lua_pushnumber(L, nCurSize);

	///* the second argument */
	//lua_pushnumber(L, nAllSize);

	//lua_pushnumber(L, nState);

	///* call the function with 2
	//	  arguments, return 1 result */
	//lua_call(L, 3, 1);

	///* get the result */
	//sum = (int)lua_tonumber(L, -1);
	//lua_pop(L, 1);

	//return sum;

//add by sxin 从写
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();
	lua_getglobal(tolua_s, "ShowDownLoadLayer");       
	if (!lua_isfunction(tolua_s, -1))
	{
		lua_pop(tolua_s, 1);
		return;
	}
	pStack->pushInt(nCurSize);
	pStack->pushInt(nAllSize);
	pStack->pushInt(nState);
	pStack->executeFunction(3);	
	pStack->clean();

}
// AddBy YanQing.Yang
int CheckUpdate(lua_State* tolua_S)
{
//	size_t value_len = 0;
//	const char *url = NULL;
//	url = lua_tolstring(tolua_S, 1, &value_len);
//	std::string n_iosUrl(url);
//	int i = n_iosUrl.find("/p");
//	std::string front_url= n_iosUrl.substr(0,i);
//	std::string after_url  = n_iosUrl.substr(i);
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS ||CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 ) 
//	front_url =  front_url+"/ios";
//#else
//	front_url =  front_url+"/andriod";
//#endif
//	front_url +=after_url;
//	url = front_url.c_str();
//	//url = 
//	if (strcmp(url,"")==0)
//	{
//		CCLOG("URL is NULL...");
//		ShowDownLoadLayer(0, 0, 3);
//	}
//	else
//	{
//		if (g_UpdateManager != NULL)
//		{
//			g_UpdateManager->ckeckUpdate(url);
//		}
//	}
//	return 0;


//add by sxin 从写

	tolua_Error tolua_err;
	if (tolua_isstring(tolua_S,1,0,&tolua_err))
	{
		const char* url = tolua_tostring(tolua_S, 1, "");		
		std::string n_iosUrl(url);
		int i = n_iosUrl.find("/p");
		std::string front_url= n_iosUrl.substr(0,i);
		std::string after_url  = n_iosUrl.substr(i);
		#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS ||CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 ) 
			front_url =  front_url+"/ios";
		#else
			front_url =  front_url+"/andriod";
		#endif

		front_url +=after_url;

		url = front_url.c_str();
	
		if (strcmp(url,"")==0)
		{
			CCLOG("URL is NULL...");
			ShowDownLoadLayer(0, 0, 3);
		}
		else
		{
			if (g_UpdateManager != NULL)
			{
				g_UpdateManager->ckeckUpdate(url);
			}
		}
		
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'CheckUpdate'.",&tolua_err);
		
	}

	return 0;

}
int StartUpdate(lua_State* tolua_S)
{	
	/*bool bIsUpdate = false;
	bIsUpdate = lua_toboolean(tolua_S,1);	

	if (bIsUpdate)
	{
	CCLOG("Start Update");
	if (g_UpdateManager != NULL)
	{
	g_UpdateManager->update();
	}
	}
	return 0;*/

	tolua_Error tolua_err;
	if (tolua_isboolean(tolua_S,1,0,&tolua_err))
	{
		
		bool bIsUpdate = ((bool)  tolua_toboolean(tolua_S,1,0));

		if (bIsUpdate)
		{
			CCLOG("Start Update");
			if (g_UpdateManager != NULL)
			{
				g_UpdateManager->update();
			}
		}
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'StartUpdate'.",&tolua_err);
	}	
	return 0;
}



int	ReSetAsync(lua_State* tolua_S)
{
	g_UpdateManager->m_nCurCount = 0;
	g_UpdateManager->m_nAllCount = 0;
	return 0;
}

int myAddImageAsync(lua_State* tolua_S)
{
//	size_t value_len = 0;
//	const char *name = NULL;
//
//	name = lua_tolstring(tolua_S, -1, &value_len);
//
//	std::string stdName = name;
//
////	if (CCFileUtils::sharedFileUtils()->isFileExist(strPath)) 
//	{
//		g_UpdateManager->m_nAllCount++;
//		if (stdName.find(".ExportJson") != std::string::npos)
//		{
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//	g_UpdateManager->loadingCallBack(1);
//#else
//	CCArmatureDataManager::sharedArmatureDataManager()->addArmatureFileInfoAsync(name, g_UpdateManager, schedule_selector(UpdateManager::loadingCallBack));
//#endif
//		}
//		else
//		{
//			CCTextureCache::sharedTextureCache()->addImageAsync(name, g_UpdateManager, callfuncO_selector(UpdateManager::loadingCallBack));
//		}
//	}
//	lua_pop(tolua_S, 1);
//
//	return 1;

// add by sxin 从写

	tolua_Error tolua_err;
	if (tolua_isstring(tolua_S,1,0,&tolua_err))
	{
		const char* name = tolua_tostring(tolua_S, 1, "");		

		std::string stdName = name;

		g_UpdateManager->m_nAllCount++;

		if (stdName.find(".ExportJson") != std::string::npos)
		{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
			g_UpdateManager->loadingCallBack(1);
#else
			CCArmatureDataManager::sharedArmatureDataManager()->addArmatureFileInfoAsync(name, g_UpdateManager, schedule_selector(UpdateManager::loadingCallBack));
#endif
		}
		else
		{
			CCTextureCache::sharedTextureCache()->addImageAsync(name, g_UpdateManager, callfuncO_selector(UpdateManager::loadingCallBack));
		}
		
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'myAddImageAsync'.",&tolua_err);
	}	
		
	return 0;
}
/*end 注册给lua 用的方法*/
//////////////////////////////////////////////////////////////////////////

UpdateManager::UpdateManager()
{
    init();
}

UpdateManager::~UpdateManager()
{
   // MyAssetsManager *pAssetsManager = getMyAssetsManager();
    CC_SAFE_DELETE(pMyAssetsManager);
}

bool UpdateManager::init()
{
	createDownloadedDir();
	pMyAssetsManager = new MyAssetsManager();
	pMyAssetsManager->setDelegate(this);
	pMyAssetsManager->setStoragePath(pathToSave.c_str());
	pMyAssetsManager->setSearchPath();
	pMyAssetsManager->setConnectionTimeout(3);
	

	CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();

	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();

	// 自动更新 add by jjc
	lua_register(tolua_s,"getAllUpdateVersion",getAllUpdateVersion);
	lua_register(tolua_s,"CheckUpdate",CheckUpdate);
	lua_register(tolua_s,"StartUpdate",StartUpdate);
	// 预加载相关 add by:jjc
	lua_register(tolua_s,"myAddImageAsync",myAddImageAsync);
	lua_register(tolua_s,"ReSetAsync",ReSetAsync);
	m_nCurCount = 0;
	m_nAllCount = 0;
	return true;
}
// 预加载相关 add by:jjc
int SetLoadingInfo( char* text, int nCurCount, int nAllCount )
{

	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();

	lua_getglobal(tolua_s, "SetLoadingInfo");       /* query function by name, stack: function */	
	if (!lua_isfunction(tolua_s, -1))
	{
		CCLOG( "lua fun SetLoadingInfo not find");
		lua_pop(tolua_s, 1);
		return 0;
	}

	pStack->pushString(text);
	pStack->pushInt(nCurCount);
	pStack->pushInt(nAllCount);
	pStack->executeFunction(3);	
	pStack->clean();
	return true;
}

void UpdateManager::loadingCallBack(CCObject *obj)
{
	g_UpdateManager->m_nCurCount++;
	SetLoadingInfo("pic loaded", g_UpdateManager->m_nCurCount, g_UpdateManager->m_nAllCount);
}
void UpdateManager::loadingCallBack( float percent )
{
	g_UpdateManager->m_nCurCount++;
	SetLoadingInfo("Json loaded", g_UpdateManager->m_nCurCount, g_UpdateManager->m_nAllCount);
}
std::string UpdateManager::getAllVersion(const char* url)
{
	return pMyAssetsManager->getAllUpdatVerCode(url);
}

void UpdateManager::ckeckUpdate(const char* verUrl)
{
// #if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
//	#if COCOS2D_DEBUG >= 1
//		ShowDownLoadLayer(0, 0, 3);
//		return 
//	#endif
//#endif
	pMyAssetsManager->setVersionFileUrl(verUrl);
	MyAssetsManager::MYUpdateRetrun eRe = pMyAssetsManager->checkUpdate();
	if (eRe == /*MyAssetsManager::eHasVersion*/ 0)
	{// 有新版本需要下载
		CCLOG("%s", pMyAssetsManager->getPackageUrl());
		//getMyAssetsManager()->update();
		ShowDownLoadLayer(0, 0, 1);
	}
	if (eRe == /*MyAssetsManager::eNoVersion*/ 1)
	{// 没有新版本
		ShowDownLoadLayer(0, 0, 3);
	}
	if (eRe == /*MyAssetsManager::eHasError*/ 2)
	{// 有错误
		ShowDownLoadLayer(0, 0, 4);
	}
}

void UpdateManager::update()
{
	pMyAssetsManager->update();
}

void UpdateManager::createDownloadedDir()
{
    pathToSave = CCFileUtils::sharedFileUtils()->getWritablePath();
	//pathToSave[pathToSave.length()-1] = '/';
    
    // Create the folder if it doesn't exist
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    DIR *pDir = NULL;
    
    pDir = opendir (pathToSave.c_str());
    if (! pDir)
    {
        mkdir(pathToSave.c_str(), S_IRWXU | S_IRWXG | S_IRWXO);
    }
#else
	if ((GetFileAttributesA(pathToSave.c_str())) == INVALID_FILE_ATTRIBUTES)
	{
		CreateDirectoryA(pathToSave.c_str(), 0);
	}
#endif
}

void UpdateManager::onError(MyAssetsManager::MYErrorCode errorCode)
{
    if (errorCode == MyAssetsManager::kNoNewVersion)
    {
		CCLog("no new version");
    }
    
    if (errorCode == MyAssetsManager::kNetwork)
    {
		CCLog("network error");
    }
}
bool bHasOver = false;
void UpdateManager::onProgress(int percent)
{
    char progress[20];
    snprintf(progress, 20, "downloading %d%%", percent);
	if (percent%10 == 0)
	{
		CCLog("%s", progress);
	}
	ShowDownLoadLayer(percent, 100, 2);
}

void UpdateManager::onSuccess()
{
	CCLog("download ok");
	ShowDownLoadLayer(0, 0, 3);
}
