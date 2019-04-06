///////////////////////////////////////////////////////////////////////////////
//
//	ExcelTextTable.h	:	V0010
//	Written by			:	ZHJL
//	V0010				:	2010-01-13
//	Desc				:	��ǰ�˶�Excel����ļ��������������ڶ��ֽں�UNICODE����ģʽ�£�����ֱ�����У������޸ġ�
//						:	������˶�ȡʱ���м��ܵĿ��أ��ɶ�û�мӹ��ܵ��ļ�ֱ�ӽ��м��ܡ�������ǰ�˵İ汾�䶯ע�͡�
///////////////////////////////////////////////////////////////////////////////


//#include "string"
#include <stdio.h>
#include <wchar.h>
#include <string>
#include <vector>
#include <map>
#include <list>
#include <string.h>

//add by sxin �޸��ַ�����С����
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
	int			m_nMaxLn;	//��ǰ�������
	int			m_nMaxCol;	//��ǰ�������

	int			m_nAssumedMaxLn;
	int			m_nAssumedMaxCol;

	unsigned long		m_dwCrcCheckSum;	//�����

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
	//ע�⣺
	// nLnMax,nColMax ����ָ��Ԥ��Ĵ�С������ʵ�Ĳ���Ҳû��ϵ��
	// ֻ����� ����ʵ����Ļ����ճ��ڴ��˷�
	//     ��ӽ���ʵֵ�Ļ����Լӿ�����ٶ�
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

	// ���������������
	void Reset();

	// ��ȡ���Ʊ��Ϊ������ŵ��ı��ļ��������ۼƶ�ȡ
	// �� nStartLine ָ����ʼ��ȡ���кţ���� <= 0 ��ʾ�ӵ�0�ж���
	// �� nEndLine ָ����ȡ����һ�к�Ϊֹ��������һ�У������ < 0 ��ʾһֱ����ĩ��
	// ��� nStartLine > 0 && nEndLine >= 0  �� nEndLine < nStartLine �Ļ� ����false
	// returns	:	�ļ������ڻ������ݳ��緵��false
	bool ReadExcelTable( const char* szName , char* szAlias = "", int nAliasCol = 0, bool bEnCode = false, int nStartLine = -1, int nEndLine = -1);

	// �õ�ָ��λ�õ�����
	// nSize	:	�õ��ĺ�׺����󳤶ȣ����С������ַ������ڶ�������������ʵ���ȣ���������������
	// ��û����д���� nData = ȱʡֵ, output = "";
	// 
	char* GetChar( int nLn, int nCol)const;
	int GetInt( int nLn, int nCol, int nDefault = -1)const;
	float GetFloat( int nLn, int nCol, float fDefault = 0.0f)const;

	unsigned long GetDWORD( int nLn, int nCol, unsigned long dwDefault =  0xffffffff)const;
	long long GetINT64( int nLn, int nCol, long long n64Default = 0)const;
	unsigned long long GetUnINT64( int nLn, int nCol, unsigned long long un64Default = 0)const;

	// ����ĳ�е����ݲ�����
	// returns	:	-1Ϊû���ҵ�������Ϊ���е���ţ�ֻ���ҵ���һ��
	int	FindLn( int nCol, int nData )const;
	int	FindLn( int nCol, wchar_t* szData )const;

	//������������(��һ������)
	char* GetCharE(int nCol, int nData)const;
	int GetIntE( int nCol, int nData,int nDefault = -1)const;
	float GetFloatE( int nCol, int nData, float fDefault = 0.0f)const;
	unsigned long GetDWORDE( int nCol, int nData,  unsigned long dwDefault =  0xffffffff)const;
	long long GetINT64E( int nCol,int nData, long long n64Default = 0)const;
	unsigned long long GetUnINT64E( int nCol,int nData, unsigned long long un64Default = 0)const;

	// ����ĳ���е����ݲ����У���nLineBegin��ʼ����
	// returns	:	-1Ϊû���ҵ�������Ϊ���е���ţ�ֻ���ҵ���һ��
	int	FindLn( unsigned int nCol1, wchar_t* szData, unsigned int nCol2, int nData2, unsigned int nLineBegin = 0 )const;	// �ַ���������	Jun 8th, 2011 joey added
	int	FindLn( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, unsigned int nLineBegin = 0 )const;		// ���ֺ�����	2010-01-14 ZHJL added

	// 2010-03-18 ZHJL added������ĳ���е����ݼ� ���뾶 �����У�ֻ֧�����֣���Ҫ�Ļ�����չ�������ͣ�
	// returns	:	-1Ϊû���ҵ�������Ϊ���е���ţ�ֻ���ҵ���һ��
	int	FindLnEx( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, int nR = 2 )const;

	bool IsUseDeault(  CStlStringArray TableLine,int nCol, int nData) const;

	int FindLnE(int nCol1,	int nData1,int nCol2=-1, int nData2=-1,int nCol3=-1, int nData3=-1,
				int nCol4=-1, int nData4=-1,int nCol5=-1, int nData5=-1,int nLineBegin = 0) const;

	// ����Ƿ���ĳ��������ͬ����
	// returns	:	-1Ϊû���ظ��У�����Ϊ�ڶ�����ͬ�е����
	int CheckDup( int nCol )const;

	// ������ͬĳ��������ͬ���У��ҵ����������ݶ�������pnFind��
	// returns	:	�����ҵ��ĸ���
	int GetDupLns( int nCol, int nData, int* pnFind, int nCount )const;
	int GetDupLns( int nCol, wchar_t* szData, int* pnFind, int nCount )const;

	int GetDupLns( unsigned int nCol1, int nData1, unsigned int nCol2, int nData2, int* pnFind, int nCount )const;
	int GetDupLns( unsigned int nCol1, wchar_t* szData, unsigned int nCol2, int nData2, int* pnFind, int nCount )const;

	// 2010-03-25 ZHJL �ӣ��ж�һ�����е�ĳһ����ֵ��Ψһ�ԣ�ÿһ����Ψһ�򷵻��档����ֻ���ַ����������Ժ��õ��ټӡ�
	// ������������������ظ�������������һ��ǰ׺����֤��ǰ׺�����ظ�������֤��������ı��������ظ������ɱ�֤����Ψһ�� 
	bool JudgeOnlyOne( int nCol, wchar_t* szData );

	// �õ������
	unsigned long GetCheckSum() { return m_dwCrcCheckSum; }

	// ��ָ������Ϊ����
	bool IndexToNum(int nCol);

	// ����������ָ��ֵ���к�
	int IndexToLine(int nIdx);
};
/////////////////////////////////////////////////
