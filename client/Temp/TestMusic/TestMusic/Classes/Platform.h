//
//  Platform.h
//  TestMusic
//
//  Created by 敏 刘 on 13-12-5.
//
//

#ifndef __TestMusic__Platform__
#define __TestMusic__Platform__


#include "cocos2d.h"
using namespace cocos2d;


class Platform
{
public:
    static void playVideo();//用于播放本地视频
    static void playURLVideo();//用于播放网络视频
};



#endif /* defined(__TestMusic__Platform__) */
