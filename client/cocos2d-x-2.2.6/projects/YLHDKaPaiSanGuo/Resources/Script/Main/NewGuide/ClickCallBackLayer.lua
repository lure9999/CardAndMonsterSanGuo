

--add by sxin 增加一个截获点击响应的通用界面 小手显示的
module("ClickCallBackLayer", package.seeall)


function Create( pos , pcallBack)

	local pTouchGroup = TouchGroup:create()
	local pCurscene =  CCDirector:sharedDirector():getRunningScene()
	
	local pUILayer = Layout:create()
	
	pUILayer:setSize(CCSize(1140,640))
	pUILayer:setTouchEnabled(true)	
	pUILayer:setZOrder(10000)
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	local GuideAnimation = CCArmature:create("zhiyin01")
	GuideAnimation:getAnimation():play("Animation1")
	
	local layout = Layout:create()
	layout:setSize(CCSize(120,120))
	GuideAnimation:setPosition(ccp(60,60))
	layout:addNode(GuideAnimation)
	layout:setPosition(ccp(pos.x-60,pos.y-60))
	pUILayer:addChild(layout)
	
	local function _Close_Item_CallBack(sender,eventType)
		if eventType == TouchEventType.ended then									
			if pcallBack~=nil then
				pcallBack()				
			end
			pTouchGroup:removeFromParentAndCleanup(true)	
		end
	end

	layout:addTouchEventListener(_Close_Item_CallBack)
	layout:setTouchEnabled(true)	
	
	pTouchGroup:addWidget(pUILayer)
	pTouchGroup:setTouchPriority(ENUM_TOUCH_LEVEL.ENUM_TOUCH_LEVEL_GUIDE)
	
	pCurscene:addChild(pTouchGroup,999999)
end