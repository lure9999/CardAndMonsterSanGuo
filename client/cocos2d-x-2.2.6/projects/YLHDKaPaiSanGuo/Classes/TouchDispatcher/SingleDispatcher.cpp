#include "SingleDispatcher.h"

SingleDispatcher::SingleDispatcher(void)
{
	m_state = kSingleStateUngrabbed;
	m_pTouch = NULL;
}

SingleDispatcher::~SingleDispatcher(void)
{
}



void SingleDispatcher::touchesBegan(CCSet* touches, CCEvent* pEvent)
{
	
	if (m_state == kSingleStateUngrabbed) 
	{
		//跨平台这里支持多个 这个接口屏蔽多个只许第一个
		
		CCTouch *pTouch;
		CCSetIterator setIter;
		setIter = touches->begin(); 	
		pTouch = (CCTouch *)(*setIter);

		m_state = kSingleStateGrabbed;
		m_pTouch = pTouch;

		if (touches->count() == 1)
		{			
			CCTouchDispatcher::touchesBegan(touches,pEvent);
		}
		else
		{
			CCSet set;	
			set.addObject(pTouch);						
			CCTouchDispatcher::touchesBegan(&set,pEvent);
		}			
	}	
}

void SingleDispatcher::touchesMoved(CCSet* touches, CCEvent* pEvent)
{
	
	if (m_state == kSingleStateGrabbed)
	{
		CCTouch *pTouch;
		CCSetIterator setIter;
		for (setIter = touches->begin(); setIter != touches->end(); ++setIter)
		{
			pTouch = (CCTouch *)(*setIter);
			if (pTouch == m_pTouch)
			{
				CCTouchDispatcher::touchesMoved(touches,pEvent);
			}		
		}
	}
		
}


void SingleDispatcher::touchesEnded(CCSet* touches, CCEvent* pEvent)
{
	if (m_state == kSingleStateGrabbed)
	{
		CCTouch *pTouch;
		CCSetIterator setIter;
		for (setIter = touches->begin(); setIter != touches->end(); ++setIter)
		{
			pTouch = (CCTouch *)(*setIter);
			if (pTouch == m_pTouch)
			{
				m_state = kSingleStateUngrabbed;
				m_pTouch = NULL;
				CCTouchDispatcher::touchesEnded(touches,pEvent);
			}		
		}
		
	}	
}

void SingleDispatcher::touchesCancelled(CCSet* touches, CCEvent* pEvent)
{

	if (m_state == kSingleStateGrabbed)
	{
		CCTouch *pTouch;
		CCSetIterator setIter;
		for (setIter = touches->begin(); setIter != touches->end(); ++setIter)
		{
			pTouch = (CCTouch *)(*setIter);
			if (pTouch == m_pTouch)
			{
				m_state = kSingleStateUngrabbed;
				m_pTouch = NULL;
				CCTouchDispatcher::touchesCancelled(touches,pEvent);
			}		
		}

	}		
}

void SingleDispatcher::ClearState()
{
	m_state = kSingleStateUngrabbed;
	m_pTouch = NULL;
}

