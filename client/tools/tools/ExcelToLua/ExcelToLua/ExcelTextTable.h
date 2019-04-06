///////////////////////////////////////////////////////////////////////////////
//
//	ExcelTextTable.h	:	V0010
//	Written by			:	ZHJL
//	V0010				:	2010-01-13
//	Desc				:	将前人读Excel表格文件的类重新整理，在多字节和UNICODE两种模式下，均可直接运行，无需修改。
//						:	并添加了读取时进行加密的开关，可对没有加过密的文件直接进行加密。上面是前人的版本变动注释。
///////////////////////////////////////////////////////////////////////////////


//#include "string"
#include <stdio.h>
#include <wchar.h>
#include <string>
#include <vector>
#include <map>
#include <list>
#include <string.h>

//add by sxin 修改字符串大小限制
//#define MAX_STR_SIZE 512
#define MAX_STR_SIZE 2048

#ifndef UNICODE
#define UNICODE
#endif

//#ifndef IOS_USED
//#define IOS_USED
//#endif

#ifdef UNICODE
typedef std::vector<wchar_t*>		CStlStringArray;
#else
typedef std::vector<char*>		CStlStringArray;
#endif
typedef std::vector<CStlStringArray*>	CStlStringTable;

/////////////////////////////////////////////////
//
//	class	CExcelTable
//
/////////////////////////////////////////////////
/////////////////////////////////////////////////
#if !defined(EXCEL_INVALID)
#define	EXCEL_INVALID	-1
#endif//#if !defined(EXCEL_INVALID)


#if !defined(EXCEL_STR_MAX)
#define	EXCEL_STR_MAX	256
#endif//#if !defined(EXCEL_STR_MAX)

size_t Utf8ToUtf16(const char* src_, wchar_t* dest_, size_t destlen_, size_t srclen_ /*= 0*/);
size_t Utf16ToUtf8(const wchar_t* src_, char* dest_, size_t destlen_, size_t srclen_);

class CExcelTextTable
{
private:
	int			m_nMaxLn;	//当前最大行数
	int			m_nMaxCol;	//当前最大列数

	int			m_nAssumedMaxLn;
	int			m_nAssumedMaxCol;

	unsigned long		m_dwCrcCheckSum;	//交验和

	CStlStringTable	m_Table;
	CStlStringArray m_pBufferArray;

	typedef std::map<int,int>	StdIntMap;
	StdIntMap		m_mapLines;

#ifdef UNICODE
	std::wstring m_szFileName;
#else
	std::string m_szFileName;
#endif // !UNICODE


public:
	//注意：
	// nLnMax,nColMax 用来指定预测的大小，和真实的不符也没关系，
	// 只是如果 〉真实情况的话会照成内存浪费
	//     最接近真实值的话可以加快加载速度
	CExcelTextTable(int nLnMax=1, int nColMax=1);
	virtual ~CExcelTextTable();

	wchar_t* GetCell(int nLine, int nCol)const;
#ifdef UNICODE
	const wchar_t* GetFileName() const {
		return m_szFileName.c_str();
	}
#else
	const char* GetFileName() const {
		return m_szFileName.c_str();
	}
#endif // !UNICODE

	int GetNumLines()const{
		return (int)m_Table.size();
	}
	int	GetMaxLn()const {
		return m_nMaxLn;
	}
	int	GetMaxCol()const {
		return m_nMaxCol;
	}

	// 清除表内所有内容
	void Reset();

	// 读取以制表符为间隔符号的文本文件，可以累计读取
	// 用 nStartLine 指定开始读取的行号，如果 <= 0 表示从第0行读起
	// 用 nEndLine 指定读取到哪一行号为止（包含这一行），如果 < 0 表示一直读到末行
	// 如果 nStartLine > 0 && nEndLine >= 0  但 nEndLine < nStartLine 的话 返回false
	// returns	:	文件不存在或者数据超界返回false
	bool ReadExcelTable( const char* szName , char* szAlias = "", int nAliasCol = 0, bool bEnCode = false, int nStartLine = -1, int nEndLine = -1);

	// 得到指定位置的数据
	// nSize	:	得到的后缀的最大长度，如果小于输出字符串（第二个参数）的真实长度，则会出现致命错误
	// 若没有填写，则 nData = 缺省值, output = "";
	// 
	char* GetChar( int nLn, int nCol)const;
	int GetInt( int nLn, int nCol, int nDefault = -1)const;
	float GetFloat( int nLn, int nCol, float fDefault = 0.0f)const;

	unsigned long GetDWORD( int nLn, int nCol, unsigned long dwDefault =  0xffffffff)const;
	long long GetINT64( int nLn, int nCol, long long n64Default = 0)const;
	unsigned long long GetUnINT64( int nLn, int nCol, unsigned long long un64Default = 0)const;

	// 根据某列的内容查找行
	// returns	:	-1为没有找到，否则为该行的序号，只能找到第一个
	int	FindLn( int nCol, int nData )const;
	int	FindLn( int nCol, wchar_t* szData )const;

	//根据主键查找(第一列数据)
	char* GetCharE(int nCol, int nData)const;
	int GetIntE( int nCol, int nData,int nDefault = -1)const;
	float GetFloatE( int nCol, int nData, float fDefault = 0.0f)const;
	unsigned long GetDWORDE( int nCol, int nData,  unsigned long dwDefault =  0xffffffff)const;
	long long GetINT64E( int nCol,int nData, long long n64Default = 0)const;
	unsigned long long GetUnINT64E( int nCol,int nData, unsigned long long un64Default = 0)const;

	// 根据某两列的内容查找行，从nLineBegin开始查找
	// returns	:	-1为没有找到，否则为该行的序号，只能找到第一个
	int	FindLn( unsigned int nCol1, wchar_t* szData, unsigned int nCol2, int nData2, unsigned int nLineBegin = 0 )const;	// 字符串和数字	Jun 8th, 2011 joey added
	int	FindLn( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, unsigned int nLineBegin = 0 )const;		// 数字和数字	2010-01-14 ZHJL added

	// 2010-03-18 ZHJL added，根据某两列的内容及 误差半径 查找行，只支持数字，需要的话在扩展其他类型，
	// returns	:	-1为没有找到，否则为该行的序号，只能找到第一个
	int	FindLnEx( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, int nR = 2 )const;

	bool IsUseDeault(  CStlStringArray TableLine,int nCol, int nData) const;

	int FindLnE(int nCol1,	int nData1,int nCol2=-1, int nData2=-1,int nCol3=-1, int nData3=-1,
				int nCol4=-1, int nData4=-1,int nCol5=-1, int nData5=-1,int nLineBegin = 0) const;

	// 检查是否有某列内容相同的行
	// returns	:	-1为没有重复行，否则为第二个相同行的序号
	int CheckDup( int nCol )const;

	// 查找相同某列内容相同的行，找到的所有内容都保存在pnFind中
	// returns	:	返回找到的个数
	int GetDupLns( int nCol, int nData, int* pnFind, int nCount )const;
	int GetDupLns( int nCol, wchar_t* szData, int* pnFind, int nCount )const;

	int GetDupLns( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, int* pnFind, int nCount )const;
	int GetDupLns( unsigned int nCol1, wchar_t* szData, unsigned int nCol2, int nData2, int* pnFind, int nCount )const;

	// 2010-03-25 ZHJL 加：判断一个表中的某一列数值的唯一性，每一个都唯一则返回真。现在只是字符串，数字以后用到再加。
	// （例如别名，不允许重复，而别名都有一个前缀，保证了前缀不会重复，并保证单个表里的别名不会重复，即可保证别名唯一） 
	bool JudgeOnlyOne( int nCol, wchar_t* szData );

	// 得到交验和
	unsigned long GetCheckSum() { return m_dwCrcCheckSum; }

	// 将指定列作为索引
	bool IndexToNum(int nCol);

	// 查找索引列指定值的行号
	int IndexToLine(int nIdx);
};
/////////////////////////////////////////////////
