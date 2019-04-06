#include "HelloWorldScene.h"

#define MUSIC_FILE        "back.mp3"

USING_NS_CC;




CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    
    //加载音乐
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadBackgroundMusic(MUSIC_FILE);
    //设置默认音量
    CocosDenshion::SimpleAudioEngine::sharedEngine()->setBackgroundMusicVolume(1);
    
    
    //播放音效
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("achievement_unlock.caf");
    
    
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCPoint origin = CCDirector::sharedDirector()->getVisibleOrigin();

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback));
    
	pCloseItem->setPosition(ccp(origin.x + visibleSize.width - pCloseItem->getContentSize().width/2 ,
                                origin.y + pCloseItem->getContentSize().height/2));

    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition(CCPointZero);
    this->addChild(pMenu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
    
    CCLabelTTF* pLabel = CCLabelTTF::create("Hello World", "Arial", 24);
    
    // position the label on the center of the screen
    pLabel->setPosition(ccp(origin.x + visibleSize.width/2,
                            origin.y + visibleSize.height - pLabel->getContentSize().height));

    // add the label as a child to this layer
    this->addChild(pLabel, 1);

    // add "HelloWorld" splash screen"
    CCSprite* pSprite = CCSprite::create("HelloWorld.png");

    // position the sprite on the center of the screen
    pSprite->setPosition(ccp(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));

    // add the sprite as a child to this layer
    this->addChild(pSprite, 0);
    
    
    
    //创建3个按钮
    CCScale9Sprite *sp1 = CCScale9Sprite::create("1.png");
    CCScale9Sprite *sp2 = CCScale9Sprite::create("2.png");
    CCScale9Sprite *sp3 = CCScale9Sprite::create("3.png");
    CCControlButton *b1 = CCControlButton::create(sp1);
    CCControlButton *b2 = CCControlButton::create(sp2);
    CCControlButton *b3 = CCControlButton::create(sp3);
    
    b1->setPosition(ccp(visibleSize.width/2-100, visibleSize.height/2+100));
    b2->setPosition(ccp(visibleSize.width/2, visibleSize.height/2+100));
    b3->setPosition(ccp(visibleSize.width/2+100, visibleSize.height/2+100));
    
    b1->addTargetWithActionForControlEvents(this, cccontrol_selector(HelloWorld::playmusic), CCControlEventTouchDown);
    
    b2->addTargetWithActionForControlEvents(this, cccontrol_selector(HelloWorld::pausemusic), CCControlEventTouchDown);
    
    b3->addTargetWithActionForControlEvents(this, cccontrol_selector(HelloWorld::stopmusic), CCControlEventTouchDown);
    
    
    
    
    b1->setPreferredSize(ccp(57, 57));
    b2->setPreferredSize(ccp(57, 57));
    b3->setPreferredSize(ccp(57, 57));
    
    this->addChild(b1, 0, 1);
    this->addChild(b2, 0, 1);
    this->addChild(b3, 0, 1);
    
    Platform::playVideo();
    
    return true;
}


void HelloWorld::playmusic(CCObject *sender, CCControlEvent)
{
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic(MUSIC_FILE,true);
}

void HelloWorld::pausemusic(CCObject *sender, CCControlEvent)
{
    CocosDenshion::SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

void HelloWorld::stopmusic(CCObject *sender, CCControlEvent)
{
    CocosDenshion::SimpleAudioEngine::sharedEngine()->stopBackgroundMusic();
}

void HelloWorld::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}
