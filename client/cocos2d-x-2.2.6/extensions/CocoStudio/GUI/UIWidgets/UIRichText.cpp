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

#include "UIRichText.h"
//add by sxin 修改 换行bug
#include "support/ccUTF8.h"
//end
NS_CC_BEGIN

namespace ui {
//add by sxin 修改 换行bug
static std::string utf8_substr(const std::string& str, unsigned long start, unsigned long leng)
{
	if (leng==0)
	{
		return "";
	}
	unsigned long c, i, ix, q, min=std::string::npos, max=std::string::npos;
	for (q=0, i=0, ix=str.length(); i < ix; i++, q++)
	{
		if (q==start)
		{
			min = i;
		}
		if (q <= start+leng || leng==std::string::npos)
		{
			max = i;
		}

		c = (unsigned char) str[i];

		if      (c<=127) i+=0;
		else if ((c & 0xE0) == 0xC0) i+=1;
		else if ((c & 0xF0) == 0xE0) i+=2;
		else if ((c & 0xF8) == 0xF0) i+=3;
		else return "";//invalid utf8
	}
	if (q <= start+leng || leng == std::string::npos)
	{
		max = i;
	}
	if (min==std::string::npos || max==std::string::npos)
	{
		return "";
	}
	return str.substr(min,max);
}
//end
    
static int _calcCharCount(const char * pszText)
{
    int n = 0;
    char ch = 0;
    while ((ch = *pszText))
    {
        CC_BREAK_IF(! ch);
        
        if (0x80 != (0xC0 & ch))
        {
            ++n;
        }
        ++pszText;
    }
    return n;
}
    
bool RichElement::init(int tag, const ccColor3B &color, GLubyte opacity)
{
    _tag = tag;
    _color = color;
    _opacity = opacity;
    return true;
}

int	RichElement::getTag()	
{
	return _tag;
}
    
RichElementText* RichElementText::create(int tag, const ccColor3B &color, GLubyte opacity, const char *text, const char *fontName, float fontSize)
{
    RichElementText* element = new RichElementText();
    if (element && element->init(tag, color, opacity, text, fontName, fontSize))
    {
        element->autorelease();
        return element;
    }
    CC_SAFE_DELETE(element);
    return NULL;
}
    
bool RichElementText::init(int tag, const ccColor3B &color, GLubyte opacity, const char *text, const char *fontName, float fontSize)
{
    if (RichElement::init(tag, color, opacity))
    {
        _text = text;
        _fontName = fontName;
        _fontSize = fontSize;
        return true;
    }
    return false;
}

RichElementImage* RichElementImage::create(int tag, const ccColor3B &color, GLubyte opacity, const char *filePath)
{
    RichElementImage* element = new RichElementImage();
    if (element && element->init(tag, color, opacity, filePath))
    {
        element->autorelease();
        return element;
    }
    CC_SAFE_DELETE(element);
    return NULL;
}
    
bool RichElementImage::init(int tag, const ccColor3B &color, GLubyte opacity, const char *filePath)
{
    if (RichElement::init(tag, color, opacity))
    {
        _filePath = filePath;
        return true;
    }
    return false;
}

RichElementCustomNode* RichElementCustomNode::create(int tag, const ccColor3B &color, GLubyte opacity, cocos2d::CCNode *customNode)
{
    RichElementCustomNode* element = new RichElementCustomNode();
    if (element && element->init(tag, color, opacity, customNode))
    {
        element->autorelease();
        return element;
    }
    CC_SAFE_DELETE(element);
    return NULL;
}
    
bool RichElementCustomNode::init(int tag, const ccColor3B &color, GLubyte opacity, cocos2d::CCNode *customNode)
{
    if (RichElement::init(tag, color, opacity))
    {
        _customNode = customNode;
        _customNode->retain();
        return true;
    }
    return false;
}

//add by sxin 扩展手动换行
RichElementNewLine* RichElementNewLine::create()
{
	RichElementNewLine* element = new RichElementNewLine();
	if (element)
	{
		element->autorelease();
		return element;
	}
	CC_SAFE_DELETE(element);
	return NULL;
}

// add by sxin  增加点击响应基类

RichTouchElement::RichTouchElement():
_TouchNodes(NULL)
{
	_type = RICH_TOUCH;
}

RichTouchElement::~RichTouchElement()
{
	m_RichElement->release();
	_TouchNodes->release();
}

bool RichTouchElement::init(RichElement* pRichElement)
{
	if (pRichElement)
	{
		pRichElement->retain();
		m_RichElement = pRichElement;
		_TouchNodes = CCArray::create();
		_TouchNodes->retain();	

		return true;
	}	
	return false;	
}

RichTouchElement* RichTouchElement::create(RichElement* pRichElement)
{
	RichTouchElement* element = new RichTouchElement();
	if (element && element->init(pRichElement))
	{
		element->autorelease();
		return element;
	}
	CC_SAFE_DELETE(element);
	return NULL;
}

bool RichTouchElement::isTouchInside(CCTouch* touch)
{
	for (unsigned int i=0; i<_TouchNodes->count(); i++)
	{
		CCNode* pNode = static_cast<CCNode*>(_TouchNodes->objectAtIndex(i));

		CCPoint touchLocation = touch->getLocation(); // Get the touch position
		touchLocation = pNode->getParent()->convertToNodeSpace(touchLocation);

		CCRect bBox=pNode->boundingBox();

		if (bBox.containsPoint(touchLocation))
		{
			return true;
		}	
	}
	return false;
}

    
RichText::RichText():
_formatTextDirty(true),
_richElements(NULL),
_leftSpaceWidth(0.0f),
_verticalSpace(0.0f),
_elementRenderersContainer(NULL)
{
    
}
    
RichText::~RichText()
{
    _richElements->release();	
}
    
RichText* RichText::create()
{
    RichText* widget = new RichText();
    if (widget && widget->init())
    {
        widget->autorelease();
        return widget;
    }
    CC_SAFE_DELETE(widget);
    return NULL;
}
    
bool RichText::init()
{
    if (Widget::init())
    {
        _richElements = CCArray::create();
        _richElements->retain();		
        return true;
    }
    return false;
}
    
void RichText::initRenderer()
{
    _elementRenderersContainer = CCNode::create();
    _elementRenderersContainer->setAnchorPoint(ccp(0.5f, 0.5f));
    CCNode::addChild(_elementRenderersContainer, 0, -1);
}

// 点击响应区域不许插入不能定位
void RichText::insertElement(RichElement *element, int index)
{
    _richElements->insertObject(element, index);
    _formatTextDirty = true;
}
    
void RichText::pushBackElement(RichElement *element)
{
    _richElements->addObject(element);
    _formatTextDirty = true;
}

//add by sxin 扩展手动换行
void RichText::pushNewLineElement()
{
	RichElementNewLine* pelementNewLine = RichElementNewLine::create();
	_richElements->addObject(pelementNewLine);
	_formatTextDirty = true;
}

// add by sxin 扩展消息点击相应
void RichText::pushTouchElement(RichElement *element)
{	
	// 这里加壳
	RichTouchElement* pRichTouchElement = RichTouchElement::create(element);
	_richElements->addObject(pRichTouchElement);
	_formatTextDirty = true;
}


// add by sxin 扩展消息点击相应
void RichText::onTouchEnded(CCTouch *touch, CCEvent *unusedEvent)
{
	//_richElements 遍历这个里有没有RichTouchElement
	
	RichElement* element = NULL;
	RichTouchElement* TouchElement = NULL;
	for (unsigned int i=0; i<_richElements->count(); i++)
	{
		element = static_cast<RichElement*>(_richElements->objectAtIndex(i));
		if (element->_type == RICH_TOUCH)
		{
			TouchElement = static_cast<RichTouchElement*>(element);
			// 判断是否点击了

			if (TouchElement->isTouchInside(touch))
			{
				//回调RichText的回调响应
				if (_touchEventListener && _touchEventSelector)
				{
					(_touchEventListener->*_touchEventSelector)(TouchElement->m_RichElement,TOUCH_EVENT_ENDED);
					return;
				}
			}
		}		
	}
	
	Widget::onTouchEnded(touch, unusedEvent);
}
    
void RichText::removeElement(int index)
{
    _richElements->removeObjectAtIndex(index);
    _formatTextDirty = true;
}
    
void RichText::removeElement(RichElement *element)
{
    _richElements->removeObject(element);	
    _formatTextDirty = true;
}
    
void RichText::formatText()
{
    if (_formatTextDirty)
    {
        _elementRenderersContainer->removeAllChildren();
        _elementRenders.clear();
        if (_ignoreSize)
        {
            addNewLine();
            for (unsigned int i=0; i<_richElements->count(); i++)
            {
                RichElement* element = static_cast<RichElement*>(_richElements->objectAtIndex(i));
                CCNode* elementRenderer = NULL;
                switch (element->_type)
                {
                    case RICH_TEXT:
                    {
                        RichElementText* elmtText = static_cast<RichElementText*>(element);
                        elementRenderer = CCLabelTTF::create(elmtText->_text.c_str(), elmtText->_fontName.c_str(), elmtText->_fontSize);
                        break;
                    }
                    case RICH_IMAGE:
                    {
                        RichElementImage* elmtImage = static_cast<RichElementImage*>(element);
                        elementRenderer = CCSprite::create(elmtImage->_filePath.c_str());
                        break;
                    }
                    case RICH_CUSTOM:
                    {
                        RichElementCustomNode* elmtCustom = static_cast<RichElementCustomNode*>(element);
                        elementRenderer = elmtCustom->_customNode;
                        break;
                    }
					//add by sxin 支持手动换行
					case RICH_NEWLINE:
					{
						RichElementNewLine* elmteNewLine = static_cast<RichElementNewLine*>(element);
						addNewLine();
						break;
					}
					//add by sxin 支持点击响应
					case RICH_TOUCH:
					{
						RichTouchElement* pTouchElement = static_cast<RichTouchElement*>(element);

						switch (pTouchElement->m_RichElement->_type)
						{
						case RICH_TEXT:
							{
								RichElementText* elmtText = static_cast<RichElementText*>(pTouchElement->m_RichElement);
								elementRenderer = CCLabelTTF::create(elmtText->_text.c_str(), elmtText->_fontName.c_str(), elmtText->_fontSize);
								break;
							}
						case RICH_IMAGE:
							{
								RichElementImage* elmtImage = static_cast<RichElementImage*>(pTouchElement->m_RichElement);
								elementRenderer = CCSprite::create(elmtImage->_filePath.c_str());
								break;
							}
						case RICH_CUSTOM:
							{
								RichElementCustomNode* elmtCustom = static_cast<RichElementCustomNode*>(pTouchElement->m_RichElement);
								elementRenderer = elmtCustom->_customNode;
								break;
							}								
						default:
							break;
						}	
						pTouchElement->_TouchNodes->addObject(elementRenderer);
						break;
					}
                    default:
                        break;
                }

				// add by sxin 区分是字体还是图片来设置颜色
				CCLabelTTF* pelmtText = static_cast<CCLabelTTF*>(elementRenderer);
				CCRGBAProtocol* colorRenderer = dynamic_cast<CCRGBAProtocol*>(elementRenderer);
				if (pelmtText)
				{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
					pelmtText->setFontFillColor(element->_color);
#else
					colorRenderer->setColor(element->_color);
#endif
					
				}
				else
				{
					colorRenderer->setColor(element->_color);
				}
                colorRenderer->setOpacity(element->_opacity);
                pushToContainer(elementRenderer);
            }
        }
        else
        {
            addNewLine();
            for (unsigned int i=0; i<_richElements->count(); i++)
            {
                
                RichElement* element = static_cast<RichElement*>(_richElements->objectAtIndex(i));
                switch (element->_type)
                {
                    case RICH_TEXT:
                    {
                        RichElementText* elmtText = static_cast<RichElementText*>(element);
                        handleTextRenderer(elmtText->_text.c_str(), elmtText->_fontName.c_str(), elmtText->_fontSize, elmtText->_color, elmtText->_opacity);
                        break;
                    }
                    case RICH_IMAGE:
                    {
                        RichElementImage* elmtImage = static_cast<RichElementImage*>(element);
                        handleImageRenderer(elmtImage->_filePath.c_str(), elmtImage->_color, elmtImage->_opacity);
                        break;
                    }
                    case RICH_CUSTOM:
                    {
                        RichElementCustomNode* elmtCustom = static_cast<RichElementCustomNode*>(element);
                        handleCustomRenderer(elmtCustom->_customNode);
                        break;
                    }
					//add by sxin 支持手动换行
					case RICH_NEWLINE:
					{
						RichElementNewLine* elmtCustom = static_cast<RichElementNewLine*>(element);
						addNewLine();
						break;
					}
					//add by sxin 支持点击响应
					case RICH_TOUCH:
					{
						RichTouchElement* pTouchElement = static_cast<RichTouchElement*>(element);

						switch (pTouchElement->m_RichElement->_type)
						{
						case RICH_TEXT:
							{
								RichElementText* elmtText = static_cast<RichElementText*>(pTouchElement->m_RichElement);
								handleTouchTextRenderer(pTouchElement,elmtText->_text.c_str(), elmtText->_fontName.c_str(), elmtText->_fontSize, elmtText->_color, elmtText->_opacity);
								break;
							}
						case RICH_IMAGE:
							{
								RichElementImage* elmtImage = static_cast<RichElementImage*>(pTouchElement->m_RichElement);
								handleTouchImageRenderer(pTouchElement,elmtImage->_filePath.c_str(), elmtImage->_color, elmtImage->_opacity);
								break;
							}
						case RICH_CUSTOM:
							{
								RichElementCustomNode* elmtCustom = static_cast<RichElementCustomNode*>(pTouchElement->m_RichElement);
								handleTouchCustomRenderer(pTouchElement,elmtCustom->_customNode);
								break;
							}								
						default:
							break;
						}							
						break;
					}
                    default:
                        break;
                }
            }
        }
        formarRenderers();
        _formatTextDirty = false;
    }
}
 
// add by sxin 修改换行bug
//void RichText::handleTextRenderer(const char *text, const char *fontName, float fontSize, const ccColor3B &color, GLubyte opacity)
//{
//    CCLabelTTF* textRenderer = CCLabelTTF::create(text, fontName, fontSize);
//    float textRendererWidth = textRenderer->getContentSize().width;
//    _leftSpaceWidth -= textRendererWidth;
//    if (_leftSpaceWidth < 0.0f)
//    {
//        float overstepPercent = (-_leftSpaceWidth) / textRendererWidth;
//        std::string curText = text;
//        int stringLength = _calcCharCount(text);;
//        int leftLength = stringLength * (1.0f - overstepPercent);
//        std::string leftWords = curText.substr(0, leftLength);
//        std::string cutWords = curText.substr(leftLength, curText.length()-1);
//        if (leftLength > 0)
//        {
//            CCLabelTTF* leftRenderer = CCLabelTTF::create(leftWords.substr(0, leftLength).c_str(), fontName, fontSize);
//            leftRenderer->setColor(color);
//            leftRenderer->setOpacity(opacity);
//            pushToContainer(leftRenderer);
//        }
//
//        addNewLine();
//        handleTextRenderer(cutWords.c_str(), fontName, fontSize, color, opacity);
//    }
//    else
//    {
//        textRenderer->setColor(color);
//        textRenderer->setOpacity(opacity);
//        pushToContainer(textRenderer);
//    }
//}

void RichText::handleTextRenderer(const char *text, const char *fontName, float fontSize, const ccColor3B &color, GLubyte opacity)
{
	CCLabelTTF* textRenderer = CCLabelTTF::create(text, fontName, fontSize);
	float textRendererWidth = textRenderer->getContentSize().width;
	_leftSpaceWidth -= textRendererWidth;
	if (_leftSpaceWidth < 0.0f)
	{
		float overstepPercent = (-_leftSpaceWidth) / textRendererWidth;
		std::string curText = text;
		size_t stringLength = cc_utf8_strlen(text);
		int leftLength = stringLength * (1.0f - overstepPercent);
		std::string leftWords = utf8_substr(curText,0,leftLength);
		std::string cutWords = utf8_substr(curText, leftLength, curText.length() - leftLength);
		if (leftLength > 0)
		{
			CCLabelTTF* leftRenderer = CCLabelTTF::create(utf8_substr(leftWords, 0, leftLength).c_str(), fontName, fontSize);
			if (leftRenderer)
			{
				//leftRenderer->setColor(color);

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
				leftRenderer->setFontFillColor(color);
#else
				leftRenderer->setColor(color);
#endif

				leftRenderer->setOpacity(opacity);
				pushToContainer(leftRenderer);
			}
		}

		addNewLine();
		handleTextRenderer(cutWords.c_str(), fontName, fontSize, color, opacity);
	}
	else
	{
		//textRenderer->setColor(color);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		textRenderer->setFontFillColor(color);
#else
		textRenderer->setColor(color);
#endif
		textRenderer->setOpacity(opacity);
		pushToContainer(textRenderer);
	}
}

//end
    
void RichText::handleImageRenderer(const char *fileParh, const ccColor3B &color, GLubyte opacity)
{
    CCSprite* imageRenderer = CCSprite::create(fileParh);
    handleCustomRenderer(imageRenderer);
}
    
void RichText::handleCustomRenderer(cocos2d::CCNode *renderer)
{
    CCSize imgSize = renderer->getContentSize();
    _leftSpaceWidth -= imgSize.width;
    if (_leftSpaceWidth < 0.0f)
    {
        addNewLine();
        pushToContainer(renderer);
        _leftSpaceWidth -= imgSize.width;
    }
    else
    {
        pushToContainer(renderer);
    }
}
    
void RichText::addNewLine()
{
    _leftSpaceWidth = _customSize.width;
    _elementRenders.push_back(CCArray::create());
}

void RichText::handleTouchTextRenderer(RichTouchElement* pRichTouchElement,const char* text, const char* fontName, float fontSize, const ccColor3B& color, GLubyte opacity)
{
	CCLabelTTF* textRenderer = CCLabelTTF::create(text, fontName, fontSize);
	float textRendererWidth = textRenderer->getContentSize().width;
	_leftSpaceWidth -= textRendererWidth;
	if (_leftSpaceWidth < 0.0f)
	{
		float overstepPercent = (-_leftSpaceWidth) / textRendererWidth;
		std::string curText = text;
		size_t stringLength = cc_utf8_strlen(text);
		int leftLength = stringLength * (1.0f - overstepPercent);
		std::string leftWords = utf8_substr(curText,0,leftLength);
		std::string cutWords = utf8_substr(curText, leftLength, curText.length() - leftLength);
		if (leftLength > 0)
		{
			CCLabelTTF* leftRenderer = CCLabelTTF::create(utf8_substr(leftWords, 0, leftLength).c_str(), fontName, fontSize);
			if (leftRenderer)
			{
				//leftRenderer->setColor(color);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
				leftRenderer->setFontFillColor(color);
#else
				leftRenderer->setColor(color);
#endif

				leftRenderer->setOpacity(opacity);
				pushToContainer(leftRenderer);				
				pRichTouchElement->_TouchNodes->addObject(leftRenderer);
			}
		}

		addNewLine();
		handleTouchTextRenderer(pRichTouchElement,cutWords.c_str(), fontName, fontSize, color, opacity);
	}
	else
	{
		//textRenderer->setColor(color);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		textRenderer->setFontFillColor(color);
#else
		textRenderer->setColor(color);
#endif
		textRenderer->setOpacity(opacity);
		pushToContainer(textRenderer);
		pRichTouchElement->_TouchNodes->addObject(textRenderer);
	}
}

void RichText::handleTouchImageRenderer(RichTouchElement* pRichTouchElement,const char* fileParh, const ccColor3B& color, GLubyte opacity)
{
	CCSprite* imageRenderer = CCSprite::create(fileParh);
	handleTouchCustomRenderer(pRichTouchElement,imageRenderer);
}

void RichText::handleTouchCustomRenderer(RichTouchElement* pRichTouchElement,CCNode* renderer)
{
	CCSize imgSize = renderer->getContentSize();
	_leftSpaceWidth -= imgSize.width;
	if (_leftSpaceWidth < 0.0f)
	{
		addNewLine();
		pushToContainer(renderer);		
		_leftSpaceWidth -= imgSize.width;
	}
	else
	{
		pushToContainer(renderer);
	}

	pRichTouchElement->_TouchNodes->addObject(renderer);
}

//add by sxin 
#define Max_NewLine_Height 18.0f
void RichText::formarRenderers()
{
    if (_ignoreSize)
    {
        float newContentSizeWidth = 0.0f;
        float newContentSizeHeight = 0.0f;
        
        CCArray* row = (CCArray*)(_elementRenders[0]);
        float nextPosX = 0.0f;
        for (unsigned int j=0; j<row->count(); j++)
        {
            CCNode* l = (CCNode*)(row->objectAtIndex(j));
            l->setAnchorPoint(CCPointZero);
            l->setPosition(ccp(nextPosX, 0.0f));
            _elementRenderersContainer->addChild(l, 1, j);
            CCSize iSize = l->getContentSize();
            newContentSizeWidth += iSize.width;
            newContentSizeHeight = MAX(newContentSizeHeight, iSize.height);
            nextPosX += iSize.width;
        }
        _elementRenderersContainer->setContentSize(CCSizeMake(newContentSizeWidth, newContentSizeHeight));
    }
    else
    {
        float newContentSizeHeight = 0.0f;
        float *maxHeights = new float[_elementRenders.size()];
        
        for (unsigned int i=0; i<_elementRenders.size(); i++)
        {
            CCArray* row = (CCArray*)(_elementRenders[i]);
            float maxHeight = 0.0f;
            for (unsigned int j=0; j<row->count(); j++)
            {
                CCNode* l = (CCNode*)(row->objectAtIndex(j));
                maxHeight = MAX(l->getContentSize().height, maxHeight);
            }
			if (maxHeight == 0.0f)
			{
				//空行换行
				maxHeight = Max_NewLine_Height;

			}
			
            maxHeights[i] = maxHeight;
            newContentSizeHeight += maxHeights[i];
        }
        
		//add by sxin 如果初始设置的大小高度是0就自动设置成匹配的高度
		if (_customSize.height <= 0)
		{
			_customSize.height = newContentSizeHeight;
		}
		
        
        float nextPosY = _customSize.height;
        for (unsigned int i=0; i<_elementRenders.size(); i++)
        {
            CCArray* row = (CCArray*)(_elementRenders[i]);
            float nextPosX = 0.0f;
            nextPosY -= (maxHeights[i] + _verticalSpace);
            
            for (unsigned int j=0; j<row->count(); j++)
            {
                CCNode* l = (CCNode*)(row->objectAtIndex(j));
                l->setAnchorPoint(CCPointZero);
                l->setPosition(ccp(nextPosX, nextPosY));
                _elementRenderersContainer->addChild(l, 1, i*10 + j);
                nextPosX += l->getContentSize().width;
            }
        }
		//add by sxin 这里应该把计算好的真实大小更新给ContentSize
		//_elementRenderersContainer->setContentSize(_size);		
		_elementRenderersContainer->setContentSize(CCSizeMake(_customSize.width, newContentSizeHeight));
        delete [] maxHeights;
    }
    _elementRenders.clear();
    if (_ignoreSize)
    {
        CCSize s = getContentSize();
        _size = s;
    }
    else
    {
        _size = _customSize;
    }
}
    
void RichText::pushToContainer(cocos2d::CCNode *renderer)
{
    if (_elementRenders.size() <= 0)
    {
        return;
    }
    _elementRenders[_elementRenders.size()-1]->addObject(renderer);
}

void RichText::visit()
{
    if (_enabled)
    {
        formatText();
        Widget::visit();
    }
}
    
void RichText::setVerticalSpace(float space)
{
    _verticalSpace = space;
}
    
void RichText::setAnchorPoint(const CCPoint &pt)
{
    Widget::setAnchorPoint(pt);
    _elementRenderersContainer->setAnchorPoint(pt);
}
    
const CCSize& RichText::getContentSize() const
{
    return _elementRenderersContainer->getContentSize();
}
    
void RichText::ignoreContentAdaptWithSize(bool ignore)
{
    if (_ignoreSize != ignore)
    {
        _formatTextDirty = true;
        Widget::ignoreContentAdaptWithSize(ignore);
    }
}
    
std::string RichText::getDescription() const
{
    return "RichText";
}

}

NS_CC_END
