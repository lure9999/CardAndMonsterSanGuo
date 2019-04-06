#ifndef __Platform_H_H__  
#define __Platform_H_H__  
#include "cocos2d.h"  
using namespace cocos2d;  
class VideoPlatform   
{  
 public:  
    //在当前的layer上播放视频，视频完毕或者点击跳过视频会跳转到指定的layer上(默认为空，也就是停留在当前layer上)  
    static void playVideo(const char * filename,CCLayer *layer =NULL);  
};  
  
#endif // __Platform_H_H__ 