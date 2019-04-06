/////////////////////////////////////////////////////////////////////////////////
//�ļ����ƣ�BaseType.h
//����������ϵͳ�ײ����ͻ����ļ�
//�汾˵����Windows����ϵͳ��Ҫ����꣺__WINDOWS__
//			Linux����ϵͳ��Ҫ����꣺__LINUX__
//
/////////////////////////////////////////////////////////////////////////////////
#pragma once
#ifndef __COMMON_BASETYPE_H__
#define __COMMON_BASETYPE_H__

/////////////////////////////////////////////////////////////////////////////////
//��ǰ������ϵͳͷ�ļ�����
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


//IP��ַ���ַ���󳤶�
#define IP_SIZE			24
//��Ч�ľ��
#define INVALID_HANDLE	-1
//��Ч��IDֵ
#define INVALID_ID		-1
//��
#ifndef TRUE
#define TRUE 1
#endif
//��
#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define  NULL 0
#endif

#ifndef HRESULT
#define HRESULT		LONG
#endif

//�ļ�·�����ַ���󳤶�
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


//typedef UINT			GUID_t;	//32λΨһ��š�
////������ڱ�ʾ�û�ΨһID�ţ��û�����Ϊ9λ
////ǰ��λΪ�����,�����0��200Ϊ��ʽ���ݣ�
////					   201��MAX_WORLD-1Ϊ��������
////����Ų��ܳ�������� MAX_WORLD
////ͨ�� GETWORLD ����Դ�GUID_t��ȡ�������

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




//����ָ��ֵɾ���ڴ�
#ifndef SAFE_DELETE
#if defined(__WINDOWS__)
#define SAFE_DELETE(x)	if( (x)!=NULL ) { Assert(_CrtIsValidHeapPointer(x));delete (x); (x)=NULL; }
#elif defined(__LINUX__)
#define SAFE_DELETE(x)	if( (x)!=NULL ) { delete (x); (x)=NULL; }
#endif
#endif
//����ָ��ֵɾ�����������ڴ�
#ifndef SAFE_DELETE_ARRAY
#if defined(__WINDOWS__)
#define SAFE_DELETE_ARRAY(x)	if( (x)!=NULL ) { Assert(_CrtIsValidHeapPointer(x));delete[] (x); (x)=NULL; }
#elif defined(__LINUX__)
#define SAFE_DELETE_ARRAY(x)	if( (x)!=NULL ) { delete[] (x); (x)=NULL; }
#endif
#endif
//����ָ�����free�ӿ�
#ifndef SAFE_FREE
#define SAFE_FREE(x)	if( (x)!=NULL ) { free(x); (x)=NULL; }
#endif
//����ָ�����Release�ӿ�
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
