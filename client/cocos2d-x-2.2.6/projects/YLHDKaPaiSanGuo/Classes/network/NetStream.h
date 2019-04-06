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
// Nov.25.2009		 Modify //添加了WCHAR类型，并修改了SetMsgBuf中的校验读取长度的方法
// Nov.10.2010		-----, 增加了对无类型缓冲区的流处理函数，增加了对SNetStream指针的支持。
//[1/7/2011 zhaowenyuan]	1.operator = 操作符判断了 自赋值  2.添加了拷贝构造函数 3.添加两个流互相输入或输出的函数
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
	// 设置给定无类型缓冲区的大小，这个类作为 “>>”的参数，必须在读取char*、WCHAR *类型的数据之前使用，使用一次以后实效。
	struct buf_size
	{
		int m_nSize;
		buf_size( int nSize ) { m_nSize = nSize; }
	};

public:
	/////////////
	// 流式输入
	// 注意流式输入结尾必须要加上<<end
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
	// 流式输出
	// 注意1。为了增加效率，流输出字符串的时候并不会复制缓冲
	// 而是仅仅返回该字符串在流中的偏移。
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
	// 读写无类型缓冲区
	SNetStream& put( void *pBuffer, int nSize );
	SNetStream& get( void *pBuffer, int nSize );
	// 这里只获取指针，并没有拷贝数据，所以速度会快些。
	SNetStream& getPointer( void** ppBuffer, int nSize );
	// 这里只获取指针，并没有拷贝数据，所以速度会快些。
	SNetStream& getPtr( void** ppBuffer, int& nSize );

	/////////////
	// Nov.10.2010. -----
	// 设置读取无类型缓冲区Buffer时候，给定的指针所指向的内存空间的大小
	SNetStream& operator << ( buf_size& maxbuf );
	SNetStream& operator >> ( buf_size& maxbuf );
	// 无类型缓冲区大小必须事先经过buf_size(n)来指定，否则会出错。
	SNetStream& operator << ( void *pBuffer );
	// 无类型缓冲区大小必须事先经过buf_size(n)来指定，否则会出错。
	SNetStream& operator >> ( void *pBuffer );
	// 这里只获取指针，并没有拷贝数据，所以速度会快些。
	SNetStream& operator >> ( void **ppBuffer );

	/////////////
	// Nov.10.2010. -----
	// 把自己的结构也放进去，这样便于嵌套使用，可以一次处理多个SNetStream流
	// 注意，这里只是拷贝指针，所以要自己保存好该类的内容。所以对于跨进程是无效的，只能在本地使用
	SNetStream& operator << ( SNetStream *pStream );
	SNetStream& operator >> ( SNetStream **ppStream );
	
	//////////////
	//  [1/7/2011 zhaowenyuan]
	//	两个流可以互相输入和输出了
	SNetStream& operator << ( SNetStream& Stream );
	SNetStream& operator >> ( SNetStream& Stream );
public:
	/////////////
	SNetStream& operator = ( const SNetStream& stream );

	/////////////
	// 流的操纵器模式
	// 现在仅仅提供了两个操纵器，
	// end 表示封包结束
	// reset 表示回归缓冲起点 
	//
	typedef SNetStream& (  *manipulator )( SNetStream& );

	SNetStream& operator << ( manipulator );
	SNetStream& operator >> ( manipulator );

	/////////////
	// 由于流会自动移动动内存指针
	// 所以这里同时提供了一个C-Style取值样式
	// 这样需要多次读取的时候便可以使用，但这种方式不推荐
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
	SNetStream(const SNetStream& rhs); //拷贝构造函数
	static	int	GetMaxSize();	// 最大容量

	// 直接设置内存指针（需要保证当处理未完成时一直有效），仅在第一次构造这个消息的时候使用
	// 这里有一个校验，即pBuffer的第一个WORD里保存的就是该Buffer的大小，要和nSize比较一下，前者必须小于等于后者。否则返回FALSE
	bool SetMsgBuf( char* pBuffer, int nSize );

	// 同上函数，区别就是这里将pBuffer的内容拷贝到自己的内部结构，pBuffer就可以释放了。
	bool CopyMsgBuf( const char* pBuffer, int nSize );

	// 还剩余多少空间，建立在当前固定空间的基础上，如以后改为动态空间，建议弄一个离标准大小还差多大的函数
	int	GetRemainSize();
	int GetMsgLen( );

	// 得到stream信息
	char* GetMsgBuf( );

	// 修改和获取当前游标
	int SetMsgPos( int nPos );
	int GetMsgPos();
	// 重设当前游标为开始的位置
	void ResetPos( );
	/////////////

	// 设置结束
	void End();

	bool IsReady();

	int GetMsgLenEX();
	// 获取当前位置到结尾之间的数据的大小
	int GetSizeofCurToEnd();
	// 不移动位置，不改变数据，查看消息流中的命令字A和B
	int GetCmdA();
	int GetCmdB();

	// 根据头获取消息长度
	int GetMsgLenByHead();
	// 根据尾反码获取消息长度
	int GetMsgLenByTail();

	//// 对组装好的消息包，设置其消息计数
	//void SetMsgCounter( UINT nCount );
	//UINT GetMsgCounter();

private:
	static const int nMaxMsgBuf	= 8192 * 2;
	static const int nMsgBeginPos = 2;
	char	m_szBuffer[ nMaxMsgBuf ];	// 系统缓冲区
	char*	m_pBuffer;
	int		m_nNowSite;
	int		m_nMaxSite;
	int		m_nBufSize;		// 把无类型缓冲区进行序列化时，实现需要用buf_size(n)来设置缓冲区大小	// Nov.10.2010. -----

};


///////////////////////////////////////////////////////////////////////////////
// 操纵器
extern SNetStream&  end( SNetStream& msg );
extern SNetStream&  reset( SNetStream& msg );

#endif	// __NETSTREAM_H__

