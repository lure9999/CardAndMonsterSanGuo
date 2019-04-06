//
//  PluginChannel.m
//  sample
//
//  Created by cocos2dx on 14-11-10.
//  Copyright (c) 2014年 cocos2dx. All rights reserved.
//

#include "PluginChannel.h"
#include <stdlib.h>
#include "Analytics.h"
#include "Push.h"
#include "cocos2d.h"
#include "PluginParam.h"

//add by sxin
extern "C" {
#include "tolua_fix.h"
}
#include "CCLuaEngine.h"
USING_NS_CC;
//end


 //#include "PartViews.h"

using namespace anysdk::framework;

#define  LOG_TAG    "PluginChannel"

//void CCMessageBox(const char* content, const char* title)
//{
//    ////
//    // [PartViews addDebugView:[[NSString alloc] initWithUTF8String:title] ctx:[[NSString alloc] initWithUTF8String:content]];
//}

void CCExit()
{
    ////
    exit(0);
}

//anysdk对lua调用接口
int Lua_AnySDK_Login(lua_State* tolua_S)
{
	PluginChannel::getInstance()->login();	
	return 0;
}

//支付系统功能
int Lua_AnySDK_pay(lua_State* tolua_S)
{

	tolua_Error tolua_err;
	if (tolua_isstring(tolua_S,1,0,&tolua_err)&&tolua_isstring(tolua_S,2,0,&tolua_err)&&tolua_isstring(tolua_S,3,0,&tolua_err)&&tolua_isstring(tolua_S,4,0,&tolua_err)&&tolua_isstring(tolua_S,5,0,&tolua_err)&&tolua_isstring(tolua_S,6,0,&tolua_err)&&tolua_isstring(tolua_S,7,0,&tolua_err)&&tolua_isstring(tolua_S,8,0,&tolua_err)&&tolua_isstring(tolua_S,9,0,&tolua_err))
	{		
		const char* pProduct_Price = tolua_tostring(tolua_S, 1, "");
		const char* pProduct_Id = tolua_tostring(tolua_S, 2, "");
		const char* pProduct_Name = tolua_tostring(tolua_S, 3, "");
		const char* pServer_Id = tolua_tostring(tolua_S, 4, "");
		const char* Product_Count = tolua_tostring(tolua_S, 5, "");
		const char* pRole_Id = tolua_tostring(tolua_S, 6, "");
		const char* pRole_Name = tolua_tostring(tolua_S, 7, "");
		const char* pRole_Grade = tolua_tostring(tolua_S, 8, "");
		const char* pRole_Balance = tolua_tostring(tolua_S, 9, "");
		PluginChannel::getInstance()->pay(pProduct_Price,pProduct_Id,pProduct_Name,pServer_Id,Product_Count,pRole_Id,pRole_Name,pRole_Grade,pRole_Balance);	
		return 0;
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_AnySDK_pay'.",&tolua_err);
	}
	return 0;

}

int Lua_AnySDK_requestProducts(lua_State* tolua_S)
{
	PluginChannel::getInstance()->requestProducts();	
	return 0;
}

int Lua_AnySDK_resetPayState(lua_State* tolua_S)
{
	//	PluginChannel::getInstance()->resetPayState();	
	return 0;
}


int Lua_AnySDK_getUserId(lua_State* tolua_S)
{
	const char* tolua_ret = (const char*)(PluginChannel::getInstance()->getUserId().c_str());	
	//CCLOG("Lua_AnySDK_getUserId UserId %s",tolua_ret);
	//tolua_pushstring(tolua_S,(const char*)tolua_ret);
	lua_pushlstring(tolua_S, tolua_ret, PluginChannel::getInstance()->getUserId().length());
	return 1;
}

int Lua_AnySDK_getChannelId(lua_State* tolua_S)
{
	const char* tolua_ret = (const char*)(PluginChannel::getInstance()->getChannelId().c_str());
	//tolua_pushstring(tolua_S,(const char*)tolua_ret);
	lua_pushlstring(tolua_S, tolua_ret, PluginChannel::getInstance()->getChannelId().length());	
	return 1;
}


PluginChannel* PluginChannel::_pInstance = NULL;
static AllProductsInfo _myProducts;

PluginChannel::PluginChannel()
{
    _pluginsIAPMap = NULL;    
}

PluginChannel::~PluginChannel()
{
    unloadPlugins();
}

PluginChannel* PluginChannel::getInstance()
{
    if (_pInstance == NULL) {
        _pInstance = new PluginChannel();
    }
    return _pInstance;
}

void PluginChannel::purge()
{
    if (_pInstance)
    {
        delete _pInstance;
        _pInstance = NULL;
    }
}

//使用anysdk.com的时候注释掉这个宏就可以
//#define isQudaoInfo 1

void PluginChannel::loadPlugins()
{
    printf("Load plugins invoked\n");
    /**
     * appKey、appSecret、privateKey不能使用Sample中的值，需要从打包工具中游戏管理界面获取，替换
     * oauthLoginServer参数是游戏服务提供的用来做登陆验证转发的接口地址。
     */

    std::string appKey = "CF44950E-78E7-2AE8-3D9F-319335551830";
    std::string appSecret = "370df4237397bf7ac782030e6472a065";
    std::string privateKey = "E7EB3458E1B52B801CB2350F4C58277D";
   // std::string oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
	std::string oauthLoginServer = "http://123.56.207.79/Login.php";
	
    
    AgentManager::getInstance()->init(appKey,appSecret,privateKey,oauthLoginServer);
    
    //使用框架中代理类进行插件初始化
    AgentManager::getInstance()->loadAllPlugins();
    
    //对用户系统设置监听类
    if(AgentManager::getInstance()->getUserPlugin())
    {
        AgentManager::getInstance()->getUserPlugin()->setActionListener(this);
    }
    
    //对支付系统设置监听类
    printf("Load plugins invoked\n");
    _pluginsIAPMap  = AgentManager::getInstance()->getIAPPlugin();
    std::map<std::string , ProtocolIAP*>::iterator iter;
    for(iter = _pluginsIAPMap->begin(); iter != _pluginsIAPMap->end(); iter++)
    {
        (iter->second)->setResultListener(this);
    }
    
    Analytics::getInstance()->setCaptureUncaughtException(true);
    Analytics::getInstance()->setSessionContinueMillis(15000);
    Analytics::getInstance()->logTimedEventBegin("Load");
    Push::getInstance()->startPush();
    
    _iapIPhone = getIAPIphone();


	//add by sxin 注册lua接口
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();

	lua_register(tolua_s,"AnySDKLogin",Lua_AnySDK_Login);	
	lua_register(tolua_s,"AnySDKpay",Lua_AnySDK_pay);	
	lua_register(tolua_s,"AnySDKrequestProducts",Lua_AnySDK_requestProducts);	
	lua_register(tolua_s,"AnySDKresetPayState",Lua_AnySDK_resetPayState);	
	lua_register(tolua_s,"AnySDKgetUserId",Lua_AnySDK_getUserId);	
	lua_register(tolua_s,"AnySDKgetChannelId",Lua_AnySDK_getChannelId);	
	//end


}

void PluginChannel::unloadPlugins()
{
    printf("Unload plugins invoked\n");
    AgentManager::getInstance()->unloadAllPlugins();
    Analytics::getInstance()->logTimedEventEnd("Unload");
}

std::string PluginChannel::getPluginId()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        return AgentManager::getInstance()->getUserPlugin()->getPluginId();
    }
    return "";
}

void PluginChannel::login()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        AgentManager::getInstance()->getUserPlugin()->login();
        Analytics::getInstance()->logEvent("login");
    }
	else
	{
		CCLOG("error in login");
	}
}


void PluginChannel::logout()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("logout"))
        {
            
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("logout",NULL);
        }
    }
}

bool PluginChannel::isFunctionSupported(std::string strClassName)
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        return AgentManager::getInstance()->getUserPlugin()->isFunctionSupported(strClassName);
        
    }
    return false;
}

const char* PluginChannel::getResourceId(std::string name)
{
    printf("getResourceId:%s\n", name.c_str());
//     NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"channel" ofType:@"plist"];
//     NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
// //    CCLOG("%@", data);
//     NSString* key = [[NSString alloc] initWithUTF8String:name.c_str()];
//     NSString* value = [data objectForKey:key];
    return "";
}

void PluginChannel::ChoosePayMode(std::vector<std::string>& pluginId)
{
    // NSMutableDictionary* _list = [NSMutableDictionary dictionary];
    // ////display interface
    // std::vector<std::string>::iterator iter;
    // for (iter = pluginId.begin(); iter != pluginId.end(); iter++) {
    //     printf("channelID:%s\n", (*iter).c_str());
    //     std::string key = "Channel" + (*iter);
    //     NSString* channelName = [[NSString alloc] initWithUTF8String:getResourceId(key)];
    //     NSString* channelKey = [[NSString alloc] initWithUTF8String:(*iter).c_str()];
    //     [_list setObject:channelName forKey:channelKey];
    // }
    // [PartViews addButtons:_list];
}

void PluginChannel::payMode(std::string id)
{
    std::map<std::string , ProtocolIAP*>::iterator iter;
    iter = _pluginsIAPMap->find(id);
    CCLOG("111");
    if(iter != _pluginsIAPMap->end())
    {
        CCLOG("222");
        (iter->second)->payForProduct(productInfo);
        CCLOG("333");
    }
    CCLOG("444");
}

ProtocolIAP* PluginChannel::getIAPIphone()
{
    if(_pluginsIAPMap)
    {
        std::map<std::string , ProtocolIAP*>::iterator it = _pluginsIAPMap->begin();
        for (; it != _pluginsIAPMap->end(); it++) {
            printf("it->first: %s----\n", it->first.c_str());
            if (it->first == IAP_IPHONE_ID) {
                return it->second;
            }
        }
    }
    return NULL;
}

void PluginChannel::requestProducts()
{
    printf("payRequest\n");
    if ( NULL!= _iapIPhone ) {
        PluginParam param1("PD_10005");
        PluginParam param2("PD_10004");
        PluginParam param3("PD_10003");
        _iapIPhone->callFuncWithParam("requestProducts", &param1, &param2, &param3, NULL);
    }
    else{
        printf("iap iphone isn't find!\n");
    }
}

void PluginChannel::pay(const char* Product_Price,const char* Product_Id,const char* Product_Name,const char* Server_Id,const char* Product_Count,const char* Role_Id,const char* Role_Name,const char* Role_Grade,const char* Role_Balance)
{
	if ( NULL != _iapIPhone ) {
		_iapIPhone->payForProduct(_myProducts["1"]);
		return;
	}

	std::map<std::string , ProtocolIAP*>::iterator it = _pluginsIAPMap->begin();
	if(_pluginsIAPMap)
	{
		productInfo["Product_Price"] = Product_Price;
		productInfo["Product_Id"] = Product_Id;
		productInfo["Product_Name"] = Product_Name;
		productInfo["Server_Id"] = Server_Id;
		productInfo["Product_Count"] = Product_Count;
		productInfo["Role_Id"] = Role_Id;
		productInfo["Role_Name"] = Role_Name;
		productInfo["Role_Grade"] = Role_Grade;
		productInfo["Role_Balance"] = Role_Balance;

		Analytics::getInstance()->logEvent("pay", productInfo);

		if(_pluginsIAPMap->size() == 1)
		{
			(it->second)->payForProduct(productInfo);
		}
		else if(_pluginsIAPMap->size() > 1)
		{
			std::vector<std::string> pluginId;
			for (;it != _pluginsIAPMap->end();++it)
			{
				pluginId.push_back(it->first);
			}
			ChoosePayMode(pluginId);
		}
	}


	PluginParam param3("size");
	std::vector<PluginParam*> params;
	params.push_back(&param3);
}

void PluginChannel::pay()
{
    if ( NULL != _iapIPhone ) {
        _iapIPhone->payForProduct(_myProducts["1"]);
        return;
    }
    
    std::map<std::string , ProtocolIAP*>::iterator it = _pluginsIAPMap->begin();
    if(_pluginsIAPMap)
    {
        productInfo["Product_Price"] = "1";
        if(AgentManager::getInstance()->getChannelId()=="000016" || AgentManager::getInstance()->getChannelId()=="000009"|| AgentManager::getInstance()->getChannelId()=="000349")
		{
            productInfo["Product_Id"] = "1";
        }
        else if(AgentManager::getInstance()->getChannelId()=="000056" )
		{//联通，传计费点
            productInfo["Product_Id"] = "130201102727";
        }
        else if (AgentManager::getInstance()->getChannelId()=="000266") 
		{//移动基地，传计费点后三位
            productInfo["Product_Id"] = "001";
        }
        else
        {
            productInfo["Product_Id"] = "monthly";
        }		
        
        productInfo["Product_Name"] = "豌豆荚测试a1";
        productInfo["Server_Id"] = "13";
        productInfo["Product_Count"] = "1";
        productInfo["Role_Id"] = "1";
        productInfo["Role_Name"] = "1";
        productInfo["Role_Grade"] = "1";
        productInfo["Role_Balance"] = "1";
		
        Analytics::getInstance()->logEvent("pay", productInfo);

        if(_pluginsIAPMap->size() == 1)
        {
            (it->second)->payForProduct(productInfo);
        }
        else if(_pluginsIAPMap->size() > 1)
        {
            std::vector<std::string> pluginId;
            for (;it != _pluginsIAPMap->end();++it)
            {
                pluginId.push_back(it->first);
            }
            ChoosePayMode(pluginId);
        }
    }
    
    
    PluginParam param3("size");
    std::vector<PluginParam*> params;
    params.push_back(&param3);
}

void PluginChannel::resetPayState()
{
    ProtocolIAP::resetPayState();
    pay();
}

std::string PluginChannel::getUserId()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        return AgentManager::getInstance()->getUserPlugin()->getUserID();
    }
    return "";
}

void PluginChannel::enterPlatform()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        //使用isFunctionSupported可先判断该插件是否支持该功能
        if(isFunctionSupported("enterPlatform"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("enterPlatform",NULL);
        }
    }
}

void PluginChannel::showToolBar(ToolBarPlace place)
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("showToolBar"))
        {
            PluginParam paramInfo(place);
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("showToolBar",&paramInfo,NULL);
        }
    }
}

void PluginChannel::hideToolBar()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("hideToolBar"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("hideToolBar",NULL);
        }
    }
}

void PluginChannel::pause()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("pause"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("pause",NULL);
        }
    }
}

void PluginChannel::destroy()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("destroy"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("destroy",NULL);
        }
    }
}

void PluginChannel::Exit()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("exit"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("exit",NULL);
        }
        
    }
}

void PluginChannel::antiAddictionQuery()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("antiAddictionQuery"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("antiAddictionQuery",NULL);
        }
        
    }
}

void PluginChannel::accountSwitch()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("accountSwitch"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("accountSwitch",NULL);
        }
        
    }
}

void PluginChannel::realNameRegister()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(isFunctionSupported("realNameRegister"))
        {
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("realNameRegister",NULL);
        }
        
    }
}

void PluginChannel::submitLoginGameRole()
{
    if(AgentManager::getInstance()->getUserPlugin())
    {
        if(PluginChannel::getInstance()->isFunctionSupported("submitLoginGameRole"))
        {
            StringMap userInfo;
            userInfo["roleId"] = "ceshi : 123456";
            userInfo["roleName"] = "ceshi : test";
            userInfo["roleLevel"] = "ceshi : 10";
            userInfo["zoneId"] = "ceshi : 123";
            userInfo["zoneName"] = "ceshi : test";
            userInfo["dataType"] = "ceshi : 1";
            userInfo["ext"] = "ceshi : login";
            PluginParam data(userInfo);
            AgentManager::getInstance()->getUserPlugin()->callFuncWithParam("submitLoginGameRole",&data,NULL);
        }
    }
}

void ShowTipDialog()
{
    ////
}

void PluginChannel::onRequestResult(RequestResultCode ret, const char* msg, AllProductsInfo info)
{
    //info: 商品获取到的信息，请在这里进行商品界面的展示。
    printf("get all iap-iphone products info:%lu\n", info.size());
    _myProducts = info;
	//add by sxin 回调成功给lua	
	AnySDK_onRequestResult();
		
}

void PluginChannel::onPayResult(PayResultCode ret, const char* msg, TProductInfo info)
{
    printf("onPayResult, %s\n", msg);
    std::string temp = "fail";
    switch(ret)
    {
        case kPaySuccess://支付成功回调
            temp = "Success";
            CCMessageBox(temp.c_str() , temp.c_str() );
			//add by sxin 回调成功给lua
			AnySDK_onPayResult_Success();			
            break;
        case kPayFail://支付失败回调
            CCMessageBox(temp.c_str()  , temp.c_str() );
            break;
        case kPayCancel://支付取消回调
            CCMessageBox(temp.c_str()  , "Cancel" );
            break;
        case kPayNetworkError://支付超时回调
            CCMessageBox(temp.c_str()  , "NetworkError");
            break;
        case kPayProductionInforIncomplete://支付超时回调
            CCMessageBox(temp.c_str()  , "ProductionInforIncomplete");
            break;
            /**
             * 新增加:正在进行中回调
             * 支付过程中若SDK没有回调结果，就认为支付正在进行中
             * 游戏开发商可让玩家去判断是否需要等待，若不等待则进行下一次的支付
             */
        case kPayNowPaying:
            ShowTipDialog();
            break;
        default:
            break;
    }
}

void PluginChannel::onActionResult(ProtocolUser* pPlugin, UserActionResultCode code, const char* msg)
{
    printf("PluginChannel, onActionResult:%d, msg%s\n",code,msg);
    bool _userLogined = false;
    switch(code)
    {
        case kInitSuccess://初始化SDK成功回调				
			AnySDK_InitSuccess();			
            break;
        case kInitFail://初始化SDK失败回调
            CCExit();
            break;
        case kLoginSuccess://登陆成功回调
			{
				_userLogined = true;
	//            CCMessageBox(msg, "User is  online");
				if (getChannelId() == "000255") 
				{//UC渠道
					printf("开始调用submitLoginGameRole函数\n");
					submitLoginGameRole();
					printf("结束调用submitLoginGameRole函数\n");
				}		
				//add by sxin 回调成功给lua				
				AnySDK_LoginSuccess();					
			}
            break;
        case kLoginNetworkError://登陆失败回调
        case kLoginCancel://登陆取消回调
        case kLoginFail://登陆失败回调
            CCMessageBox(msg, "fail");
            _userLogined = false;
            Analytics::getInstance()->logError("login","fail");

			//add by sxin 回调成功给lua			
			AnySDK_LoginFail();
            break;
        case kLogoutSuccess://登出成功回调
			//add by sxin 回调成功给lua					
			AnySDK_LoginFail();			         
            break;
        case kLogoutFail://登出失败回调
            CCMessageBox(msg  , "登出失败");			
			AnySDK_LoginFail();			          
            break;
        case kPlatformEnter://平台中心进入回调
            break;
        case kPlatformBack://平台中心退出回调
            break;
        case kPausePage://暂停界面回调
            break;
        case kExitPage://退出游戏回调
            CCExit();
            
            break;
        case kAntiAddictionQuery://防沉迷查询回调
            CCMessageBox(msg  , "防沉迷查询回调");
            break;
        case kRealNameRegister://实名注册回调
            CCMessageBox(msg  , "实名注册回调");
            break;
        case kAccountSwitchSuccess://切换账号成功回调
            break;
        case kAccountSwitchFail://切换账号成功回调
            break;
        default:
            break;
    }

	
}

std::string PluginChannel::getChannelId()
{
    return AgentManager::getInstance()->getChannelId();
}



//add by sxin 支持anysdk
//anysdk回调接口
void PluginChannel::AnySDK_LoginSuccess()
{
	CCLOG("Lua_onActionResult");
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();
	lua_getglobal(tolua_s, "AnySDKLogin_Success");       /* query function by name, stack: function */	
	if (!lua_isfunction(tolua_s, -1))
	{
		CCLOG("AnySDKLogin_Success fun not find");
		lua_pop(tolua_s, 1);					
	}
	else
	{	
		pStack->pushString(PluginChannel::getInstance()->getUserId().c_str(),PluginChannel::getInstance()->getUserId().length());
		pStack->pushString(PluginChannel::getInstance()->getChannelId().c_str(),PluginChannel::getInstance()->getChannelId().length());
		int ret = pStack->executeFunction(2);	
		pStack->clean();
		if (ret == -3)
		{
			//失败了
			CCLOG("AnySDKLogin_Success executeFunction error");
			//再尝试一次
			lua_getglobal(tolua_s, "AnySDKLogin_Success");       /* query function by name, stack: function */	
			if (!lua_isfunction(tolua_s, -1))
			{
				CCLOG("AnySDKLogin_Success fun not find");
				lua_pop(tolua_s, 1);	
				//重新登陆
				PluginChannel::getInstance()->login();	
			}
			else
			{
				pStack->pushString(PluginChannel::getInstance()->getUserId().c_str(),PluginChannel::getInstance()->getUserId().length());
				pStack->pushString(PluginChannel::getInstance()->getChannelId().c_str(),PluginChannel::getInstance()->getChannelId().length());
				int ret = pStack->executeFunction(2);	
				pStack->clean();
			}

		}

	}

}


void PluginChannel::AnySDK_LoginFail()
{
	CCLOG("AnySDK_LoginFail");
	PluginChannel::getInstance()->login();	
}

void PluginChannel::AnySDK_InitSuccess()
{
	CCLOG("AnySDK_InitSuccess");
	//CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	//CCLuaStack *pStack = pEngine->getLuaStack();
	//lua_State *tolua_s = pStack->getLuaState();
	//lua_getglobal(tolua_s, "AnySDKInit_Success");       /* query function by name, stack: function */	
	//if (!lua_isfunction(tolua_s, -1))
	//{
	//	CCLOG("AnySDKInit_Success fun not find");
	//	lua_pop(tolua_s, 1);					
	//}
	//else
	//{		
	//	pStack->executeFunction(0);	
	//	pStack->clean();
	//}
}

void PluginChannel::AnySDK_onRequestResult()
{
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();
	lua_getglobal(tolua_s, "AnySDKonRequestResult");       /* query function by name, stack: function */	
	if (!lua_isfunction(tolua_s, -1))
	{
		lua_pop(tolua_s, 1);					
	}
	else
	{		
		pStack->executeFunction(0);	
		pStack->clean();
	}
}

void PluginChannel::AnySDK_onPayResult_Success()
{
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaStack *pStack = pEngine->getLuaStack();
	lua_State *tolua_s = pStack->getLuaState();
	lua_getglobal(tolua_s, "AnySDKonPayResult_Success");       /* query function by name, stack: function */	
	if (!lua_isfunction(tolua_s, -1))
	{
		lua_pop(tolua_s, 1);					
	}
	else
	{		
		pStack->executeFunction(0);		
		pStack->clean();
	}
}
