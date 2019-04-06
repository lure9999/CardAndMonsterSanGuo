// add by sxin 
//文件名称：	Socket.h
//功能描述：	封装网络Socket的功能，通过接口实现所有的网络操作
//				
//

#if defined (__WINDOWS__) || defined (WIN32)
#include <process.h>
#else
#include <errno.h>
//#include <sys/signal.h>
#include <pthread.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <arpa/inet.h>
#define Sleep(x) usleep(x*1000)

#include <sys/stat.h>	// for open()
#include <unistd.h>		// for fcntl()
#include <sys/ioctl.h>	// for ioctl()

#endif

#include "BaseType.h"
#pragma once
class CNetSocket
{
public:
	CNetSocket(void);
	CNetSocket(const char* host, int port);
	~CNetSocket(void);

	bool create() ;

	// close connection
	void close () ;

	// try connect to remote host
	bool connect () ;
	bool connect (const char* host, unsigned int port) ;

	// close previous connection and connect to another socket
	bool reconnect (const char* host, unsigned int port) ;

	// send data to peer
	int send (const void* buf, unsigned int len, unsigned int flags = 0) ;

	// receive data from peer
	int receive (void* buf, unsigned int len, unsigned int flags = 0) ;

	unsigned int available ()const ;

	int accept( struct sockaddr* addr, unsigned int* addrlen ) ;

	bool bind( ) ;
	bool bind( unsigned int port ) ;

	bool listen( int backlog ) ;

	//////////////////////////////////////////////////
	// methods
	//////////////////////////////////////////////////
public :

	// get/set socket's linger status
	bool getLinger ()const ;
	bool setLinger (int lingertime) ;

	bool isReuseAddr ()const ;
	bool setReuseAddr (bool on = true) ;

	// get is Error
	bool getSockError()const ;

	// get/set socket's nonblocking status
	bool isNonBlocking ()const ;
	bool setNonBlocking (bool on = true) ;

	// get/set receive buffer size
	unsigned int getReceiveBufferSize ()const ;
	bool setReceiveBufferSize (int size) ;

	// get/set send buffer size
	int getSendBufferSize ()const ;
	bool setSendBufferSize (int size) ;

	int getPort ()const ;
	IP_t getHostIP ()const ;

	// check if socket is valid
	bool isValid ()const ;

	// get socket descriptor
	int getSOCKET ()const ;

	bool isSockError()const ;

	//add by sxin 
	int GetSockErrorID()const ;

	char* GetSockErrorDes(int iErrid)const ;

public :

	int m_SocketID;

	// socket address structure
	struct sockaddr_in m_SockAddr;

	// peer host
	char m_Host[IP_SIZE];

	// peer port
	int m_Port;

	bool m_bNonBlocking;
};

