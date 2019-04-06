// PngToRes.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

#include <fstream>
#include <string>
#include <list>
#include <windows.h>
#include <io.h>
using namespace std;
#define LEN 1024
#define MAX_STR_SIZE 512

std::list<std::string> gFileList;

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

BOOL  DirectoryList(LPWSTR Path)
{
	WIN32_FIND_DATA FindData;
	HANDLE hError;
	int FileCount = 0;
	WCHAR FilePathName[LEN];
	// 构造路径
	WCHAR FullPathName[LEN];
	wcscpy(FilePathName, Path);
	wcscat(FilePathName, L"\\*.*");
	hError = FindFirstFile(FilePathName, &FindData);
	if (hError == INVALID_HANDLE_VALUE)
	{
		return 0;
	}
	while(::FindNextFile(hError, &FindData))
	{
		// 过虑.和..
		if (wcscmp(FindData.cFileName, L".") == 0
			|| wcscmp(FindData.cFileName, L"..") == 0 )
		{
			continue;
		}

		// 构造完整路径
		wsprintf(FullPathName, L"%s\\%s", Path,FindData.cFileName);
		FileCount++;

		if (FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
		{
			DirectoryList(FullPathName);
		}
		else
		{

			std::wstring strTemp = FullPathName;
			if(strTemp.find(L".ExportJson") != std::wstring::npos)
			{

				if(strTemp.find(L"Image\\Fight\\animation") == std::wstring::npos && 
					strTemp.find(L"Image\\Fight\\particl") == std::wstring::npos &&
					strTemp.find(L"Image\\Fight\\Scene") == std::wstring::npos)
				{
					TCHAR szPath[MAX_PATH];
					GetCurrentDirectory(MAX_PATH, szPath);
					strTemp.erase(0, wcslen(szPath));

					char szGlobleExcelStr[MAX_STR_SIZE];
					memset(szGlobleExcelStr, 0, sizeof(char) * MAX_STR_SIZE);
					//wsprintf(FullPathName, L"%s", FindData.cFileName);
					std::wstring::size_type pos = strTemp.find(L"\\");
					strTemp.replace(pos, 1, L"");
					while(1)
					{
						std::wstring::size_type pos = strTemp.find(L"\\");
						if(pos != std::wstring::npos)
						{
							strTemp.replace(pos, 1, L"\/");
						}
						else
							break;
					}
					wsprintf(FullPathName, L"%s", strTemp.c_str());
					Utf16ToUtf8( FullPathName,szGlobleExcelStr,MAX_STR_SIZE,0 );
					gFileList.push_back(szGlobleExcelStr);

					std::fstream zf;

					char szPath1[MAX_PATH];
					GetCurrentDirectoryA(MAX_PATH, szPath1);

					std::string strPath = szPath1;
					strPath += "\\res.txt";
					zf.open(strPath.c_str(),std::ios::binary|std::ios::out|std::ios::app);
					zf.write(szGlobleExcelStr, strlen(szGlobleExcelStr));
					zf.write("\r\n", strlen("\r\n"));
					zf.close();
				}
			}

			// 是文件。判断是否是图片
			/*
			std::wstring strTemp = FullPathName;
			if(strTemp.find(L".png") != std::wstring::npos || strTemp.find(L".jpg") != std::wstring::npos || strTemp.find(L".ExportJson") != std::wstring::npos)
			{
				if(strTemp.find(L".png") != std::wstring::npos || strTemp.find(L".jpg") != std::wstring::npos)
				{
					if(strTemp.find(L"Image\\Fight\\animation") == std::wstring::npos && 
						strTemp.find(L"Image\\Fight\\particl") == std::wstring::npos &&
						strTemp.find(L"Image\\Fight\\Scene") == std::wstring::npos && 
						strTemp.find(L"Image\\Fight\\player") == std::wstring::npos && 
						strTemp.find(L"Image\\Fight\\skill") == std::wstring::npos && 
						strTemp.find(L"Image\\Fight\\UI\\Animation") == std::wstring::npos)
					{
						OutputDebugStringW(L"\r\n");
						OutputDebugStringW(strTemp.c_str());
						//return 0;
						std::wstring strPlist = strTemp;
						if (strTemp.find(L".png") != std::wstring::npos)
						{
							strPlist.replace(strTemp.find(L".png"), 4, L".plist");
						}
						else
						{
							strPlist.replace(strTemp.find(L".jpg"), 4, L".plist");
						}
						char szPlist[MAX_STR_SIZE];
						memset(szPlist, 0, sizeof(char) * MAX_STR_SIZE);
						Utf16ToUtf8( strPlist.c_str(),szPlist,MAX_STR_SIZE,0 );
						if(_access(szPlist, 0) == -1)
						{
							TCHAR szPath[MAX_PATH];
							GetCurrentDirectory(MAX_PATH, szPath);
							strTemp.erase(0, wcslen(szPath));

							char szGlobleExcelStr[MAX_STR_SIZE];
							memset(szGlobleExcelStr, 0, sizeof(char) * MAX_STR_SIZE);
							//wsprintf(FullPathName, L"%s", FindData.cFileName);
							std::wstring::size_type pos = strTemp.find(L"\\");
							strTemp.replace(pos, 1, L"");
							while(1)
							{
								std::wstring::size_type pos = strTemp.find(L"\\");
								if(pos != std::wstring::npos)
								{
									strTemp.replace(pos, 1, L"\/");
								}
								else
									break;
							}
							wsprintf(FullPathName, L"%s", strTemp.c_str());
							Utf16ToUtf8( FullPathName,szGlobleExcelStr,MAX_STR_SIZE,0 );
							gFileList.push_back(szGlobleExcelStr);

							std::fstream zf;

							char szPath1[MAX_PATH];
							GetCurrentDirectoryA(MAX_PATH, szPath1);

							std::string strPath = szPath1;
							strPath += "\\res.txt";
							zf.open(strPath.c_str(),std::ios::binary|std::ios::out|std::ios::app);
							zf.write(szGlobleExcelStr, strlen(szGlobleExcelStr));
							zf.write("\r\n", strlen("\r\n"));
							zf.close();
						}
					}
				}
				else
				{

					if(strTemp.find(L"Image\\Fight\\animation") == std::wstring::npos && 
						strTemp.find(L"Image\\Fight\\particl") == std::wstring::npos &&
						strTemp.find(L"Image\\Fight\\Scene") == std::wstring::npos && 
						strTemp.find(L"Image\\Fight\\UI\\Animation") == std::wstring::npos)
					{
						TCHAR szPath[MAX_PATH];
						GetCurrentDirectory(MAX_PATH, szPath);
						strTemp.erase(0, wcslen(szPath));

						char szGlobleExcelStr[MAX_STR_SIZE];
						memset(szGlobleExcelStr, 0, sizeof(char) * MAX_STR_SIZE);
						//wsprintf(FullPathName, L"%s", FindData.cFileName);
						std::wstring::size_type pos = strTemp.find(L"\\");
						strTemp.replace(pos, 1, L"");
						while(1)
						{
							std::wstring::size_type pos = strTemp.find(L"\\");
							if(pos != std::wstring::npos)
							{
								strTemp.replace(pos, 1, L"\/");
							}
							else
								break;
						}
						wsprintf(FullPathName, L"%s", strTemp.c_str());
						Utf16ToUtf8( FullPathName,szGlobleExcelStr,MAX_STR_SIZE,0 );
						gFileList.push_back(szGlobleExcelStr);

						std::fstream zf;

						char szPath1[MAX_PATH];
						GetCurrentDirectoryA(MAX_PATH, szPath1);

						std::string strPath = szPath1;
						strPath += "\\res.txt";
						zf.open(strPath.c_str(),std::ios::binary|std::ios::out|std::ios::app);
						zf.write(szGlobleExcelStr, strlen(szGlobleExcelStr));
						zf.write("\r\n", strlen("\r\n"));
						zf.close();
					}
				}
			}
			*/
		}

	}
	return 0;
}

int _tmain(int argc, _TCHAR* argv[])
{
	std::wstring strPath = L"D:\\";
	strPath += L"res.txt";
	DeleteFile(strPath.c_str());
	TCHAR szPath[MAX_PATH];
	GetCurrentDirectory(MAX_PATH, szPath);
	DirectoryList(szPath);
	return 0;
}

