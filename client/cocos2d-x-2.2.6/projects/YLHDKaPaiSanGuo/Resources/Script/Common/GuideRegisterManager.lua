--注册引导的管理 celina


module("GuideRegisterManager", package.seeall)

require "Script/Guide/GuideTotalLayer"

local ShowGuideTotalLayer = GuideTotalLayer.CreateTotalLayer
local function ToGuideLayer(self)
	self.tab = {}
	self.tab.itemID = self.nItemID
	self.tab.nType = self.nItemType
	local pScene = CCDirector:sharedDirector():getRunningScene()
	if pScene:getChildByTag(layerGuideTotal_Tag)~=nil then
		pScene:getChildByTag(layerGuideTotal_Tag):removeFromParentAndCleanup(true)
	end
	local pLayer = ShowGuideTotalLayer(self.tab)
	pScene:addChild(pLayer,layerGuideTotal_Tag,layerGuideTotal_Tag)
	--MainScene.PushUILayer(pLayer)
end

--传入需要指引的对象sizeTouch,触摸区域的宽和高
local function RegisteGuide_Manager(self,pGuideImg,nTempID,nType)
	self.pGuideObject = pGuideImg
	self.pNode = Widget:create()
	self.nItemID = nTempID
	self.nItemType = nType
	self.pNode:setEnabled(true)
	self.pNode:setTouchEnabled(true)
	self.pNode:ignoreContentAdaptWithSize(false)
    self.pNode:setSize(CCSize(self.pGuideObject:getContentSize().width+10,self.pGuideObject:getContentSize().height+10))
	local function _Guide_CallBack (sender,eventType)
		if  eventType == TouchEventType.ended then
			ToGuideLayer(self)
		end
	end
	self.pNode:addTouchEventListener(_Guide_CallBack)
	AddLabelImg(self.pNode,6000,self.pGuideObject)
end

function RegisterGuideManager()
	local pRegisterGuide = {}
	pRegisterGuide.RegisteGuide = RegisteGuide_Manager
	--pRegisterGuide.DestoryGuide = DestoryGuide_Manager
	return pRegisterGuide

end