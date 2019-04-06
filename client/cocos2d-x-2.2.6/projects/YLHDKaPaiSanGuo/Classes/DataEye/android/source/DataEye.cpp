/*
** Lua binding: DataEye
** Generated automatically by tolua++-1.0.92 on 05/26/14 16:06:48.
*/

#include "DataEye.h"
#include "CCLuaEngine.h"

#include "DCAccountType.h"
#include "DCGender.h"
#include "DCTaskType.h"

#include "DCLuaAgent.h"

#include <string>
#include <map>

using namespace cocos2d;
using namespace std;

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S, "DCLuaAgent");
 tolua_usertype(tolua_S,"DCLuaEvent");
 tolua_usertype(tolua_S,"DCLuaAccount");
 tolua_usertype(tolua_S,"DCLuaLevels");
 tolua_usertype(tolua_S,"DCLuaTask");
 tolua_usertype(tolua_S,"DCLuaItem");
 tolua_usertype(tolua_S,"DCLuaCardsGame");
 tolua_usertype(tolua_S,"DCLuaVirtualCurrency");
 tolua_usertype(tolua_S,"DCLuaCoin");
 tolua_usertype(tolua_S,"DCLuaConfigParams");
 tolua_usertype(tolua_S,"DCLuaTracking");
}

#ifndef tolua_dataEye_DCAgent_setVersion00
static int tolua_dataEye_DCAgent_setVersion00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaAgent",0,&tolua_err) ||
        !tolua_isstring(tolua_S,2,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,3,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        const char* version = ((const char*)  tolua_tostring(tolua_S,2,0));
        DCLuaAgent::setVersion(version);
    }
    return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'setVersion'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: reportError of class  DCLuaAgent */
#ifndef tolua_dataEye_DCAgent_reportError00
static int tolua_dataEye_DCAgent_reportError00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaAgent",0,&tolua_err) ||
        !tolua_isstring(tolua_S,2,0,&tolua_err) ||
        !tolua_isstring(tolua_S,3,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,4,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        const char* title = ((const char*)  tolua_tostring(tolua_S,2,0));
        const char* content = ((const char*)  tolua_tostring(tolua_S,3,0));
        DCLuaAgent::reportError(title, content);
    }
    return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'reportError'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setVersion of class  DCLuaAgent */
#ifndef tolua_dataEye_DCAgent_uploadNow00
static int tolua_dataEye_DCAgent_uploadNow00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaAgent",0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,2,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        DCLuaAgent::uploadNow();
    }
    return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'uploadNow'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getUID of class  DCLuaAgent */
#ifndef tolua_dataEye_DCAgent_getUID00
static int tolua_dataEye_DCAgent_getUID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaAgent",0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,2,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        const char* uid = DCLuaAgent::getUID();
        tolua_pushstring(tolua_S, uid);
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'getUID'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

#ifndef TOLUA_DISABLE_tolua_DataEye_DCTracking_setEffectPoint00
/* method: setEffectPoint of class  DCLuaTracking */
static int tolua_dataEye_DCTracking_setEffectPoint00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaTracking",0,&tolua_err) ||
		!tolua_isstring(tolua_S,2,0,&tolua_err) ||
		!tolua_istable(tolua_S,3,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,4,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        const char* pointId = ((const char*)  tolua_tostring(tolua_S,2,0));
		map<string,string> labelMap;
		lua_pushnil(tolua_S);
		while(lua_next(tolua_S, -2))
		{
			const char* key = tolua_tostring(tolua_S, -2, 0);
			const char* value = tolua_tostring(tolua_S, -1, 0);
			lua_pop(tolua_S, 1);
			labelMap.insert(pair<string, string>(key, value));
		}
		DCLuaTracking::setEffectPoint(pointId, &labelMap);
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'setEffectPoint'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: buy of class  DCLuaItem */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCItem_buy00
static int tolua_DataEye_DCItem_buy00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaItem",0,&tolua_err) ||
        !tolua_isstring(tolua_S,2,0,&tolua_err) ||
        !tolua_isstring(tolua_S,3,0,&tolua_err) ||
        !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
        !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
        !tolua_isstring(tolua_S,6,0,&tolua_err) ||
		!tolua_isstring(tolua_S,7,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,8,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        const char* itemId = ((const char*)  tolua_tostring(tolua_S,2,0));
        const char* itemType = ((const char*)  tolua_tostring(tolua_S,3,0));
        int itemCount = ((int)  tolua_tonumber(tolua_S,4,0));
        long long virtualCurrency = ((long long)  tolua_tonumber(tolua_S,5,0));
        const char* currencyType = ((const char*)  tolua_tostring(tolua_S,6,0));
		const char* consumePoint = ((const char*)  tolua_tostring(tolua_S,7,0));
        {
            DCLuaItem::buy(itemId,itemType,itemCount,virtualCurrency,currencyType,consumePoint);
        }
    }
    return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'buy'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: buyInLevel of class  DCLuaItem */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCItem_buyInLevel00
static int tolua_DataEye_DCItem_buyInLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"DCLuaItem",0,&tolua_err) ||
        !tolua_isstring(tolua_S,2,0,&tolua_err) ||
        !tolua_isstring(tolua_S,3,0,&tolua_err) ||
        !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
        !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
        !tolua_isstring(tolua_S,6,0,&tolua_err) ||
		!tolua_isstring(tolua_S,7,0,&tolua_err) ||
		!tolua_isstring(tolua_S,8,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,9,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        const char* itemId = ((const char*)  tolua_tostring(tolua_S,2,0));
        const char* itemType = ((const char*)  tolua_tostring(tolua_S,3,0));
        int itemCount = ((int)  tolua_tonumber(tolua_S,4,0));
        long long virtualCurrency = ((long long)  tolua_tonumber(tolua_S,5,0));
        const char* currencyType = ((const char*)  tolua_tostring(tolua_S,6,0));
		const char* consumePoint = ((const char*)  tolua_tostring(tolua_S,7,0));
		const char* levelId = ((const char*)  tolua_tostring(tolua_S,8,0));
        {
            DCLuaItem::buyInLevel(itemId,itemType,itemCount,virtualCurrency,currencyType,consumePoint, levelId);
        }
    }
    return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'buyInLevel'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: get of class  DCLuaItem */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCItem_get00
static int tolua_DataEye_DCItem_get00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaItem",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* itemId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* itemType = ((const char*)  tolua_tostring(tolua_S,3,0));
  int itemCount = ((int)  tolua_tonumber(tolua_S,4,0));
  const char* reason = ((const char*)  tolua_tostring(tolua_S,5,0));
  {
   DCLuaItem::get(itemId,itemType,itemCount,reason);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'get'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInLevel of class  DCLuaItem */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCItem_getInLevel00
static int tolua_DataEye_DCItem_getInLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaItem",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* itemId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* itemType = ((const char*)  tolua_tostring(tolua_S,3,0));
  int itemCount = ((int)  tolua_tonumber(tolua_S,4,0));
  const char* reason = ((const char*)  tolua_tostring(tolua_S,5,0));
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,6,0));
  {
   DCLuaItem::getInLevel(itemId,itemType,itemCount,reason,levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: consume of class  DCLuaItem */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCItem_consume00
static int tolua_DataEye_DCItem_consume00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaItem",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* itemId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* itemType = ((const char*)  tolua_tostring(tolua_S,3,0));
  int itemCount = ((int)  tolua_tonumber(tolua_S,4,0));
  const char* reason = ((const char*)  tolua_tostring(tolua_S,5,0));
  {
   DCLuaItem::consume(itemId,itemType,itemCount,reason);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'consume'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: consumeInLevel of class  DCLuaItem */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCItem_consumeInLevel00
static int tolua_DataEye_DCItem_consumeInLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaItem",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* itemId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* itemType = ((const char*)  tolua_tostring(tolua_S,3,0));
  int itemCount = ((int)  tolua_tonumber(tolua_S,4,0));
  const char* reason = ((const char*)  tolua_tostring(tolua_S,5,0));
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,6,0));
  {
   DCLuaItem::consumeInLevel(itemId,itemType,itemCount,reason,levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'consumeInLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: login of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_login00
static int tolua_DataEye_DCAccount_login00(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* accountId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaAccount::login(accountId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'login'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_login01
static int tolua_DataEye_DCAccount_login01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* accountId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* gameServer = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaAccount::login(accountId, gameServer);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
tolua_lerror:
    return tolua_DataEye_DCAccount_login00(tolua_S);
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: logout of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_logout00
static int tolua_DataEye_DCAccount_logout00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   DCLuaAccount::logout();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'logout'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getAccountId of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_getAccountId00
static int tolua_DataEye_DCAccount_getAccountId00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   const char* accountId = DCLuaAccount::getAccountId();
   tolua_pushstring(tolua_S, accountId);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getAccountId'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAccountType of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_setAccountType00
static int tolua_DataEye_DCAccount_setAccountType00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  DCAccountType accountType = ((DCAccountType) (int)  tolua_tonumber(tolua_S,2,0));
  {
   DCLuaAccount::setAccountType(accountType);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAccountType'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setLevel of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_setLevel00
static int tolua_DataEye_DCAccount_setLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int level = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   DCLuaAccount::setLevel(level);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setGender of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_setGender00
static int tolua_DataEye_DCAccount_setGender00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  DCGender gender = ((DCGender) (int)  tolua_tonumber(tolua_S,2,0));
  {
   DCLuaAccount::setGender(gender);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setGender'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAge of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_setAge00
static int tolua_DataEye_DCAccount_setAge00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int age = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   DCLuaAccount::setAge(age);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAge'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setGameServer of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_setGameServer00
static int tolua_DataEye_DCAccount_setGameServer00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* gameServer = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaAccount::setGameServer(gameServer);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setGameServer'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: tag of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_addTag00
static int tolua_DataEye_DCAccount_addTag00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* tag = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* subTag = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaAccount::addTag(tag, subTag);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addTag'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unTag of class  DCLuaAccount */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCAccount_unTag00
static int tolua_DataEye_DCAccount_removeTag00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaAccount",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* tag = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* subTag = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaAccount::removeTag(tag, subTag);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'removeTag'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: play of class  DCLuaCardsGame */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCardsGame_play00
static int tolua_DataEye_DCCardsGame_play00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCardsGame",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,7,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,8,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* roomId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* id = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,4,0));
  long long loseOrGain = ((long long)  tolua_tonumber(tolua_S,5,0));
  long long tax = ((long long)  tolua_tonumber(tolua_S,6,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,7,0));
  {
   DCLuaCardsGame::play(roomId,id,coinType,loseOrGain,tax,left);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'play'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: gain of class  DCLuaCardsGame */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCardsGame_gain00
static int tolua_DataEye_DCCardsGame_gain00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCardsGame",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* roomId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* id = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,4,0));
  long long gain = ((long long)  tolua_tonumber(tolua_S,5,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,6,0));
  {
   DCLuaCardsGame::gain(roomId,id,coinType,gain,left);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'gain'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: lost of class  DCLuaCardsGame */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCardsGame_lost00
static int tolua_DataEye_DCCardsGame_lost00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCardsGame",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* roomId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* id = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,4,0));
  long long lost = ((long long)  tolua_tonumber(tolua_S,5,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,6,0));
  {
   DCLuaCardsGame::lost(roomId,id,coinType,lost,left);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'lost'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setCoinNum of class  DCLuaCoin */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCoin_setCoinNum00
static int tolua_DataEye_DCCoin_setCoinNum00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCoin",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  long long coinNum = ((long long)  tolua_tonumber(tolua_S,2,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaCoin::setCoinNum(coinNum,coinType);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setCoinNum'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: lost of class  DCLuaCoin */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCoin_lost00
static int tolua_DataEye_DCCoin_lost00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCoin",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* id = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,3,0));
  long long lost = ((long long)  tolua_tonumber(tolua_S,4,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,5,0));
  {
   DCLuaCoin::lost(id,coinType,lost,left);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'lost'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: lostInLevel of class  DCLuaCoin */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCoin_lostInLevel00
static int tolua_DataEye_DCCoin_lostInLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCoin",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* id = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,3,0));
  long long lost = ((long long)  tolua_tonumber(tolua_S,4,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,5,0));
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,6,0));
  {
   DCLuaCoin::lostInLevel(id,coinType,lost,left,levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'lostInLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: gain of class  DCLuaCoin */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCoin_gain00
static int tolua_DataEye_DCCoin_gain00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCoin",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* id = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,3,0));
  long long gain = ((long long)  tolua_tonumber(tolua_S,4,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,5,0));
  {
   DCLuaCoin::gain(id,coinType,gain,left);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'gain'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: gainInLevel of class  DCLuaCoin */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCCoin_gainInLevel00
static int tolua_DataEye_DCCoin_gainInLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaCoin",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* id = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* coinType = ((const char*)  tolua_tostring(tolua_S,3,0));
  long long gain = ((long long)  tolua_tonumber(tolua_S,4,0));
  long long left = ((long long)  tolua_tonumber(tolua_S,5,0));
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,6,0));
  {
   DCLuaCoin::gainInLevel(id,coinType,gain,left,levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'gainInLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventBeforeLogin of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_onEventBeforeLogin00
static int tolua_DataEye_DCEvent_onEventBeforeLogin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_istable(tolua_S,3,0,&tolua_err) ||
	 !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  long long duration = ((long long)  tolua_tonumber(tolua_S,4,0));
  lua_remove(tolua_S, 4);
  map<string,string> labelMap;
  lua_pushnil(tolua_S);
  while(lua_next(tolua_S, -2))
  {
	const char* key = tolua_tostring(tolua_S, -2, 0);
	const char* value = tolua_tostring(tolua_S, -1, 0);
	lua_pop(tolua_S, 1);
	labelMap.insert(pair<string, string>(key, value));
  }
  {
   DCLuaEvent::onEventBeforeLogin(eventId, &labelMap, duration);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onEventEventBeforLogin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventCount of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventCount00
static int tolua_DataEye_DCEvent_onEventCount00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  int count = ((int)  tolua_tonumber(tolua_S,3,0));
  {
   DCLuaEvent::onEventCount(eventId, count);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onEventCount'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEvent of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEvent00
static int tolua_DataEye_DCEvent_onEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaEvent::onEvent(eventId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEvent of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEvent01
static int tolua_DataEye_DCEvent_onEvent01(lua_State* tolua_S)
{
CCLog("event 01");
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* label = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaEvent::onEvent(eventId,label);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEvent00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEvent of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEvent02
static int tolua_DataEye_DCEvent_onEvent02(lua_State* tolua_S)
{
CCLog("event 02");
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
	 !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_istable(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = tolua_tostring(tolua_S, 2, 0);
  map<string,string> labelMap;
  lua_pushnil(tolua_S);
  while(lua_next(tolua_S, -2))
  {
	const char* key = tolua_tostring(tolua_S, -2, 0);
	const char* value = tolua_tostring(tolua_S, -1, 0);
	lua_pop(tolua_S, 1);
	labelMap.insert(pair<string, string>(key, value));
  }
  {
   DCLuaEvent::onEvent(eventId, &labelMap);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEvent01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventDuration of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventDuration00
static int tolua_DataEye_DCEvent_onEventDuration00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  long long duration = ((long long)  tolua_tonumber(tolua_S,3,0));
  {
   DCLuaEvent::onEventDuration(eventId,duration);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onEventDuration'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventDuration of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventDuration01
static int tolua_DataEye_DCEvent_onEventDuration01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* label = ((const char*)  tolua_tostring(tolua_S,3,0));
  long long duration = ((long long)  tolua_tonumber(tolua_S,4,0));
  {
   DCLuaEvent::onEventDuration(eventId,label,duration);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEventDuration00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventDuration of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventDuration02
static int tolua_DataEye_DCEvent_onEventDuration02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_istable(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  long long duration = ((long long)  tolua_tonumber(tolua_S,4,0));
  lua_remove(tolua_S, 4);
  map<string,string> labelMap;
  lua_pushnil(tolua_S);
  while(lua_next(tolua_S, -2))
  {
	const char* key = tolua_tostring(tolua_S, -2, 0);
	const char* value = tolua_tostring(tolua_S, -1, 0);
	lua_pop(tolua_S, 1);
	labelMap.insert(pair<string, string>(key, value));
  }
  {
   DCLuaEvent::onEventDuration(eventId, &labelMap,duration);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEventDuration01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventBegin of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventBegin00
static int tolua_DataEye_DCEvent_onEventBegin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaEvent::onEventBegin(eventId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onEventBegin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventBegin of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventBegin01
static int tolua_DataEye_DCEvent_onEventBegin01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_istable(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  map<string,string> labelMap;
  lua_pushnil(tolua_S);
  while(lua_next(tolua_S, -2))
  {
	const char* key = tolua_tostring(tolua_S, -2, 0);
	const char* value = tolua_tostring(tolua_S, -1, 0);
	lua_pop(tolua_S, 1);
	labelMap.insert(pair<string, string>(key, value));
  }
  {
   DCLuaEvent::onEventBegin(eventId, &labelMap);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEventBegin00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventBegin of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventBegin02
static int tolua_DataEye_DCEvent_onEventBegin02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_istable(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* flag = ((const char*)  tolua_tostring(tolua_S,4,0));
  lua_remove(tolua_S, 4);
  map<string,string> labelMap;
  lua_pushnil(tolua_S);
  while(lua_next(tolua_S, -2))
  {
	const char* key = tolua_tostring(tolua_S, -2, 0);
	const char* value = tolua_tostring(tolua_S, -1, 0);
	lua_pop(tolua_S, 1);
	labelMap.insert(pair<string, string>(key, value));
  }
  {
   DCLuaEvent::onEventBegin(eventId, &labelMap,flag);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEventBegin01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventEnd of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventEnd00
static int tolua_DataEye_DCEvent_onEventEnd00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaEvent::onEventEnd(eventId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onEventEnd'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onEventEnd of class  DCLuaEvent */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCEvent_onEventEnd01
static int tolua_DataEye_DCEvent_onEventEnd01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaEvent",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* flag = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaEvent::onEventEnd(eventId,flag);
  }
 }
 return 0;
tolua_lerror:
 return tolua_DataEye_DCEvent_onEventEnd00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: begin of class  DCLuaLevels */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCLevels_begin00
static int tolua_DataEye_DCLevels_begin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaLevels",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaLevels::begin(levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'begin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: complete of class  DCLuaLevels */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCLevels_complete00
static int tolua_DataEye_DCLevels_complete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaLevels",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaLevels::complete(levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'complete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: fail of class  DCLuaLevels */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCLevels_fail00
static int tolua_DataEye_DCLevels_fail00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaLevels",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* failPoint = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaLevels::fail(levelId,failPoint);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'fail'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: begin of class  DCLuaTask */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCTask_begin00
static int tolua_DataEye_DCTask_begin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaTask",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* taskId = ((const char*)  tolua_tostring(tolua_S,2,0));
  DCTaskType taskType = ((DCTaskType) (int)  tolua_tonumber(tolua_S,3,0));
  {
   DCLuaTask::begin(taskId,taskType);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'begin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: complete of class  DCLuaTask */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCTask_complete00
static int tolua_DataEye_DCTask_complete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaTask",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* taskId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   DCLuaTask::complete(taskId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'complete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: fail of class  DCLuaTask */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCTask_fail00
static int tolua_DataEye_DCTask_fail00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaTask",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* taskId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* reason = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   DCLuaTask::fail(taskId,reason);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'fail'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE


/* method: paymentSuccess of class  DCLuaVirtualCurrency */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCVirtualCurrency_paymentSuccess00
static int tolua_DataEye_DCVirtualCurrency_paymentSuccess00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaVirtualCurrency",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* orderId = ((const char*) tolua_tostring(tolua_S,2,0));
  const char* iapId = ((const char*) tolua_tostring(tolua_S,3,0));
  double currencyAmount = ((double)  tolua_tonumber(tolua_S,4,0));
  const char* currencyType = ((const char*)  tolua_tostring(tolua_S,5,0));
  const char* paymentType = ((const char*)  tolua_tostring(tolua_S,6,0));
  {
   DCLuaVirtualCurrency::paymentSuccess(orderId,iapId,currencyAmount,currencyType,paymentType);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'paymentSuccess'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: paymentSuccessInLevel of class  DCLuaVirtualCurrency */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCVirtualCurrency_paymentSuccessInLevel00
static int tolua_DataEye_DCVirtualCurrency_paymentSuccessInLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaVirtualCurrency",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isstring(tolua_S,6,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,7,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,8,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* orderId = ((const char*) tolua_tostring(tolua_S,2,0));
  const char* iapId = ((const char*) tolua_tostring(tolua_S,3,0));
  double currencyAmount = ((double)  tolua_tonumber(tolua_S,4,0));
  const char* currencyType = ((const char*)  tolua_tostring(tolua_S,5,0));
  const char* paymentType = ((const char*)  tolua_tostring(tolua_S,6,0));
  const char* levelId = ((const char*)  tolua_tostring(tolua_S,7,0));
  {
   DCLuaVirtualCurrency::paymentSuccessInLevel(orderId,iapId,currencyAmount,currencyType,paymentType,levelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'paymentSuccessInLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: update of class  DCLuaConfigParams */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCConfigParams_update00
static int tolua_DataEye_DCConfigParams_update00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaConfigParams",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   DCLuaConfigParams::update();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'update'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getParameterString of class  DCLuaConfigParams */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCConfigParams_getParameter00
static int tolua_DataEye_DCConfigParams_getParameter00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaConfigParams",0,&tolua_err) ||
	 !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
 const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
 const char* defaultValue = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   const char* tolua_ret = ((const char*) DCLuaConfigParams::getParameterString(key, defaultValue));
   tolua_pushstring(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getParameter'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getParameterInt of class  DCLuaConfigParams */
/*#ifndef TOLUA_DISABLE_tolua_DataEye_DCConfigParams_getParameter01
static int tolua_DataEye_DCConfigParams_getParameter01(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaConfigParams",0,&tolua_err) ||
	 !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
 const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
 int defaultValue = ((int)  tolua_tonumber(tolua_S,3,0));
  {
   int tolua_ret = ((int) DCLuaConfigParams::getParameterInt(key, defaultValue));
   tolua_pushnumber(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 return tolua_DataEye_DCConfigParams_getParameter00(tolua_S);
#endif
}
#endif //#ifndef TOLUA_DISABLE*/

#ifndef TOLUA_DISABLE_tolua_DataEye_DCConfigParams_getParameter01
static int tolua_DataEye_DCConfigParams_getParameter01(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaConfigParams",0,&tolua_err) ||
	 !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
 const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
 long long defaultValue = ((long long)  tolua_tonumber(tolua_S,3,0));
  {
   long long tolua_ret = ((long long) DCLuaConfigParams::getParameterLong(key, defaultValue));
   tolua_pushnumber(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 return tolua_DataEye_DCConfigParams_getParameter00(tolua_S);
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getParameterInt of class  DCLuaConfigParams */
#ifndef TOLUA_DISABLE_tolua_DataEye_DCConfigParams_getParameter02
static int tolua_DataEye_DCConfigParams_getParameter02(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DCLuaConfigParams",0,&tolua_err) ||
	 !tolua_isstring(tolua_S,2,0,&tolua_err) ||
	 !tolua_isboolean(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
 const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
 bool defaultValue = ((bool)  tolua_toboolean(tolua_S,3,0));
  {
   bool tolua_ret = ((bool) DCLuaConfigParams::getParameterBool(key, defaultValue));
   tolua_pushboolean(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 return tolua_DataEye_DCConfigParams_getParameter01(tolua_S);
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_DataEye_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
 
  tolua_constant(tolua_S,"DC_Anonymous",DC_Anonymous);
  tolua_constant(tolua_S,"DC_Registered",DC_Registered);
  tolua_constant(tolua_S,"DC_SinaWeibo",DC_SinaWeibo);
  tolua_constant(tolua_S,"DC_QQ",DC_QQ);
  tolua_constant(tolua_S,"DC_QQWeibo",DC_QQWeibo);
  tolua_constant(tolua_S,"DC_ND91",DC_ND91);
  tolua_constant(tolua_S,"DC_Type1",DC_Type1);
  tolua_constant(tolua_S,"DC_Type2",DC_Type2);
  tolua_constant(tolua_S,"DC_Type3",DC_Type3);
  tolua_constant(tolua_S,"DC_Type4",DC_Type4);
  tolua_constant(tolua_S,"DC_Type5",DC_Type5);
  tolua_constant(tolua_S,"DC_Type6",DC_Type6);
  tolua_constant(tolua_S,"DC_Type7",DC_Type7);
  tolua_constant(tolua_S,"DC_Type8",DC_Type8);
  tolua_constant(tolua_S,"DC_Type9",DC_Type9);
  tolua_constant(tolua_S,"DC_Type10",DC_Type10);
  tolua_constant(tolua_S,"DC_UNKNOWN",DC_UNKNOWN);
  tolua_constant(tolua_S,"DC_MALE",DC_MALE);
  tolua_constant(tolua_S,"DC_FEMALE",DC_FEMALE);
  tolua_constant(tolua_S,"DC_GuideLine",DC_GuideLine);
  tolua_constant(tolua_S,"DC_MainLine",DC_MainLine);
  tolua_constant(tolua_S,"DC_BranchLine",DC_BranchLine);
  tolua_constant(tolua_S,"DC_Daily",DC_Daily);
  tolua_constant(tolua_S,"DC_Activity",DC_Activity);
  tolua_constant(tolua_S,"DC_Other",DC_Other);
  
  tolua_cclass(tolua_S,"DCLuaItem","DCLuaItem","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaItem");
   tolua_function(tolua_S,"buy",tolua_DataEye_DCItem_buy00);
   tolua_function(tolua_S,"buyInLevel",tolua_DataEye_DCItem_buyInLevel00);
   tolua_function(tolua_S,"get",tolua_DataEye_DCItem_get00);
   tolua_function(tolua_S,"getInLevel",tolua_DataEye_DCItem_getInLevel00);
   tolua_function(tolua_S,"consume",tolua_DataEye_DCItem_consume00);
   tolua_function(tolua_S,"consumeInLevel",tolua_DataEye_DCItem_consumeInLevel00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaAgent","DCLuaAgent","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaAgent");
	tolua_function(tolua_S, "setVersion", tolua_dataEye_DCAgent_setVersion00);
    tolua_function(tolua_S, "reportError", tolua_dataEye_DCAgent_reportError00);
	tolua_function(tolua_S, "uploadNow", tolua_dataEye_DCAgent_uploadNow00);
	tolua_function(tolua_S, "getUID", tolua_dataEye_DCAgent_getUID00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaTracking","DCLuaTracking","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaTracking");
	tolua_function(tolua_S, "setEffectPoint", tolua_dataEye_DCTracking_setEffectPoint00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaAccount","DCLuaAccount","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaAccount");
  tolua_function(tolua_S,"login",tolua_DataEye_DCAccount_login00);
   tolua_function(tolua_S,"login",tolua_DataEye_DCAccount_login01);
   tolua_function(tolua_S,"logout",tolua_DataEye_DCAccount_logout00);
   tolua_function(tolua_S,"getAccountId",tolua_DataEye_DCAccount_getAccountId00);
   tolua_function(tolua_S,"setAccountType",tolua_DataEye_DCAccount_setAccountType00);
   tolua_function(tolua_S,"setLevel",tolua_DataEye_DCAccount_setLevel00);
   tolua_function(tolua_S,"setGender",tolua_DataEye_DCAccount_setGender00);
   tolua_function(tolua_S,"setAge",tolua_DataEye_DCAccount_setAge00);
   tolua_function(tolua_S,"setGameServer",tolua_DataEye_DCAccount_setGameServer00);
   tolua_function(tolua_S,"addTag",tolua_DataEye_DCAccount_addTag00);
   tolua_function(tolua_S,"removeTag",tolua_DataEye_DCAccount_removeTag00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaCardsGame","DCLuaCardsGame","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaCardsGame");
   tolua_function(tolua_S,"play",tolua_DataEye_DCCardsGame_play00);
   tolua_function(tolua_S,"gain",tolua_DataEye_DCCardsGame_gain00);
   tolua_function(tolua_S,"lost",tolua_DataEye_DCCardsGame_lost00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaCoin","DCLuaCoin","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaCoin");
   tolua_function(tolua_S,"setCoinNum",tolua_DataEye_DCCoin_setCoinNum00);
   tolua_function(tolua_S,"lost",tolua_DataEye_DCCoin_lost00);
   tolua_function(tolua_S,"lostInLevel",tolua_DataEye_DCCoin_lostInLevel00);
   tolua_function(tolua_S,"gain",tolua_DataEye_DCCoin_gain00);
   tolua_function(tolua_S,"gainInLevel",tolua_DataEye_DCCoin_gainInLevel00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaEvent","DCLuaEvent","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaEvent");
  tolua_function(tolua_S,"onEventBeforeLogin",tolua_DataEye_DCEvent_onEventBeforeLogin00);
   tolua_function(tolua_S,"onEventCount",tolua_DataEye_DCEvent_onEventCount00);
   tolua_function(tolua_S,"onEvent",tolua_DataEye_DCEvent_onEvent00);
   tolua_function(tolua_S,"onEvent",tolua_DataEye_DCEvent_onEvent01);
   tolua_function(tolua_S,"onEvent",tolua_DataEye_DCEvent_onEvent02);
   tolua_function(tolua_S,"onEventDuration",tolua_DataEye_DCEvent_onEventDuration00);
   tolua_function(tolua_S,"onEventDuration",tolua_DataEye_DCEvent_onEventDuration01);
   tolua_function(tolua_S,"onEventDuration",tolua_DataEye_DCEvent_onEventDuration02);
   tolua_function(tolua_S,"onEventBegin",tolua_DataEye_DCEvent_onEventBegin00);
   tolua_function(tolua_S,"onEventBegin",tolua_DataEye_DCEvent_onEventBegin01);
   tolua_function(tolua_S,"onEventBegin",tolua_DataEye_DCEvent_onEventBegin02);
   tolua_function(tolua_S,"onEventEnd",tolua_DataEye_DCEvent_onEventEnd00);
   tolua_function(tolua_S,"onEventEnd",tolua_DataEye_DCEvent_onEventEnd01);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaLevels","DCLuaLevels","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaLevels");
   tolua_function(tolua_S,"begin",tolua_DataEye_DCLevels_begin00);
   tolua_function(tolua_S,"complete",tolua_DataEye_DCLevels_complete00);
   tolua_function(tolua_S,"fail",tolua_DataEye_DCLevels_fail00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaTask","DCLuaTask","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaTask");
   tolua_function(tolua_S,"begin",tolua_DataEye_DCTask_begin00);
   tolua_function(tolua_S,"complete",tolua_DataEye_DCTask_complete00);
   tolua_function(tolua_S,"fail",tolua_DataEye_DCTask_fail00);
  tolua_endmodule(tolua_S);
  
  tolua_cclass(tolua_S,"DCLuaVirtualCurrency","DCLuaVirtualCurrency","",NULL);
  tolua_beginmodule(tolua_S,"DCLuaVirtualCurrency");
   tolua_function(tolua_S,"paymentSuccess",tolua_DataEye_DCVirtualCurrency_paymentSuccess00);
   tolua_function(tolua_S,"paymentSuccessInLevel",tolua_DataEye_DCVirtualCurrency_paymentSuccessInLevel00);
  tolua_endmodule(tolua_S);
  
 tolua_cclass(tolua_S, "DCLuaConfigParams", "DCLuaConfigParams", "", NULL);
 tolua_beginmodule(tolua_S, "DCLuaConfigParams");
	tolua_function(tolua_S, "update", tolua_DataEye_DCConfigParams_update00);
	tolua_function(tolua_S, "getParameter", tolua_DataEye_DCConfigParams_getParameter00);
	tolua_function(tolua_S, "getParameter", tolua_DataEye_DCConfigParams_getParameter01);
	tolua_function(tolua_S, "getParameter", tolua_DataEye_DCConfigParams_getParameter02);
 tolua_endmodule(tolua_S);
 
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_DataEye (lua_State* tolua_S) {
 return tolua_DataEye_open(tolua_S);
};
#endif

