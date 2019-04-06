/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org
 Copyright (c) Microsoft Open Technologies, Inc.

 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#ifndef __MyAssetsManager__
#define __MyAssetsManager__

#include "cocos2d.h"
#include "ExtensionMacros.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WINRT) && (CC_TARGET_PLATFORM != CC_PLATFORM_WP8)
#include <string>
#include <curl/curl.h>
#include <pthread.h>

class MyAssetsManagerDelegateProtocol;

/*
 *  This class is used to auto update resources, such as pictures or scripts.
 *  The updated package should be a zip file. And there should be a file named
 *  version in the server, which contains version code.
 *  @js NA
 *  @lua NA
 */
class MyAssetsManager
{
public:
	enum MYUpdateRetrun
	{
		eHasVersion,
		eNoVersion,
		eHasError
	};
    enum MYErrorCode
    {
        // Error caused by creating a file to store downloaded data
        kCreateFile,
        /** Error caused by network
         -- network unavaivable
         -- timeout
         -- ...
         */
        kNetwork,
        /** There is not a new version
         */
        kNoNewVersion,
        /** Error caused in uncompressing stage
         -- can not open zip file
         -- can not read file global information
         -- can not read file information
         -- can not create a directory
         -- ...
         */
        kUncompress,
    };
    
    /* @brief Creates a AssetsManager with new package url, version code url and storage path.
     *
     * @param packageUrl URL of new package, the package should be a zip file.
     * @param versionFileUrl URL of version file. It should contain version code of new package.
     * @param storagePath The path to store downloaded resources.
     */
    MyAssetsManager();
    
    virtual ~MyAssetsManager();
    
    /* @brief Check out if there is a new version resource.
     *        You may use this method before updating, then let user determine whether
     *        he wants to update resources.
     */
    virtual MYUpdateRetrun checkUpdate();
    
    /* @brief Download new package if there is a new version, and uncompress downloaded zip file.
     *        Ofcourse it will set search path that stores downloaded files.
     */
    virtual void update();
    
    /* @brief Gets url of package.
     */
    const char* getPackageUrl() const;
    
    /* @brief Sets package url.
     */
    void setPackageUrl(const char* packageUrl);
    
    /* @brief Gets version file url.
     */
    const char* getVersionFileUrl() const;
    
    /* @brief Gets version file url.
     */
    void setVersionFileUrl(const char* versionFileUrl);
    
    /* @brief Gets current version code.
     */
    std::string getVersion();
    
    /* @brief Deletes recorded version code.
     */
    void deleteVersion();
    
    /* @brief Gets storage path.
     */
    const char* getStoragePath() const;
    /* @brief Gets all need download version code.
     */
	std::string getAllUpdatVerCode(const char* url);
    /* @brief Sets storage path.
     *
     * @param storagePath The path to store downloaded resources.
     * @warm The path should be a valid path.
     */
    void setStoragePath(const char* storagePath);
    
    /** @brief Sets delegate, the delegate will receive messages
     */
    void setDelegate(MyAssetsManagerDelegateProtocol *delegate);
    
    /** @brief Sets connection time out in seconds
     */
    void setConnectionTimeout(unsigned int timeout);
    
    /** @brief Gets connection time out in secondes
     */
    unsigned int getConnectionTimeout();
    
    /* downloadAndUncompress is the entry of a new thread 
     */
    friend void* assetsManagerDownloadAndUncompress(void*);
    friend int assetsManagerProgressFunc(void *, double, double, double, double);

	bool uncompress();

    bool downLoad();
    bool createDirectory(const char *path);
    void setSearchPath();
    void sendErrorMessage(MYErrorCode code);
    
    typedef struct My_Message
    {
    public:
        My_Message() : what(0), obj(NULL){}
        unsigned int what; // message type
        void* obj;
    } MyMessage;

	class MyHelper : public cocos2d::CCObject
	{
	public:
		MyHelper();
		~MyHelper();

		virtual void update(float dt);
		void sendMessage(MyMessage *msg);

		void handleUpdateSucceed(MyMessage *msg);

		std::list<MyMessage*> *_messageQueue;
		pthread_mutex_t _messageQueueMutex;
	};
    
    //! The path to store downloaded resources.
    std::string _storagePath;
    
    //! The version of downloaded resources.
    std::string _version;
    
    std::string _packageUrl;
    std::string _versionFileUrl;
    
    CURL *_curl;
    MyHelper *_schedule;
    pthread_t *_tid;
    unsigned int _connectionTimeout;
    
    MyAssetsManagerDelegateProtocol *_delegate; // weak reference
};

class MyAssetsManagerDelegateProtocol
{
public:
    /* @brief Call back function for error
       @param errorCode Type of error
     */
    virtual void onError(MyAssetsManager::MYErrorCode errorCode) {};
    /** @brief Call back function for recording downloading percent
        @param percent How much percent downloaded
        @warn This call back function just for recording downloading percent.
              AssetsManager will do some other thing after downloading, you should
              write code in onSuccess() after downloading. 
     */
    virtual void onProgress(int percent) {};
    /** @brief Call back function for success
     */
    virtual void onSuccess() {};
};

#endif // CC_TARGET_PLATFORM != CC_PLATFORM_WINRT
#endif /* defined(__AssetsManager__) */
