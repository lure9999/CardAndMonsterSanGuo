
// MakeUpdataFile.cpp : ����Ӧ�ó��������Ϊ��
//

#include "stdafx.h"
#include "MakeUpdataFile.h"
#include "MakeUpdataFileDlg.h"
#include "MD5Checksum.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif
#include <string>
#include "afxdialogex.h"
#include <atlconv.h>
#include <stdio.h> 
#include <locale.h>
#define LEN 1024
#define MAX_STR_SIZE 512
BEGIN_MESSAGE_MAP(CMakeUpdataFileApp, CWinApp)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()

// CMakeUpdataFileApp ����

CMakeUpdataFileApp::CMakeUpdataFileApp()
{
	// ֧����������������
	m_dwRestartManagerSupportFlags = AFX_RESTART_MANAGER_SUPPORT_RESTART;

	// TODO: �ڴ˴���ӹ�����룬
	// ��������Ҫ�ĳ�ʼ�������� InitInstance ��
	m_strConfigName = L"config.ini";
}


// Ψһ��һ�� CMakeUpdataFileApp ����

CMakeUpdataFileApp theApp;

// CMakeUpdataFileApp ��ʼ��

BOOL CMakeUpdataFileApp::InitInstance()
{
	// ���һ�������� Windows XP �ϵ�Ӧ�ó����嵥ָ��Ҫ
	// ʹ�� ComCtl32.dll �汾 6 ����߰汾�����ÿ��ӻ���ʽ��
	//����Ҫ InitCommonControlsEx()�����򣬽��޷��������ڡ�
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// ��������Ϊ��������Ҫ��Ӧ�ó�����ʹ�õ�
	// �����ؼ��ࡣ
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();


	AfxEnableControlContainer();

	// ���� shell ���������Է��Ի������
	// �κ� shell ����ͼ�ؼ��� shell �б���ͼ�ؼ���
	CShellManager *pShellManager = new CShellManager;

	// ��׼��ʼ��
	// ���δʹ����Щ���ܲ�ϣ����С
	// ���տ�ִ���ļ��Ĵ�С����Ӧ�Ƴ�����
	// ����Ҫ���ض���ʼ������
	// �������ڴ洢���õ�ע�����
	// TODO: Ӧ�ʵ��޸ĸ��ַ�����
	// �����޸�Ϊ��˾����֯��
	SetRegistryKey(_T("Ӧ�ó��������ɵı���Ӧ�ó���"));
	CMakeUpdataFileDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: �ڴ˷��ô����ʱ��
		//  ��ȷ�������رնԻ���Ĵ���
		//DeleteNullFolder(GetOutPath());
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: �ڴ˷��ô����ʱ��
		//  ��ȡ�������رնԻ���Ĵ���
	}

	// ɾ�����洴���� shell ��������
	//if (pShellManager != NULL)
	//{
	//	delete pShellManager;
	//}

	// ���ڶԻ����ѹرգ����Խ����� FALSE �Ա��˳�Ӧ�ó���
	//  ����������Ӧ�ó������Ϣ�á�

	return FALSE;
}

size_t _utf_length(const char* utf8str_) 
{
	size_t cnt = 0;
	while (*utf8str_++)
		cnt++;
	return cnt;
}

size_t _utf_length(const wchar_t* utf16str_)
{
	size_t cnt = 0;
	while (*utf16str_++)
		cnt++;
	return cnt;
}

size_t _encoded_size(wchar_t codepoint_)
{
	if (codepoint_ < 0x80)
		return 1;
	else if (codepoint_ < 0x0800)
		return 2;
	else if (codepoint_ < 0x10000)
		return 3;
	else
		return 4;
}

size_t Utf8ToUtf16(const char* src_, wchar_t* dest_, size_t destlen_, size_t srclen_ /*= 0*/) 
{
	if (srclen_ == 0)
		srclen_ = _utf_length(src_);
	size_t destcapacity = destlen_;
	for (size_t idx = 0; ((idx < srclen_) && (destcapacity > 0));)
	{
		wchar_t	cp;
		unsigned char	cu = src_[idx++];
		if (cu < 0x80)
			cp = (wchar_t)(cu);
		else if (cu < 0xE0)
		{
			cp = ((cu & 0x1F) << 6);
			cp |= (src_[idx++] & 0x3F);
		}
		else if (cu < 0xF0)
		{
			cp = ((cu & 0x0F) << 12);
			cp |= ((src_[idx++] & 0x3F) << 6);
			cp |= (src_[idx++] & 0x3F);
		}
		else
		{
			cp = L'?';
		}
		*dest_++ = cp;
		--destcapacity;
	}
	return destlen_ - destcapacity;
}

size_t Utf16ToUtf8(const wchar_t* src_, char* dest_, size_t destlen_, size_t srclen_)
{
	if (srclen_ == 0)
		srclen_ = _utf_length(src_);
	size_t destcapacity = destlen_;
	for (size_t idx = 0; idx < srclen_; ++idx)
	{
		wchar_t cp = src_[idx];
		if (destcapacity < _encoded_size(cp))
			break;
		if (cp < 0x80)
		{
			*dest_++ = (char)cp;
			--destcapacity;
		}
		else if (cp < 0x0800)
		{
			*dest_++ = (char)((cp >> 6) | 0xC0);
			*dest_++ = (char)((cp & 0x3F) | 0x80);
			destcapacity -= 2;
		}
		else if (cp < 0x10000)
		{
			*dest_++ = (char)((cp >> 12) | 0xE0);
			*dest_++ = (char)(((cp >> 6) & 0x3F) | 0x80);
			*dest_++ = (char)((cp & 0x3F) | 0x80);
			destcapacity -= 3;
		}
		else
		{
			*dest_++ = (char)'?';
			*dest_++ = (char)'?';
			*dest_++ = (char)'?';
			*dest_++ = (char)'?';
			destcapacity -= 4;
		}
	}
	return destlen_ - destcapacity;
}

void CMakeUpdataFileApp::ReadConfigFile()
{
	if(m_fConing.Open(m_strConfigName,CFile::modeRead|CFile::typeText)!=0)
	{
		CString strConInfo =NULL;
		while(m_fConing.ReadString(strConInfo))
		{
			SetConfigInfo(strConInfo);
		}
		m_fConing.Close();
	}
}

void CMakeUpdataFileApp::WriteConfigFile()
{
	if(m_fConing.Open(m_strConfigName, CFile::modeCreate|CFile::modeNoTruncate|CFile::typeText|CFile::modeReadWrite)!=0)
	{
		m_fConing.SeekToBegin();
		for (map<CString, CString>::iterator pIter=m_mapConInfo.begin(); pIter!=m_mapConInfo.end();++pIter)
		{
			CString strInfo = pIter->first+L"=";
			strInfo += pIter->second+L"\n";
			m_fConing.WriteString(strInfo);
		}
		m_fConing.Close();
	}
}

void CMakeUpdataFileApp::UpdateConfigFile(CString strKey, CString strValue)
{
	//���map����С��1, ��������
	if (m_mapConInfo.size()<1)
	{
		m_mapConInfo.insert(map<CString,CString>::value_type(strKey, strValue));
	}
	else
	{
		map<CString, CString>::iterator pIter;
		pIter=m_mapConInfo.find(strKey);
		//�����map���ҵ�,��������
		if(pIter!=m_mapConInfo.end())
		{
			if (strValue.Compare(pIter->second)!=0)
			{
				pIter->second=strValue;
			}
		}
		else//�����map��û�ҵ�,��������
		{
			m_mapConInfo.insert(map<CString,CString>::value_type(strKey, strValue));
		}
	}
}

CString CMakeUpdataFileApp::GetDataFromConfigInfo(CString strkey)
{
	map<CString, CString>::iterator pIter=m_mapConInfo.find(strkey);
	if(pIter!=m_mapConInfo.end())
	{
		return pIter->second;
	}
	else
	{
		return NULL;
	}
}

void CMakeUpdataFileApp::SetConfigInfo(CString strInfo)
{
	int nSplit = strInfo.Find(L"=");
	CString strData = strInfo.Mid(nSplit+1);
	CString strName = strInfo.Left(nSplit);
	UpdateConfigFile(strName, strData);
}

BOOL CMakeUpdataFileApp::IsCanCompare(CString strOld, CString strNew)
{
	if (!PathFileExists(strOld))
	{
		AfxMessageBox(_T("����Դ·�������ڣ�"));
		return FALSE;
	}

	if (!PathFileExists(strNew))
	{
		AfxMessageBox(_T("����Դ·�������ڣ�"));
		return FALSE;
	}

	if (IsNullFolder(strNew))
	{
		AfxMessageBox(_T("����Դ·�ļ���Ϊ�գ�"));
		return FALSE;
	}
	return TRUE;
}

BOOL CMakeUpdataFileApp::IsNullFolder(CString strPath)
{
	CFileFind   cFinder; 
	BOOL bFound = cFinder.FindFile(strPath+ _T("\\*"),0); 

	while(bFound) 
	{ 
		bFound = cFinder.FindNextFile(); 
		if(cFinder.GetFileName()== _T(".")||cFinder.GetFileName()== _T("..")) 
		{
			continue; 
		}
		return FALSE;
	}
	return TRUE;
}

BOOL CMakeUpdataFileApp::CompareUpdateFiles(CString strFullPath, CString strOldPath, CString strNewPath, CString strOutRoot)
{
	CFileFind   cFinder; 
	BOOL bFound = cFinder.FindFile(strFullPath+ _T("\\*"),0); 
	while(bFound) 
	{ 
		bFound = cFinder.FindNextFile(); 
		if(cFinder.GetFileName()== _T(".")||cFinder.GetFileName()== _T("..")) 
		{
			continue; 
		}
		if(cFinder.IsDirectory())  
		{  
			CompareUpdateFiles(cFinder.GetFilePath(), strOldPath, strNewPath, strOutRoot);
		}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
		else
		{
			CString strOldFileName = cFinder.GetFilePath();
			CString strOutNewPath = cFinder.GetFilePath();
			strOldFileName.Replace(strNewPath, strOldPath);
			strOutNewPath.Replace(strNewPath, strOutRoot);

			CString  strOutPath =cFinder.GetFilePath();
			strOutPath.Replace(strNewPath, strOutRoot);
			if(PathFileExists(strOldFileName))
			{// ����
				CString ss = CMD5Checksum::GetMD5(strOldFileName);
				CString ss1 = CMD5Checksum::GetMD5(cFinder.GetFilePath());
				if(ss1.Compare(ss) == 0)
				{// �ļ���ͬ��������
					continue;
				}
				else
				{// �ļ���ͬ�ŵ�����Ŀ¼
					// ������ļ�����Ŀ¼
					strOutPath.Replace(cFinder.GetFileName(), NULL);
					// ���Ŀ¼�����ڣ�����Ŀ¼
					if(PathFileExists(strOutPath)==FALSE)
					{
						CString str=L"Create Dir: "; 
						str+=strOutPath;
						if (SHCreateDirectoryEx(NULL, strOutPath, NULL) != ERROR_SUCCESS)
						{
							str+=" Failed !";
							return FALSE;
						}
						str+=" Successfully !";
						OutputLog(str);
					}
					
					CString str=L"Copy File: "; 
					str+=cFinder.GetFileName();
					if(CopyFile(cFinder.GetFilePath(), strOutNewPath, false)==FALSE)
					{
						str+=" Failed !";
						OutputLog(str);  
						return FALSE;
					}
					str+=" Successfully !";
					OutputLog(str); 

					CString strLogFileName = cFinder.GetFilePath();
					strLogFileName.Replace(strNewPath+L"\\", NULL);
					m_vecUpdateFiles.push_back(strLogFileName);
				}
			}
			else
			{// ������
				// ������ļ�����Ŀ¼
				strOutPath.Replace(cFinder.GetFileName(), NULL);
				// ���Ŀ¼�����ڣ�����Ŀ¼
				if(PathFileExists(strOutPath)==FALSE)
				{
					CString str=L"Create Dir: "; 
					str+=strOutPath;
					if (SHCreateDirectoryEx(NULL, strOutPath, NULL) != ERROR_SUCCESS)
					{
						str+=" Failed !";
						OutputLog(str);  
						return FALSE;
					}
					str+=" Successfully !";
					OutputLog(str); 
				}
				CString str=L"Copy File: "; 
				str+=cFinder.GetFileName();
				if(CopyFile(cFinder.GetFilePath(), strOutNewPath, false)==FALSE)
				{
					str+=" Failed !";
					OutputLog(str); 
					return FALSE;
				}
				str+=" Successfully !";
				OutputLog(str); 

				CString strLogFileName = cFinder.GetFilePath();
				strLogFileName.Replace(strNewPath+_T("\\"), NULL);
				m_vecUpdateFiles.push_back(strLogFileName);
			}
		}
	}
	cFinder.Close();
	return TRUE;
}
BOOL CMakeUpdataFileApp::MakeUpdateZipFile(CString strWinRARPath, CString strOutPath, CString strNewVer)
{
	USES_CONVERSION;
	CString strZipPath =  strOutPath+"\\"+"zip"+"\\"+strNewVer;

	if(m_vecUpdateFiles.size()==0)
	{
		AfxMessageBox(_T("û���ļ������£�"));
		return FALSE;
	}
	if (!PathFileExists(strZipPath))
	{
		if (SHCreateDirectoryEx(NULL, strZipPath, NULL) != ERROR_SUCCESS)
		{
			return FALSE;
		}
	}

	//CString strZip = strWinRARPath;\

	/*CString strZip;
	GetCurrentDirectory(1024, strZip);*/
	CString strZip = L"WinRAR.exe";
	strZip += " a -k -r -s -m1 -ibck -ep1 ";
	strZip += strZipPath;
	strZip += "\\";
	strZip += strNewVer;
	strZip += ".zip ";
	CString strResPath = strOutPath+"\\res"+"\\"+strNewVer;
	if (!PathFileExists(strResPath))
	{
		return FALSE;
	}

	strResPath += "\\*.*";
	strZip += strResPath;

	UINT uResult = WinExec((LPCSTR)T2A(strZip),SW_SHOW);
	if (uResult<=31)
	{
		return FALSE;
	}
	return TRUE;
}

BOOL CMakeUpdataFileApp::MakeVerFile(CString strVer, CString strFtp, CString strOutPath)
{

	CString strVerName = strOutPath+"\\"+"zip"+"\\"+strVer;
	strVerName += "\\ver.ini";

	CStdioFile verFile;

	CFileException fileException; 
	if(verFile.Open(strVerName, CFile::modeCreate|CFile::modeNoTruncate|CFile::typeText|CFile::modeWrite)==0)
	{
		return FALSE;
	}
	else
	{
		CString str = strVer+"\n";
		str += strFtp;
		str += "/pub/";
		str += strVer;
		str += "/";
		str += strVer;
		str += ".zip";
		verFile.WriteString(str);
		verFile.Close();
		//verFile.WriteString(L"ftp://192.168.0.163//pub//1.1//1.1.zip");
		return TRUE;
	}
}

void CMakeUpdataFileApp::BackUpResFile(CString strResPath, CString strVer)
{
	CString strBackup = GetNewData(strResPath, '\\', strVer);
	CopyResFile(strResPath, strBackup);
	DelResFile(strResPath);
}

void  CMakeUpdataFileApp::CopyResFile(CString strFromPath, CString strToPath)  
{  
	CreateDirectory(strToPath,NULL); 
	CFileFind cFinder;  
	BOOL bFound = cFinder.FindFile(strFromPath+ _T("\\*"),0); 
	while(bFound)
	{  
		bFound = cFinder.FindNextFile();  
		if(cFinder.IsDirectory() && !cFinder.IsDots())
		{ //���ļ��� ���� ���Ʋ��� . �� ..  

			CopyResFile(cFinder.GetFilePath(),strToPath+"\\"+cFinder.GetFileName()); //�ݹ鴴���ļ���+"/"+finder.GetFileName()  
		}  
		else
		{ //���ļ� ��ֱ�Ӹ���  
			CopyFile(cFinder.GetFilePath(),strToPath+"\\"+cFinder.GetFileName(),FALSE);
			//MoveFile(finder.GetFilePath(),strToPath+"\\"+finder.GetFileName());
		}  
	}  
	cFinder.Close();
}  

void CMakeUpdataFileApp::DelResFile(CString strResPath)
{
	//����ɾ���ļ������ļ��� 
	CFileFind   cFinder; 
	BOOL bFound = cFinder.FindFile(strResPath+ _T("\\*"),0); 
	while(bFound) 
	{ 
		bFound = cFinder.FindNextFile(); 
		if(cFinder.IsDots()) 
		{
			continue; 
		}
		//ȥ���ļ�(��)ֻ�������� 
		SetFileAttributes(cFinder.GetFilePath(),FILE_ATTRIBUTE_NORMAL); 
		if(cFinder.IsDirectory())  
		{   
			//�ݹ�ɾ�����ļ��� 
			DelResFile(cFinder.GetFilePath()); 
			RemoveDirectory(cFinder.GetFilePath()); 
		} 
		else   
		{ 
			DeleteFile(cFinder.GetFilePath());   //ɾ���ļ� 
		} 
	} 
	cFinder.Close(); 
}

CString CMakeUpdataFileApp::GetNewData(CString strSrc, WCHAR wSplit, CString strNew)
{
	int nSpilt = strSrc.ReverseFind(wSplit);
	CString strDes =strSrc.Left(nSpilt); 
	strDes+=L"\\";
	strDes+=strNew;
	return strDes;
}

void CMakeUpdataFileApp::UpdateVerNum(CString strVer, CString strKey)
{
	int nSpilt = strVer.ReverseFind('.');
	int nCount = strVer.Remove('.');
	int nOldLen= strVer.GetLength();
	if (nCount!=0)
	{
		int nNewVer = _ttoi(strVer)+1;
		CString strNewVer;
		strNewVer.Format(L"%d", nNewVer);
		int nNewLen = strNewVer.GetLength();
		if (nNewLen>nOldLen)
		{
			strNewVer.Insert(nSpilt+1,'.');
		}
		else
		{
			strNewVer.Insert(nSpilt,'.');
		}
		if (!strNewVer.IsEmpty())
		{
			UpdateConfigFile(strKey, strNewVer);
		}
	}
}

void CMakeUpdataFileApp::MakeUpdateListFiles(CString strPath, CString strVer)
{
	m_strUpdateName =  strPath+"\\"+"zip"+"\\"+L"UpdateFiles_"+strVer+L".txt";
	if(PathFileExists(m_strUpdateName))
	{
		DeleteFile(m_strUpdateName);
	}

	CString str = strPath+"\\"+"zip";
	if (!PathFileExists(str))
	{
		SHCreateDirectoryEx(NULL, str, NULL);
	}

	if(m_fUpdate.Open(m_strUpdateName, CFile::modeCreate|CFile::modeNoTruncate|CFile::typeText|CFile::modeWrite)!=0)
	{
		for (vector<CString>::iterator pIter=m_vecUpdateFiles.begin();pIter!=m_vecUpdateFiles.end();++pIter)
		{
			CString strFileName =L"";
			strFileName = setlocale( LC_CTYPE, ("chs"));
			strFileName = *pIter;
			m_fUpdate.WriteString(strFileName+L"\r\n");
		}
	}
	m_fUpdate.Close();
}

void CMakeUpdataFileApp::OpenUpdateListFiles()
{
	USES_CONVERSION;
	if(!PathFileExists(m_strUpdateName))
	{
		AfxMessageBox(_T("�ļ������ڣ�"));
		return;
	}
	CString str = L"notepad " + m_strUpdateName;
	int nRet = WinExec((LPCSTR)T2A(str),SW_SHOW);
	if (nRet<=31)
	{
		AfxMessageBox(_T("���ļ�ʧ�ܣ�"));
	}

}
BOOL CMakeUpdataFileApp::MakeLogFile(CString strPath, CString strVer)
{
	m_strLogName =  strPath+"\\"+"zip"+"\\"+L"Log_"+strVer+L".txt";
	CString str = strPath+"\\"+"zip";
	if (!PathFileExists(str))
	{
		SHCreateDirectoryEx(NULL, str, NULL);
	}
	if(m_fLog.Open(m_strLogName, CFile::modeCreate|CFile::modeNoTruncate|CFile::typeText|CFile::modeWrite)!=0)
	{
		m_fLog.Close();
		return TRUE;
	}
	AfxMessageBox(_T("������־�ļ�ʧ�ܣ�"));
	return FALSE;
}

void CMakeUpdataFileApp::UpdateOldPath(CString strNew, CString strVer, CString strKey)
{
	CString strOldPath = GetNewData(strNew, '\\', strVer);
	if (!strOldPath.IsEmpty())
	{
		UpdateConfigFile(strKey, strOldPath);
	}
}

void CMakeUpdataFileApp::OutputLog(CString strMsg)
{
	try
	{
		//�����ļ��Ĵ򿪲���
		//CStdioFile outFile(m_fLog, CFile::modeNoTruncate | CFile::modeCreate | CFile::modeWrite | CFile::typeText);
		if(m_fLog.Open(m_strLogName, CFile::modeCreate|CFile::modeNoTruncate|CFile::typeText|CFile::modeWrite)!=0)
		{
			CString msLine;
			CTime tt = CTime::GetCurrentTime();
			//����ĸ�ʽ�磺2010-June-10 Thursday, 15:58:12
			msLine = tt.Format("[%Y-%M-%d %H:%M:%S] ") + strMsg;
			msLine += "\n";

			//���ļ�ĩβ�����¼�¼
			m_fLog.SeekToEnd();
			m_fLog.WriteString( msLine );
			m_fLog.Close();
		}
	}
	catch(CFileException *fx)
	{
		fx->Delete();
	}
}

void CMakeUpdataFileApp::OpenLogFile()
{
	USES_CONVERSION;
	if(!PathFileExists(m_strLogName))
	{
		AfxMessageBox(_T("�ļ������ڣ�"));
		return;
	}
	CString str = L"notepad " + m_strLogName;
	int nRet = WinExec((LPCSTR)T2A(str),SW_SHOW);
	if (nRet<=31)
	{
		AfxMessageBox(_T("���ļ�ʧ�ܣ�"));
	}
}

CString CMakeUpdataFileApp::GetResourcesPath()
{
	TCHAR           szFolderPath[MAX_PATH] = {0};  
	CString         strFolderPath = TEXT("");  

	BROWSEINFO      sInfo;  
	::ZeroMemory(&sInfo, sizeof(BROWSEINFO));  
	sInfo.pidlRoot   = 0;  
	sInfo.lpszTitle   = _T("ѡ���ļ��У�");  
	sInfo.ulFlags   = BIF_DONTGOBELOWDOMAIN | BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE | BIF_EDITBOX;  
	sInfo.lpfn     = NULL;  

	// ��ʾ�ļ���ѡ��Ի���  
	LPITEMIDLIST lpidlBrowse = ::SHBrowseForFolder(&sInfo);   
	if (lpidlBrowse != NULL)  
	{  
		// ȡ���ļ�����  
		if (::SHGetPathFromIDList(lpidlBrowse,szFolderPath))    
		{  
			strFolderPath = szFolderPath;  
		}  
	}  
	if(lpidlBrowse != NULL)  
	{  
		::CoTaskMemFree(lpidlBrowse);  
	}  

	return strFolderPath; 
}

CString CMakeUpdataFileApp::GetWinRARPath()
{
	CString strEnvironmentName = L"WINRAR";
	WCHAR cWinRARPath[256];
	DWORD dwRet=GetEnvironmentVariable(strEnvironmentName, cWinRARPath, sizeof(cWinRARPath));
	if(dwRet==0)
	{
		AfxMessageBox(L"���Ȱ�װWinRar,���½���������<WINRAR>.");
		return NULL;
	}
	else
	{
		return cWinRARPath;
	}
}

map<CString, CString>& CMakeUpdataFileApp::GetConfigInfo()
{
	return m_mapConInfo;
}