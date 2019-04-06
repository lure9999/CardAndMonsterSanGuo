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
// Nov.10.2010		-----, �����˶������ͻ����������������������˶�SNetStreamָ���֧�֡�
///////////////////////////////////////////////////////////////////////////////
#include "NetStream.h"
void EnCode( unsigned char *buf, unsigned int nsize, unsigned int nkey )
{
	//unsigned char tempc1 = nsize ^ ~0xFF;//  nsize%256;
	//unsigned char tempc2 = nkey ^ ~0xFF;//  nkey%256;
	//unsigned char tempc3;
	//for( unsigned int i=0; i<nsize; i++ )
	//{
	//	tempc3 = buf[i];
	//	tempc1 ^= tempc2;
	//	buf[i] ^= tempc1;
	//	tempc1 = buf[i] ^ tempc3;
	//}
}
///////////////////////////////////////////////////////////////////////////////
SNetStream& SNetStream::operator << ( char n )
{
	if ( m_nNowSite + sizeof( char ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( char ) );
	m_nNowSite += sizeof( char );
	return ( *this );
}

SNetStream& SNetStream::operator << ( signed char n )
{
	if ( m_nNowSite + sizeof( signed char ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( signed char ) );
	m_nNowSite += sizeof( signed char );
	return ( *this );
}

SNetStream& SNetStream::operator << ( unsigned char n )
{
	if ( m_nNowSite + sizeof( unsigned char ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( unsigned char ) );
	m_nNowSite += sizeof( unsigned char );
	return ( *this );
}

SNetStream& SNetStream::operator << ( wchar_t n )
{
	if ( m_nNowSite + sizeof( wchar_t ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( wchar_t ) );
	m_nNowSite += sizeof( wchar_t );
	return ( *this );
}

SNetStream& SNetStream::operator << ( short n )
{
	if ( m_nNowSite + sizeof( short ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( short ) );
	m_nNowSite += sizeof( short );
	return ( *this );
}

SNetStream& SNetStream::operator << ( unsigned short n )
{
	if ( m_nNowSite + sizeof( unsigned short ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( unsigned short ) );
	m_nNowSite += sizeof( unsigned short );
	return ( *this );
}

SNetStream& SNetStream::operator << ( int n )
{
	if ( m_nNowSite + sizeof( int ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( int ) );
	m_nNowSite += sizeof( int );
	return ( *this );
}

SNetStream& SNetStream::operator << ( unsigned int n )
{
	if ( m_nNowSite + sizeof( unsigned int ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( unsigned int ) );
	m_nNowSite += sizeof( unsigned int );
	return ( *this );
}

SNetStream& SNetStream::operator << ( unsigned long n )
{
	if ( m_nNowSite + sizeof( unsigned long ) > nMaxMsgBuf )
	{
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( unsigned long ) );
	m_nNowSite += sizeof( unsigned long );
	return ( *this );
}

SNetStream& SNetStream::operator << ( long n )
{
	if ( m_nNowSite + sizeof( long ) > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + sizeof( unsigned long ) <= nMaxMsgBuf );
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof(  long ) );
	m_nNowSite += sizeof(  long );
	return ( *this );
}

SNetStream& SNetStream::operator << ( float n )
{
	if ( m_nNowSite + sizeof( float ) > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + sizeof( float ) <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + sizeof( float ) <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( float ) );
	m_nNowSite += sizeof( float );
	return ( *this );
}

SNetStream& SNetStream::operator << ( double n )
{
	if ( m_nNowSite + sizeof( double ) > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + sizeof( double ) <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + sizeof( double ) <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &n, sizeof( double ) );
	m_nNowSite += sizeof( double );
	return ( *this );
}

SNetStream& SNetStream::operator << ( const char* p )
{
	int ncharLen = 0;
	if( p != NULL )
		ncharLen = ( int )strlen( p );
	// ��Ҫ�ַ��������'\0'
	int nLen = ncharLen + 1;
	if ( m_nNowSite + nLen * sizeof( char ) > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + nLen * sizeof( char ) <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + nLen * sizeof( char ) <= nMaxMsgBuf, __T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}

	if( p == NULL )
	{
		char ch;
		memset( &ch, 0, sizeof( char ) );
		memcpy( m_pBuffer + m_nNowSite, &ch, 1 * sizeof( char ) );
	}
	else
	{
		memcpy( m_pBuffer + m_nNowSite, p, nLen * sizeof( char ) );
	}
	m_nNowSite += nLen * sizeof( char );
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
SNetStream& SNetStream::operator >> ( char& n )
{
	if( m_nNowSite + (int)sizeof( char ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( char ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( char ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( char ) );
	m_nNowSite += sizeof( char );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( signed char& n )
{
	if( m_nNowSite + (int)sizeof( signed char ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( signed char ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( signed char ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( signed char ) );
	m_nNowSite += sizeof( signed char );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( unsigned char& n )
{
	if( m_nNowSite + (int)sizeof( unsigned char ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( unsigned char ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( unsigned char ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( unsigned char ) );
	m_nNowSite += sizeof( unsigned char );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( wchar_t& n )
{
	if( m_nNowSite + (int)sizeof( wchar_t ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( wchar_t ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( wchar_t ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( wchar_t ) );
	m_nNowSite += sizeof( wchar_t );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( short& n )
{
	if( m_nNowSite + (int)sizeof( short ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( short ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( short ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( short ) );
	m_nNowSite += sizeof( short );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( unsigned short& n )
{
	if( m_nNowSite + (int)sizeof( unsigned short ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( unsigned short ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( unsigned short ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( unsigned short ) );
	m_nNowSite += sizeof( unsigned short );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( int& n )
{
	if( m_nNowSite + (int)sizeof( int ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( int ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( int ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( int ) );
	m_nNowSite += sizeof( int );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( unsigned int& n )
{
	if( m_nNowSite + (int)sizeof( unsigned int ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( unsigned int ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( unsigned int ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( unsigned int ) );
	m_nNowSite += sizeof( unsigned int );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( unsigned long& n )
{
	if( m_nNowSite + (int)sizeof( unsigned long ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( unsigned long ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( unsigned long ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( unsigned long ) );
	m_nNowSite += sizeof( unsigned long );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( long& n )
{
	if( m_nNowSite + (int)sizeof( long ) > m_nMaxSite )
	{
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( long ) <= m_nMaxSite, __T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( long ) );
	m_nNowSite += sizeof( long );
	return ( *this );	
}

SNetStream& SNetStream::operator >> ( float& n )
{
	if( m_nNowSite + (int)sizeof( float ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( float ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( float ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( float ) );
	m_nNowSite += sizeof( float );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( double& n )
{
	if( m_nNowSite + (int)sizeof( double ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( double ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( double ) <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( &n, m_pBuffer + m_nNowSite, sizeof( double ) );
	m_nNowSite += sizeof( double );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( char*& p )
{
	int nLen = ( int )strlen( m_pBuffer + m_nNowSite ) + 1;
	if( m_nNowSite + nLen * (int)sizeof( char ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + nLen * (int)sizeof( char ) <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + nLen * (int)sizeof( char ) <= m_nMaxSite, __T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	p = m_pBuffer + m_nNowSite; 
	m_nNowSite += nLen * sizeof( char );
	return ( *this );
}
///////////////////////////////////////////////////////////////////////////////
// ��д�����ͻ�����
SNetStream& SNetStream::put( void *pBuffer, int nSize )
{
	if ( m_nNowSite + nSize > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + nSize <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + nSize <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}

	memcpy( m_pBuffer + m_nNowSite, pBuffer, nSize );
	m_nNowSite += nSize;
	return( *this );
}

SNetStream& SNetStream::get( void *pBuffer, int nSize )
{
	if( m_nNowSite + nSize > m_nMaxSite )
	{
		//MY_ASSERT_EX( m_nNowSite + nSize <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( pBuffer, m_pBuffer + m_nNowSite, nSize );
	m_nNowSite += nSize * sizeof(char);
	return ( *this );
}

// ����ֻ��ȡָ�룬��û�п������ݣ������ٶȻ��Щ��
SNetStream& SNetStream::getPointer( void **ppBuffer, int nSize )
{
	if( m_nNowSite + (int)sizeof( void * ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( void * )  <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( void * )  <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	*ppBuffer = m_pBuffer + m_nNowSite;
	m_nNowSite += nSize; // ע�����ﲻ��sizeof( void * )�� �������ַ����Ĵ���
	return ( *this );
}

// ����ֻ��ȡָ�룬��û�п������ݣ������ٶȻ��Щ��
SNetStream& SNetStream::getPtr( void **ppBuffer, int& nSize )
{
	nSize = m_nMaxSite - m_nNowSite;
	*ppBuffer = m_pBuffer + m_nNowSite;
	m_nNowSite += nSize; // ע�����ﲻ��sizeof( void * )�� �������ַ����Ĵ���
	return ( *this );
}

///////////////////////////////////////////////////////////////////////////////
// Nov.10.2010. -----
// ��д�����ͻ������÷���
// ����1���ַ�������
//	char wcsABC[256] = "ABCDEFG_abcdefg";
//	sNet << SNetStream::buf_size(256) << (void *)wcsABC << end;
//	char wcsABC2[256];
//	sNet >> SNetStream::buf_size(256) >> (void *)wcsABC2;
// ע��ʵ�����������ַ���������ôд���������·������ɣ�
//	sNet << wcsABC << end;
//	char *pwcsABC2 = NULL;
//	sNet >> pwcsABC2;

// ����2���ṹ����
//	SNetStream sNet;
//	struct SHEADER
//	{
//		float m_fA;
//		Wchar m_szStr[32];
//	} header;
//	header.m_fA = 123.456789f;
//	wcscpy_s( header.m_szStr, 32, _T("abc_ABC_123_!@#") );
//
//	sNet << SNetStream::buf_size(sizeof(header)) << &header << end;
//
//	����1��
//	SHEADER header2;
//	sNet >> SNetStream::buf_size(sizeof(header)) >> (void *)&header2;
//
//	����2�����Ч�ʸ�һ�㣬��Ϊû�п���
//	SHEADER *pheader3 = NULL;
//	sNet >> SNetStream::buf_size(sizeof(header)) >> (void **)&pheader3;


///////////////////////////////////////////////////////////////////////////////
// ���ö�ȡ�����ͻ�����Bufferʱ�򣬸�����ָ����ָ����ڴ�ռ�Ĵ�С
SNetStream& SNetStream::operator << ( buf_size& maxbuf )
{
	m_nBufSize = maxbuf.m_nSize;
	//MY_ASSERT( m_nBufSize <= nMaxMsgBuf-m_nNowSite );
	//MY_ASSERT_EX( m_nBufSize <= nMaxMsgBuf-m_nNowSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
	return ( *this );
}
SNetStream& SNetStream::operator >> ( buf_size& maxbuf )
{
	m_nBufSize = maxbuf.m_nSize;
	//MY_ASSERT( m_nBufSize <= m_nMaxSite-m_nNowSite );
	//MY_ASSERT_EX( m_nBufSize <= m_nMaxSite-m_nNowSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
	return ( *this );
}

// �����ͻ�������С�������Ⱦ���buf_size(n)��ָ������������
SNetStream& SNetStream::operator << ( void *pBuffer )
{
	if( m_nBufSize <= 0 )
	{
		//MY_ASSERT( m_nBufSize > 0 );
		//MY_ASSERT_EX( m_nBufSize > 0, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	if ( m_nNowSite + m_nBufSize > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + m_nBufSize <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + m_nBufSize <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}

	memcpy( m_pBuffer + m_nNowSite, pBuffer, m_nBufSize );
	m_nNowSite += m_nBufSize;
	m_nBufSize = 0;	// �����Ժ�������㣬����Ӱ������ʹ��
	return( *this );
}
// �����ͻ�������С�������Ⱦ���buf_size(n)��ָ������������
SNetStream& SNetStream::operator >> ( void *pBuffer )
{
	if( m_nBufSize <= 0 || !pBuffer )
	{
		//MY_ASSERT( m_nBufSize > 0 );
		//MY_ASSERT_EX( m_nBufSize > 0, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	if( m_nNowSite + m_nBufSize > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + m_nBufSize <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + m_nBufSize <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	// ������ָ�룬�Ϳ������������ٶ���һЩ
	memcpy( pBuffer, m_pBuffer + m_nNowSite, m_nBufSize );
	m_nNowSite += m_nBufSize;
	m_nBufSize = 0;	// �����Ժ�������㣬����Ӱ������ʹ��
	return ( *this );
}
SNetStream& SNetStream::operator >> ( void **ppBuffer )
{
	if( m_nBufSize <= 0 )
	{
		//MY_ASSERT( m_nBufSize > 0 );
		//MY_ASSERT_EX( m_nBufSize > 0, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	if( m_nNowSite + (int)sizeof( void * ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( void * )  <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( void * )  <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	// ֱ�Ӱ�ָ��ָ��ǰλ�ã��������ٶȿ�һЩ
	*ppBuffer = m_pBuffer + m_nNowSite;

	m_nNowSite += m_nBufSize; // ע�����ﲻ��sizeof( void * )�� �������ַ����Ĵ���
	m_nBufSize = 0;	// �����Ժ�������㣬����Ӱ������ʹ��
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
// ���Լ��ĽṹҲ�Ž�ȥ����������Ƕ��ʹ�ã�����һ�δ�����SNetStream��
// ע�⣬����ֻ�ǿ���ָ�룬����Ҫ�Լ�����ø�������ݡ����Զ��ڿ��������Ч�ģ�ֻ���ڱ���ʹ��
SNetStream& SNetStream::operator << ( SNetStream *pStream )
{
	if ( m_nNowSite + sizeof( SNetStream * ) > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + sizeof( SNetStream * ) <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + sizeof( SNetStream * ) <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, &pStream, sizeof( SNetStream * ) );
	m_nNowSite += sizeof( SNetStream * );
	return ( *this );
}
SNetStream& SNetStream::operator >> ( SNetStream **ppStream )
{
	if( m_nNowSite + (int)sizeof( SNetStream * ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( SNetStream * )  <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + sizeof( SNetStream * ) <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	memcpy( ppStream, m_pBuffer + m_nNowSite, sizeof( SNetStream * ) );
	m_nNowSite += sizeof( SNetStream * );
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
SNetStream& SNetStream::operator = ( const SNetStream& stream )
{
	if( this == &stream ) // �ж��ָ�ֵ [1/7/2011 zhaowenyuan]
	{
		return ( *this );
	}

	memcpy( m_szBuffer, stream.m_szBuffer, nMaxMsgBuf );
	m_pBuffer = m_szBuffer;
	m_nNowSite = stream.m_nNowSite;
	m_nMaxSite = stream.m_nMaxSite;
	m_nBufSize = stream.m_nBufSize;		// �������ͻ������������л�ʱ��ʵ����Ҫ��buf_size(n)�����û�������С
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
SNetStream& SNetStream::operator << ( manipulator p )
{
	// �ã�������������ģʽ
	( *p )( *this );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( manipulator p )
{
	// �ã�������������ģʽ
	( *p )( *this );
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
SNetStream::SNetStream( )
{
	// Ĭ��Ϊ��ǰ��ϵͳ������
	m_pBuffer	= m_szBuffer;
	m_nNowSite	= nMsgBeginPos;
	m_nMaxSite	= nMsgBeginPos;
	memset( m_pBuffer, 0, nMaxMsgBuf ); // Ч������͵Ļ�������ȡ��
	m_nBufSize = 0;		// �������ͻ������������л�ʱ��ʵ����Ҫ��buf_size(n)�����û�������С	// Nov.10.2010. -----
}


SNetStream::SNetStream( int _wMsgID, int _wSubMsgID )
{
	// Ĭ��Ϊ��ǰ��ϵͳ������
	m_pBuffer	= m_szBuffer;
	m_nNowSite	= nMsgBeginPos;
	m_nMaxSite	= nMsgBeginPos;
	memset( m_pBuffer, 0, nMaxMsgBuf ); // Ч������͵Ļ�������ȡ��
	m_nBufSize = 0;		// �������ͻ������������л�ʱ��ʵ����Ҫ��buf_size(n)�����û�������С	// Nov.10.2010. -----
	*this << _wMsgID << _wSubMsgID;
}

SNetStream::SNetStream( const SNetStream& rhs )
{
	// Ĭ��Ϊ��ǰ��ϵͳ������
	memcpy( m_szBuffer, rhs.m_szBuffer, nMaxMsgBuf );
	m_pBuffer = m_szBuffer;
	m_nNowSite = rhs.m_nNowSite;
	m_nMaxSite = rhs.m_nMaxSite;
	m_nBufSize = rhs.m_nBufSize;		// �������ͻ������������л�ʱ��ʵ����Ҫ��buf_size(n)�����û�������С
}

int	SNetStream::GetMaxSize()
{
	return nMaxMsgBuf - nMsgBeginPos;
}


SNetStream& SNetStream::operator << ( SNetStream& Stream )
{
	// ������Լ��Ļ��ͷ���
	if( this == &Stream )
	{
		return (*this);
	}

	int nLen = Stream.m_nMaxSite -  Stream.m_nNowSite;
	if ( 0 == nLen)
	{
		return ( *this );
	}

	if ( m_nNowSite + nLen > nMaxMsgBuf )
	{
		//MY_ASSERT( m_nNowSite + nLen <= nMaxMsgBuf );
		//MY_ASSERT_EX( m_nNowSite + nLen <= nMaxMsgBuf, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return( *this );
	}
	memcpy( m_pBuffer + m_nNowSite, Stream.m_pBuffer + Stream.m_nNowSite , nLen );
	m_nNowSite += nLen ;
	Stream.m_nNowSite += nLen ;
	return ( *this );
}
SNetStream& SNetStream::operator >> ( SNetStream& Stream )
{
	Stream << (*this);
	return ( *this );
}

///////////////////////////////////////////////////////////////////////////////
bool SNetStream::SetMsgBuf( char* pBuffer, int nSize )
{	// ����һ��У�飬pBuffer�ĵ�һ��unsigned short���汣��ľ���ʵ��Buffer�Ĵ�С��Ҫ�Ͳ����������Ĵ�С�Ƚϣ�ǰ�߱���С�ڵ��ں��ߡ�
	//int nRealSize = pBuffer[0]+(pBuffer[1]<<8);
	// 2009-12-25 Fixed by  ���У��ȡ�����Ĵ�С���ԣ�����ֱ��ǿ��ת��������
	unsigned short wSize = * ( unsigned short* )pBuffer;
	int nRealSize = int(wSize);
	if( nRealSize > nSize )
		return FALSE;

	m_pBuffer = pBuffer;
	m_nNowSite = nMsgBeginPos;
	m_nMaxSite = nRealSize;
	m_nBufSize = 0;

	ResetPos();
	return TRUE;
}

bool SNetStream::CopyMsgBuf( const char* pBuffer, int nSize )
{	// ����һ��У�飬pBuffer�ĵ�һ��unsigned short���汣��ľ���ʵ��Buffer�Ĵ�С��Ҫ�Ͳ����������Ĵ�С�Ƚϣ�ǰ�߱���С�ڵ��ں��ߡ�
	//int nRealSize = pBuffer[0]+(pBuffer[1]<<8);
	unsigned short wSize = * ( unsigned short* )pBuffer;
	int nRealSize = int(wSize);
	if( nRealSize > nSize )
		return FALSE;

	if( nRealSize != nSize )
	{
		int dsfsf = 0 ;
	}

	m_pBuffer = m_szBuffer;
	memcpy( m_pBuffer, pBuffer, nSize );
	m_nNowSite = nMsgBeginPos;
	m_nMaxSite = nRealSize;
	m_nBufSize = 0;

	ResetPos();
	return TRUE;
}

// ��ʣ����ٿռ䣬�����ڵ�ǰ�̶��ռ�Ļ����ϣ����Ժ��Ϊ��̬�ռ䣬����Ūһ�����׼��С������ĺ���
int	SNetStream::GetRemainSize(){ return nMaxMsgBuf - m_nNowSite; }
int SNetStream::GetMsgLen( ){ return m_nMaxSite; }
char* SNetStream::GetMsgBuf( ){ return m_pBuffer; }
int SNetStream::SetMsgPos( int nPos )
{
	int nOldPos	= m_nNowSite;
	m_nNowSite	= nPos;
	return nOldPos;
}
int SNetStream::GetMsgPos(){ return m_nNowSite; }
void SNetStream::ResetPos( ){ m_nNowSite	= nMsgBeginPos; }

void SNetStream::End( )
{
	// ��һ�°ɣ��������ظ����ô˷����������ƻ�����
	if( m_nNowSite == nMsgBeginPos )
		return;

	// ��������
	// ע��1��ĩβ��һ��4�ֽڣ��̶����ı������Ժ�������ֹ�Ƿ�����
	// ע��2��Ȼ�����һ�����ȵķ���( unsigned short )
	//m_nNowSite += 4;
	unsigned short wSite = ( unsigned short )(~( m_nNowSite + sizeof( unsigned short ) ) );
	memcpy( m_pBuffer + m_nNowSite, &wSite, sizeof( unsigned short ) );
	m_nNowSite += ( sizeof( unsigned short ) );
	* ( unsigned short* )m_pBuffer = m_nNowSite;

	m_nMaxSite = m_nNowSite;
	m_nBufSize = 0;

	ResetPos();	// �ѱ�־λ�趨Ϊһ��ʼ��׼�������Ķ�����
}

bool SNetStream::IsReady()
{
	return ( m_nNowSite == nMsgBeginPos );
}

int SNetStream::GetMsgLenEX()
{
	unsigned short wLen = (* ( unsigned short* )(m_pBuffer));
	int nLen = int(wLen);
	return nLen;
}
// ��ȡ��ǰλ�õ���β֮������ݵĴ�С
int SNetStream::GetSizeofCurToEnd(){ return m_nMaxSite - m_nNowSite; }
// ���ƶ�λ�ã����ı����ݣ��鿴��Ϣ���е�������A��B
int SNetStream::GetCmdA()
{
	if (!m_pBuffer)
	{
		return 0;
	}
	return * ( int* )(m_pBuffer+2);
}
int SNetStream::GetCmdB()
{
	if (!m_pBuffer)
	{
		return 0;
	}
	return * ( int* )(m_pBuffer+6);
}
// ����ͷ��ȡ��Ϣ����
int SNetStream::GetMsgLenByHead()
{
	unsigned short wLen = (* ( unsigned short* )(m_pBuffer));
	int nLen = int(wLen);
	return nLen;
}
// ����β�����ȡ��Ϣ����
int SNetStream::GetMsgLenByTail()
{
	unsigned short wLen = ~(* ( unsigned short* )(m_pBuffer+m_nMaxSite-sizeof(unsigned short)));
	int nLen = int(wLen);
	return nLen;
}

//// ����װ�õ���Ϣ������������Ϣ����
//void SNetStream::SetMsgCounter( Uint nCount )
//{
//	if( m_nMaxSite >= 12 )
//	{
//		Uint* pCount = (Uint*)(m_pBuffer+m_nMaxSite-6);
//		*pCount = nCount;
//	}
//}
//Uint SNetStream::GetMsgCounter()
//{
//	if( m_nMaxSite >= 12 )
//	{
//		Uint nCount = *(Uint*)(m_pBuffer+m_nMaxSite-6);
//		return nCount;
//	}
//	return 0;
//}

///////////////////////////////////////////////////////////////////////////////
SNetStream& reset( SNetStream& msg )
{
	msg.ResetPos( );
	return msg;
}

SNetStream& end( SNetStream& msg )
{
	// 2010-10-08 :����������ŵ�End����������ڲ����˷�ֹ�ظ����ý������ж�
	msg.End();
	return msg;
}