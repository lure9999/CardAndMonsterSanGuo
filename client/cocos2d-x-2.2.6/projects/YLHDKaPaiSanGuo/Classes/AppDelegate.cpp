#include "cocos2d.h"

extern "C" {
#include "tolua_fix.h"
}

#include "CCEGLView.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "Lua_extensions_CCB.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

#if ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
#include "PluginChannel.h"
#include "DataEye/android/include/DataEye.h"
#endif

#include "spine/Json.h"

//#include "platform/platform.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include<windows.h>
#endif

// add by:jjc
//#include "VideoPlatform.h"
#include "MyAssetsManager/UpdateManager.h"

//add by sxin 增加网络层
#include "network/networkcallback.h"

using namespace CocosDenshion;

USING_NS_CC;

#include "cocos-ext.h"
USING_NS_CC_EXT;


enum SharderKey{ 
	E_SharderKey_Normal=0,//正常
	E_SharderKey_Banish,//消除
	E_SharderKey_Blur,//模糊
	E_SharderKey_Frozen,//冻
	E_SharderKey_GrayScaling,//灰色
	E_SharderKey_Ice,//冰
	E_SharderKey_Invisible,//看不见
	E_SharderKey_Poison,//毒药
	E_SharderKey_SpriteGray,
	E_SharderKey_Stone,//石化
	E_SharderKey_RounIcon,//圆形图标
	E_SharderKey_RounIcon_Gray,//圆形图标+灰度
	E_SharderKey_Color_R,//修改图的r 值 等倍数修改
	E_SharderKey_Max,
};

enum NodeSharderType{ 
	E_CCNodeSharder_Sprite=0,
	E_CCNodeSharder_Armature,

};

void CCNodeSharder(CCNode* pNode,int iSharderKey,NodeSharderType NodeType,void* pData = NULL);

//add by sxin 增强Lua函数
int Log(lua_State* tolua_S)
{

	size_t value_len = 0;
	const char *name = NULL;
	name = lua_tolstring(tolua_S, 1, &value_len);

	//CCLuaLog(name);	
	// 发布版本。输出信息接口
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
		//CCLog(name);
	if(value_len < 32767)
	{
#if COCOS2D_DEBUG >= 1
		CCLuaLog(name);
#else
		if(value_len < 256)
		{
			CCLuaLog(name);
		}
#endif
	
	}
	else
	{
		CCLuaLog("Log:value_len error");  
	}

#endif


	return 1;
}


//add by sxin 增加暂停调试用
int Lua_Pause(lua_State *L)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
		
	
#if COCOS2D_DEBUG >= 1
	system("pause");

#endif	

#endif	

	return 0;
}


//add by sxin 增加时间差记录
//add by sxin 增加时间记录
//time_t g_start;  
//time_t g_end;

double g_start;
double g_end;

int BeginTime(lua_State *L)
{
	/*
	CCSprite *bg = CCSprite::create("Image/hero/head_icon/touxiang_diaochan.png");
	CCSprite *stencil = CCSprite::create("Image/hero/head_icon/1.png");

	CCClippingNode *clip = CCClippingNode::create();
	clip->setStencil(stencil);
	clip->addChild(bg);

	clip->setAnchorPoint(ccp(0,0));
	clip->setPosition(ccp(300,300));
	clip->setAlphaThreshold(GLfloat(0.5f));
	clip->setInverted(false);

	//CCSprite* tip = CCSprite::create("Image/main/btn_equip_h.png");  
	//tip->setPosition(ccp(visibleSize.width/2-70,visibleSize.height/2+50));  
	//this->addChild(tip,kTagTip);

	CCDirector::sharedDirector()->getRunningScene()->addChild(clip, 1000, 100);
	*/
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	//time(&g_start);  
	g_start = GetTickCount();
#endif
	return 0;
}

int EndTime(lua_State *L)
{	

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	double cost;  
	//time(&g_end);  	
	//cost=difftime(g_end,g_start); 
	g_end = GetTickCount(); 
	cost= g_end  - g_start;
	if(cost>=1)
	{
		printf("EndTime*****************%f*************\n",cost);
	}
#endif
	return 0;
}


cocos2d::CCRenderTexture* maskedMask(cocos2d::CCSprite* textureSprite, cocos2d::CCSprite* maskSprite, cocos2d::CCSize size)
{
	maskSprite->setPosition(CCPointMake(size.width/2, size.height/2)); 
	textureSprite->setPosition(CCPointMake(size.width/2, size.height/2));

	CCRenderTexture *rt = CCRenderTexture::create(size.width,size.height);


	ccBlendFunc blendFunc;
	blendFunc.src = GL_ONE;
	blendFunc.dst = GL_ZERO;
	maskSprite->setBlendFunc(blendFunc);

	ccBlendFunc blendFunc1;
	blendFunc1.src = GL_DST_ALPHA;
	blendFunc1.dst = GL_ZERO;
	textureSprite->setBlendFunc(blendFunc1);

	rt->begin();
	maskSprite->visit();
	textureSprite->visit();
	rt->end();
	return rt;
}

cocos2d::CCSprite* maskedMask_Sprite(cocos2d::CCSprite* textureSprite, cocos2d::CCSprite* maskSprite, cocos2d::CCSize size)
{
	CCRenderTexture* pRenderTexture = maskedMask(textureSprite,maskSprite,size);
	//rt->saveToFile("image-maskedMask.png", kCCImageFormatPNG);

	CCTexture2D *tex = pRenderTexture->getSprite()->getTexture();	

	CCSprite *sprite = CCSprite::createWithTexture(tex);

	sprite->setFlipY(true);

	pRenderTexture->release();

	return sprite;
}


// root, iconPath
int MakeMaskIcon(lua_State *tolua_S)
{
	CCSprite* root = (CCSprite*) tolua_tousertype(tolua_S,1,0);
	size_t value_len = 0;
	const char *path = NULL;
	path = lua_tolstring(tolua_S, 2, &value_len);

	int bgray =  tolua_tonumber(tolua_S,3,0);

	float fscale =  tolua_tonumber(tolua_S,4,0);
	const char *pathMask = NULL;
	pathMask = lua_tolstring(tolua_S, 5, &value_len);

	CCSprite* sprite = CCSprite::create(path);
	CCSprite* maskSprite = CCSprite::create(pathMask);
	sprite->setFlipY(true);
	sprite->setScale(fscale);
	maskSprite->setFlipY(true);
	maskSprite->setScale(fscale);
	
	if (bgray == 1)
	{
		CCNodeSharder(sprite,E_SharderKey_SpriteGray,E_CCNodeSharder_Sprite);
	}	

	CCRenderTexture* maskCal = maskedMask(sprite, maskSprite, sprite->getContentSize());			
	root->initWithTexture(maskCal->getSprite()->getTexture());	
	sprite->release();
	maskSprite->release();
	maskCal->release();	
	return 0;
}

int MakeRoundIcon(lua_State *tolua_S)
{
	CCSprite* root = (CCSprite*) tolua_tousertype(tolua_S,1,0);
	size_t value_len = 0;
	const char *path = NULL;
	path = lua_tolstring(tolua_S, 2, &value_len);

	int bgray =  tolua_tonumber(tolua_S,3,0);

	float fscale =  tolua_tonumber(tolua_S,4,0);

	CCSprite* sprite = CCSprite::create(path);

	sprite->setScale(fscale);

	if (bgray == 1)
	{
		CCNodeSharder(sprite,E_SharderKey_RounIcon_Gray,E_CCNodeSharder_Sprite);
	}
	else
	{
		CCNodeSharder(sprite,E_SharderKey_RounIcon,E_CCNodeSharder_Sprite);
	}	

	sprite->setAnchorPoint(ccp(0.5, 0.5));
	sprite->setPosition(ccp(root->getContentSize().width/2, root->getContentSize().height/2));

	root->addChild(sprite, 0, 100);	

	return 0;
}

void CCNodeSharder(CCNode* pNode,int iSharderKey,NodeSharderType NodeType,void* pData )
{
	if ( iSharderKey > 0 )
	{
		CCGLProgram *shader = new CCGLProgram();

		switch(iSharderKey)
		{
		case E_SharderKey_Banish:
			{
				shader->initWithVertexShaderFilename("Shaders/BanishShader.vsh", "Shaders/BanishShader.fsh");
			}
			break;
		case E_SharderKey_Blur:
			{
				//需要uniform vec2 blurSize;
				shader->initWithVertexShaderFilename("Shaders/Blur.vsh", "Shaders/Blur.fsh");				
			}
			break;
		case E_SharderKey_Frozen:
			{
				shader->initWithVertexShaderFilename("Shaders/FrozenShader.vsh", "Shaders/FrozenShader.fsh");
			}
			break;
		case E_SharderKey_GrayScaling:
			{
				shader->initWithVertexShaderFilename("Shaders/GrayScalingShader.vsh", "Shaders/GrayScalingShader.fsh");
			}
			break;
		case E_SharderKey_Ice:
			{
				shader->initWithVertexShaderFilename("Shaders/IceShader.vsh", "Shaders/IceShader.fsh");
			}
			break;
		case E_SharderKey_Invisible:
			{
				shader->initWithVertexShaderFilename("Shaders/InvisibleShader.vsh", "Shaders/InvisibleShader.fsh");
			}
			break;
		case E_SharderKey_Poison:
			{
				shader->initWithVertexShaderFilename("Shaders/PoisonShader.vsh", "Shaders/PoisonShader.fsh");
			}
			break;
		case E_SharderKey_SpriteGray:
			{
				shader->initWithVertexShaderFilename("Shaders/SpriteGray.vsh", "Shaders/SpriteGray.fsh");
			}
			break;
		case E_SharderKey_Stone:
			{
				shader->initWithVertexShaderFilename("Shaders/StoneShader.vsh", "Shaders/StoneShader.fsh");
			}
			break;
		case E_SharderKey_RounIcon:
		case E_SharderKey_RounIcon_Gray:
			{
				shader->initWithVertexShaderFilename("Shaders/RounIcon.vsh", "Shaders/RounIcon.fsh");
			}
			break;
		case E_SharderKey_Color_R:
			{
				shader->initWithVertexShaderFilename("Shaders/ColorRShader.vsh", "Shaders/ColorRShader.fsh");
			}
			break;
		default:
			{				
				shader->release();	
				return;
			}

			
		}


		shader->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		shader->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		shader->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
		shader->link();	
		shader->updateUniforms();

		//sharder 的参数设置
		if (iSharderKey == E_SharderKey_Blur)
		{
			GLint  blurLocation = shader->getUniformLocationForName("blurSize");

			if (blurLocation>0)
			{
				CCSize s = pNode->getContentSize();
				//写死模糊系数
				float fblur = 0.4f;
				CCPoint blur_ = ccp(1/s.width, 1/s.height);
				blur_ = ccpMult(blur_,fblur);				

				shader->setUniformLocationWith2f(blurLocation, blur_.x, blur_.y);
			}		
		}
		else if (iSharderKey == E_SharderKey_RounIcon)
		{
			
			GLint  IconParmLocation	= shader->getUniformLocationForName("IconParm");			

			if (IconParmLocation>0 )
			{
				CCSize s = pNode->getContentSize();		
				shader->setUniformLocationWith3f(IconParmLocation, s.width, s.height,0.0f);		
			}			
		}	
		else if (iSharderKey == E_SharderKey_RounIcon_Gray)
		{

			GLint  IconParmLocation	= shader->getUniformLocationForName("IconParm");			

			if (IconParmLocation>0 )
			{
				CCSize s = pNode->getContentSize();		
				shader->setUniformLocationWith3f(IconParmLocation, s.width, s.height,1.0f);		
			}			
		}	

		if (pNode)
		{
			pNode->setShaderProgram(shader);
		}
		shader->release();	
	}
	else
	{
		CCGLProgram *alphaTestShader = CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColor);
		if (pNode)
		{
			pNode->setShaderProgram(alphaTestShader);
		}		
	}	
}

int Lua_SpriteSharder(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCSprite",0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{

		CCSprite* self = (CCSprite*) tolua_tousertype(tolua_S,1,0);

		int iSharderKey =  tolua_tonumber(tolua_S,2,0);	

		CCNodeSharder(self,iSharderKey,E_CCNodeSharder_Sprite);		

	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_SpriteSharder'.",&tolua_err);
	}
	return 0;
}

int Lua_CCArmatureSharder(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCArmature",0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{

		CCArmature* self = (CCArmature*) tolua_tousertype(tolua_S,1,0);

		int iSharderKey =  tolua_tonumber(tolua_S,2,0);		

		CCNodeSharder(self,iSharderKey,E_CCNodeSharder_Armature);		

	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_CCArmatureSharder'.",&tolua_err);
	}
	return 0;
}

int SpriteSetGray(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCSprite",0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{
		CCSprite* self = (CCSprite*)  tolua_tousertype(tolua_S,1,0);

		int igray =  tolua_tonumber(tolua_S,2,0);

		if (igray>0)
		{
			CCNodeSharder(self,E_SharderKey_SpriteGray,E_CCNodeSharder_Sprite);
		}
		else
		{
			CCNodeSharder(self,E_SharderKey_Normal,E_CCNodeSharder_Sprite);
		}
				
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'SpriteSetGray'.",&tolua_err);
	}

	return 0;

}
//增加描边 celina
class StrokeLabel : public ui::Layout
{
public:
	int fontSize;
	const char* fontName;	
	const char* fontText;
	CCPoint posFont;
	ccColor3B* strokeColor;//描边的颜色
	ccColor3B* textColor;//文本的颜色
	bool	isCenter;//是否居中
	float 	strokeSize;//描边的大小

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	CCLabelTTF* m_pCenterLabel;
#else
	CCLabelTTF* m_pCenterLabel;
	CCLabelTTF* m_pUpLabel;
	CCLabelTTF* m_pDownLabel;
	CCLabelTTF* m_pLeftLabel;
	CCLabelTTF* m_pRightLabel;
#endif


	CREATE_FUNC(StrokeLabel);
	void SetStokeData(int iFsize, const char* sFontName, const char* sFontText,CCPoint* pos, ccColor3B* sColor, ccColor3B* tColor,bool bCenter, float iSize)
	{
		fontSize = iFsize;
		fontName = sFontName;
		fontText = sFontText;
		posFont = *pos;
		strokeColor = sColor;
		textColor = tColor;
		isCenter = bCenter;
		strokeSize = iSize;
		DrawStokeLabel();
	}
	bool init()
	{
		if ( !ui::Layout::init() )
		{
			return false;
		}
		
		return true;
	};
	void DrawStokeLabel()
	{		

		//中间
		m_pCenterLabel = CCLabelTTF::create(fontText, fontName , fontSize); 

		setPosition(posFont);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 )
		m_pCenterLabel->setColor(*textColor);
		//描边上
		m_pUpLabel = CCLabelTTF::create(fontText, fontName , fontSize); 
		m_pUpLabel->setColor(*strokeColor);
		m_pUpLabel->setPosition(ccp(0, strokeSize));  
		//描边下
		m_pDownLabel = CCLabelTTF::create(fontText, fontName , fontSize); 
		m_pDownLabel->setColor(*strokeColor);  
		m_pDownLabel->setPosition(ccp(0, -strokeSize));  

		//描边左
		m_pLeftLabel = CCLabelTTF::create(fontText, fontName , fontSize); 
		m_pLeftLabel->setColor(*strokeColor);  
		m_pLeftLabel->setPosition(ccp(-strokeSize, 0));  

		//描边右边
		m_pRightLabel = CCLabelTTF::create(fontText, fontName , fontSize); 
		m_pRightLabel->setColor(*strokeColor);  
		m_pRightLabel->setPosition(ccp(strokeSize, 0));  


		if ( isCenter==false ) 
		{
			m_pCenterLabel->setAnchorPoint(ccp(0,0.5));
			m_pUpLabel->setAnchorPoint(ccp(0,0.5));
			m_pDownLabel->setAnchorPoint(ccp(0,0.5));
			m_pLeftLabel->setAnchorPoint(ccp(0,0.5));
			m_pRightLabel->setAnchorPoint(ccp(0,0.5));
			//upLabel:setAnchorPoint(ccp(0,0.5));
			//downLabel:setAnchorPoint(ccp(0,0.5));
			//leftLabel:setAnchorPoint(ccp(0,0.5));
			//rightLabel:setAnchorPoint(ccp(0,0.5));
			//setAnchorPoint(ccp(0,0.5));

		};


		addNode(m_pUpLabel,0);
		addNode(m_pDownLabel,0);
		addNode(m_pLeftLabel,0);
		addNode(m_pRightLabel,0);
		addNode(m_pCenterLabel,0);
#else
		m_pCenterLabel->setFontFillColor(*textColor);
		m_pCenterLabel->enableStroke(*strokeColor,strokeSize*2);
		if (  isCenter == false )  

		{
			m_pCenterLabel->setAnchorPoint(ccp(0,0.5));
		}
		addNode(m_pCenterLabel,0);

#endif

	};
	void SetStokeText(const char* sText)

	{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS ||  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

		m_pCenterLabel->setString(sText);
#else

		m_pCenterLabel->setString(sText);
		m_pUpLabel->setString(sText);
		m_pDownLabel->setString(sText);
		m_pRightLabel->setString(sText);
		m_pLeftLabel->setString(sText);

#endif
	};
	const char* GetStokeText()
	{
		return m_pCenterLabel->getString();
	};
	//只改变字体的颜色
	void SetStokeColor(ccColor3B colorFont)
	{
		m_pCenterLabel->setColor(colorFont);
	}
	void SetStokeOpacity(int nOpeacity)
	{
		m_pCenterLabel->setOpacity(nOpeacity);
	}
};

int Lua_createStrokeLabel(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isnumber(tolua_S,1,0,&tolua_err) &&
		tolua_isstring(tolua_S, 2,0,&tolua_err) &&
		tolua_isstring(tolua_S, 3,0,&tolua_err) &&	
		tolua_isusertype(tolua_S,4,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,5,"ccColor3B",0,&tolua_err) &&
		tolua_isusertype(tolua_S,6,"ccColor3B",0,&tolua_err) &&
		tolua_isboolean(tolua_S,7,0,&tolua_err) &&		
		tolua_isnumber(tolua_S,8,0,&tolua_err) )
	{
		int FontSize = tolua_tonumber(tolua_S,1,0);

		const char* FontName = tolua_tostring(tolua_S, 2,0);

		const char* FontText = tolua_tostring(tolua_S, 3,0);
		CCPoint* posF = (CCPoint*)tolua_tousertype(tolua_S, 4,0);
	
		ccColor3B* colorFontside = (ccColor3B*) tolua_tousertype(tolua_S,5,0);
		ccColor3B*  colorFont = (ccColor3B*) tolua_tousertype(tolua_S, 6,0);

		bool isCenter = tolua_toboolean(tolua_S,7,0);
	
		float sideOff = (float)tolua_tonumber(tolua_S,8,0);
		

		StrokeLabel* tolua_ret = (StrokeLabel*)  StrokeLabel::create();
		tolua_ret->SetStokeData(FontSize,FontName,FontText,posF,colorFontside,colorFont,isCenter,sideOff);

		int nID = (tolua_ret) ? (int)tolua_ret->m_uID : -1;
		int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
		toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"Layout");

	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_createStrokeLabel'.",&tolua_err);
		return 0;
	}
	return 1;
}
int Lua_SetStrokeText(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isusertype(tolua_S,1,"Layout",0,&tolua_err) &&
		tolua_isstring(tolua_S, 2,0,&tolua_err) )
	{
		 ui::Layout* pStokeLabel = ( ui::Layout*) tolua_tousertype(tolua_S,1,0);
		const char* sValue = (const char*)tolua_tostring(tolua_S,2,0);

		((StrokeLabel*)(pStokeLabel))->SetStokeText(sValue);
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_SetStrokeText'.",&tolua_err);
	}
	return 0;
};
int Lua_GetStrokeText(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isusertype(tolua_S,1,"Layout",0,&tolua_err) )
	{
		 ui::Layout* pStokeLabel = ( ui::Layout*) tolua_tousertype(tolua_S,1,0);
		const char* str_ret =  ((StrokeLabel*)pStokeLabel)->GetStokeText();
		tolua_pushstring(tolua_S,str_ret);
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_GetStrokeText'.",&tolua_err);
		return 0;
	}
	return 1;
};
int Lua_SetStrokeTextColor(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isusertype(tolua_S,1,"Layout",0,&tolua_err) &&
		tolua_isusertype(tolua_S,2,"ccColor3B",0,&tolua_err))
	{
		 ui::Layout* pStokeLabel = ( ui::Layout*) tolua_tousertype(tolua_S,1,0);

		 if (pStokeLabel)
		 {
			 ccColor3B* colorFont = (ccColor3B*) tolua_tousertype(tolua_S, 2,0);
			 ((StrokeLabel*)pStokeLabel)->SetStokeColor(*colorFont);
		 }
		 else
		 {			
			tolua_error(tolua_S,"invalid 'pStokeLabel' in function 'Lua_SetStrokeTextColor'", NULL);
		 }		
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_SetStrokeTextColor'.",&tolua_err);
	}
	return 0;
};
int Lua_SetStrokeOpacity(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isusertype(tolua_S,1,"Layout",0,&tolua_err) &&
		tolua_isnumber(tolua_S,2,0,&tolua_err))
	{
		ui::Layout* pStokeLabel = ( ui::Layout*) tolua_tousertype(tolua_S,1,0);

		if (pStokeLabel)
		{
			int iOpercity =  tolua_tonumber(tolua_S,2,0);	
			((StrokeLabel*)pStokeLabel)->SetStokeOpacity(iOpercity);
		}
		else
		{			
			tolua_error(tolua_S,"invalid 'pStokeLabel' in function 'Lua_SetStrokeTextColor'", NULL);
		}		
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_SetStrokeTextColor'.",&tolua_err);
	}
	return 0;
};

int Lua_Scale9SpriteSetGray(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCScale9Sprite",0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{

		CCScale9Sprite* self = (CCScale9Sprite*) tolua_tousertype(tolua_S,1,0);

		int igray =  tolua_tonumber(tolua_S,2,0);		

		CCSpriteBatchNode* pscale9Image = self->getscale9Image();
		
		if (igray>0)
		{
			CCNodeSharder(pscale9Image,E_SharderKey_SpriteGray,E_CCNodeSharder_Sprite);
		}
		else
		{
			CCNodeSharder(pscale9Image,E_SharderKey_Normal,E_CCNodeSharder_Sprite);
		}			
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_SpriteSharder'.",&tolua_err);
	}
	return 0;
}

int SpriteSetRoundIcon(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCSprite",0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{
		CCSprite* self = (CCSprite*)  tolua_tousertype(tolua_S,1,0);

		int igray =  tolua_tonumber(tolua_S,2,0);

		if (igray>0)
		{
			CCNodeSharder(self,E_SharderKey_RounIcon,E_CCNodeSharder_Sprite);
		}
		else
		{
			CCNodeSharder(self,E_SharderKey_Normal,E_CCNodeSharder_Sprite);
		}

	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'SpriteSetRoundIcon'.",&tolua_err);
	}

	return 0;

}



//增加Lua_pauseSchedulerAndActions

int Lua_pauseSchedulerAndActions(lua_State* tolua_S)
{
	
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCNode",0,&tolua_err)  )
	{
		CCNode* self = (CCNode*)  tolua_tousertype(tolua_S,1,0);

		self->pauseSchedulerAndActions();
		
	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_pauseSchedulerAndActions'.",&tolua_err);
	}

	return 0;

}

int Lua_resumeSchedulerAndActions(lua_State* tolua_S)
{

	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"CCNode",0,&tolua_err)  )
	{
		CCNode* self = (CCNode*)  tolua_tousertype(tolua_S,1,0);

		self->resumeSchedulerAndActions();

	}
	else
	{
		tolua_error(tolua_S,"#ferror in function 'Lua_resumeSchedulerAndActions'.",&tolua_err);
	}

	return 0;

}

class DrawAddPoly : public CCLayer
{
public:
	CCPoint m_pt1;
	CCPoint m_pt2;
	CCPoint m_pt3;
	CCPoint m_pt4;
	CCPoint m_pt5;
	CCPoint m_pt6;
	CCPoint m_pt7;
	CCPoint m_pt8;
	ccColor3B m_cColor;
	ccColor3B m_cColorSide;
	float	m_fA;
	CREATE_FUNC(DrawAddPoly);
	void SetPoint(CCPoint* pt1, CCPoint* pt2, CCPoint* pt3, CCPoint* pt4, CCPoint* pt5, CCPoint* pt6, CCPoint* pt7, CCPoint* pt8, ccColor3B* color, ccColor3B* colorside, float fA)
	{
		m_pt1 = *pt1;
		m_pt2 = *pt2;
		m_pt3 = *pt3;
		m_pt4 = *pt4;
		m_pt5 = *pt5;
		m_pt6 = *pt6;
		m_pt7 = *pt7;
		m_pt8 = *pt8;
		m_cColor = *color;
		m_cColorSide = *colorside;
		m_fA = fA;
	}
	bool init()
	{
		if ( !CCLayer::init() )
		{
			return false;
		}
		return true;
	};
	virtual void draw()
	{
		ccDrawColor4B(m_cColorSide.r, m_cColorSide.g, m_cColorSide.b, 255);
		CHECK_GL_ERROR_DEBUG();
		CCPoint vertices8[] = {ccp(m_pt1.x, m_pt1.y), ccp(m_pt2.x, m_pt2.y), ccp(m_pt3.x, m_pt3.y), ccp(m_pt4.x, m_pt4.y),
							ccp(m_pt5.x, m_pt5.y), ccp(m_pt6.x, m_pt6.y), ccp(m_pt7.x, m_pt7.y), ccp(m_pt8.x, m_pt8.y)};
		ccColor4F c4f = ccc4FFromccc3B(m_cColor);
		c4f.a = m_fA;
		ccDrawSolidPoly( vertices8, 8, c4f );
		ccDrawPoly( vertices8, 8, true);

		ccDrawColor4B(255,255,255,255);
		CHECK_GL_ERROR_DEBUG();
	};
};

int Lua_AddPoly(lua_State* tolua_S)
{
	tolua_Error tolua_err;	
	if (tolua_isusertype(tolua_S,1,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,2,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,3,"CCPoint",0,&tolua_err) &&
		tolua_isusertype(tolua_S,4,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,5,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,6,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,7,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,8,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,9,"ccColor3B",0,&tolua_err) && 
		tolua_isusertype(tolua_S,10,"ccColor3B",0,&tolua_err) && 
		tolua_isnumber(tolua_S,11,0,&tolua_err)
		//tolua_isusertype(tolua_S,8, "Layer",0, &tolua_err)
		)
	{
		CCPoint* pt1 = (CCPoint*) tolua_tousertype(tolua_S, 1,0);
		CCPoint* pt2 = (CCPoint*) tolua_tousertype(tolua_S, 2,0);
		CCPoint* pt3 = (CCPoint*) tolua_tousertype(tolua_S, 3,0);
		CCPoint* pt4 = (CCPoint*) tolua_tousertype(tolua_S, 4,0);
		CCPoint* pt5 = (CCPoint*) tolua_tousertype(tolua_S, 5,0);
		CCPoint* pt6 = (CCPoint*) tolua_tousertype(tolua_S, 6,0);
		CCPoint* pt7 = (CCPoint*) tolua_tousertype(tolua_S, 7,0);
		CCPoint* pt8 = (CCPoint*) tolua_tousertype(tolua_S, 8,0);
		ccColor3B* color = (ccColor3B*) tolua_tousertype(tolua_S, 9,0);
		ccColor3B* colorside = (ccColor3B*) tolua_tousertype(tolua_S, 10,0);
		float nA =  (float) tolua_tonumber(tolua_S,11,0);
		DrawAddPoly* tolua_ret = (DrawAddPoly*)  DrawAddPoly::create();
		tolua_ret->SetPoint(pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8, color, colorside, nA);
		int nID = (tolua_ret) ? (int)tolua_ret->m_uID : -1;
		int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
		toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"CCLayer");
		return 1;
	}
	return 0;
}
// add by sxin 增加划线功能
class DrawAddLine : public CCLayer
{
public:
	CCPoint m_pt1;
	CCPoint m_pt2;	
	ccColor3B m_cColor;
	float	m_flineWidth;
	float	m_fA;
	CREATE_FUNC(DrawAddLine);
	void SetData(CCPoint* pt1, CCPoint* pt2, ccColor3B* color, float flineWidth, float fA)
	{
		m_pt1 = *pt1;
		m_pt2 = *pt2;
		m_cColor = *color;
		m_flineWidth = flineWidth;
		m_fA = fA;
	}
	bool init()
	{
		if ( !CCLayer::init() )
		{
			return false;
		}
		return true;
	};
	virtual void draw()
	{		
		CHECK_GL_ERROR_DEBUG();
	
		glLineWidth( m_flineWidth ); 
	
		ccDrawColor4B(m_cColor.r, m_cColor.g, m_cColor.b, m_fA);

		ccDrawLine( m_pt1, m_pt2 ); 
		
		CHECK_GL_ERROR_DEBUG();
	};
};

int Lua_AddLine(lua_State* tolua_S)
{
	tolua_Error tolua_err;	
	if (tolua_isusertype(tolua_S,1,"CCPoint",0,&tolua_err) && 
		tolua_isusertype(tolua_S,2,"CCPoint",0,&tolua_err) && 	
		tolua_isusertype(tolua_S,3,"ccColor3B",0,&tolua_err) && 
		tolua_isnumber(tolua_S,4,0,&tolua_err) && 
		tolua_isnumber(tolua_S,5,0,&tolua_err)		
		)
	{
		CCPoint* pt1 = (CCPoint*) tolua_tousertype(tolua_S, 1,0);
		CCPoint* pt2 = (CCPoint*) tolua_tousertype(tolua_S, 2,0);	
		ccColor3B* color = (ccColor3B*) tolua_tousertype(tolua_S, 3,0);
		float flineWidth =  (float) tolua_tonumber(tolua_S,4,0);
		float nA =  (float) tolua_tonumber(tolua_S,5,0);

		DrawAddLine* tolua_ret = (DrawAddLine*)  DrawAddLine::create();
		tolua_ret->SetData(pt1, pt2, color, flineWidth, nA);
		int nID = (tolua_ret) ? (int)tolua_ret->m_uID : -1;
		int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
		toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"CCLayer");
		return 1;
	}
	return 0;
}

int Lua_UIntTrans(lua_State* tolua_S)
{

	tolua_Error tolua_err;
	if ( tolua_isnumber(tolua_S,1,0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) && tolua_isnumber(tolua_S,3,0,&tolua_err) && tolua_isusertype(tolua_S,4,"CCArray",0,&tolua_err))
	{
		unsigned int nData = (unsigned int)tolua_tonumber(tolua_S, 1, 0);
		int nDis = (int)tolua_tonumber(tolua_S, 2, 0);
		int nOffset = (int)tolua_tonumber(tolua_S, 3, 0);
		CCArray *nArr = (CCArray*)tolua_tousertype(tolua_S,4,0);
		
		int tmpOffSet = 0;
		while(1)
		{
			int a = ((nData >> tmpOffSet) & nOffset);
			nArr->addObject(CCInteger::create(a));
			tmpOffSet += nDis;

			if(tmpOffSet >= 32)
				break;
		}
	}

	return 0;
}

int Lua_IntTrans(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isnumber(tolua_S,1,0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) && tolua_isnumber(tolua_S,3,0,&tolua_err) && tolua_isusertype(tolua_S,4,"CCArray",0,&tolua_err))
	{
		int nData = (int)tolua_tonumber(tolua_S, 1, 0);
		int nDis = (int)tolua_tonumber(tolua_S, 2, 0);
		int nOffset = (int)tolua_tonumber(tolua_S, 3, 0);
		CCArray *nArr = (CCArray*)tolua_tousertype(tolua_S,4,0);

		int tmpOffSet = 0;
		while(1)
		{
			int a = ((nData >> tmpOffSet) & nOffset);
			nArr->addObject(CCInteger::create(a));
			tmpOffSet += nDis;

			if(tmpOffSet >= 32)
				break;
		}
	}

	return 0;
}

//Add By YanQing.Yang__检测周几开放
int Lua_CheckOpenWeekDay(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if ( tolua_isnumber(tolua_S,1,0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{
		int nOpenWeekDay = (int)tolua_tonumber(tolua_S, 1, 0);
		int nMaskWeekDay = (int)tolua_tonumber(tolua_S, 2, 0) - 1;
		if(nMaskWeekDay>6 || nMaskWeekDay<0)
		{
			CCLOG("MaskWeekDay Error");
		}
		
		//int nRet = nOpenWeekDay & (1<<nMaskWeekDay);
		int nRet = nOpenWeekDay>>nMaskWeekDay&1;
		//CCLOG("OpenWeekDay = %d\tMaskDay = %d\tResult = %d", nOpenWeekDay, nMaskWeekDay, nRet);
		tolua_pushnumber(tolua_S, nRet);
		return 1;
	}
	return 0;
}

//add by sxin 支持ui编辑器播放ccfade 动画
int Lua_WidgetSetOpacity(lua_State* tolua_S)
{
	tolua_Error tolua_err;
	if (tolua_isusertype(tolua_S,1,"Widget",0,&tolua_err) && tolua_isnumber(tolua_S,2,0,&tolua_err) )
	{
		cocos2d::ui::Widget* self = (cocos2d::ui::Widget*)tolua_tousertype(tolua_S,1,0);
		GLubyte opacity = ((GLubyte) (int)  tolua_tonumber(tolua_S,2,0));
		{
			self->setWidgetOpacity(opacity);
		}
	}
	return 0;
}
//add celina 获得当前平台 1,代表 ios，2代表android
int Lua_GetPlatform(lua_State *L)
{
//	int i_platfrom = 0 ;
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
//	i_platfrom = 1;
//	tolua_pushnumber(L, i_platfrom);
//	return 1;
//	
//#endif
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//	i_platfrom = 2;
//	tolua_pushnumber(L, i_platfrom);
//	return 1;
//#endif
	
	int i_platfrom = CC_TARGET_PLATFORM ;
	tolua_pushnumber(L, i_platfrom);
	return 1;
};

AppDelegate::AppDelegate()
{
	m_pLastUpdate = new struct cocos2d::cc_timeval();
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();

	if (g_UpdateManager)
	{
		delete g_UpdateManager;
		g_UpdateManager = NULL;
	}

	if (g_NetWork)
	{
		delete g_NetWork;
		g_NetWork = NULL;
	}
	// delete m_pLastUpdate
	CC_SAFE_DELETE(m_pLastUpdate);
}

bool AppDelegate::applicationDidFinishLaunching()
{
	// As an example, load config file
	// XXX: This should be loaded before the Director is initialized,
	// XXX: but at this point, the director is already initialized
	//CCConfiguration::sharedConfiguration()->loadConfigFile("configs/config_YLHDSanGuoGame.plist");
	

    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();

	//add by sxin 修改触摸方式
	// single touchDispatcher
	m_pSingleTouchDispatcher = new SingleDispatcher();
	m_pSingleTouchDispatcher->init();
	pDirector->setTouchDispatcher(m_pSingleTouchDispatcher);


    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());

    // turn on display FPS
    pDirector->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

	//add by sxin 增加自动适应分辨率
	CCSize screenSize = CCEGLView::sharedOpenGLView()->getFrameSize();

	CCLOG("ScreenSize width:%f,height:%f", screenSize.width,screenSize.height);

	CCSize designSize;
		
	designSize = CCSizeMake(1140.0f, 640.0f); 

	float fScanScreen = screenSize.width/screenSize.height;
	float fScanDes = designSize.width/designSize.height;
	float fScanMinX = 960.0f;
	float fScanMinY= 640.0f;
	float fScanD = designSize.width/designSize.height;


	if ( fScanScreen*fScanMinY < fScanMinX)
	{			
		CCEGLView::sharedOpenGLView()->setDesignResolutionSize(designSize.width,designSize.height, kResolutionFixedStandard_4s);		
	}
	else 
	{		
		CCEGLView::sharedOpenGLView()->setDesignResolutionSize(designSize.width,designSize.height, kResolutionNoBorder);
	}
	//end

    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    CCLuaStack *pStack = pEngine->getLuaStack();
    lua_State *tolua_s = pStack->getLuaState();
    tolua_extensions_ccb_open(tolua_s);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    pStack = pEngine->getLuaStack();
    tolua_s = pStack->getLuaState();
    tolua_web_socket_open(tolua_s);
#endif

// add by sxin for dataeye
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
	pStack = pEngine->getLuaStack();
	tolua_s = pStack->getLuaState();
	luaopen_DataEye(tolua_s);
#endif

	
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_BLACKBERRY)
    CCFileUtils::sharedFileUtils()->addSearchPath("script");
#endif

	//add by sxin 注册战斗的lua接口
	lua_register(tolua_s,"Log",Log);
	lua_register(tolua_s,"BeginTime",BeginTime);
	lua_register(tolua_s,"EndTime",EndTime);
	lua_register(tolua_s,"SpriteSetGray",SpriteSetGray);
	lua_register(tolua_s,"Scale9SpriteSetGray",Lua_Scale9SpriteSetGray);	

	lua_register(tolua_s,"MakeRoundIcon",MakeRoundIcon);
	lua_register(tolua_s,"MakeMaskIcon",MakeMaskIcon);

	lua_register(tolua_s,"SpriteSharder",Lua_SpriteSharder);	
	lua_register(tolua_s,"CCArmatureSharder",Lua_CCArmatureSharder);	



	lua_register(tolua_s,"Pause",Lua_Pause);
	lua_register(tolua_s,"pauseSchedulerAndActions",Lua_pauseSchedulerAndActions);
	lua_register(tolua_s,"resumeSchedulerAndActions",Lua_resumeSchedulerAndActions);

	lua_register(tolua_s,"WidgetSetOpacity",Lua_WidgetSetOpacity);
	lua_register(tolua_s,"AddPoly",Lua_AddPoly);
	lua_register(tolua_s, "CheckOpenWeekDay", Lua_CheckOpenWeekDay);
	lua_register(tolua_s,"AddLine",Lua_AddLine);
	lua_register(tolua_s,"UIntTrans",Lua_UIntTrans);
	lua_register(tolua_s,"IntTrans",Lua_IntTrans);
	lua_register(tolua_s,"createStrokeLabelNew",Lua_createStrokeLabel);	
	lua_register(tolua_s,"SetStrokeText",Lua_SetStrokeText);		
	lua_register(tolua_s,"GetStrokeText",Lua_GetStrokeText);	
	lua_register(tolua_s,"SetStrokeTextColor",Lua_SetStrokeTextColor);	
	lua_register(tolua_s,"SetStrokeOpacity",Lua_SetStrokeOpacity);	
	lua_register(tolua_s,"GetPlatform",Lua_GetPlatform);
	
	//add by sxin 增加网络接口
	//CNetWork::CreatNetWork();
	g_NetWork = new CNetWork();	
	g_NetWork->init();


	g_UpdateManager = new UpdateManager();

	//add by sxin 
	//anysdk初始化
#if ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
	pDirector->setDisplayStats(false);
	PluginChannel::getInstance()->loadPlugins();	
	CCLOG("Lua_AnySDK_loadPlugins");
#endif


	//自动更新相关。暂时注掉
	//std::string pathToSave = CCFileUtils::sharedFileUtils()->getWritablePath();
	//pathToSave[pathToSave.length()-1] = '/';
	////pathToSave += "new_res/";
	//std::vector<std::string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
	//std::vector<std::string>::iterator iter = searchPaths.begin();
	//searchPaths.insert(iter, pathToSave);
	//CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);

#if ( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

	//std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("Script/Login/StartScene.lua");
	//pEngine->executeScriptFile(path.c_str());
	std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("Script/Login/StartLoadingScene.lua");
	pEngine->executeScriptFile(path.c_str());

#else
	//std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("Script/Login/StartScene.lua");
	//pEngine->executeScriptFile("Script/Login/StartScene.lua");
	pEngine->executeScriptFile("Script/Login/StartLoadingScene.lua");
#endif

	// play cg add by jjc
	//VideoPlatform::playVideo("video.mp4");
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();

    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();

	CCDirector *pDirector = CCDirector::sharedDirector();
	//add by sxin 修改触摸方式
	// single touchDispatcher	
	SingleDispatcher* pSingleDispatcher = dynamic_cast<SingleDispatcher*>(pDirector->getTouchDispatcher()); 
	pSingleDispatcher->ClearState();



	//#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	//	//test 切出去就退出
	//	CCDirector::sharedDirector()->end();
	//#endif
	calculateDeltaTime();
	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();

	if (pEngine)
	{
		CCLuaStack *pStack = pEngine->getLuaStack();
		lua_State *tolua_s = pStack->getLuaState();
		lua_getglobal(tolua_s, "Lua_EnterBackground");       /* query function by name, stack: function */	
		if (!lua_isfunction(tolua_s, -1))
		{
			lua_pop(tolua_s, 1);
			return ;
		}	
		pStack->executeFunction(0);	
		pStack->clean();
	}
		

}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();

    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();

	CCLuaEngine* pEngine = ( CCLuaEngine*) CCScriptEngineManager::sharedManager()->getScriptEngine();
	calculateDeltaTime();
	if (pEngine)
	{
		CCLuaStack *pStack = pEngine->getLuaStack();
		lua_State *tolua_s = pStack->getLuaState();
		lua_getglobal(tolua_s, "Lua_EnterForeground");       /* query function by name, stack: function */	
		if (!lua_isfunction(tolua_s, -1))
		{
			lua_pop(tolua_s, 1);
			return ;
		}	
		pStack->pushFloat(m_fDeltaTime);
		pStack->executeFunction(1);	
		pStack->clean();
	}
	
}

void AppDelegate::calculateDeltaTime(void)
{
	struct cc_timeval now;

	if (CCTime::gettimeofdayCocos2d(&now, NULL) != 0)
	{
		CCLOG("error in gettimeofday");
		m_fDeltaTime = 0;
		return;
	}

	// new delta time. Re-fixed issue #1277
	if (m_bNextDeltaTimeZero)
	{
		m_fDeltaTime = 0;
		m_bNextDeltaTimeZero = false;
	}
	else
	{
		m_fDeltaTime = (now.tv_sec - m_pLastUpdate->tv_sec) + (now.tv_usec - m_pLastUpdate->tv_usec) / 1000000.0f;
		m_fDeltaTime = MAX(0, m_fDeltaTime);
	}

	*m_pLastUpdate = now;
}
float AppDelegate::getDeltaTime()
{
	return m_fDeltaTime;
}
