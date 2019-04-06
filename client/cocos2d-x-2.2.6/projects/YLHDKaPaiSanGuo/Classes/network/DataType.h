#pragma once

#ifndef __DATATYPE_H__
#define __DATATYPE_H__

/////////////////////////////////////////////
//
// 基本的数据类型头文件
// Utility的库文件
//
// Author	: EL.AHong.F
//
/////////////////////////////////////////////
/////////////////////////////////////////////
//// 包含各种头文件
//#ifndef WINVER			// 确保win2k（含）以上系统使用
//#define WINVER 0x0500
//#endif
//
//#ifndef _WIN32_IE		// 确保IE5.0（含）以上系统使用
//#define _WIN32_IE 0x0500
//#endif
/////////////////////////////////////////////

#if defined(__WINDOWS__) || defined(WIN32)

/////////////////////////////////////////////
#ifndef _AFXDLL				// 区分MFC和非MFC
#	define WIN32_LEAN_AND_MEAN
#	include <windows.h>		// system
#	include <comutil.h>
#	include <windef.h>
#else
#	include <afx.h>			// 如果使用了MFC则直接包含MFC函数
#endif
/////////////////////////////////////////////
// 包含各种头文件
#include <winsock2.h>
#pragma comment(lib, "ws2_32.lib")
#include <mbstring.h>
#include <tchar.h>

#include <process.h>
#include <string>
#include <algorithm>
#include <utility>
#else

#include <sys/types.h>
#include <pthread.h>
#include <string.h>
#endif	// __WINDOWS__ || WIN32

/////////////////////////////////////////////


#include <stdio.h>			// crt
#include <time.h>
#include <math.h>
#include <vector>			// stl
#include <list>
#include <stack>
#include <queue>
#include <map>
#include <set>
/////////////////////////////////////////////

/////////////////////////////////////////////

#ifndef NULL
#define NULL	0
#endif

// 一些方便的宏
#if defined( __WINDOW__ ) || defined(WIN32)
#ifndef SLEEP
#define SLEEP(x) Sleep(x);
#endif	// SLEEP
#elif defined( __LINUX__ )
#ifndef SLEEP
#define SLEEP(x) usleep(x*1000);
#endif	// SLEEP
#endif

#ifndef ARRSIZE
#	define ARRSIZE(x)				(sizeof(x)/sizeof(x[0]))
#endif	// ARRSIZE

#ifndef __INLINE
#	define __INLINE					inline
#endif	// __INLINE

#ifndef SAFE_DELETE
#	define SAFE_DELETE(p)			{ if((p)!=NULL)delete (p),(p)=NULL; }
#endif	// SAFE_DELETE

#ifndef SAFE_DELETE_ARRAY
#	define SAFE_DELETE_ARRAY(p)		{ if((p)!=NULL)delete[] (p),(p)=NULL; }
#endif	// SAFE_DELETE_ARRAY
/////////////////////////////////////////////

/////////////////////////////////////////////
// 如果定义了_DLL，将函数或者类导出
#ifdef UTILITY_EXPORT
#	define UTILITY_EXPORT __declspec( dllexport )
#	pragma message ( "__NOTE__: NOW! Utility is the DLL Version." )
#else
#	define UTILITY_EXPORT
#endif
/////////////////////////////////////////////

/////////////////////////////////////////////
#ifndef _DEBUG
	#define USE_TRY
#endif
#ifdef USE_TRY
#	define TRY_			try				
#	define CATCH_		catch( ... )
#	define TRY_END_	
#else
#	define TRY_
#	define CATCH_		if(0)
#	define TRY_END_		
#endif

/////////////////////////////////////////////

#ifdef __LINUX__
 #ifndef UINT_MAX
 #define UINT_MAX (unsigned int)0xFFFFFFFF
 #endif
#endif

#endif	// __DATATYPE_H__
