///////////////////////////////////////////////////////////////////////////////
//
//	ExcelTextTable.h	:	V0010
//	Written by			:	ZHJL
//	V0010				:	2010-01-13
//	Desc				:	将前人读Excel表格文件的类重新整理，在多字节和UNICODE两种模式下，均可直接运行，无需修改。
//						:	并添加了读取时进行加密的开关，可对没有加过密的文件直接进行加密。上面是前人的版本变动注释。
///////////////////////////////////////////////////////////////////////////////

//#include "CmdAdapter.h"

#include "stdafx.h"
#include "ExcelTextTable.h"
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <istream>
#include <string>
//#include <io.h>
//#include "MsvcrtSafeFunction.h"
//#include "LogSystemThread.h"

//#include "checkSum/CRC32.h"

/////////////////////////////////////////////////
const int ENCRYPT_CODE = 0x79;
/////////////////////////////////////////////////
const int MAX_COL_EXCEL = 0x1000;//excel 表格最大列数



char szGlobleExcelStr[MAX_STR_SIZE];

#ifdef UNICODE
#define strlen_my wcslen
#define strcmp_my wcscmp
#define _stricmp_my wcscmp
#define _strnicmp_my wcsncmp
#define strstr_my wcsstr
#define atoi_my wcstol
#define atof_my wcstod
#define strtoul_my wcstoul

#ifdef IOS_USED
#define _atoi64_my wcstoll
#else
#define _atoi64_my _wtoi64
#endif

#define _itoa_my _itow_s
#else
#define strlen_my strlen
#define strcmp_my strcmp
#define _stricmp_my _stricmp
#define strstr_my strstr
#define atoi_my atoi
#define atof_my atof
#define strtoul_my strtoul
#define _atoi64_my _atoi64
#define _itoa_my _itoa_s
#endif


#include <stdio.h>
#include <stdlib.h>

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


void CharEncrypt( int& c )
{
	c = c ^ ENCRYPT_CODE;
}



/////////////////////////////////////////////////
//
//	class	CExcelTable
//
/////////////////////////////////////////////////
/////////////////////////////////////////////////


CExcelTextTable::CExcelTextTable(int nLnMax, int nColMax)
{
	m_nAssumedMaxLn		= nLnMax;
	if ( m_nAssumedMaxLn < 1 )
		m_nAssumedMaxLn = 1;
	m_nAssumedMaxCol	= nColMax;
	if ( m_nAssumedMaxCol < 1 )
		m_nAssumedMaxCol = 1;

	m_nMaxLn  = 0;
	m_nMaxCol = 0;
	m_dwCrcCheckSum = 0;//x03520734;
}


CExcelTextTable::~CExcelTextTable()
{
	Reset();
}

// 清除表内所有内容

void CExcelTextTable::Reset()
{
	{
		CStlStringTable::iterator it = m_Table.begin();
		while( it != m_Table.end() )
		{
			delete (*it);
			++it;
		}
		m_Table.clear();
	}
	{
		CStlStringArray::iterator it = m_pBufferArray.begin();
		while( it != m_pBufferArray.end() )
		{
			delete [] (*it);
			++it;
		}
	}

	m_pBufferArray.clear();

	m_mapLines.clear();
  
	m_nMaxLn  = 0;
	m_nMaxCol = 0;
	m_dwCrcCheckSum = 0;//x03520734;
}
wchar_t* EMPTY_EXCEL_TEXT = L"";
wchar_t* CExcelTextTable::GetCell(int nLine, int nCol)const
{
	if ( nLine >= 0 && nLine < (int)m_Table.size() )
	{
		const CStlStringArray& TableLine = *m_Table[nLine];
		if ( nCol >= 0 && nCol < (int)TableLine.size() )
			return TableLine[nCol];
	}
	return EMPTY_EXCEL_TEXT;
}


// 读取以制表符为间隔符号的文本文件，可以累计读取
// 用 bEnCode 指定是否对文件进行加密，为 true 时如果没有加过密，则自动加密，默认false
// 用 nStartLine 指定开始读取的行号，如果 <= 0 表示从第0行读起
// 用 nEndLine 指定读取到哪一行号为止（包含这一行），如果 < 0 表示一直读到末行
// 如果 nStartLine > 0 && nEndLine >= 0  但 nEndLine < nStartLine 的话 返回false
// returns	:	文件不存在或者数据超界返回false
bool CExcelTextTable::ReadExcelTable( const char* szName ,
									char* szAlias,//=L""
									 int nAliasCol,//=0
									 bool bEnCode ,//= false
									 int nStartLine ,//= -1,
									 int nEndLine //= -1
									 )
{
	//g_Log.WriteLogByDate( _T("ReadGameData"), _T("%s Begin"), szName );
	

	if ( nStartLine > 0 && nEndLine >= 0 && nEndLine < nStartLine )
		return false;// 非法的参数

	int nFileLine = 0;

	int ch;
	//bool ret = true;
	
	wchar_t wcName[MAX_STR_SIZE];
	memset(wcName, 0, sizeof(wchar_t) * MAX_STR_SIZE);
	Utf8ToUtf16(szName, wcName, MAX_STR_SIZE, 0);

	wchar_t wcAlias[MAX_STR_SIZE];
	memset(wcAlias, 0, sizeof(wchar_t) * MAX_STR_SIZE);
	Utf8ToUtf16(szAlias, wcAlias, MAX_STR_SIZE, 0);

	// 修改为以CPU换磁盘的方法,以前CPU速度慢,现在已经不成问题,所以减少磁盘的IO操作,以提升读取速度.
//	FILE*  fp = NULL;
//	int    fh;
//#ifdef UNICODE
//	_wfopen_s(&fp, wcName, L"rb, ccs=UNICODE" );
//#else
//	fopen_s(&fp, szName, "rb" );
//#endif // !UNICODE
    
//	if( !fp )
//	{
//		int nErrCode;
//		_get_errno( &nErrCode );
//		wchar_t* lpMsgBuf = _wcserror( nErrCode );
//		std::wstring strMsg = L"CExcelTextTable::ReadExcelTable() Error (0) : fopen Error<"; strMsg += lpMsgBuf; strMsg += L">!\n";
//		//OutputDebugString( strMsg.c_str() );
//		return false;
//	}
//
//	fh = fileno(fp);
//	long length = _filelength(fh);
//	if ( 0 == length ) 
//	{
//		//OutputDebugString( _T("CExcelTextTable::ReadExcelTable() Error (0) : filelength =0!\n") );
//		fclose(fp);
//		return false ;
//	}
//
//	//MY_ASSERT( length < 100*1024*1024 );	// o?…???o?–°”?100MB

    
	std::fstream zf;
	zf.open(szName,std::ios::binary|std::ios::in);
	if (!zf)
	{
		//int nErrCode;
		//_get_errno( &nErrCode );
		//wchar_t* lpMsgBuf = _wcserror( nErrCode );
		//std::wstring strMsg = L"CExcelTextTable::ReadExcelTable() Error (0) : fopen Error<"; strMsg += lpMsgBuf; strMsg += L">!\n";
		//OutputDebugString( strMsg.c_str() );
		return false;
	}
	zf.seekg(0, std::ios_base::end);
	int length = zf.tellg();
	if (length<=0)
	{
		zf.close();
		return false;
	}
    
	zf.seekg(0, std::ios_base::beg);
    
    
	//zf.close();
    

	long lDataSize = 0;
#ifdef UNICODE
	long lengthEx = length/sizeof(wchar_t);
	wchar_t* pBuffer = new wchar_t[lengthEx+1];
	lDataSize = (lengthEx)*sizeof(wchar_t);
#else
	char* pBuffer = new char[length+1];
	lDataSize = length;
#endif

	if( !pBuffer )
	{
		//OutputDebugString( _T("CExcelTextTable::ReadExcelTable() Error (0) : Not enough memory!\n") );
		return false;
	}
#ifdef UNICODE
	memset( pBuffer, 0, (lengthEx+1)*sizeof(wchar_t) );
#else
	memset( pBuffer, 0, length+1 );
#endif

//	fseek( fp, 0, SEEK_SET );
//	size_t nCount = fread( pBuffer, length, 1, fp );
//	if( nCount!= 1 )
//	{
//		fclose( fp );
//		delete pBuffer; pBuffer = NULL;
//		//OutputDebugString( _T("CExcelTextTable::ReadExcelTable() Error (1) : Read failed!\n") );
//		return false;
//	}
//	fclose( fp );
//
    
	zf.read((char*)pBuffer, length);
	zf.close();
    
//	//m_dwCrcCheckSum = CRC32(m_dwCrcCheckSum,pBuffer,length);

	m_szFileName = wcName;

	long lPos = 0;
	bool bEncrypt = false;
	ch = pBuffer[lPos++];
	if( (ch&0x000000FF) == 0x80 )
	{	// 加密了
		bEncrypt = true;
	}
	else
	{
		lPos = 0;
	}

	// 如果没加过密的话，再new出一块来，后面加密用
#ifdef UNICODE
		wchar_t* pBufferEx = NULL;
#else
		char* pBufferEx = NULL;
#endif
	if( !bEncrypt && bEnCode )
	{
#ifdef UNICODE
		pBufferEx = new wchar_t[lengthEx+1];
#else
		pBufferEx = new char[length+1];
#endif

		if( pBufferEx == NULL )
		{
			delete pBuffer; pBuffer = NULL;
			return false;
		}
	}

	std::list< CStlStringArray* > lList;
	std::list< CStlStringArray* >::iterator it;

	int nCol = 0;
	long lcount = 0;
#ifdef UNICODE
	wchar_t *szUnit[MAX_COL_EXCEL];
	wchar_t *szStart = pBuffer + lPos;
	lcount = lengthEx;
#else
	char *szUnit[MAX_COL_EXCEL];
	char *szStart = pBuffer + lPos;
	lcount = length;
#endif
	// 某个字段里面如果有'\r''\n'，那么这个字段必须整个都被一对双引号包裹起来，这里就是识别这种情况，遇到这样的双引号就特殊处理
	bool bJustNewUnit = true;
	bool bInQuat = false;

	while( lPos < lcount )
	{
		ch = pBuffer[lPos];
	
		if( bEncrypt )
		{	// 解密
			CharEncrypt( ch );
			pBuffer[lPos] = ch;
		}
		else
		{
			if( bEnCode )
				pBufferEx[lPos] = ch;
		}

		if( ch == L'\"' && bJustNewUnit )
		{
			lPos++;
			bInQuat = true;
			szStart = pBuffer + lPos;	// 跳过这个双引号－这个双引号是控制用的（双引号内部包括换行符在内都是内容））
			bJustNewUnit = false;
		}
		else if( ch == 0x0D && !bInQuat ) // "\r\n"
		{
			pBuffer[lPos] = 0;
			pBuffer[lPos+1] = 0;

			if ( nStartLine > 0 )
			{
				nStartLine--;
			}
			else
			{
				//MY_ASSERT( nCol<MAX_COL_EXCEL );
				szUnit[nCol++]=szStart;
			}

			// 如果读制定的某几行的话，由于行号不能变，前面跳过的行也要以空内容加进去。
			CStlStringArray*	ptrLine = new CStlStringArray( szUnit, szUnit+nCol );
			if( ptrLine == NULL )
				goto error;

			nCol = 0;

			lList.push_back( ptrLine );
			lPos++;
			lPos++;
			szStart = pBuffer + lPos;

			// 因为行号是从0行开始计算的，把下列判断放到这里，才能保证nEndLine所在的那行也被包含在内读出来。
			nFileLine++;
			if (nEndLine >= 0 && nFileLine > nEndLine )
				goto WELL_DONE_BYEBYE;
			bJustNewUnit = false;
		}
		else if( ch == 0x09 ) // "\t"
		{
			if( bInQuat )
			{	// 去掉结尾的双引号，这个表示控制内容的结束，并不被读到系统里
				//MY_ASSERT( lPos > 1 );
				pBuffer[lPos-1] = 0;
			}
			bJustNewUnit = true;
			bInQuat = false;

			pBuffer[lPos] = 0;

			if ( nStartLine <= 0 )
			{
				//MY_ASSERT( nCol<MAX_COL_EXCEL );
				szUnit[nCol++]=szStart;
			}

			lPos++;
			szStart = pBuffer + lPos;
		}
		else
		{
			lPos++;
			bJustNewUnit = false;
		}
	}

	// 最后再判断下，有可能最后一行的回车换行符被删了，在这里加上。
	if( szStart - pBuffer != lcount )
	{
		if ( nStartLine <= 0 )
		{
			//MY_ASSERT( nCol<MAX_COL_EXCEL );
			szUnit[nCol++]=szStart;

			CStlStringArray*	ptrLine = new CStlStringArray( szUnit, szUnit+nCol );
			if( ptrLine == NULL )
				goto error;

			nCol = 0;

			lList.push_back( ptrLine );
		}
	}

WELL_DONE_BYEBYE:	// 这里是最后读完了，或者读完了制定的内容，也要到这里进行修正

	it = lList.begin();
	while( it != lList.end() )
	{
		CStlStringArray* pLine = (*it);
		//修正最大列数
		if( m_nMaxCol < (int)pLine->size() )
			m_nMaxCol = (int)pLine->size();

		m_Table.push_back( pLine );
		++it;
	}
	//已经 有m_nMaxLn行了
	//修正最大行数
	m_nMaxLn += lList.size();

	// 这里把整个BUFFER加到数组里，到析构函数里统一释放，因为表里存的是指针，不能释放
	m_pBufferArray.push_back( pBuffer );

	// 这里判断下别名是否唯一
	if( !JudgeOnlyOne( nAliasCol, wcAlias ) )
	{
		goto error;
	}

	// 在这里直接对没有加过密的文件进行加密，省去写加密工具了。
	if( !bEncrypt && bEnCode )
	{
		// 对整个内容进行加密
		lPos = 0;
		while( lPos < lcount )
		{
			ch = pBufferEx[lPos];
		
			CharEncrypt( ch );
			pBufferEx[lPos] = ch;

			lPos++;
		}

//#ifdef UNICODE
//		_wfopen_s(&fp, wcName, L"wb, ccs=UNICODE" );
//#else
//		fopen_s(&fp, szName, "wb" );
//#endif // !UNICODE
//
//		if( !fp )
//		{
//			//OutputDebugString( _T("CExcelTextTable::ReadExcelTable() Error (0) : fopen Error!\n") );
//			return false;
//		}
//
//		fseek( fp, 0, SEEK_SET );
//
//		ch = 0x80;
//
//		// –￥o”√?∫?μ???o??∑
//#ifdef UNICODE
//		nCount = fwrite( (void*)&ch, sizeof(wchar_t), 1, fp );
//#else
//		nCount = fwrite( (void*)&ch, sizeof(char), 1, fp );
//#endif // !UNICODE
//
//		// –￥’?∏?o”√?∫?μ?????
//		nCount = fwrite( (void*)pBufferEx, lDataSize, 1, fp );
//
//		fclose( fp );

		std::fstream zf;
		zf.open(szName,std::ios::binary|std::ios::out);
		if (!zf)
		{
			//int nErrCode;
			//_get_errno( &nErrCode );
			//wchar_t* lpMsgBuf = _wcserror( nErrCode );
			//std::wstring strMsg = L"CExcelTextTable::ReadExcelTable() Error (0) : fopen Error<"; strMsg += lpMsgBuf; strMsg += L">!\n";
			//OutputDebugString( strMsg.c_str() );
			return false;
		}
		zf.seekp(0, std::ios_base::beg);
		ch = 0x80;
		// 写加密后的文件头
#ifdef UNICODE
		zf.write((char*)&ch,sizeof(wchar_t));
#else
		zf.write((char*)&ch,sizeof(char));
#endif // !UNICODE
		zf.write((char*)pBufferEx,lDataSize);
		zf.close();

        
		delete pBufferEx;
		pBufferEx = NULL;
	}
    
	//g_Log.WriteLogByDate( _T("ReadGameData"), _T("%s End OK"), szName );
	return true;
    
error:
	it = lList.begin();
	while( it != lList.end() )
	{
		delete (*it);
		++it;
	}
    
	delete pBuffer;
	pBuffer = NULL;
    
	if( !bEncrypt && bEnCode )
	{
		delete pBufferEx;
		pBufferEx = NULL;
	}
    
	return false;
}


// 得到指定位置的数据
// nSize	:	得到的后缀的最大长度，如果小于输出字符串（第二个参数）的真实长度，则会出现致命错误
// 若没有填写，则 nData = default, output = "";
char* CExcelTextTable::GetChar( int nLn, int nCol)const
{	
	memset(szGlobleExcelStr, 0, sizeof(char) * MAX_STR_SIZE);
	wchar_t wcCHAR[MAX_STR_SIZE];
	wchar_t* szCell = GetCell(nLn,nCol);
	if( szCell[0] != '\0' )
	{
		//MY_ASSERT( strlen_my(szCell)<(unsigned int)nSize );
#ifdef UNICODE
		wcscpy(wcCHAR, szCell);
#else
		wcscpy_s(wcCHAR, MAX_STR_SIZE, szCell);
#endif
	}
	else
	{
		wcCHAR[0] = 0;
	}

	Utf16ToUtf8( wcCHAR,szGlobleExcelStr,MAX_STR_SIZE,0 );

	return szGlobleExcelStr;
}

int CExcelTextTable::GetInt( int nLn, int nCol, int nDefault
						  )const
{	
	int nValue = 0;
	const wchar_t* szCell = GetCell(nLn,nCol);
	if( szCell[0] != L'\0' )
	{
        nValue = (int)wcstol(szCell,NULL,10);
		//nValue = atoi_my( szCell );
	}
	else
	{
		nValue = nDefault;

	}

	return nValue;
}

float CExcelTextTable::GetFloat( int nLn, int nCol, float fDefault //= 0.0f
						  )const
{	
	float fData = 0.0f;
	wchar_t* szCell = GetCell(nLn,nCol);
	if( szCell[0] != '\0' )
	{
        fData = (float)wcstod(szCell,NULL);
//		fData = (float)atof_my( szCell );
	}
	else
	{
		fData = fDefault;
	}

	return fData;
}

unsigned long CExcelTextTable::GetDWORD( int nLn, int nCol,  unsigned long dwDefault //=  0xffffffff 
						  )const
{	
	unsigned long dwOutData;
	wchar_t* szCell = GetCell(nLn,nCol);
	if( szCell[0] != '\0' )
	{
		dwOutData = strtoul_my( szCell ,NULL,10);
	}
	else
	{
		dwOutData = dwDefault;
	}

	return dwOutData;
}

long long CExcelTextTable::GetINT64( int nLn, int nCol, long long n64Default //= 0
							 )const
{	
	long long n64OutData = 0; 
	wchar_t* szCell = GetCell(nLn,nCol);
	if( szCell[0] != '\0' )
	{
#ifdef IOS_USED
		n64OutData = _atoi64_my( szCell, NULL, 10 );
#else
		n64OutData = _atoi64_my( szCell );
#endif
	}
	else
	{
		n64OutData = n64Default;
	}
	return n64OutData;
}

unsigned long long CExcelTextTable::GetUnINT64( int nLn, int nCol, unsigned long long un64Default //= 0
							)const
{	
	unsigned long long un64OutData  = 0;
	wchar_t* szCell = GetCell(nLn,nCol);
	if( szCell[0] != L'\0' )
	{
#ifdef IOS_USED
		un64OutData = (unsigned long long)_atoi64_my( szCell, NULL, 10 );
#else
		un64OutData = (unsigned long long)_atoi64_my( szCell );
#endif
	}
	else
	{
		un64OutData = un64Default;
	}
	return un64OutData;
}


// 根据某列的内容查找行
// returns	:	-1为没有找到，否则为该行的序号
int	CExcelTextTable::FindLn( int nCol, int nData )const
{
	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++ )
	{
		const CStlStringArray& TableLine = (**it);
#ifdef UNICODE
        int d = (int)wcstol(TableLine[nCol],NULL,10);
#else
        int d = atoi_my(TableLine[nCol]);
#endif
		if ( (int)TableLine.size() > nCol
			&& d == nData)
			return i;
	}

	return -1;
}
int	CExcelTextTable::FindLn( int nCol, wchar_t* szData )const
{
	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++ )
	{
		const CStlStringArray& TableLine = (**it);
		if ( (int)TableLine.size() > nCol &&
			_stricmp_my(TableLine[nCol] , szData)==0 )
		{

			return i;
		}
	}

	return -1;
}

//根据主键查找(第一列数据)
char* CExcelTextTable::GetCharE( int nCol, int nData)const
{
	int nNine =	FindLn(0,nData);
	return  GetChar(nNine,nCol);
}

int CExcelTextTable::GetIntE( int nCol,int nData, int nDefault/* = -1*/)const
{
	int nNine =	FindLn(0,nData);
	return GetInt(nNine,nCol,nDefault);
}

float CExcelTextTable::GetFloatE( int nCol,int nData, float fDefault /*= 0.0f*/)const
{
	int nNine =	FindLn(0,nData);
	return GetFloat(nNine,nCol,fDefault);
}

unsigned long CExcelTextTable::GetDWORDE( int nCol,int nData,  unsigned long dwDefault/* =  0xffffffff*/)const
{
	int nNine =	FindLn(0,nData);
	return GetDWORD(nNine,nCol,dwDefault);
}

long long CExcelTextTable::GetINT64E( int nCol,int nData, long long n64Default/* = 0*/)const
{
	int nNine =	FindLn(0,nData);
	return GetINT64(nNine,nCol,n64Default);
}

unsigned long long CExcelTextTable::GetUnINT64E(  int nCol,int nData, unsigned long long un64Default/* = 0*/)const
{
	int nNine =	FindLn(0,nData);
	return GetUnINT64(nNine,nCol,un64Default);
}

// Jun 8th, 2011 joey added，根据某两列的内容查找行，字符串和数字
// returns	:	-1为没有找到，否则为该行的序号，只能找到第一个
int	CExcelTextTable::FindLn( unsigned int nCol1, wchar_t* szData, unsigned int nCol2, int nData2, unsigned int nLineBegin )const
{
	const size_t nSize = m_Table.size();
	for ( size_t i=nLineBegin; i<nSize; ++i )
	{
		const CStlStringArray& TableLine = *m_Table.at(i);
#ifdef UNICODE
        int nValue = (int)wcstol(TableLine[nCol2],NULL,10);
#else
        int nValue = atoi_my(TableLine[nCol2]);
#endif
		if ( TableLine.size() > nCol1
			&& TableLine.size() > nCol2
			&& _stricmp_my(TableLine[nCol1], szData)==0
			&& nValue == nData2)
			return i;
	}

	return -1;
}
// 2010-01-14 ZHJL added，根据某两列的内容查找行，数字和数字
// returns	:	-1为没有找到，否则为该行的序号，只能找到第一个
int	CExcelTextTable::FindLn( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, unsigned int nLineBegin )const
{
	const size_t nSize = m_Table.size();
	for ( size_t i=nLineBegin; i<nSize; ++i )
	{
		const CStlStringArray& TableLine = *m_Table.at(i);
#ifdef UNICODE
        int nValue1 = (int)wcstol(TableLine[nCol1],NULL,10);
        int nValue2 = (int)wcstol(TableLine[nCol2],NULL,10);
#else
        int nValue1 = atoi_my(TableLine[nCol1]);
        int nValue2 = atoi_my(TableLine[nCol2]);
#endif
		if ( TableLine.size() > nCol1
			&& TableLine.size() > nCol2
			&& nValue1 == nData1
			&& nValue2 == nData2)
			return i;
	}

	return -1;
}
// 2010-03-18 ZHJL added，根据某两列的内容及 误差半径 查找行，只支持数字，需要的话在扩展其他类型，
// returns	:	-1为没有找到，否则为该行的序号，只能找到第一个
int	CExcelTextTable::FindLnEx( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, int nR )const
{
	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++ )
	{
		const CStlStringArray& TableLine = (**it);
		if( TableLine.size() > nCol1 )
		{
#ifdef UNICODE
            int n1 = (int)wcstol(TableLine[nCol1],NULL,10);
            int n2 = (int)wcstol(TableLine[nCol2],NULL,10);
#else
			int n1 = atoi_my(TableLine[nCol1]);
			int n2 = atoi_my(TableLine[nCol2]);
#endif
			if( nData1 >= n1-nR && nData1 <= n1+nR && nData2 >= n2-nR && nData2 <= n2+nR )
				return i;
		}
	}

	return -1;
}

bool CExcelTextTable::IsUseDeault(  CStlStringArray TableLine,int nCol, int nData) const
{	
	if ( nCol == -1)
		return true;
	
	if( TableLine.size() <= nCol )
		return false;

#ifdef UNICODE
	int nValue = (int)wcstol(TableLine[nCol],NULL,10);
#else
	int nValue = atoi_my(TableLine[nCol]);
#endif
	if( nValue != nData )
		return false;

	return true;
}

int CExcelTextTable::FindLnE(int nCol1,	int nData1,int nCol2/*=-1*/, int nData2/*=-1*/,int nCol3/*=-1*/, int nData3/*=-1*/,
	int nCol4/*=-1*/, int nData4/*=-1*/,int nCol5/*=-1*/, int nData5/*=-1*/,int nLineBegin/* = 0*/) const
{	
	const size_t nSize = m_Table.size();
	for ( size_t i=nLineBegin; i<nSize; ++i )
	{
		const CStlStringArray& TableLine = *m_Table.at(i);

#ifdef UNICODE
		int nValue = (int)wcstol(TableLine[nCol1],NULL,10);
#else
		int nValue = atoi_my(TableLine[nCol1]);
#endif
		if ( TableLine.size() > nCol1
			&& nValue == nData1
			&& IsUseDeault( TableLine,nCol2, nData2)
			&& IsUseDeault( TableLine,nCol3, nData3)
			&& IsUseDeault( TableLine,nCol4, nData4)
			&& IsUseDeault( TableLine,nCol5, nData5))  
			return i;
	}


	return -1;
}

// 检查是否有某列内容相同的行
// returns	:	-1为没有重复行，否则为第二个相同行的序号
int CExcelTextTable::CheckDup( int nCol )const
{
	int i=0;
	for ( CStlStringTable::const_iterator itA = m_Table.begin();
		itA != m_Table.end(); ++itA,i++ )
	{
		int j=i+1;
		for ( CStlStringTable::const_iterator itB = itA+1;
			itB != m_Table.end(); ++itB,j++ )
		{
			if( (**itA) == (**itB) )
				return j;
		}
	}
	return -1;
}

// 查找相同某列内容相同的行，找到的所有内容都保存在pnFind中
// returns	:	返回找到的个数
int CExcelTextTable::GetDupLns( int nCol, int nData, int* pnFind, int nCount )const
{
	memset( pnFind, 0, sizeof(int)*nCount );
	int nCounter = 0;
	int i=0;
#ifdef UNICODE
	wchar_t szTemp[256];
#else
	char szTemp[256];
#endif

	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++)
	{
#ifdef UNICODE
        wprintf(szTemp,"%d",nData);
#else
		_itoa_my( nData, szTemp, 256, 10 );
#endif
		if ( (int)(**it).size() > nCol && _stricmp_my( (**it)[nCol], szTemp ) == 0 )
		{
			pnFind[nCounter] = i;
			nCounter++;
			if( nCounter == nCount )
				break;
		}
	}
	return nCounter;
}
int CExcelTextTable::GetDupLns( int nCol, wchar_t* szData, int* pnFind, int nCount )const
{
	memset( pnFind, 0, sizeof(int)*nCount );
	int nCounter = 0;
	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++)
	{
		if ( (int)(**it).size() > nCol && _stricmp_my( (**it)[nCol], szData ) == 0 )
		{
			pnFind[nCounter] = i;
			nCounter++;
			if( nCounter == nCount )
				break;
		}
	}
	return nCounter;
}

int CExcelTextTable::GetDupLns( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, int* pnFind, int nCount )const
{
	memset( pnFind, 0, sizeof(int)*nCount );
	int nCounter = 0;
	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++)
	{
#ifdef UNICODE
        int n1 = (int)wcstol((**it)[nCol1],NULL,10);
        int n2 = (int)wcstol((**it)[nCol2],NULL,10);
#else
        int n1 = atoi_my((**it)[nCol1]);
        int n2 = atoi_my((**it)[nCol2]);
#endif
		if ( ( (int)(**it).size() > nCol1 && n1 == nData1 )
			&& ( (int)(**it).size() > nCol2 && n2 == nData2 ) )
		{
			pnFind[nCounter] = i;
			nCounter++;
			if( nCounter >= nCount )
				break;
		}
	}
	return nCounter;
}

int CExcelTextTable::GetDupLns( unsigned int nCol1, wchar_t* szData, unsigned int nCol2, int nData2, int* pnFind, int nCount ) const
{
	memset( pnFind, 0, sizeof(int)*nCount );
	int nCounter = 0;
	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++)
	{
#ifdef UNICODE
        int n2 = (int)wcstol((**it)[nCol2],NULL,10);
#else
        int n2 = atoi_my((**it)[nCol2]);
#endif
		if ( ( (int)(**it).size() > nCol1 && _stricmp_my( (**it)[nCol1], szData ) == 0 )
			&& ( (int)(**it).size() > nCol2 && n2 == nData2 ) )
		{
			pnFind[nCounter] = i;
			nCounter++;
			if( nCounter >= nCount )
				break;
		}
	}
	return nCounter;
}
// 2010-03-25 ZHJL 加：判断一个表中的某一列数值的唯一性，每一个都唯一则返回真。现在只是字符串，数字以后用到再加。
// （例如别名，不允许重复，而别名都有一个前缀，保证了前缀不会重复，并保证单个表里的别名不会重复，即可保证别名唯一） 
bool CExcelTextTable::JudgeOnlyOne( int nCol, wchar_t* szData )
{
	// 如果是空的则不用判断。
	int nPreLen = strlen_my( szData );
	if( nPreLen == 0 )
		return true;

	bool bRet = true;

	// 注意：szData是别名的前缀

	// 判断前缀是否相同
	for( CStlStringTable::const_iterator itk = m_Table.begin(); itk != m_Table.end(); ++itk)
	{
		if( !( (int)(**itk).size() > nCol && strlen_my((**itk)[nCol]) > 0 ) )
			continue;

		if ( (int)(**itk).size() > nCol && _strnicmp_my( (**itk)[nCol], szData, nPreLen ) != 0 )
		{
			//MY_ASSERT_EX( 0, L"别名前缀不一样：%s : %s", szData, (**itk)[nCol] );
			bRet = false;
		}
	}

	// 判断是否有重复的
	int i = 0, j = 0;
	CStlStringTable::const_iterator iti = m_Table.begin();
	while( iti != m_Table.end() )
	{
		if( (int)(**iti).size() > nCol && strlen_my((**iti)[nCol]) > 0 )
		{
			for( CStlStringTable::const_iterator itj = m_Table.begin();
				itj != m_Table.end(); itj++,j++)
			{
				if( iti == itj )
					continue;

				if ( (int)(**itj).size() > nCol && _stricmp_my( (**iti)[nCol], (**itj)[nCol] ) == 0 )
				{
					//MY_ASSERT_EX( 0, L"别名重复：%s, %d, %d ", (**iti)[nCol], i, j );
					bRet = false;
				}
			}
		}

		i++;
		++iti;
	}

	return bRet;
}

/////////////////////////////////////////////////

// 将指定列作为索引
bool CExcelTextTable::IndexToNum(int nCol)
{
	m_mapLines.clear();

	int i=0;
	for ( CStlStringTable::const_iterator it = m_Table.begin();
		it != m_Table.end(); ++it,i++ )
	{
		const CStlStringArray& TableLine = (**it);
		if ( i > 0 && (int)TableLine.size() > nCol )
		{
#ifdef UNICODE
			int nId = (int)atoi_my(TableLine[nCol],NULL,10);
#else
			int nId = (int)atoi_my(TableLine[nCol]);
#endif
			if ( nId > 0 )
			{
				StdIntMap::iterator it = m_mapLines.find(nId);
				if ( it != m_mapLines.end() )
				{
					//MY_ASSERT_EX( 0, L"文件[%s]索引ID重复：%d行, %d ", GetFileName(), i, nId);
					continue;
				}
				m_mapLines[nId] = i;
			}
		}
	}

	return m_mapLines.size() > 0 ;
}

// 查找索引列指定值的行号
int CExcelTextTable::IndexToLine(int nIdx)
{
	StdIntMap::iterator it = m_mapLines.find(nIdx);
	if ( it != m_mapLines.end() )
		return it->second;
	return -1;
}