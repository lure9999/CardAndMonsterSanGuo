// ExcelToLua.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "ExcelTextTable.h"
#include <fstream>
#include <string>
#include <iostream>
#include <windows.h>
#include <stdio.h>
using namespace std;
#define LEN 1024

std::list<std::string> gFileList;

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
	   //DirectoryList(FullPathName);
	  }
	  else
	  {
		  // 是文件。判断是否是*.txt
		  std::wstring strTemp = FullPathName;
		  if(strTemp.find(L".txt") != std::wstring::npos)
		  {
			  char szGlobleExcelStr[MAX_STR_SIZE];
			  memset(szGlobleExcelStr, 0, sizeof(char) * MAX_STR_SIZE);
			  wsprintf(FullPathName, L"%s", FindData.cFileName);
			  Utf16ToUtf8( FullPathName,szGlobleExcelStr,MAX_STR_SIZE,0 );
			  gFileList.push_back(szGlobleExcelStr);
		  }
	  }
	 
	 }
	 return 0;
}


int _tmain(int argc, _TCHAR* argv[])
{
	TCHAR szPath[MAX_PATH];
	GetCurrentDirectory(MAX_PATH, szPath);
	DirectoryList(szPath);

	if(gFileList.size() <= 0) return 0;

	std::list<std::string>::iterator i = gFileList.begin();
	while (i != gFileList.end())
	{
		std::string strFile = *i;
		//////////////////////////////////////////////////////////////////////////
		CExcelTextTable ExcelTable;
		ExcelTable.ReadExcelTable(strFile.c_str(),"",0,false);

		std::string strLua = strFile;
		std::string strName = strLua;
		strLua.replace(strLua.length()-4, 4, ".lua");
		strName.replace(strName.length()-4, 4, "");
		std::fstream zf;
		zf.open(strLua.c_str(),std::ios::binary|std::ios::out);

		zf.write("-- Description: auto-created by ExcelToLua tool.\n-- Author:jjc", strlen("-- Description: auto-created by ExcelToLua tool.\n-- Author:jjc"));
		zf.write("\n\n", strlen("\n\n"));
		zf.write("module(\"",strlen("module(\""));
		zf.write(strName.c_str(), strName.length());
		zf.write("\", package.seeall)\n\n", strlen("\", package.seeall)\n\n"));
		zf.write("\n", strlen("\n"));
		zf.write("keys = {\n	", strlen("keys = {\n	"));
		// 写keys
		for (int i=0; i<ExcelTable.GetMaxCol(); i++)
		{
			std::string strData = "\"";
			strData += ExcelTable.GetChar(0,i);
			strData += "\", ";
			zf.write(strData.c_str(), strData.length());
		}
		zf.write("\n}\n\n", strlen("\n}\n\n"));
		zf.write(strName.c_str(), strName.length());
		zf.write("Table = {\n", strlen("Table = {\n"));

		for (int i=1; i<ExcelTable.GetMaxLn(); i++)
		{
			// 写ids
			std::string strData = "    id_";
			strData += ExcelTable.GetChar(i,0);
			strData += " = {";
			zf.write(strData.c_str(), strData.length());

			for (int j=1; j<ExcelTable.GetMaxCol(); j++)
			{
				std::string strData = "\"";
				std::string strTemp = ExcelTable.GetChar(i,j);
				if(strTemp.length() <= 0)
					strData = "nil, ";
				else
				{
					strData += strTemp;
					strData += "\", ";
				}
				zf.write(strData.c_str(), strData.length());
			}
			strData = "";
			strData += "},\n";
			zf.write(strData.c_str(), strData.length());
		}
		std::string strData = "";
		strData += "}\n";
		zf.write(strData.c_str(), strData.length());
		// getDataById
		zf.write("\n\n", strlen("\n\n"));
		zf.write("function getDataById(key_id)\n", strlen("function getDataById(key_id)\n"));
		zf.write("    local id_data = ", strlen("    local id_data = "));
		zf.write(strName.c_str(), strName.length());
		zf.write("Table[\"id_\" .. ", strlen("Table[\"id_\" .. "));
		zf.write("key_id]\n", strlen("key_id]\n"));
		zf.write("    if id_data == nil then\n", strlen("    if id_data == nil then\n"));
		zf.write("        return nil\n    end\n    return id_data\nend", strlen("        return nil\n    end\n    return id_data\nend"));
		
		// getArrDataByField
		//add by sxin 修改之前只返回一条符合检索要求的 但是可能表里会有多条所以修改成返回一个数组的table
		zf.write("\n\n", strlen("\n\n"));
		zf.write("function getArrDataByField(fieldName, fieldValue)\n", strlen("function getArrDataByField(fieldName, fieldValue)\n"));
		zf.write("    local arrData = {}\n    local fieldNo = 1\n    for i=1, #keys do\n        if keys[i] == fieldName then\n            fieldNo = i\n", strlen("    local arrData = {}\n    local fieldNo = 1\n    for i=1, #keys do\n        if keys[i] == fieldName then\n            fieldNo = i\n"));
		zf.write("            break\n        end\n    end\n\n    for k, v in pairs(",strlen("            break\n        end\n    end\n\n    for k, v in pairs("));
		zf.write(strName.c_str(), strName.length());

	//	zf.write("Table) do\n        if tostring(v[fieldNo-1]) == tostring(fieldValue) then\n            arrData = copyTab(v)\n", strlen("Table) do\n        if tostring(v[fieldNo-1]) == tostring(fieldValue) then\n            arrData = copyTab(v)\n"));
		zf.write("Table) do\n        if tostring(v[fieldNo-1]) == tostring(fieldValue) then\n            table.insert(arrData, copyTab(v))\n", strlen("Table) do\n        if tostring(v[fieldNo-1]) == tostring(fieldValue) then\n            table.insert(arrData, copyTab(v))\n"));
		zf.write("        end\n    end\n\n    return arrData\nend\n\n", strlen("        end\n    end\n\n    return arrData\nend\n\n"));

		//getTable
		zf.write("function getTable()\n    return ", strlen("function getTable()\n    return "));
		zf.write(strName.c_str(), strName.length());
		zf.write("Table\nend\n", strlen("Table\nend\n"));

		// getFieldByIdAndIndex
		zf.write("\n\n", strlen("\n\n"));
		//zf.write("function getFieldByIdAndIndex(key_id, fieldName)\n    if key_id == -1 then local temp = {} return temp end\n", strlen("function getFieldByIdAndIndex(key_id, fieldName)\n    if key_id == -1 then local temp = {} return temp end\n"));
		zf.write("function getFieldByIdAndIndex(key_id, fieldName)\n", strlen("function getFieldByIdAndIndex(key_id, fieldName)\n"));
		zf.write("    local fieldNo = 0\n    for i=1, #keys do\n        if keys[i] == fieldName then\n            fieldNo = i-1\n", strlen("    local fieldNo = 0\n    for i=1, #keys do\n        if keys[i] == fieldName then\n            fieldNo = i-1\n"));
		zf.write("            break\n        end\n    end\n    return getDataById(key_id)[fieldNo]\nend\n",strlen("            break\n        end\n    end\n    return getDataById(key_id)[fieldNo]\nend\n"));

		// getIndexByField
		zf.write("\n\n", strlen("\n\n"));
		zf.write("function getIndexByField(fieldName)\n", strlen("function getIndexByField(fieldName)\n"));
		zf.write("    local fieldNo = 0\n    for i=1, #keys do\n        if keys[i] == fieldName then\n            fieldNo = i-1\n", strlen("    local fieldNo = 0\n    for i=1, #keys do\n        if keys[i] == fieldName then\n            fieldNo = i-1\n"));
		zf.write("            break\n        end\n    end\n    return fieldNo\nend\n",strlen("            break\n        end\n    end\n    return fieldNo\nend\n"));


		//----add by sxin 增加2个条件查找接口		
		zf.write("\n\n", strlen("\n\n"));
		zf.write("function getArrDataBy2Field(fieldName1, fieldValue1, fieldName2, fieldValue2)\n", strlen("function getArrDataBy2Field(fieldName1, fieldValue1, fieldName2, fieldValue2)\n"));
		zf.write("	local arrData = {}\n	local fieldNo1 = 1\n	local fieldNo2 = 1\n	for i=1, #keys do\n		if keys[i] == fieldName1 then\n			fieldNo1 = i\n		end\n		if keys[i] == fieldName2 then\n			fieldNo2 = i\n		end\n", strlen("	local arrData = {}\n	local fieldNo1 = 1\n	local fieldNo2 = 1\n	for i=1, #keys do\n		if keys[i] == fieldName1 then\n			fieldNo1 = i\n		end\n		if keys[i] == fieldName2 then\n			fieldNo2 = i\n		end\n"));
		zf.write("	end\n\n    for k, v in pairs(",strlen("	end\n\n    for k, v in pairs("));
		zf.write(strName.c_str(), strName.length());
		zf.write("Table) do\n        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then\n            table.insert(arrData, copyTab(v))\n", strlen("Table) do\n        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then\n            table.insert(arrData, copyTab(v))\n"));
		zf.write("        end\n    end\n\n    return arrData\nend\n\n", strlen("        end\n    end\n\n    return arrData\nend\n\n"));
		
		//----end

		// release
		zf.write("\n\n", strlen("\n\n"));
		zf.write("function release()\n", strlen("function release()\n"));
		zf.write("    _G[\"", strlen("    _G[\""));
		zf.write(strName.c_str(), strName.length());
		zf.write("\"] = nil\n", strlen("\"] = nil\n"));
		zf.write("    package.loaded[\"", strlen("    package.loaded[\""));
		zf.write(strName.c_str(), strName.length());
		zf.write("\"] = nil\nend\n", strlen("\"] = nil\nend\n"));

		if (!zf)
		{
			return false;
		}
		zf.close();
		//////////////////////////////////////////////////////////////////////////
		i++;
	}

	return 0;
}

