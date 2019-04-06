#pragma once

template< int size >
class CBuffer
{
public:
	//CBuffer(const CBuffer& rSrc);
	//void operator=(const CBuffer& rSrc);
	CBuffer( );
	~CBuffer( );

	// 获取缓冲区的总容量
	int GetCapacity( );

	// 获取有效缓冲区长度
	int GetLength( );

	// 获取剩余的buffer首址
	char* GetIdleBuffer( );

	// 获取剩余的buffer长度
	int GetIdleLength( );

	// 向缓冲区中增加一段内容，若增加后缓冲区将越界，则撤销增加并返回失败
	bool AddBuffer( char const* buf, int nSize );

	// 增加缓冲区中内容的长度
	bool AddBuffer( int nSize );

	// 获取缓冲区头的地址
	char* GetBuffer( );

	// 释放从缓冲区开始到指定长度的内容空间
	void ReleaseBuffer( int nLength );

	// 整理缓冲（会根据当前的状态来判断是否实行memcpy）
	bool TrimBuffer( );

	// 重置缓冲（不管当前的状态直接实行memcpy）
	bool ResetBuffer( );

	// 恢复初始状态
	void Clear( );

private:
	int m_nLength;		// 当前有效缓冲长度
	int m_nCurPos;		// 当前缓冲长度
	char m_buf[size];	// 缓冲
};

template< int size >
CBuffer<size>::
	CBuffer( )
{
	Clear( );
}

template< int size >
CBuffer<size>::
	~CBuffer( )
{
	m_nLength = 0;
	m_nCurPos = 0;
}

template< int size >
int CBuffer<size>::
	GetCapacity( )
{ 
	return size; 
}

template< int size >
int CBuffer<size>::
	GetLength( )
{ 
	return m_nLength;
}

template< int size >
char* CBuffer<size>::
	GetIdleBuffer( )
{ 
	//printf("0000000000000000000GetIdleBuffer0000000000000000000000\n");
	//printf("m_nCurPos = (%d)\n", m_nCurPos);
	//printf("m_nLength = (%d)\n", m_nLength);
	//printf("buffer -- = (%08x)\n", m_buf);
	//printf("000000000000000000GetIdleBuffer00000000000000000000000\n");
	return m_buf + m_nCurPos + m_nLength;
}

template< int size >
int CBuffer<size>::
	GetIdleLength( )
{ 
	//printf("[[[[[[[[[[[[[[[[GetIdleLength[[[[[[[[[[[[[[[[[[[[[[[[\n");
	//printf("size =      (%d)\n", size);
	//printf("m_nLength = (%d)\n", m_nLength);
	//printf("m_nCurPos = (%d)\n", m_nCurPos);
	//printf("]]]]]]]]]]]]]]]]]GetIdleLength]]]]]]]]]]]]]]]]]]]]]]]\n");
	return size - ( m_nLength + m_nCurPos );
}

template< int size >
bool CBuffer<size>::
	AddBuffer( char const* buf, int nSize )
{
	if ( ( m_nCurPos + m_nLength + nSize ) > size )
	{
		return false;
	}

	memcpy( ( m_buf + m_nLength + m_nCurPos ), buf, nSize );
	m_nLength += nSize;
	return true;
}

template< int size >
bool CBuffer<size>::
	AddBuffer( int nSize )
{
	if ( ( m_nCurPos + m_nLength + nSize ) > size )
	{
		return false;
	}
	m_nLength += nSize;
	return true;
}

template< int size >
char* CBuffer<size>::
	GetBuffer( )
{ 
	return ( m_buf + m_nCurPos );
}

template< int size >
void CBuffer<size>::
	ReleaseBuffer( int nLength )
{
	if ( nLength < 0 || nLength >= m_nLength )
	{
		m_nLength = 0;
		m_nCurPos = 0;
		//printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
		//printf("m_nCurPos = (%d)\n", m_nCurPos);
		//printf("m_nLength = (%d)\n", m_nLength);
		//printf("buffer = (%08x)\n", m_buf + m_nCurPos);
		//printf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
	}
	else
	{
		// 2010-03-09  注：旧版本中为了省掉一次内存拷贝，m_nCurPos = nLength;这句太不细心了，完全错误了。而且上面的IF里应该清零m_nCurPos
		m_nCurPos += nLength;
		m_nLength -= nLength;

		//printf("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
		//printf("m_nCurPos = (%d)\n", m_nCurPos);
		//printf("m_nLength = (%s)\n", m_nLength);
		//printf("buffer = (%s)\n", m_buf + m_nCurPos);
		//printf("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");

		// 下面是以前的旧版本
		/*
		m_nCurPos = nLength;
		m_nLength -= nLength;
		// memcpy( m_buf, m_buf + nLength, m_nLength );
		*/
	}
}

template< int size >
bool CBuffer<size>::
	TrimBuffer( )
{
	if ( m_nLength + m_nCurPos > size )
	{
		// 表示是因为缓冲根本无法处理，不够大小
		return false;
	}

	if ( m_nLength + m_nCurPos == size )
	{
		// 这个时候才需要进行一次memcpy，将没有处理完的数据
		// 拷贝到缓冲的最前端，从而进行一次环行的操作
		memcpy( m_buf, m_buf + m_nCurPos, m_nLength );
		m_nCurPos = 0;
	}
	return true;
}

template< int size >
bool CBuffer<size>::
	ResetBuffer( )
{
	if ( m_nCurPos != 0 )
	{
		memmove( m_buf, m_buf + m_nCurPos, m_nLength );
		m_nCurPos = 0;
		return true;
	}
	return false;
}

template< int size >
void CBuffer<size>::
	Clear( )
{
	m_nLength = 0;
	m_nCurPos = 0;
	memset( m_buf, 0, size*sizeof(m_buf[0]) );
}

