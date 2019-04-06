#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "cocos2d.h"
#include "SimpleAudioEngine.h"
#include "cocos-ext.h"
#include "Platform.h"

using namespace cocos2d;
using namespace cocos2d::extension;


class HelloWorld : public cocos2d::CCLayer
{
public:
    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();  

    // there's no 'id' in cpp, so we recommend returning the class instance pointer
    static cocos2d::CCScene* scene();
    
    // a selector callback
    void menuCloseCallback(CCObject* pSender);
    
    // implement the "static node()" method manually
    CREATE_FUNC(HelloWorld);
    
    //播放
    void playmusic(CCObject *sender, CCControlEvent);
    //暂停
    void pausemusic(CCObject *sender, CCControlEvent);
    //停止
    void stopmusic(CCObject *sender, CCControlEvent);
    
};

#endif // __HELLOWORLD_SCENE_H__
