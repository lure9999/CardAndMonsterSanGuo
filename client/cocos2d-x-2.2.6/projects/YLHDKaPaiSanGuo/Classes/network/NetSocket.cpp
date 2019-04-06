#include "NetSocket.h"


CNetSocket::CNetSocket(void)
{
	m_SocketID = INVALID_ID;
	memset( &m_SockAddr, 0, sizeof(sockaddr_in) ) ;
	memset( m_Host, 0, IP_SIZE ) ;
	m_Port = 0 ;
	m_bNonBlocking = true;
}

CNetSocket::CNetSocket(const char* host, int port)
{
	strncpy( m_Host, host, IP_SIZE-1 ) ;
	m_Port = port ;

	create() ;	
}

CNetSocket::~CNetSocket(void)
{
	close() ;
}

bool CNetSocket::create()
{

	m_SocketID = socket(AF_INET, SOCK_STREAM, 0);
	//m_SocketID = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

	memset( &m_SockAddr , 0 , sizeof(m_SockAddr) );

	m_SockAddr.sin_family = AF_INET;

	if( isValid() )
		return true ;
	else 
		return false ;


	return false ;
}

// close connection
void CNetSocket::close ()
{
	
	if( isValid() && !isSockError() ) 
	{
#if defined (__WINDOWS__) || defined (WIN32)
		
		closesocket(m_SocketID);
#else
		::close(m_SocketID);
#endif		
		
	}

	m_SocketID = INVALID_ID ;
	memset( &m_SockAddr, 0, sizeof(sockaddr_in ) ) ;
	memset( m_Host, 0, IP_SIZE ) ;
	m_Port = 0 ;
}

// try connect to remote host
bool CNetSocket::connect () 
{
	m_SockAddr.sin_addr.s_addr = inet_addr( m_Host );

	// set sockaddr's port
	m_SockAddr.sin_port = htons(m_Port);

	// try to connect to peer host
	int result = ::connect(m_SocketID, (const struct sockaddr *)&m_SockAddr , sizeof(m_SockAddr));
	
	if (isNonBlocking() == true)
	{
		if( result == -1)
			return true ;
		else
			return false ;
	}
	else
	{
		if (result == 0)
		{
			return true ;
		}
		else
		{
			return false ;
		}
	}	
	
	return false ;
}

bool CNetSocket::connect (const char* host, unsigned int port) 
{
	strncpy( m_Host, host, IP_SIZE-1 ) ;
	m_Port = port ;

	return connect() ;
}

// close previous connection and connect to another socket
bool CNetSocket::reconnect (const char* host, unsigned int port) 
{
	// delete old socket impl object
	close();

	// create new socket impl object
	strncpy( m_Host, host, IP_SIZE-1 ) ;
	m_Port = port ;

	create() ;

	// try to connect
	return connect();	
}

// send data to peer
int CNetSocket::send (const void* buf, unsigned int len, unsigned int flags ) 
{
	int nSendLen = 0;
#if defined (__WINDOWS__) || defined (WIN32)	
	nSendLen = ::send(m_SocketID,(const char *)buf,len,flags); 
#else
	nSendLen = ::send(m_SocketID,buf,len,flags);
#endif

	return nSendLen;
}

// receive data from peer
int CNetSocket::receive (void* buf, unsigned int len, unsigned int flags ) 
{
	int nrecv = 0;
#if defined (__WINDOWS__) || defined (WIN32)	
	nrecv = ::recv(m_SocketID,(char*)buf,len,flags);
#else
	nrecv = ::recv(m_SocketID,buf,len,flags);
#endif

	return nrecv;
}

unsigned int CNetSocket::available ()const 
{

#if defined (__WINDOWS__) || defined (WIN32)
	ULONG argp = 0;
	::ioctlsocket(m_SocketID,FIONREAD,&argp);
	return argp;
#else
	unsigned int arg = 0;
	ioctl(m_SocketID,FIONREAD,&arg);
	return arg;
#endif

	return 0;
}

int CNetSocket::accept( struct sockaddr* addr, unsigned int* addrlen ) 
{
	
#if defined (__WINDOWS__) || defined (WIN32)	
	int client = ::accept( m_SocketID , addr , (int*)addrlen );
#else
	int client = ::accept( m_SocketID , addr , (socklen_t*)addrlen );
#endif
	
	return client ;
}

bool CNetSocket::bind( ) 
{
	m_SockAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	m_SockAddr.sin_port        = htons(m_Port);

	int result = ::bind( m_SocketID , (const struct sockaddr *)&m_SockAddr , sizeof(m_SockAddr) ) ;
	if( result )
		return true ;
	else
		return false ;
}

bool CNetSocket::bind( unsigned int port ) 
{
	m_Port = port ;

	return bind();
}

bool CNetSocket::listen( int backlog ) 
{
	return ::listen( m_SocketID , backlog );
}



// get/set socket's linger status
bool CNetSocket::getLinger ()const 
{
	struct linger ling;
	unsigned int len = sizeof(ling);

#if defined (__WINDOWS__) || defined (WIN32)	
	getsockopt( m_SocketID , SOL_SOCKET , SO_LINGER , (char*)&ling , (int*) &len );
#else
	getsockopt(  m_SocketID , SOL_SOCKET , SO_LINGER , (char*)&ling , (socklen_t*)&len );
#endif

	return ling.l_linger;
}

bool CNetSocket::setLinger (int lingertime) 
{
	struct linger ling;

	ling.l_onoff = lingertime > 0 ? 1 : 0;
	ling.l_linger = lingertime;

	int iRest = -1;
#if defined (__WINDOWS__) || defined (WIN32)	
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_LINGER , (char*)&ling , sizeof(ling) );
#else
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_LINGER , &ling , sizeof(ling) );
#endif
				
	return (iRest > 0);
}

bool CNetSocket::isReuseAddr ()const 
{
	int reuse;
	unsigned int len = sizeof(reuse);

#if defined (__WINDOWS__) || defined (WIN32)
	getsockopt( m_SocketID , SOL_SOCKET , SO_REUSEADDR , (char*) &reuse , (int*)&len );
#else
	getsockopt(m_SocketID , SOL_SOCKET , SO_REUSEADDR , &reuse , (socklen_t*)&len  );
#endif

	return reuse == 1;
}

bool CNetSocket::setReuseAddr (bool on ) 
{
	int opt = on == true ? 1 : 0;
	int iRest = -1;
#if defined (__WINDOWS__) || defined (WIN32)	
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_REUSEADDR , (char*) &opt , sizeof(opt) );
#else
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_REUSEADDR , &opt , sizeof(opt) );
#endif

	return (iRest > 0);	
}

// get is Error
bool CNetSocket::getSockError()const 
{
	return isSockError(); 
}

// get/set socket's nonblocking status
bool CNetSocket::isNonBlocking ()const 
{
	return m_bNonBlocking ;

//#if defined (__WINDOWS__) || defined (WIN32)
//	return m_bNonBlocking ;
//#else
//	int flags = fcntl ( m_SocketID , F_GETFL , 0 );
//	flags = flags & O_NONBLOCK;
//
//	if (flags != 0)
//	{
//		return true;
//	}
//	else
//	{
//		return false;
//	}
//	
//#endif	
}

bool CNetSocket::setNonBlocking (bool on ) 
{
	m_bNonBlocking = on;

#if defined (__WINDOWS__) || defined (WIN32)
	ULONG argp = ( on == true ) ? 1 : 0;	
	return ioctlsocket( m_SocketID,FIONBIO,&argp);
#else	
	int flags = fcntl( m_SocketID , F_GETFL , 0 );
	if ( on )
		// make nonblocking fd
		flags |= O_NONBLOCK;
	else
		// make blocking fd
		flags &= ~O_NONBLOCK;
	fcntl( m_SocketID , F_SETFL , flags );
	return true;
#endif
	
}

// get/set receive buffer size
unsigned int CNetSocket::getReceiveBufferSize ()const 
{
	unsigned int ReceiveBufferSize;
	unsigned int size = sizeof(ReceiveBufferSize);

#if defined (__WINDOWS__) || defined (WIN32)
	getsockopt( m_SocketID , SOL_SOCKET , SO_RCVBUF , (char*)&ReceiveBufferSize , (int*)&size );
#else
	getsockopt( m_SocketID , SOL_SOCKET , SO_RCVBUF , &ReceiveBufferSize, (socklen_t*)&size );
#endif

	return ReceiveBufferSize;
}

bool CNetSocket::setReceiveBufferSize (int size) 
{
	int iRest = -1;
#if defined (__WINDOWS__) || defined (WIN32)
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_RCVBUF , (char*) &size , sizeof(unsigned int) );
#else
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_RCVBUF , &size, sizeof(unsigned int)  );
#endif
	
	return (iRest > 0) ;
}

// get/set send buffer size
int CNetSocket::getSendBufferSize ()const 
{
	unsigned int SendBufferSize;
	unsigned int size = sizeof(SendBufferSize);

#if defined (__WINDOWS__) || defined (WIN32)
	getsockopt( m_SocketID , SOL_SOCKET , SO_SNDBUF , (char*)&SendBufferSize , (int*)&size );
#else
	getsockopt( m_SocketID , SOL_SOCKET , SO_SNDBUF , &SendBufferSize, (socklen_t*)&size );
#endif
	
	return SendBufferSize;
}

bool CNetSocket::setSendBufferSize (int size) 
{
	int iRest = -1;
#if defined (__WINDOWS__) || defined (WIN32)	
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_SNDBUF , (char*) &size , sizeof(unsigned int) );
#else
	iRest = setsockopt( m_SocketID , SOL_SOCKET , SO_SNDBUF , &size, sizeof(unsigned int)  );
#endif

	return (iRest > 0) ;
}

int CNetSocket::getPort ()const 
{
	return m_Port; 
}

IP_t CNetSocket::getHostIP ()const 
{
	return (IP_t)(m_SockAddr.sin_addr.s_addr);
}

// check if socket is valid
bool CNetSocket::isValid ()const 
{
	return m_SocketID!=INVALID_ID;
}

// get socket descriptor
int CNetSocket::getSOCKET ()const 
{
	return m_SocketID; 
}

bool CNetSocket::isSockError()const 
{
	int error;
	unsigned int len = sizeof(error);
	int Result = 0;
#if defined (__WINDOWS__) || defined (WIN32)
	Result = getsockopt( m_SocketID , SOL_SOCKET , SO_ERROR , (char*)&error , (int*)&len );
#else
	Result = getsockopt( m_SocketID , SOL_SOCKET , SO_ERROR , &error, (socklen_t*)&len );
#endif	

	if( Result != -1 ) 
		return false;
	else 			  
		return true;
}

int CNetSocket::GetSockErrorID()const 
{
#if defined (__WINDOWS__) || defined (WIN32)
	int iErr = WSAGetLastError() ;
	return iErr;
#else
	return errno;
#endif
}
#define _ESIZE 256
char* CNetSocket::GetSockErrorDes(int iErrid)const 
{
	char ErrorDes[_ESIZE];
	memset(ErrorDes,0,_ESIZE);

#if defined (__WINDOWS__) || defined (WIN32)
	switch ( iErrid ) 
	{
	case WSANOTINITIALISED : 
		strncpy( ErrorDes, "WSANOTINITIALISED", _ESIZE ) ;
		break ;
	case WSAENETDOWN : 
		strncpy( ErrorDes, "WSAENETDOWN", _ESIZE ) ;
		break ;
	case WSAEADDRINUSE : 
		strncpy( ErrorDes, "WSAEADDRINUSE", _ESIZE ) ;
		break ;
	case WSAEINTR : 
		strncpy( ErrorDes, "WSAEINTR", _ESIZE ) ;
		break ;
	case WSAEINPROGRESS : 
		strncpy( ErrorDes, "WSAEINPROGRESS", _ESIZE ) ;
		break ;
	case WSAEALREADY : 
		strncpy( ErrorDes, "WSAEALREADY", _ESIZE ) ;
		break ;
	case WSAEADDRNOTAVAIL : 
		strncpy( ErrorDes, "WSAEADDRNOTAVAIL", _ESIZE ) ;
		break ;
	case WSAEAFNOSUPPORT : 
		strncpy( ErrorDes, "WSAEAFNOSUPPORT", _ESIZE ) ;
		break ;
	case WSAECONNREFUSED : 
		strncpy( ErrorDes, "WSAECONNREFUSED", _ESIZE ) ;
		break ;
	case WSAEFAULT : 
		strncpy( ErrorDes, "WSAEFAULT", _ESIZE ) ;
		break ;
	case WSAEINVAL : 
		strncpy( ErrorDes, "WSAEINVAL", _ESIZE ) ;
		break ;
	case WSAEISCONN : 
		strncpy( ErrorDes, "WSAEISCONN", _ESIZE ) ;
		break ;
	case WSAENETUNREACH : 
		strncpy( ErrorDes, "WSAENETUNREACH", _ESIZE ) ;
		break ;
	case WSAENOBUFS : 
		strncpy( ErrorDes, "WSAENOBUFS", _ESIZE ) ;
		break ;
	case WSAENOTSOCK : 
		strncpy( ErrorDes, "WSAENOTSOCK", _ESIZE ) ;
		break ;
	case WSAETIMEDOUT : 
		strncpy( ErrorDes, "WSAETIMEDOUT", _ESIZE ) ;
		break ;
	case WSAEWOULDBLOCK  : 
		strncpy( ErrorDes, "WSAEWOULDBLOCK", _ESIZE ) ;
		break ;
	default :
		{
			strncpy( ErrorDes, "UNKNOWN", _ESIZE ) ;
			break ;
		};
	};//end of switch
#else
	strncpy( ErrorDes, "Linuex UNKNOWN", _ESIZE ) ;
#endif
	return ErrorDes;
}