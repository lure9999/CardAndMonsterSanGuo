#ifndef __OBJPOOL_H__
#define __OBJPOOL_H__


#include "BaseType.h"
#ifndef	WIN32
#include <pthread.h>
#include <list>
#include <string.h>
#endif	// __WINDOWS__ || WIN32

#ifndef SAFE_DELETE
#define SAFE_DELETE(p)			{ if((p)!=NULL)delete (p),(p)=NULL; }
#endif

//
// ����أ���������Ԥ�����õĶ���
// �Ӷ��ﵽ���ÿռ任ȡʱ���Ŀ��
// ����ʱ���ϵ������ؿ��ܲ������Ż���
// ����û�й�ϵ���Ժ���ʱ���һὫ������
//
// 	CObjPool< CTest, TRUE > pool;
//	pool.Init( 100, 30 );
//
// Sep 04th, 2006	EL.AHong.F	Create
// Nov 06th, 2006	EL.AHong.F	Modify 
// Dec 09th, 2009	joey		Modify
//
// 2010-03-12  Add GetTotalCount()
// Jun 03th, 2011	joey		���������ڴ湦��

#define LD_POOL_NEW(pool) (pool).New( )

template< class T, bool THREAD_SAFE >
class CObjPool
{
public:
	CObjPool();
	virtual ~CObjPool();
	T* New( );
	void Delete( T* p );

	bool Init( int nSize, int nGrow );
	void UnInit( );

	// ���������ڴ�
	void CleanExcrescentMemory();

	int GetUsedCount( void )const;

	int InitMutex();

	// 2010-03-12  ע�����������ʹ�õĽڵ�������������һ���֪�������Ѿ�������ڴ�Ľڵ�����
	int GetTotalCount( void )const;

private:
	void AppendNode( int nSize );

private:
	typedef std::list< T* >		ObjList;
	typedef std::list< unsigned char* >	MemList;
	ObjList				m_listNodePool;		// �ڴ�ؽڵ�����
	MemList				m_listRawMem;		// ��ʵ�ڴ�����
#if defined(__WINDOWS__) || defined(WIN32)
	CRITICAL_SECTION	allocator_lock;		// ������
#else
	pthread_mutex_t		m_Pmutex;			// ������;
#endif	// __WINDOWS__ || WIN32
	int					m_nGrow;			// ����ϵ��
	//int					m_nTotalAlloc;		// �������
	int					m_nNodeCount;		// �ڵ�����

	bool				m_bInit;			// �Ƿ��Ѿ���ʼ����
#if defined(__WINDOWS__) || defined(WIN32)
	#define __NODE_ALLOC_INIT		InitializeCriticalSection( &allocator_lock )
	#define __NODE_ALLOC_LOCK		EnterCriticalSection( &allocator_lock )
	#define __NODE_ALLOC_UNLOCK		LeaveCriticalSection( &allocator_lock )
	#define __NODE_ALLOC_UNINIT		DeleteCriticalSection( &allocator_lock )
	#define __VOLATILE				volatile
#else
	#define __NODE_ALLOC_INIT		pthread_mutex_init(&m_Pmutex, NULL)
	#define __NODE_ALLOC_LOCK		pthread_mutex_lock(&m_Pmutex)
	#define __NODE_ALLOC_UNLOCK		pthread_mutex_unlock(&m_Pmutex)
	#define __NODE_ALLOC_UNINIT		pthread_mutex_destroy(&m_Pmutex)
#endif	// __WINDOWS__ || WIN32
};

template< class T, bool THREAD_SAFE >
CObjPool< T, THREAD_SAFE >::CObjPool()
{
	m_nGrow = 1;			// ����ϵ��
	//m_nTotalAlloc = 0;		// �������
	m_nNodeCount = 0;		// �ڵ�����

	m_bInit = FALSE;			// �Ƿ��Ѿ���ʼ����
}

template< class T, bool THREAD_SAFE >
CObjPool< T, THREAD_SAFE >::~CObjPool()
{
	UnInit();
}

template< class T, bool THREAD_SAFE >
bool CObjPool< T, THREAD_SAFE >::Init( int nSize, int nGrow )
{
	__NODE_ALLOC_INIT;
	if( THREAD_SAFE )
		__NODE_ALLOC_LOCK;

	m_nNodeCount = 0;
	m_nGrow = nGrow;
	AppendNode( nSize );
	m_bInit = TRUE;

	if( THREAD_SAFE )
		__NODE_ALLOC_UNLOCK;
	return TRUE;
}

template< class T, bool THREAD_SAFE >
void CObjPool< T, THREAD_SAFE >::AppendNode( int nSize )
{
	int nTotalSize = nSize * sizeof( T );
	unsigned char* pMem = new unsigned char[ nTotalSize ];
	memset( pMem, 0, nTotalSize );
	m_nNodeCount += nSize;

	for ( int i=0;i<nSize;++i )
	{
		T* pPointer = ( ( T* )pMem ) + i;
		m_listNodePool.push_back( pPointer );
	}
	
	m_listRawMem.push_back( pMem );
}

template< class T, bool THREAD_SAFE >
void CObjPool< T, THREAD_SAFE >::UnInit( )
{
	for ( MemList::iterator itePos = m_listRawMem.begin( );
		itePos != m_listRawMem.end( ); ++itePos )
	{
		char* pPointer = ( char* )( *itePos );
		SAFE_DELETE( pPointer );
	}
	if( m_bInit )
	{
		m_listNodePool.clear();
		m_listRawMem.clear();
		__NODE_ALLOC_UNINIT;
		m_bInit = FALSE;
	}
}

template< class T, bool THREAD_SAFE >
T* CObjPool< T, THREAD_SAFE >::New( )
{
	if( THREAD_SAFE )
		__NODE_ALLOC_LOCK;

	if ( m_listNodePool.empty( ) )
	{
		AppendNode( m_nGrow );
	}
	T* p = m_listNodePool.front( );
	m_listNodePool.pop_front( );

	if( THREAD_SAFE )
		__NODE_ALLOC_UNLOCK;
	
	new (p) T;
	return p;
}

template< class T, bool THREAD_SAFE >
void CObjPool< T, THREAD_SAFE >::Delete( T* p )
{
	if ( p )
	{
		if( THREAD_SAFE )
			__NODE_ALLOC_LOCK;

		p->~T( );
		m_listNodePool.push_back( p );
	
		if( THREAD_SAFE )
			__NODE_ALLOC_UNLOCK;
	}
}

// ���������ڴ�
template< class T, bool THREAD_SAFE >
void CObjPool< T, THREAD_SAFE >::CleanExcrescentMemory()
{
	if( THREAD_SAFE )
		__NODE_ALLOC_LOCK;

	MemList::iterator itePos = m_listRawMem.begin( );
	++itePos;
	for ( ;	itePos != m_listRawMem.end( ); )
	{
		unsigned char* pMem = *itePos;

		// �ڶ���������в��ұ��ڴ����û�б�ʹ�ã����ҵ���û��ʹ�õĶ���ڵ�������ʱ����
		ObjList tmpList;
		bool bUsed = false;
		for ( int i=0; i<m_nGrow; ++i )
		{
			T* pPointer = ( ( T* )pMem ) + i;
			typename ObjList::iterator iter = find( m_listNodePool.begin(), m_listNodePool.end(), pPointer );
			if ( iter==m_listNodePool.end() )
			{
				bUsed = true;
			}
			else
			{
				tmpList.push_back(pPointer);
				m_listNodePool.erase(iter);
			}
		}
		
		if ( bUsed )
		{
			m_listNodePool.splice( m_listNodePool.end(), tmpList );
			++itePos;
		}
		else
		{
			// ������ڴ��û�б�ʹ�ã���ȫ��ʩ�ŵ�
			itePos = m_listRawMem.erase(itePos);
			m_nNodeCount -= tmpList.size();
			tmpList.clear();
			SAFE_DELETE(pMem);
		}
	}

	if( THREAD_SAFE )
		__NODE_ALLOC_UNLOCK;
}

template< class T, bool THREAD_SAFE >
int CObjPool< T, THREAD_SAFE >::GetUsedCount( void ) const
{
	return m_nNodeCount - (int)m_listNodePool.size();
}

template< class T, bool THREAD_SAFE >
int CObjPool< T, THREAD_SAFE >::GetTotalCount( void ) const
{
	return m_nNodeCount;
}

#endif	// __OBJPOOL_H__
