#include "VideoPlatform.h"  
#include "../../cocos2dx/platform/CCPlatformConfig.h"  
#if (CC_TARGET_PLATFORM==CC_PLATFORM_ANDROID)  
#include <jni.h>  
#include "../../cocos2dx/platform/android/jni/JniHelper.h"  
#include <android/log.h>  
#elif(CC_TARGET_PLATFORM==CC_PLATFORM_IOS)  
#include "IOSPlayVideo.h"  
#endif  
  
void VideoPlatform::playVideo(const char * filename,CCLayer *layer)  
{  
  
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)  
	//Android视频播放代码  
	JniMethodInfo minfo;  
	bool isHave = JniHelper::getMethodInfo(minfo,"org/cocos2dx/video/video","playVideo", "()V");  
	if (isHave) {  
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);  
	}  
#elif(CC_TARGET_PLATFORM==CC_PLATFORM_IOS)  
	//iOS视频播放代码  
	IOSPlayVideo::playVideoForIOS(filename,layer);  
	  
#endif  
  
}  