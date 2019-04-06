/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org
 
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

#include "MyAssetsManager.h"
#include "cocos2d.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WINRT) && (CC_TARGET_PLATFORM != CC_PLATFORM_WP8)
#include <curl/curl.h>
#include <curl/easy.h>

#include <stdio.h>
#include <vector>

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#endif

#include "support/zip_support/unzip.h"

#include "sys/stat.h"

using namespace cocos2d;
using namespace std;


#define MYKEY_OF_VERSION   "current-version-code"
#define MYKEY_OF_DOWNLOADED_VERSION    "downloaded-version-code"
#define MYTEMP_PACKAGE_FILE_NAME    "cocos2dx-update-temp-package.zip"
#define MYRESDIRFILENAME    "Resources"
#define MYBUFFER_SIZE    8192
#define MYMAX_FILENAME   512

// Message type
#define MYASSETSMANAGER_MESSAGE_UPDATE_SUCCEED                0
#define MYASSETSMANAGER_MESSAGE_RECORD_DOWNLOADED_VERSION     1
#define MYASSETSMANAGER_MESSAGE_PROGRESS                      2
#define MYASSETSMANAGER_MESSAGE_ERROR                         3

// Some data struct for sending messages

struct MYErrorMessage
{
    MyAssetsManager::MYErrorCode code;
    MyAssetsManager* manager;
};

struct MYProgressMessage
{
    int percent;
    MyAssetsManager* manager;
};

// Implementation of AssetsManager

MyAssetsManager::MyAssetsManager()
: _version("")
, _curl(NULL)
, _tid(NULL)
, _connectionTimeout(0)
, _delegate(NULL)
{
    _schedule = new MyHelper();
}

MyAssetsManager::~MyAssetsManager()
{
    if (_schedule)
    {
        _schedule->release();
    }
}

static size_t getVersionCode(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    string *version = (string*)userdata;
    version->append((char*)ptr, size * nmemb);
    
    return (size * nmemb);
}

MyAssetsManager::MYUpdateRetrun MyAssetsManager::checkUpdate()
{
    if (_versionFileUrl.size() == 0) return eHasError;
    
    _curl = curl_easy_init();
    if (! _curl)
    {
        CCLOG("can not init curl");
        return eHasError;
    }
    
    // Clear _version before assign new value.
    _version.clear();
    string strTemp = "";
    CURLcode res;
	curl_easy_setopt(_curl, CURLOPT_URL, _versionFileUrl.c_str());
	//curl_easy_setopt(_curl, CURLOPT_USERPWD, "spider:spider");   
	curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 10);
    curl_easy_setopt(_curl, CURLOPT_SSL_VERIFYPEER, 0L);
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, getVersionCode);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &strTemp);
    if (_connectionTimeout) curl_easy_setopt(_curl, CURLOPT_CONNECTTIMEOUT, _connectionTimeout);
    res = curl_easy_perform(_curl);
    
    if (res != 0)
    {
        sendErrorMessage(kNetwork);
        CCLOG("can not get version file content, error code is %d", res);
        curl_easy_cleanup(_curl);
        return eHasError;
    }

	stringstream ss(strTemp);
	getline(ss,_version,'\n');
	getline(ss,_packageUrl,'\n');
	if(_version.find('\r')!=string::npos)
	{
		_version = _version.erase(_version.size()-1);
	}
	if(_packageUrl.find('\r')!=string::npos)
	{
		_packageUrl = _packageUrl.erase(_packageUrl.size()-1);
	}
	//_version = _version.erase(_version.size()-1);
    string recordedVersion = CCUserDefault::sharedUserDefault()->getStringForKey(MYKEY_OF_VERSION);
	float rVersion  = atof(recordedVersion.c_str());
	float nowVersion  = atof(_version.c_str());
  //  if (recordedVersion > _version)
	 if (rVersion >= nowVersion)
    {
        sendErrorMessage(kNoNewVersion);
        CCLOG("there is not new version");
        // Set resource search path.
		//setSearchPath();
		curl_easy_cleanup(_curl);
        return eNoVersion;
    }

	curl_easy_cleanup(_curl);
    CCLOG("there is a new version: %s", _version.c_str());
    
    return eHasVersion;
}

std::string MyAssetsManager::getAllUpdatVerCode(const char* url)
{
	if (url==NULL)
	{
		CCLOG("Url Error...");
		return "";
	}

	_curl = curl_easy_init();
	if (! _curl)
	{
		CCLOG("can not init curl");
		return "";
	}

	// Clear _version before assign new value.
	string strAllVer = "";
	CURLcode res;
	curl_easy_setopt(_curl, CURLOPT_URL, url);
	//curl_easy_setopt(_curl, CURLOPT_USERPWD, "spider:spider");   
	curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 10);
	curl_easy_setopt(_curl, CURLOPT_SSL_VERIFYPEER, 0L);
	curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, getVersionCode);
	curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &strAllVer);
	if (_connectionTimeout) curl_easy_setopt(_curl, CURLOPT_CONNECTTIMEOUT, _connectionTimeout);
	res = curl_easy_perform(_curl);

	if (res != 0)
	{
		sendErrorMessage(kNetwork);
		CCLOG("can not get version file content, error code is %d", res);
		curl_easy_cleanup(_curl);
		return "";
	}
	stringstream ssAllVer(strAllVer);
	string strVer = "";
	string strReturn = "";
	string strRecordedVer = CCUserDefault::sharedUserDefault()->getStringForKey(MYKEY_OF_VERSION);
	if(strRecordedVer.find('\r')!=string::npos)
	{
		strRecordedVer = strRecordedVer.erase(strRecordedVer.size()-1);
	}
	while (getline(ssAllVer,strVer,'\n'))
	{
		if(strVer.find('\r')!=string::npos)
		{
			strVer = strVer.erase(strVer.size()-1);
		}
		if (strVer.compare(strRecordedVer)>0)
		{
			strReturn+=strVer+"|";
		}
		//CCLOG(strVer.c_str());
	}
	//CCLOG(strReturn.c_str());
	return strReturn;
}

void* assetsManagerDownloadAndUncompress(void *data)
{
    MyAssetsManager* self = (MyAssetsManager*)data;
    
    do
    {
        if (! self->downLoad()) break;
            
         //Record downloaded version.
         MyAssetsManager::MyMessage *msg1 = new MyAssetsManager::MyMessage();
         msg1->what = MYASSETSMANAGER_MESSAGE_RECORD_DOWNLOADED_VERSION;
         msg1->obj = self;
         self->_schedule->sendMessage(msg1);
        
         //Uncompress zip file.
        if (! self->uncompress())
        {
            self->sendErrorMessage(MyAssetsManager::kUncompress);
            break;
        }
        
        // Record updated version and remove downloaded zip file
        MyAssetsManager::MyMessage *msg2 = new MyAssetsManager::MyMessage();
        msg2->what = MYASSETSMANAGER_MESSAGE_UPDATE_SUCCEED;
        msg2->obj = self;
        self->_schedule->sendMessage(msg2);
    } while (0);
    
    if (self->_tid)
    {
        delete self->_tid;
        self->_tid = NULL;
    }
    
    return NULL;
}

void MyAssetsManager::update()
{
    if (_tid) return;
    
    // 1. Urls of package and version should be valid;
    // 2. Package should be a zip file.
    if (_packageUrl.size() == 0 ||
        std::string::npos == _packageUrl.find(".zip"))
    {
        CCLOG("no version file url, or no package url, or the package is not a zip file");
        return;
    }
    
    _tid = new pthread_t();
    pthread_create(&(*_tid), NULL, assetsManagerDownloadAndUncompress, this);
}

bool MyAssetsManager::uncompress()
{
    // Open the zip file
    string outFileName = _storagePath + MYTEMP_PACKAGE_FILE_NAME;
    unzFile zipfile = unzOpen(outFileName.c_str());
    if (! zipfile)
    {
        CCLOG("can not open downloaded zip file %s", outFileName.c_str());
        return false;
    }
    
    // Get info about the zip file
    unz_global_info global_info;
    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    {
        CCLOG("can not read file global info of %s", outFileName.c_str());
        unzClose(zipfile);
        return false;
    }
    
    // Buffer to hold data read from the zip file
    char readBuffer[MYBUFFER_SIZE];
    
    CCLOG("start uncompressing");
    
    // Loop to extract all files.
    uLong i;
    for (i = 0; i < global_info.number_entry; ++i)
    {
        // Get info about current file.
        unz_file_info fileInfo;
        char fileName[MYMAX_FILENAME];
        if (unzGetCurrentFileInfo(zipfile,
                                  &fileInfo,
                                  fileName,
                                  MYMAX_FILENAME,
                                  NULL,
                                  0,
                                  NULL,
                                  0) != UNZ_OK)
        {
            CCLOG("can not read file info");
            unzClose(zipfile);
            return false;
        }
        
        string fullPath = _storagePath + fileName;
        
        // Check if this entry is a directory or a file.
        const size_t filenameLength = strlen(fileName);
        if (fileName[filenameLength-1] == '/')
        {
            // Entry is a direcotry, so create it.
            // If the directory exists, it will failed scilently.
            if (!createDirectory(fullPath.c_str()))
            {
                CCLOG("can not create directory %s", fullPath.c_str());
                unzClose(zipfile);
                return false;
            }
        }
        else
        {
            // Entry is a file, so extract it.
            
            // Open current file.
            if (unzOpenCurrentFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not open file %s", fileName);
                unzClose(zipfile);
                return false;
            }
            
            // Create a file to store current file.
            FILE *out = fopen(fullPath.c_str(), "wb");
            if (! out)
            {
                CCLOG("can not open destination file %s", fullPath.c_str());
                unzCloseCurrentFile(zipfile);
                unzClose(zipfile);
                return false;
            }
            
            // Write current file content to destinate file.
            int error = UNZ_OK;
            do
            {
                error = unzReadCurrentFile(zipfile, readBuffer, MYBUFFER_SIZE);
                if (error < 0)
                {
                    CCLOG("can not read zip file %s, error code is %d", fileName, error);
                    unzCloseCurrentFile(zipfile);
                    unzClose(zipfile);
                    return false;
                }
                
                if (error > 0)
                {
                    fwrite(readBuffer, error, 1, out);
                }
            } while(error > 0);
            
            fclose(out);
        }
        
        unzCloseCurrentFile(zipfile);
        
        // Goto next entry listed in the zip file.
        if ((i+1) < global_info.number_entry)
        {
            if (unzGoToNextFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not read next file");
                unzClose(zipfile);
                return false;
            }
        }
    }
    
	CCLOG("end uncompressing");
	unzClose(zipfile);
    
    return true;
}

/*
 * Create a direcotry is platform depended.
 */
bool MyAssetsManager::createDirectory(const char *path)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST))
    {
        return false;
    }
    
    return true;
#else
    BOOL ret = CreateDirectoryA(path, NULL);
	if (!ret && ERROR_ALREADY_EXISTS != GetLastError())
	{
		return false;
	}
    return true;
#endif
}

void MyAssetsManager::setSearchPath()
{
    vector<string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    vector<string>::iterator iter = searchPaths.begin();
	std::string pathToSave = _storagePath + MYRESDIRFILENAME +'/';	
    searchPaths.insert(iter, pathToSave);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
	CCLOG("setSearchPaths");
	for (std::vector<std::string>::const_iterator iter = searchPaths.begin(); iter != searchPaths.end(); ++iter)
	{
		CCLOG("%s", (*iter).c_str());
	}
}

static size_t downLoadPackage(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    FILE *fp = (FILE*)userdata;
    size_t written = fwrite(ptr, size, nmemb, fp);
    return written;
}
int nCurPercent = 0;
int assetsManagerProgressFunc(void *ptr, double totalToDownload, double nowDownloaded, double totalToUpLoad, double nowUpLoaded)
{
	if(nCurPercent != (nowDownloaded/totalToDownload*100))
	{
		MyAssetsManager* manager = (MyAssetsManager*)ptr;
		MyAssetsManager::MyMessage *msg = new MyAssetsManager::MyMessage();
		msg->what = MYASSETSMANAGER_MESSAGE_PROGRESS;

		MYProgressMessage *progressData = new MYProgressMessage();
		progressData->percent = (int)(nowDownloaded/totalToDownload*100);
		progressData->manager = manager;
		msg->obj = progressData;
		// 更新进度大于1的时候再发送消息
		if(progressData->percent>=0 && progressData->percent>nCurPercent)
		{
			manager->_schedule->sendMessage(msg);
			nCurPercent = progressData->percent;
		}
		if ((int)(nowDownloaded/totalToDownload*100)%10 == 0)
		{
			CCLOG("downloading... %d%%", (int)(nowDownloaded/totalToDownload*100));
		}
	}
    
    return 0;
}

size_t getcontentlengthfunc(void *ptr, size_t size, size_t nmemb, void *stream)   
{  
	int r;  
	long len = 0;  
	/* _snscanf() is Win32 specific */  
	//r = _snscanf(ptr, size * nmemb, "Content-Length: %ld\n", &len);  
	r = sscanf((const char*)ptr, "Content-Length: %ld\n", &len);  
	if (r) /* Microsoft: we don't read the specs */  
		*((long *) stream) = len;  
	return size * nmemb;  
}

bool MyAssetsManager::downLoad()
{
	string localpath = _storagePath + MYTEMP_PACKAGE_FILE_NAME;
	CURL *curlhandle = NULL;  
	CURL *curldwn = NULL;  
	curl_global_init(CURL_GLOBAL_ALL);  
	curlhandle = curl_easy_init();  
	curldwn = curl_easy_init(); 

	//if (remove(localpath.c_str()) != 0)
	//{
	//	CCLOG("can not remove downloaded zip file %s", localpath.c_str());
	//}

	FILE *f;  
	curl_off_t local_file_len = -1 ;  
	long filesize =0 ;  
	CURLcode r = CURLE_GOT_NOTHING;  
	struct stat file_info;  
	int use_resume = 0;  
	//获取本地文件大小信息  
	if(stat(localpath.c_str(), &file_info) == 0)  
	{  
		local_file_len = file_info.st_size;   
		use_resume = 1;  
	}  
	//追加方式打开文件，实现断点续传  
	f = fopen(localpath.c_str(), "ab+");  
	if (f == NULL) {  
		perror(NULL);  
		return 0;  
	}  
	//_packageUrl = "ftp://10.248.31.157/pub/1234.zip";
	// _packageUrl = "ftp://192.168.0.133/pub/1.1/1.1.zip";
	curl_easy_setopt(curlhandle, CURLOPT_URL, _packageUrl.c_str());  
	curl_easy_setopt(curlhandle, CURLOPT_SSL_VERIFYPEER, 0L);
	//curl_easy_setopt(curlhandle, CURLOPT_USERPWD, "spider:spider");     
	//连接超时设置  
	curl_easy_setopt(curlhandle, CURLOPT_CONNECTTIMEOUT, 120);  
	//设置头处理函数  
	curl_easy_setopt(curlhandle, CURLOPT_HEADERFUNCTION, getcontentlengthfunc);  
	curl_easy_setopt(curlhandle, CURLOPT_HEADERDATA, &filesize);  
	// 设置断点续传  
	curl_easy_setopt(curlhandle, CURLOPT_RESUME_FROM_LARGE, use_resume?local_file_len:0);  
	curl_easy_setopt(curlhandle, CURLOPT_WRITEFUNCTION, downLoadPackage);

	curl_easy_setopt(curlhandle,CURLOPT_DNS_USE_GLOBAL_CACHE,0L);

	curl_easy_setopt(curlhandle, CURLOPT_WRITEDATA, f);  
	curl_easy_setopt(curlhandle, CURLOPT_NOPROGRESS, 0L); 
	curl_easy_setopt(curlhandle, CURLOPT_PROGRESSFUNCTION, assetsManagerProgressFunc);
	curl_easy_setopt(curlhandle, CURLOPT_PROGRESSDATA, this); 

	curl_easy_setopt(curlhandle, CURLOPT_VERBOSE, 1L);  
	r = curl_easy_perform(curlhandle);  
	curl_easy_cleanup(curlhandle);

	if (r != 0)
	{
		sendErrorMessage(kNetwork);
		CCLOG("error when download package");
		fclose(f);
		return false;
	}
	nCurPercent = 0;
	CCLOG("succeed downloading package %s", _packageUrl.c_str());

	fclose(f);
	return true;
}

const char* MyAssetsManager::getPackageUrl() const
{
    return _packageUrl.c_str();
}
;
void MyAssetsManager::setPackageUrl(const char *packageUrl)
{
    _packageUrl = packageUrl;
}

const char* MyAssetsManager::getStoragePath() const
{
    return _storagePath.c_str();
}

void MyAssetsManager::setStoragePath(const char *storagePath)
{
    _storagePath = storagePath;
}

const char* MyAssetsManager::getVersionFileUrl() const
{
    return _versionFileUrl.c_str();
}

void MyAssetsManager::setVersionFileUrl(const char *versionFileUrl)
{
    _versionFileUrl = versionFileUrl;
}

string MyAssetsManager::getVersion()
{
    return CCUserDefault::sharedUserDefault()->getStringForKey(MYKEY_OF_VERSION);
}

void MyAssetsManager::deleteVersion()
{
    CCUserDefault::sharedUserDefault()->setStringForKey(MYKEY_OF_VERSION, "");
}

void MyAssetsManager::setDelegate(MyAssetsManagerDelegateProtocol *delegate)
{
    _delegate = delegate;
}

void MyAssetsManager::setConnectionTimeout(unsigned int timeout)
{
    _connectionTimeout = timeout;
}

unsigned int MyAssetsManager::getConnectionTimeout()
{
    return _connectionTimeout;
}

void MyAssetsManager::sendErrorMessage(MyAssetsManager::MYErrorCode code)
{
    MyMessage *msg = new MyMessage();
    msg->what = MYASSETSMANAGER_MESSAGE_ERROR;
    
    MYErrorMessage *errorMessage = new MYErrorMessage();
    errorMessage->code = code;
    errorMessage->manager = this;
    msg->obj = errorMessage;
    
    _schedule->sendMessage(msg);
}

// Implementation of AssetsManagerHelper

MyAssetsManager::MyHelper::MyHelper()
{
    _messageQueue = new list<MyMessage*>();
    pthread_mutex_init(&_messageQueueMutex, NULL);
    CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this, 0, false);
}

MyAssetsManager::MyHelper::~MyHelper()
{
    //CCDirector::sharedDirector()->getScheduler()->unscheduleAllForTarget(this);
    delete _messageQueue;
}

void MyAssetsManager::MyHelper::sendMessage(MyMessage *msg)
{
    pthread_mutex_lock(&_messageQueueMutex);
    _messageQueue->push_back(msg);
    pthread_mutex_unlock(&_messageQueueMutex);
}

void MyAssetsManager::MyHelper::update(float dt)
{
    MyMessage *msg = NULL;
    
    // Returns quickly if no message
    pthread_mutex_lock(&_messageQueueMutex);
    if (0 == _messageQueue->size())
    {
        pthread_mutex_unlock(&_messageQueueMutex);
        return;
    }
    
    // Gets message
    msg = *(_messageQueue->begin());
    _messageQueue->pop_front();
    pthread_mutex_unlock(&_messageQueueMutex);
    
    switch (msg->what) {
        case MYASSETSMANAGER_MESSAGE_UPDATE_SUCCEED:
            handleUpdateSucceed(msg);
            
            break;
        case MYASSETSMANAGER_MESSAGE_RECORD_DOWNLOADED_VERSION:
            CCUserDefault::sharedUserDefault()->setStringForKey(MYKEY_OF_DOWNLOADED_VERSION,
                                                                ((MyAssetsManager*)msg->obj)->_version.c_str());
            CCUserDefault::sharedUserDefault()->flush();
            
            break;
        case MYASSETSMANAGER_MESSAGE_PROGRESS:
            if (((MYProgressMessage*)msg->obj)->manager->_delegate)
            {
                ((MYProgressMessage*)msg->obj)->manager->_delegate->onProgress(((MYProgressMessage*)msg->obj)->percent);
            }
            
            delete (MYProgressMessage*)msg->obj;
            
            break;
        case MYASSETSMANAGER_MESSAGE_ERROR:
            // error call back
            if (((MYErrorMessage*)msg->obj)->manager->_delegate)
            {
                ((MYErrorMessage*)msg->obj)->manager->_delegate->onError(((MYErrorMessage*)msg->obj)->code);
            }
            
            delete ((MYErrorMessage*)msg->obj);
            
            break;
        default:
            break;
    }
    
    delete msg;
}

void MyAssetsManager::MyHelper::handleUpdateSucceed(MyMessage *msg)
{
    MyAssetsManager* manager = (MyAssetsManager*)msg->obj;
    
    // Record new version code.
    CCUserDefault::sharedUserDefault()->setStringForKey(MYKEY_OF_VERSION, manager->_version.c_str());
    
    // Unrecord downloaded version code.
    CCUserDefault::sharedUserDefault()->setStringForKey(MYKEY_OF_DOWNLOADED_VERSION, "");
    CCUserDefault::sharedUserDefault()->flush();
    
    // Set resource search path.
    //manager->setSearchPath();
    
    // Delete unloaded zip file.
    string zipfileName = manager->_storagePath + MYTEMP_PACKAGE_FILE_NAME;
    if (remove(zipfileName.c_str()) != 0)
    {
        CCLOG("can not remove downloaded zip file %s", zipfileName.c_str());
    }
    
    if (manager) manager->_delegate->onSuccess();
}

#endif // CC_PLATFORM_WINRT
