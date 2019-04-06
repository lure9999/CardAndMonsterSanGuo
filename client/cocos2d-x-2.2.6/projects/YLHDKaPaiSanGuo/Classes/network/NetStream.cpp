///////////////////////////////////////////////////////////////////////////////
// 网络输出消息
// 利用Ｃ＋＋流方式，方便用户填充
// 本来流式输入和流式输出应该分开
// 但是由于其功能相似并功能较少，我把他放入同一个结构中
//
// 在这个结构中，最前面的两个字节是网络包的大小，
// 这个大小对于用户是透明的，他不会被任何函数解析到
// 不过这个流不应该放置到ServerLib中
// 因为客户端也会使用
//
// Aug 24th, 2006	EL.AHong.F	Modify.
// Sep 01st, 2006	EL.AHong.F	Modify.
// Dec.26.2008		----- Modify
// Nov.10.2010		-----, 增加了对无类型缓冲区的流处理函数，增加了对SNetStream指针的支持。
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
	// 需要字符串后面的'\0'
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
// 读写无类型缓冲区
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

// 这里只获取指针，并没有拷贝数据，所以速度会快些。
SNetStream& SNetStream::getPointer( void **ppBuffer, int nSize )
{
	if( m_nNowSite + (int)sizeof( void * ) > m_nMaxSite )
	{
		//MY_ASSERT( m_nNowSite + (int)sizeof( void * )  <= m_nMaxSite );
		//MY_ASSERT_EX( m_nNowSite + (int)sizeof( void * )  <= m_nMaxSite, _T("A:%d, B:%d, m_nNowSite:%d, m_nMaxSite:%d"), GetCmdA(), GetCmdB(), m_nNowSite, m_nMaxSite );
		return ( *this );
	}
	*ppBuffer = m_pBuffer + m_nNowSite;
	m_nNowSite += nSize; // 注意这里不是sizeof( void * )， 类似于字符串的处理
	return ( *this );
}

// 这里只获取指针，并没有拷贝数据，所以速度会快些。
SNetStream& SNetStream::getPtr( void **ppBuffer, int& nSize )
{
	nSize = m_nMaxSite - m_nNowSite;
	*ppBuffer = m_pBuffer + m_nNowSite;
	m_nNowSite += nSize; // 注意这里不是sizeof( void * )， 类似于字符串的处理
	return ( *this );
}

///////////////////////////////////////////////////////////////////////////////
// Nov.10.2010. -----
// 读写无类型缓冲区用法：
// 例子1（字符串）：
//	char wcsABC[256] = "ABCDEFG_abcdefg";
//	sNet << SNetStream::buf_size(256) << (void *)wcsABC << end;
//	char wcsABC2[256];
//	sNet >> SNetStream::buf_size(256) >> (void *)wcsABC2;
// 注：实际上真正的字符串不用这么写，按照以下方法即可：
//	sNet << wcsABC << end;
//	char *pwcsABC2 = NULL;
//	sNet >> pwcsABC2;

// 例子2（结构）：
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
//	方法1：
//	SHEADER header2;
//	sNet >> SNetStream::buf_size(sizeof(header)) >> (void *)&header2;
//
//	方法2：这个效率高一点，因为没有拷贝
//	SHEADER *pheader3 = NULL;
//	sNet >> SNetStream::buf_size(sizeof(header)) >> (void **)&pheader3;


///////////////////////////////////////////////////////////////////////////////
// 设置读取无类型缓冲区Buffer时候，给定的指针所指向的内存空间的大小
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

// 无类型缓冲区大小必须事先经过buf_size(n)来指定，否则会出错。
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
	m_nBufSize = 0;	// 用完以后必须清零，以免影响后面的使用
	return( *this );
}
// 无类型缓冲区大小必须事先经过buf_size(n)来指定，否则会出错。
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
	// 给定了指针，就拷贝，这样做速度慢一些
	memcpy( pBuffer, m_pBuffer + m_nNowSite, m_nBufSize );
	m_nNowSite += m_nBufSize;
	m_nBufSize = 0;	// 用完以后必须清零，以免影响后面的使用
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
	// 直接把指针指向当前位置，这样做速度快一些
	*ppBuffer = m_pBuffer + m_nNowSite;

	m_nNowSite += m_nBufSize; // 注意这里不是sizeof( void * )， 类似于字符串的处理
	m_nBufSize = 0;	// 用完以后必须清零，以免影响后面的使用
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
// 把自己的结构也放进去，这样便于嵌套使用，可以一次处理多个SNetStream流
// 注意，这里只是拷贝指针，所以要自己保存好该类的内容。所以对于跨进程是无效的，只能在本地使用
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
	if( this == &stream ) // 判断字赋值 [1/7/2011 zhaowenyuan]
	{
		return ( *this );
	}

	memcpy( m_szBuffer, stream.m_szBuffer, nMaxMsgBuf );
	m_pBuffer = m_szBuffer;
	m_nNowSite = stream.m_nNowSite;
	m_nMaxSite = stream.m_nMaxSite;
	m_nBufSize = stream.m_nBufSize;		// 把无类型缓冲区进行序列化时，实现需要用buf_size(n)来设置缓冲区大小
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
SNetStream& SNetStream::operator << ( manipulator p )
{
	// Ｃ＋＋　流操纵器模式
	( *p )( *this );
	return ( *this );
}

SNetStream& SNetStream::operator >> ( manipulator p )
{
	// Ｃ＋＋　流操纵器模式
	( *p )( *this );
	return ( *this );
}


///////////////////////////////////////////////////////////////////////////////
SNetStream::SNetStream( )
{
	// 默认为当前的系统缓冲区
	m_pBuffer	= m_szBuffer;
	m_nNowSite	= nMsgBeginPos;
	m_nMaxSite	= nMsgBeginPos;
	memset( m_pBuffer, 0, nMaxMsgBuf ); // 效率如果低的话，可以取消
	m_nBufSize = 0;		// 把无类型缓冲区进行序列化时，实现需要用buf_size(n)来设置缓冲区大小	// Nov.10.2010. -----
}


SNetStream::SNetStream( int _wMsgID, int _wSubMsgID )
{
	// 默认为当前的系统缓冲区
	m_pBuffer	= m_szBuffer;
	m_nNowSite	= nMsgBeginPos;
	m_nMaxSite	= nMsgBeginPos;
	memset( m_pBuffer, 0, nMaxMsgBuf ); // 效率如果低的话，可以取消
	m_nBufSize = 0;		// 把无类型缓冲区进行序列化时，实现需要用buf_size(n)来设置缓冲区大小	// Nov.10.2010. -----
	*this << _wMsgID << _wSubMsgID;
}

SNetStream::SNetStream( const SNetStream& rhs )
{
	// 默认为当前的系统缓冲区
	memcpy( m_szBuffer, rhs.m_szBuffer, nMaxMsgBuf );
	m_pBuffer = m_szBuffer;
	m_nNowSite = rhs.m_nNowSite;
	m_nMaxSite = rhs.m_nMaxSite;
	m_nBufSize = rhs.m_nBufSize;		// 把无类型缓冲区进行序列化时，实现需要用buf_size(n)来设置缓冲区大小
}

int	SNetStream::GetMaxSize()
{
	return nMaxMsgBuf - nMsgBeginPos;
}


SNetStream& SNetStream::operator << ( SNetStream& Stream )
{
	// 如果是自己的话就返回
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
{	// 增加一个校验，pBuffer的第一个unsigned short里面保存的就是实际Buffer的大小，要和参数传过来的大小比较，前者必须小于等于后者。
	//int nRealSize = pBuffer[0]+(pBuffer[1]<<8);
	// 2009-12-25 Fixed by  这个校验取出来的大小不对，还是直接强制转换过来吧
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
{	// 增加一个校验，pBuffer的第一个unsigned short里面保存的就是实际Buffer的大小，要和参数传过来的大小比较，前者必须小于等于后者。
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

// 还剩余多少空间，建立在当前固定空间的基础上，如以后改为动态空间，建议弄一个离标准大小还差多大的函数
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
	// 判一下吧，不允许重复调用此方法，以免破坏数据
	if( m_nNowSite == nMsgBeginPos )
		return;

	// 操纵器，
	// 注意1：末尾有一个4字节（固定）的保留（以后用来防止非法包）
	// 注意2：然后紧随一个长度的反码( unsigned short )
	//m_nNowSite += 4;
	unsigned short wSite = ( unsigned short )(~( m_nNowSite + sizeof( unsigned short ) ) );
	memcpy( m_pBuffer + m_nNowSite, &wSite, sizeof( unsigned short ) );
	m_nNowSite += ( sizeof( unsigned short ) );
	* ( unsigned short* )m_pBuffer = m_nNowSite;

	m_nMaxSite = m_nNowSite;
	m_nBufSize = 0;

	ResetPos();	// 把标志位设定为一开始，准备别人阅读它。
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
// 获取当前位置到结尾之间的数据的大小
int SNetStream::GetSizeofCurToEnd(){ return m_nMaxSite - m_nNowSite; }
// 不移动位置，不改变数据，查看消息流中的命令字A和B
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
// 根据头获取消息长度
int SNetStream::GetMsgLenByHead()
{
	unsigned short wLen = (* ( unsigned short* )(m_pBuffer));
	int nLen = int(wLen);
	return nLen;
}
// 根据尾反码获取消息长度
int SNetStream::GetMsgLenByTail()
{
	unsigned short wLen = ~(* ( unsigned short* )(m_pBuffer+m_nMaxSite-sizeof(unsigned short)));
	int nLen = int(wLen);
	return nLen;
}

//// 对组装好的消息包，设置其消息计数
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
	// 2010-10-08 :将具体操作放到End方法里，并在内部加了防止重复调用结束的判断
	msg.End();
	return msg;
}