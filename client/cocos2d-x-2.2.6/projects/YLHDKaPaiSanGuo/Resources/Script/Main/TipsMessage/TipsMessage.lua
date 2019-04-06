--点击按钮的各种提示信息  celina

module("TipsMessage", package.seeall)

require "Script/Main/TipsMessage/TipsMessageData"

--数据
local GetMessage = TipsMessageData.GetMessageByValue
local GetMessageWidth  = TipsMessageData.GetMessageWidthByValue
local ChangeFormat    = TipsMessageData.ChangeFormat

local function AddRichAble(self)
	self.richLable = RichLabel.Create(self.str,GetMessageWidth(self.nTipsType,self.nTipsValue,self.nTipsPos))
	self.img_bg = ImageView:create()
	self.img_bg:loadTexture("Image/imgres/common/tip_bk_01.png")
	self.img_bg:setScale9Enabled(true)
	self.img_bg:setSize(CCSize(GetMessageWidth(self.nTipsType,self.nTipsValue,self.nTipsPos)+30, self.richLable:getContentSize().height+20))
	self.img_bg:setPosition(self.position)
	self.img_bg:setAnchorPoint(ccp(0,1))
	self.richLable:setPosition(ccp(20,-10))
	self.richLable:setTouchEnabled(false)
	self.img_bg:addChild(self.richLable)
	self.pTipsLayer:addChild(self.img_bg)
	--倒计时功能暂时不写
	--[[if self.bHaveTime == true then
		local label_time = Label:create()
		label_time:set
		local function UpdateCallBack()
		end
		local pArray=CCArray:create()
		pArray:addObject(CCDelayTime:create(1))
		pArray:addObject(CCCallFuncN:create(UpdateCallBack))
		
		self.richLable:runAction(CCRepeatForever:create(CCSequence:create(pArray)))
	end]]--
end

local function InitUI(self)
	self.str = GetMessage(self.nTipsType,self.nTipsValue,self.nTipsPos)
	--[[if tonumber(self.nTipsValue) == 0 then
		if tonumber(self.nTipsPos) == 3 or tonumber(self.nTipsPos) ==4 then
			--体力
			self.bHaveTime = true 
			local function GetTime(nTime)
				NetWorkLoadingLayer.loadingShow(false)
				self.minu,self.sec = ChangeFormat(nTime)
				--self.str = string.format(self.str,self.minu,self.sec,self.minu,self.sec)
				AddRichAble(self)
			end
			Packet_GetAttrTime.SetSuccessCallBack(GetTime)
			if tonumber(self.nTipsPos) == 3 then
				network.NetWorkEvent(Packet_GetAttrTime.CreatPacket(1))
			else
				network.NetWorkEvent(Packet_GetAttrTime.CreatPacket(2))
			end
			NetWorkLoadingLayer.loadingShow(true)
		else
			self.bHaveTime = false 
			AddRichAble(self)
		end
	else
		self.bHaveTime = false 
		AddRichAble(self)
	end]]--
	AddRichAble(self)
end
--nTipsType表的提示类型，nTipsValue类型参数，nTipsPos --提示位置
local function CreateTips(self,nType,nValue,nPos,pos)
	self.nTipsType = nType
	self.nTipsValue = nValue
	self.nTipsPos = nPos
	self.position = pos
	self.pTipsTouchGroup = TouchGroup:create()
	local pCurScene =  CCDirector:sharedDirector():getRunningScene()
	self.pTipsLayer = Layout:create()
	
	self.pTipsLayer:setSize(CCSize(1140,640))
	self.pTipsLayer:setTouchEnabled(true)	
	self.pTipsLayer:setZOrder(layerTipsMessage_Tag)
	local function _Tips_CallBack(sender,eventType)
		--点击消失
		if eventType == TouchEventType.ended then
			--删除层
			self.pTipsTouchGroup:removeFromParentAndCleanup(true)	
			self.pTipsTouchGroup = nil
		end
	end
	self.pTipsLayer:addTouchEventListener(_Tips_CallBack)
	
	InitUI(self)
	self.pTipsTouchGroup:addWidget(self.pTipsLayer)
	
	pCurScene:addChild(self.pTipsTouchGroup,99999)
end

local function AddRichAbleByStr(self)
	self.richLable = RichLabel.Create(self.str,self.width)
	self.img_bg = ImageView:create()
	self.img_bg:loadTexture("Image/imgres/common/tip_bk_01.png")
	self.img_bg:setScale9Enabled(true)
	self.img_bg:setSize(CCSize(self.width+30, self.richLable:getContentSize().height+20))
	self.img_bg:setPosition(self.position)
	self.img_bg:setAnchorPoint(ccp(0,1))
	self.richLable:setPosition(ccp(20,-10))
	self.richLable:setTouchEnabled(false)
	self.img_bg:addChild(self.richLable)
	self.pTipsLayer:addChild(self.img_bg)

end
local function CreateTipsByStr(self,strRichable,n_width,pos)
	
	self.pTipsTouchGroup = TouchGroup:create()
	local pCurScene =  CCDirector:sharedDirector():getRunningScene()
	self.pTipsLayer = Layout:create()
	
	self.pTipsLayer:setSize(CCSize(1140,640))
	self.pTipsLayer:setTouchEnabled(true)	
	self.pTipsLayer:setZOrder(layerTipsMessage_Tag)
	
	self.str = strRichable
	self.width = n_width
	self.position = pos
	local function _Tips_CallBack(sender,eventType)
		--点击消失
		if eventType == TouchEventType.ended then
			--删除层
			self.pTipsTouchGroup:removeFromParentAndCleanup(true)	
			self.pTipsTouchGroup = nil
		end
	end
	self.pTipsLayer:addTouchEventListener(_Tips_CallBack)
	
	AddRichAbleByStr(self)
	self.pTipsTouchGroup:addWidget(self.pTipsLayer)
	
	pCurScene:addChild(self.pTipsTouchGroup,99999)

end
--Tip表的ID

function CreateTipsMessage()
	local pTips = {}
	pTips.Create = CreateTips
	pTips.CreateByStr = CreateTipsByStr
	return pTips
end