

module("guide", package.seeall)

require "Script/serverDB/guidedata"

local enterMain 
local enterGuide


local layer_guide = nil
local pRt = nil
local g_propertyTag = nil
local function setHighLightRect(rect)
	local pMask = CCSprite:create("Image/guide/bg.png")
	pMask:setPosition(ccp(rect.origin.x,rect.origin.y))
	pMask:setAnchorPoint(ccp(0,0))
	pMask:setScaleX(rect.size.width/pMask:getContentSize().width)
	pMask:setScaleY(rect.size.height/pMask:getContentSize().height)
	local blend = ccBlendFunc()
	blend.src = GL_ZERO
	blend.dst = GL_ONE_MINUS_SRC_ALPHA
	pMask:setBlendFunc(blend)
	pRt:clear(0,0,0,0.9)
	pRt:begin()
	pMask:visit()
	pRt:endToLua()
	
	
end

--参数说明 rect 高亮的区域 property(1表示强制，0表示非强制)
function mainImpl(rect,property)
	print("mainImpl")
    layer_guide = CCLayer:create()
	g_propertyTag = property
	local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
	print(CommonData.g_sizeVisibleSize.width)
	pRt = CCRenderTexture:create(CommonData.g_nDeginSize_Width,CommonData.g_nDeginSize_Height)
	local touchRect = nil
	if g_propertyTag == 0 then
		touchRect = CCRectMake(0,0,CommonData.g_nDeginSize_Width,CommonData.g_nDeginSize_Height)
	else 
		touchRect = rect
	end
	if touchRect== nil then
		--print("399999999999999999999999999999999")
	end
	--print("lololo"..rect.origin.x)
	local listener = function (eventType,x,y) 
		if(eventType == "began") then
            if(touchRect == nil) then                          
                --[[if(touchCallback ~= nil) then
                    touchCallback()
                end]]--
                return true
            else
                if(touchRect:containsPoint(ccp(x,y))) then
					require "Script/Guide/GuideManager"
					GuideManager.checkGuideEnd()
					--print("ssssssssssssss")
                    return false
                else
                   --[[ if(touchCallback ~= nil) then
                        touchCallback()
                    end]]--
                    return true
                end
            end
        end
        print(eventType)
	end
	layer_guide:registerScriptTouchHandler(listener,false,-999999, true)
	layer_guide:setTouchEnabled(true)
	
	local color = ccc3(0,0,0)
	local opacity = nil
	if touchRect== nil then
		opacity = 0
	else
		opacity = 0.6
	end
	pRt:clear(color.r, color.g, color.b, opacity)
	pRt:setPosition(ccp(CommonData.g_nDeginSize_Width/2,CommonData.g_nDeginSize_Height/2))
	layer_guide:addChild(pRt)
	setHighLightRect(touchRect)
	--添加箭头
	local sprite_arrow = CCSprite:create("Image/guide/arrow.png")
	sprite_arrow:setPosition(ccp(rect.origin.x-sprite_arrow:getContentSize().width/2,rect.origin.y+sprite_arrow:getContentSize().height))
	layer_guide:addChild(sprite_arrow)
	--enterGuide()
	return layer_guide
end

local function guideImpl()
	--enterMain()
	print("guideImpl")
end

local g_MainThread = coroutine.create(mainImpl)
local g_GuideThread = coroutine.create(guideImpl)
function enterMain()
	coroutine.yield()
	
	coroutine.resume(g_MainThread)
end
function enterGuide()
	--coroutine.yield()
	coroutine.resume(g_GuideThread)
	--guideImpl()
end
