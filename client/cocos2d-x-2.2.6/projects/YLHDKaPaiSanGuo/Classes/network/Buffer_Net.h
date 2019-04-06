#pragma once

template< int size >
class CBuffer
{
public:
	//CBuffer(const CBuffer& rSrc);
	//void operator=(const CBuffer& rSrc);
	CBuffer( );
	~CBuffer( );

	// ��ȡ��������������
	int GetCapacity( );

	// ��ȡ��Ч����������
	int GetLength( );

	// ��ȡʣ���buffer��ַ
	char* GetIdleBuffer( );

	// ��ȡʣ���buffer����
	int GetIdleLength( );

	// �򻺳���������һ�����ݣ������Ӻ󻺳�����Խ�磬�������Ӳ�����ʧ��
	bool AddBuffer( char const* buf, int nSize );

	// ���ӻ����������ݵĳ���
	bool AddBuffer( int nSize );

	// ��ȡ������ͷ�ĵ�ַ
	char* GetBuffer( );

	// �ͷŴӻ�������ʼ��ָ�����ȵ����ݿռ�
	void ReleaseBuffer( int nLength );

	// �����壨����ݵ�ǰ��״̬���ж��Ƿ�ʵ��memcpy��
	bool TrimBuffer( );

	// ���û��壨���ܵ�ǰ��״ֱ̬��ʵ��memcpy��
	bool ResetBuffer( );

	// �ָ���ʼ״̬
	void Clear( );

private:
	int m_nLength;		// ��ǰ��Ч���峤��
	int m_nCurPos;		// ��ǰ���峤��
	char m_buf[size];	// ����
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
		// 2010-03-09  ע���ɰ汾��Ϊ��ʡ��һ���ڴ濽����m_nCurPos = nLength;���̫��ϸ���ˣ���ȫ�����ˡ����������IF��Ӧ������m_nCurPos
		m_nCurPos += nLength;
		m_nLength -= nLength;

		//printf("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
		//printf("m_nCurPos = (%d)\n", m_nCurPos);
		//printf("m_nLength = (%s)\n", m_nLength);
		//printf("buffer = (%s)\n", m_buf + m_nCurPos);
		//printf("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");

		// ��������ǰ�ľɰ汾
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
		// ��ʾ����Ϊ��������޷�����������С
		return false;
	}

	if ( m_nLength + m_nCurPos == size )
	{
		// ���ʱ�����Ҫ����һ��memcpy����û�д����������
		// �������������ǰ�ˣ��Ӷ�����һ�λ��еĲ���
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

