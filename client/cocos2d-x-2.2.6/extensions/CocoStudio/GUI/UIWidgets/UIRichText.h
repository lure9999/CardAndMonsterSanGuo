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

#ifndef __UIRICHTEXT_H__
#define __UIRICHTEXT_H__

#include "../BaseClasses/UIWidget.h"

NS_CC_BEGIN

namespace ui {
    
typedef enum {
    RICH_TEXT,
    RICH_IMAGE,
    RICH_CUSTOM,
	RICH_NEWLINE,//add by sxin 增加手动换行类型
	RICH_TOUCH,//add by sxin 增加点击响应
}RichElementType;
    
class CC_EX_DLL RichElement : public CCObject
{
public:
    RichElement(){};
    virtual ~RichElement(){};
    virtual bool init(int tag, const ccColor3B& color, GLubyte opacity);	
	int	getTag();	
protected:
    RichElementType _type;
    int _tag;
    ccColor3B _color;
    GLubyte _opacity;
    friend class RichText;
};
    
class CC_EX_DLL RichElementText : public RichElement
{
public:
    RichElementText(){_type = RICH_TEXT;};
    virtual ~RichElementText(){};
    virtual bool init(int tag, const ccColor3B& color, GLubyte opacity, const char* text, const char* fontName, float fontSize);
    static RichElementText* create(int tag, const ccColor3B& color, GLubyte opacity, const char* text, const char* fontName, float fontSize);
protected:
    std::string _text;
    std::string _fontName;
    float _fontSize;
    friend class RichText;
    
};
    
class CC_EX_DLL RichElementImage : public RichElement
{
public:
    RichElementImage(){_type = RICH_IMAGE;};
    virtual ~RichElementImage(){};
    virtual bool init(int tag, const ccColor3B& color, GLubyte opacity, const char* filePath);
    static RichElementImage* create(int tag, const ccColor3B& color, GLubyte opacity, const char* filePath);
protected:
    std::string _filePath;
    CCRect _textureRect;
    int _textureType;
    friend class RichText;
};
    
class CC_EX_DLL RichElementCustomNode : public RichElement
{
public:
    RichElementCustomNode(){_type = RICH_CUSTOM;};
    virtual ~RichElementCustomNode(){CC_SAFE_RELEASE(_customNode);};
    virtual bool init(int tag, const ccColor3B& color, GLubyte opacity, CCNode* customNode);
    static RichElementCustomNode* create(int tag, const ccColor3B& color, GLubyte opacity, CCNode* customNode);
protected:
    CCNode* _customNode;
    friend class RichText;
};

//add by sxin 增加支持手动换行
class CC_EX_DLL RichElementNewLine : public RichElement
{
public:
	RichElementNewLine(){_type = RICH_NEWLINE;};
	virtual ~RichElementNewLine(){};	
	static RichElementNewLine* create();
protected:	
	friend class RichText;
};

// add by sxin  增加点击响应基类
class CC_EX_DLL RichTouchElement : public RichElement
{
public:
	RichTouchElement();
	virtual ~RichTouchElement();
	virtual bool init(RichElement* pRichElement);
	static RichTouchElement* create(RichElement* pRichElement);
	bool isTouchInside(CCTouch* touch);
protected:		
	RichElement* m_RichElement;
	CCArray* _TouchNodes;
	friend class RichText;
};
    
class CC_EX_DLL RichText : public Widget
{
public:
    RichText();
    virtual ~RichText();
    static RichText* create();
    void insertElement(RichElement* element, int index);
    void pushBackElement(RichElement* element);
    void removeElement(int index);
    void removeElement(RichElement* element);
    virtual void visit();
    void setVerticalSpace(float space);
    virtual void setAnchorPoint(const CCPoint &pt);
    virtual const CCSize& getContentSize() const;
    void formatText();
    virtual void ignoreContentAdaptWithSize(bool ignore);
    virtual std::string getDescription() const;
	//add by sxin 扩展手动换行
	void pushNewLineElement();
	// add by sxin 扩展消息点击相应
	virtual void onTouchEnded(CCTouch *touch, CCEvent *unusedEvent);	
	void pushTouchElement(RichElement *element);

protected:
    virtual bool init();
    virtual void initRenderer();
    void pushToContainer(CCNode* renderer);
    void handleTextRenderer(const char* text, const char* fontName, float fontSize, const ccColor3B& color, GLubyte opacity);
    void handleImageRenderer(const char* fileParh, const ccColor3B& color, GLubyte opacity);
    void handleCustomRenderer(CCNode* renderer);
    void formarRenderers();
    void addNewLine();

	// add by sxin 从写点击响应的方法 需要把渲染层和RichElement关联
	void handleTouchTextRenderer(RichTouchElement* pRichTouchElement,const char* text, const char* fontName, float fontSize, const ccColor3B& color, GLubyte opacity);
	void handleTouchImageRenderer(RichTouchElement* pRichTouchElement,const char* fileParh, const ccColor3B& color, GLubyte opacity);
	void handleTouchCustomRenderer(RichTouchElement* pRichTouchElement,CCNode* renderer);

protected:
    bool _formatTextDirty;
    CCArray* _richElements;
    std::vector<CCArray*> _elementRenders;
    float _leftSpaceWidth;
    float _verticalSpace;
    CCNode* _elementRenderersContainer;	
};
    
}

NS_CC_END

#endif /* defined(__UIRichText__) */
