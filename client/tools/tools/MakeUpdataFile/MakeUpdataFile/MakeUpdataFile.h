
// MakeUpdataFile.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
#endif

#include "resource.h"		// ������
#include <string>
#include "afxdialogex.h"
#include <atlconv.h>
#include <stdio.h> 
#include <locale.h>
#include<vector>
#include <map>

using namespace std;

// CMakeUpdataFileApp:
// �йش����ʵ�֣������ MakeUpdataFile.cpp
//
const CString g_saKey[] = {L"oldPath", L"newPath",L"newVer",L"ftp",L"outPath"} ;
class CMakeUpdataFileApp : public CWinApp
{
public:
	CMakeUpdataFileApp();

private:
	CStdioFile m_fConing;
	CStdioFile m_fLog;
	CStdioFile m_fUpdate;

	CString m_strLogName;
	CString m_strConfigName;
	CString m_strUpdateName;

	vector<CString> m_vecUpdateFiles;
	map<CString, CString> m_mapConInfo;
// ��д
public:
	virtual BOOL InitInstance();

// ʵ��
	void ReadConfigFile();
	void WriteConfigFile();
	map<CString, CString>& GetConfigInfo();

	void SetConfigInfo(CString strInfo);
	void UpdateConfigFile(CString strName, CString strData);
	CString GetDataFromConfigInfo(CString strkey);

	BOOL  IsCanCompare(CString strOld, CString strNew);
	BOOL  IsNullFolder(CString strPath);
	BOOL  CompareUpdateFiles(CString strFullPath, CString strOldPath, CString strNewPath, CString strOutPath);
	BOOL  MakeUpdateZipFile(CString strWinRARPath, CString strOutPath, CString strNewVer);
	BOOL  MakeVerFile(CString strVer, CString strFtp, CString strOutPath);

	void  BackUpResFile(CString strResPath, CString strVer);
	void  CopyResFile(CString strFromPath, CString strToPath);
	void  DelResFile(CString strPath);

	void  UpdateVerNum(CString strVer, CString strKey);
	void  UpdateOldPath(CString strNew, CString strVer, CString strKey);

	CString GetNewData(CString strSrc, WCHAR wSplit, CString strNew);
	void MakeUpdateListFiles(CString strPath, CString strVer);
	void OpenUpdateListFiles();

	BOOL MakeLogFile(CString strPath, CString strVer);
	void OutputLog(CString strMsg);
	void OpenLogFile();
	

	CString GetResourcesPath();
	CString GetWinRARPath();
	DECLARE_MESSAGE_MAP()
};

extern CMakeUpdataFileApp theApp;