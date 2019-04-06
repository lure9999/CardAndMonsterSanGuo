///////////////////////////////////////////////////////////////////////////////
// ���������Ϣ
// ���ãã�������ʽ�������û����
// ������ʽ�������ʽ���Ӧ�÷ֿ�
// ���������书�����Ʋ����ܽ��٣��Ұ�������ͬһ���ṹ��
//
// ������ṹ�У���ǰ��������ֽ���������Ĵ�С��
// �����С�����û���͸���ģ������ᱻ�κκ���������
// �����������Ӧ�÷��õ�ServerLib��
// ��Ϊ�ͻ���Ҳ��ʹ��
//
// Aug 24th, 2006	EL.AHong.F	Modify.
// Sep 01st, 2006	EL.AHong.F	Modify.
// Dec.26.2008		----- Modify
// Nov.25.2009		 Modify //�����WCHAR���ͣ����޸���SetMsgBuf�е�У���ȡ���ȵķ���
// Nov.10.2010		-----, �����˶������ͻ����������������������˶�SNetStreamָ���֧�֡�
//[1/7/2011 zhaowenyuan]	1.operator = �������ж��� �Ը�ֵ  2.����˿������캯�� 3.����������������������ĺ���
///////////////////////////////////////////////////////////////////////////////
#ifndef __NETSTREAM_H__
#define __NETSTREAM_H__

#include "datatype.h"
#include "BaseType.h"
using namespace std;
void EnCode( unsigned char *buf, unsigned int nsize, unsigned int nkey );

///////////////////////////////////////////////////////////////////////////////
class SNetStream
{
public:
	// ���ø��������ͻ������Ĵ�С���������Ϊ ��>>���Ĳ����������ڶ�ȡchar*��WCHAR *���͵�����֮ǰʹ�ã�ʹ��һ���Ժ�ʵЧ��
	struct buf_size
	{
		int m_nSize;
		buf_size( int nSize ) { m_nSize = nSize; }
	};

public:
	/////////////
	// ��ʽ����
	// ע����ʽ�����β����Ҫ����<<end
	//
	SNetStream& operator << ( char n );
	SNetStream& operator << ( signed char n );
	SNetStream& operator << ( unsigned char n );
	SNetStream& operator << ( wchar_t n );			// WCHAR
	SNetStream& operator << ( short n );
	SNetStream& operator << ( unsigned short n );	// WORD
	SNetStream& operator << ( int n );
	SNetStream& operator << ( unsigned int n );		// UINT
	SNetStream& operator << ( unsigned long n );	// DWORD
	SNetStream& operator << ( long n );	// time_t
	SNetStream& operator << ( float n );
	SNetStream& operator << ( double n );
	SNetStream& operator << ( const char* p );
	SNetStream& operator << ( const wchar_t* p );	// WCHAR*
	SNetStream& operator << ( bool b) { return *this << (b ? (char)1 : (char)0); }

	/////////////
	// ��ʽ���
	// ע��1��Ϊ������Ч�ʣ�������ַ�����ʱ�򲢲��Ḵ�ƻ���
	// ���ǽ������ظ��ַ��������е�ƫ�ơ�
	SNetStream& operator >> ( char& n );
	SNetStream& operator >> ( signed char& n );
	SNetStream& operator >> ( unsigned char& n );
	SNetStream& operator >> ( wchar_t& n );			// WCHAR
	SNetStream& operator >> ( short& n );
	SNetStream& operator >> ( unsigned short& n );	// WORD
	SNetStream& operator >> ( int& n );
	SNetStream& operator >> ( unsigned int& n );	// UINT
	SNetStream& operator >> ( unsigned long& n );	// DWORD
	SNetStream& operator >> ( long& n );	// time_t
	SNetStream& operator >> ( float& n );
	SNetStream& operator >> ( double& n );
	SNetStream& operator >> ( char*& p );
	SNetStream& operator >> ( wchar_t*& p );		// WCHAR*
	SNetStream& operator >> ( bool& b) { char tmp; *this>> tmp; b = (tmp != 0); return *this; }

	/////////////
	// ��д�����ͻ�����
	SNetStream& put( void *pBuffer, int nSize );
	SNetStream& get( void *pBuffer, int nSize );
	// ����ֻ��ȡָ�룬��û�п������ݣ������ٶȻ��Щ��
	SNetStream& getPointer( void** ppBuffer, int nSize );
	// ����ֻ��ȡָ�룬��û�п������ݣ������ٶȻ��Щ��
	SNetStream& getPtr( void** ppBuffer, int& nSize );

	/////////////
	// Nov.10.2010. -----
	// ���ö�ȡ�����ͻ�����Bufferʱ�򣬸�����ָ����ָ����ڴ�ռ�Ĵ�С
	SNetStream& operator << ( buf_size& maxbuf );
	SNetStream& operator >> ( buf_size& maxbuf );
	// �����ͻ�������С�������Ⱦ���buf_size(n)��ָ������������
	SNetStream& operator << ( void *pBuffer );
	// �����ͻ�������С�������Ⱦ���buf_size(n)��ָ������������
	SNetStream& operator >> ( void *pBuffer );
	// ����ֻ��ȡָ�룬��û�п������ݣ������ٶȻ��Щ��
	SNetStream& operator >> ( void **ppBuffer );

	/////////////
	// Nov.10.2010. -----
	// ���Լ��ĽṹҲ�Ž�ȥ����������Ƕ��ʹ�ã�����һ�δ�����SNetStream��
	// ע�⣬����ֻ�ǿ���ָ�룬����Ҫ�Լ�����ø�������ݡ����Զ��ڿ��������Ч�ģ�ֻ���ڱ���ʹ��
	SNetStream& operator << ( SNetStream *pStream );
	SNetStream& operator >> ( SNetStream **ppStream );
	
	//////////////
	//  [1/7/2011 zhaowenyuan]
	//	���������Ի�������������
	SNetStream& operator << ( SNetStream& Stream );
	SNetStream& operator >> ( SNetStream& Stream );
public:
	/////////////
	SNetStream& operator = ( const SNetStream& stream );

	/////////////
	// ���Ĳ�����ģʽ
	// ���ڽ����ṩ��������������
	// end ��ʾ�������
	// reset ��ʾ�ع黺����� 
	//
	typedef SNetStream& (  *manipulator )( SNetStream& );

	SNetStream& operator << ( manipulator );
	SNetStream& operator >> ( manipulator );

	/////////////
	// ���������Զ��ƶ����ڴ�ָ��
	// ��������ͬʱ�ṩ��һ��C-Styleȡֵ��ʽ
	// ������Ҫ��ζ�ȡ��ʱ������ʹ�ã������ַ�ʽ���Ƽ�
	char PeekChar();
	int PeekInt();
	char* PeekStr();

	/////////////
	friend SNetStream& end( SNetStream& msg );
	friend SNetStream& reset( SNetStream& msg );

public:
	/////////////
	SNetStream( );
	SNetStream( int _wMsgID, int _wSubMsgID );
	SNetStream(const SNetStream& rhs); //�������캯��
	static	int	GetMaxSize();	// �������

	// ֱ�������ڴ�ָ�루��Ҫ��֤������δ���ʱһֱ��Ч�������ڵ�һ�ι��������Ϣ��ʱ��ʹ��
	// ������һ��У�飬��pBuffer�ĵ�һ��WORD�ﱣ��ľ��Ǹ�Buffer�Ĵ�С��Ҫ��nSize�Ƚ�һ�£�ǰ�߱���С�ڵ��ں��ߡ����򷵻�FALSE
	bool SetMsgBuf( char* pBuffer, int nSize );

	// ͬ�Ϻ���������������ｫpBuffer�����ݿ������Լ����ڲ��ṹ��pBuffer�Ϳ����ͷ��ˡ�
	bool CopyMsgBuf( const char* pBuffer, int nSize );

	// ��ʣ����ٿռ䣬�����ڵ�ǰ�̶��ռ�Ļ����ϣ����Ժ��Ϊ��̬�ռ䣬����Ūһ�����׼��С������ĺ���
	int	GetRemainSize();
	int GetMsgLen( );

	// �õ�stream��Ϣ
	char* GetMsgBuf( );

	// �޸ĺͻ�ȡ��ǰ�α�
	int SetMsgPos( int nPos );
	int GetMsgPos();
	// ���赱ǰ�α�Ϊ��ʼ��λ��
	void ResetPos( );
	/////////////

	// ���ý���
	void End();

	bool IsReady();

	int GetMsgLenEX();
	// ��ȡ��ǰλ�õ���β֮������ݵĴ�С
	int GetSizeofCurToEnd();
	// ���ƶ�λ�ã����ı����ݣ��鿴��Ϣ���е�������A��B
	int GetCmdA();
	int GetCmdB();

	// ����ͷ��ȡ��Ϣ����
	int GetMsgLenByHead();
	// ����β�����ȡ��Ϣ����
	int GetMsgLenByTail();

	//// ����װ�õ���Ϣ������������Ϣ����
	//void SetMsgCounter( UINT nCount );
	//UINT GetMsgCounter();

private:
	static const int nMaxMsgBuf	= 8192 * 2;
	static const int nMsgBeginPos = 2;
	char	m_szBuffer[ nMaxMsgBuf ];	// ϵͳ������
	char*	m_pBuffer;
	int		m_nNowSite;
	int		m_nMaxSite;
	int		m_nBufSize;		// �������ͻ������������л�ʱ��ʵ����Ҫ��buf_size(n)�����û�������С	// Nov.10.2010. -----

};


///////////////////////////////////////////////////////////////////////////////
// ������
extern SNetStream&  end( SNetStream& msg );
extern SNetStream&  reset( SNetStream& msg );

#endif	// __NETSTREAM_H__

