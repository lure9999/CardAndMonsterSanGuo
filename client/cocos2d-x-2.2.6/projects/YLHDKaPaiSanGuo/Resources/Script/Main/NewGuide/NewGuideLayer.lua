

--新手引导层 celina
module("NewGuideLayer", package.seeall)



--对象
local pGuideTouchGroup = nil 
local pNewGuideLayer = nil 
local img_guide = nil
local bFight = false
local m_Now_CallBack = nil 


function GetNewGuideTouchGroup()
	return pGuideTouchGroup
end

function GetNewGuideLayer()
	return pNewGuideLayer
end

--[[local function InitVars()
	pGuideTouchGroup = nil 
end]]--

function DeleteNewGuideTouchGroup()
	pGuideTouchGroup:removeFromParentAndCleanup(true)	
	pGuideTouchGroup = nil
end

function GetGuideIcon()
	if pNewGuideLayer:getChildByTag(500)~=nil then
		return pNewGuideLayer:getChildByTag(500)
	end
	return nil 
end
function AddGuideIcon(pos)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	local GuideAnimation = CCArmature:create("zhiyin01")
	GuideAnimation:getAnimation():play("Animation1")
	
	local layout = Layout:create()
	layout:setSize(CCSize(120,120))
	GuideAnimation:setPosition(ccp(60,60))
	layout:addNode(GuideAnimation)
	layout:setPosition(ccp(pos.x-60,pos.y-60))
	pNewGuideLayer:addChild(layout,500,500)
end



--[[function SetColorOpacity(nOpacity)
	if pNewGuideLayer~=nil then
		pNewGuideLayer:setBackGroundColorOpacity(nOpacity)
	end
end]]--

function DeleteGuide()
	if pNewGuideLayer~=nil then
		if pNewGuideLayer:getChildByTag(500)~=nil then
			pNewGuideLayer:getChildByTag(500):removeFromParentAndCleanup(true)
		end
	
	end
end

function SetFight(bNowFight)
	bFight =  bNowFight
end
--和Fight对应，切换场景的时候使用
function SetNextCallBack(fCallBack)
	m_Now_CallBack = fCallBack
end

function CreateNewGuideLayer()
	pGuideTouchGroup = TouchGroup:create()
	local pCurscene =  CCDirector:sharedDirector():getRunningScene()
	
	pNewGuideLayer = Layout:create()
	pNewGuideLayer:setName("pNewGuideLayer")
	pNewGuideLayer:setSize(CCSize(1140,640))
	pNewGuideLayer:setTouchEnabled(true)	
	pNewGuideLayer:setZOrder(10000)
	--pNewGuideLayer:setTouchPriority(1)
	pGuideTouchGroup:addWidget(pNewGuideLayer)
	pGuideTouchGroup:setTouchPriority(ENUM_TOUCH_LEVEL.ENUM_TOUCH_LEVEL_GUIDE)
	bFight = false
	local function SceneEvent(tag)
		if tag == "enter" then	
			if bFight == true then
				SetFight(false)
				if m_Now_CallBack~=nil then
					m_Now_CallBack()
					m_Now_CallBack = nil
				end
			end
		end
	end
	pNewGuideLayer:registerScriptHandler(SceneEvent)
	pCurscene:addChild(pGuideTouchGroup,999999)
end