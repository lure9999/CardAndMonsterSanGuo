//
//  Platform.mm
//  TestMusic
//
//  Created by 敏 刘 on 13-12-5.
//
//

#include "Platform.h"
#include "../cocos2dx/platform/CCPlatformConfig.h"
#include "IOSPlayVideo.h"



void Platform::playVideo()
{

    //IOS播放本地视频
    IOSPlayVideo::playVideoForIOS();
 }


void Platform::playURLVideo()
{

    //IOS播放网络视频
    IOSPlayVideo::playVideoForIOS();
}
