/////////////////////////////////////////////////////////////////////////////////
//文件名称：BaseType.h
//功能描述：系统底层类型基础文件
//版本说明：Windows操作系统需要定义宏：__WINDOWS__
//			Linux操作系统需要定义宏：__LINUX__
//
/////////////////////////////////////////////////////////////////////////////////
#pragma once
#ifndef __COMMON_BASETYPE_H__
#define __COMMON_BASETYPE_H__

/////////////////////////////////////////////////////////////////////////////////
//当前包含的系统头文件引用
/////////////////////////////////////////////////////////////////////////////////
#if defined(__WINDOWS__) || defined(WIN32)
#pragma warning ( disable : 4786 )
#include <Windows.h>
#include "crtdbg.h"
#include <tchar.h>
#include <hash_map>
#elif defined(__LINUX__)
#include <sys/types.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <list>
#include <vector>
#include <set>
#include <tr1/unordered_map>
//#define INT int
//#define CHAR char
//#define VOID void




#endif	// __WINDOWS__ || WIN32

#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string.h>
#include <time.h>
#include <math.h>
#include <stdarg.h>
#include <limits>

//using namespace std;

//#ifdef UNICODE
//typedef WCHAR					TCHAR, *PTCHAR;
//typedef WCHAR					tchar, *ptchar;
//#ifndef tstring
//typedef std::wstring			tstring;
//#endif	// tstring
//typedef std::wostringstream		tosstringstream;
//#else
//#ifndef tstring
//typedef std::string				tstring;
//#endif	// tstring
//typedef std::ostringstream		tosstringstream;
//#endif	// UNICODE
//
//#define CONST					const

typedef unsigned long			IP_t;


//IP地址的字符最大长度
#define IP_SIZE			24
//无效的句柄
#define INVALID_HANDLE	-1
//无效的ID值
#define INVALID_ID		-1
//真
#ifndef TRUE
#define TRUE 1
#endif
//假
#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define  NULL 0
#endif

#ifndef HRESULT
#define HRESULT		LONG
#endif

//文件路径的字符最大长度
#ifndef _MAX_PATH
#define _MAX_PATH 260
#endif

#ifndef MAX_PATH
#define MAX_PATH 260
#endif	// MAX_PATH

#ifndef MAX_APP_PATH
#define MAX_APP_PATH 260
#endif	// MAX_APP_PATH

#ifndef PURE
#define PURE			= 0
#endif

//#ifndef ULONG_MAX
//#define ULONG_MAX     0xffffffffUL  /* maximum unsigned long value */
//#endif


//typedef UINT			GUID_t;	//32位唯一编号。
////如果用于表示用户唯一ID号，用户部分为9位
////前三位为世界号,世界号0～200为正式数据，
////					   201～MAX_WORLD-1为测试数据
////世界号不能超过或等于 MAX_WORLD
////通过 GETWORLD 宏可以从GUID_t中取得世界号

//#ifndef MAKEWORD
//typedef unsigned long long	ULONG_PTR, *PULONG_PTR;
//typedef ULONG_PTR DWORD_PTR, *PDWORD_PTR;
//#define MAKEWORD(a, b)      ((WORD)(((BYTE)(((DWORD_PTR)(a)) & 0xff)) | ((WORD)((BYTE)(((DWORD_PTR)(b)) & 0xff))) << 8))
//#endif

//#ifndef MAKELONG
//#define MAKELONG(a, b)      ((LONG)(((WORD)(a)) | ((DWORD)((WORD)(b))) << 16))
//#endif	// MAKELONG

//#ifndef INT_MIN
//#define INT_MIN     (-2147483647 - 1) /* minimum (signed) int value */
//#endif	// INT_MIN

//#ifndef INT_MAX
//#define INT_MAX       2147483647    /* maximum (signed) int value */
//#endif	// INT_MAX
//
///* minimum signed 64 bit value */
//#ifndef _I64_MIN
//#define _I64_MIN    (-(((__int64)0x7fffffff<<32) | 0xffffffff) - 1)
//#endif	// _I64_MIN
//
///* maximum signed 64 bit value */
//#ifndef _I64_MAX
//#define _I64_MAX	(((__int64)0x7fffffff<<32) | 0xffffffff)
//#endif	// _I64_MAX
//
//#ifndef _I32_MAX
//#define _I32_MAX	((int)0x7fffffff)
//#endif // _I32_MAX

//#define	MAX_STRING_64	64
//#define	MAX_STRING_256	256
//#define	MAX_STRING_1024	1024




//根据指针值删除内存
#ifndef SAFE_DELETE
#if defined(__WINDOWS__)
#define SAFE_DELETE(x)	if( (x)!=NULL ) { Assert(_CrtIsValidHeapPointer(x));delete (x); (x)=NULL; }
#elif defined(__LINUX__)
#define SAFE_DELETE(x)	if( (x)!=NULL ) { delete (x); (x)=NULL; }
#endif
#endif
//根据指针值删除数组类型内存
#ifndef SAFE_DELETE_ARRAY
#if defined(__WINDOWS__)
#define SAFE_DELETE_ARRAY(x)	if( (x)!=NULL ) { Assert(_CrtIsValidHeapPointer(x));delete[] (x); (x)=NULL; }
#elif defined(__LINUX__)
#define SAFE_DELETE_ARRAY(x)	if( (x)!=NULL ) { delete[] (x); (x)=NULL; }
#endif
#endif
//根据指针调用free接口
#ifndef SAFE_FREE
#define SAFE_FREE(x)	if( (x)!=NULL ) { free(x); (x)=NULL; }
#endif
//根据指针调用Release接口
#ifndef SAFE_RELEASE
#define SAFE_RELEASE(x)	if( (x)!=NULL ) { (x)->Release(); (x)=NULL; }
#endif

inline	bool IsEqualTo0( float a )
{
	if ( a<0.0001f && a>-0.0001f )
		return true;

	return false;
}

#ifdef __SGI_STL_PORT
#define	__MY_MAP__		std::hash_map
#else
#if defined (__WINDOWS__) || defined (WIN32)
#define __MY_MAP__		stdext::hash_map
#else
#define __MY_MAP__		std::tr1::unordered_map
#endif	// __WINDOWS || WIN32
#endif	// __SGI_STL_PORT

#endif	// __COMMON_BASETYPE_H__
