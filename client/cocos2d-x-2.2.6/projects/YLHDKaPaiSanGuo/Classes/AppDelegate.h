#ifndef __APP_DELEGATE_H__
#define __APP_DELEGATE_H__

#include "cocos2d.h"
#include "TouchDispatcher/SingleDispatcher.h"
/**
@brief    The cocos2d Application.

The reason for implement as private inheritance is to hide some interface call by CCDirector.
*/
class  AppDelegate : private cocos2d::CCApplication
{
public:
    AppDelegate();
    virtual ~AppDelegate();

    /**
    @brief    Implement CCDirector and CCScene init code here.
    @return true    Initialize success, app continue.
    @return false   Initialize failed, app terminate.
    */
    virtual bool applicationDidFinishLaunching();

    /**
    @brief  The function be called when the application enter background
    @param  the pointer of the application
    */
    virtual void applicationDidEnterBackground();

    /**
    @brief  The function be called when the application enter foreground
    @param  the pointer of the application
    */
    virtual void applicationWillEnterForeground();	

private:

	/** calculates delta time since last time it was called */    
	void calculateDeltaTime();

	/* delta time since last tick to main loop */
	CC_PROPERTY_READONLY(float, m_fDeltaTime, DeltaTime);

	/* last time the main loop was updated */
	struct cocos2d::cc_timeval *m_pLastUpdate;
	/* whether or not the next delta time will be zero */
	bool m_bNextDeltaTimeZero;

	SingleDispatcher* m_pSingleTouchDispatcher;
};

#endif  // __APP_DELEGATE_H__

