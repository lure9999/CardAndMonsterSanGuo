
#ifndef __DATAEYE_H_
#define __DATAEYE_H_

extern "C" {
#include "lua.h"
#include "tolua++.h"
#include "tolua_fix.h"
}

TOLUA_API int luaopen_DataEye(lua_State* tolua_S);

#endif // __DATAEYE_H_
