#include "cocos2d.h"

USING_NS_CC;

typedef enum SingleDispatcherState 
{
	kSingleStateGrabbed,
	kSingleStateUngrabbed
} SingleState; 

class SingleDispatcher : public CCTouchDispatcher
{
	SingleState        m_state;
	CCTouch *		   m_pTouch;
public:
	SingleDispatcher(void);
	virtual ~SingleDispatcher(void);		
	
	
    virtual void touchesBegan(CCSet* touches, CCEvent* pEvent);
   
    virtual void touchesMoved(CCSet* touches, CCEvent* pEvent);
   
    virtual void touchesEnded(CCSet* touches, CCEvent* pEvent);   

	virtual void touchesCancelled(CCSet* touches, CCEvent* pEvent);
  
	void ClearState();	
};


