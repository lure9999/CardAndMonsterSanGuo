--最上面的各种货币提示条 celina

module("CoinInfoBarNew", package.seeall)

--require "Script/Common/CoinInfoBarLogic"
require "Script/Main/CoinBar/CoinInfoBarData"
require "Script/Main/CoinBar/CoinInfoBarLogicNew"
require "Script/Main/TipsMessage/TipsMessage"

--逻辑

local GetPathByTypeID = CoinInfoBarLogicNew.GetPathByTypeID
local GetNumOnBarByType = CoinInfoBarLogicNew.GetNumOnBarByType

--数据
local GetTabDatByLayerType = CoinInfoBarData.GetTabDatByLayerType
local GetColumNum = CoinInfoBarData.GetColumNum

local function _Fight_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--提示信息
		local pMessage = TipsMessage.CreateTipsMessage()
		pMessage:Create(1,1,1,ccp(850,600))
	end
end

local function _Coin_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--提示信息
		local nTag = sender:getTag()-1000
		local pMessage = TipsMessage.CreateTipsMessage()
		pMessage:Create(1,0,nTag,ccp(sender:getPositionX()+100,600))
	end
end
--添加银币的特效
local function AddSliverTX(img_bg)
	
	local pAnimature = CommonInterface.GetAnimationByName("Image/imgres/effectfile/yuanbaoyinbi_texiao/yuanbaoyinbi_texiao.ExportJson", 
		"yuanbaoyinbi_texiao", 
		"Animation2", 
		img_bg, 
		ccp(0, 0),
		nil,
		100)
	pAnimature:setScale(0.5)
end
--添加金币的特效
local function AddGoldTX(img_bg)
	local pAnimature = CommonInterface.GetAnimationByName("Image/imgres/effectfile/yuanbaoyinbi_texiao/yuanbaoyinbi_texiao.ExportJson", 
		"yuanbaoyinbi_texiao", 
		"Animation1", 
		img_bg, 
		ccp(0, 0),
		nil,
		100)
	pAnimature:setScale(0.5)
end
local function InitUI(self)
	local nBarType = self.nLayerType
	self.m_pBarLayer =tolua.cast( self.m_pCoinBarLayer,"TouchGroup")
	local tabBarData = GetTabDatByLayerType(nBarType)
	for i=1,4 do 
		--取得栏位的类型
		local columType = tonumber(tabBarData[GetColumNum("ColumnType"..i)])
		local columID   = tonumber(tabBarData[GetColumNum("Column"..i)])
		--Pause()
		
		if self.m_pBarLayer==nil then
			return 
		end
		
		self.img_icon_bg = tolua.cast(self.m_pBarLayer:getWidgetByName("img_icon_bg"..i),"ImageView")
		if self.img_icon_bg==nil then
			return 
		end
		if columID == 1 then
			--银币 加特效
			local img_icon_lbg1 = tolua.cast(self.m_pBarLayer:getWidgetByName("img_icon_"..i),"ImageView")
			AddSliverTX(img_icon_lbg1)
		end
		if columID == 2 then
			--元宝 加特效
			local img_icon_lbg2 = tolua.cast(self.m_pBarLayer:getWidgetByName("img_icon_"..i),"ImageView")
			AddGoldTX(img_icon_lbg2)
		end
		self.img_icon_bg:setTag(1000+tonumber(columID))
		self.img_icon_bg:setTouchEnabled(true)
		self.img_icon_bg:addTouchEventListener(_Coin_CallBack)
		if columType<1 then
			self.img_icon_bg:setVisible(false)
		else
			self.img_icon_bg:setVisible(true)
			local img_coin = tolua.cast(self.m_pBarLayer:getWidgetByName("img_coin"..i),"ImageView")
			if columID ~= 1 and columID~=2 then
				local sPath = GetPathByTypeID(columType,columID)
				if sPath~=nil then
					img_coin:loadTexture(sPath)
				end
				
			else
				img_coin:setVisible(false)
			end
			local sShowNum = ""
			sShowNum = GetNumOnBarByType(columType,columID)
			local pText = self.img_icon_bg:getChildByTag(1000)
			if pText~=nil then
				LabelLayer.setText(pText,sShowNum)
			else
				local text = LabelLayer.createStrokeLabel(20, "微软雅黑", sShowNum, ccp(-25, 0), COLOR_Black, ccc3(206,147,91), false, ccp(0, -2), 2)
				self.img_icon_bg:addChild(text,  0, 1000)
			end
		end
	end
	self.img_fight_bg = tolua.cast(self.m_pBarLayer:getWidgetByName("img_fight_bg"),"ImageView")
	self.img_fight_bg:setTouchEnabled(true)	
	self.img_fight_bg:addTouchEventListener(_Fight_CallBack)
	if tonumber(tabBarData[GetColumNum("ColumnType5")])>0  then
		self.img_fight_bg:setVisible(true)
		local l_fight = self.img_fight_bg:getChildByTag(1000)
		if l_fight ~=nil then
			local p_fight = tolua.cast(l_fight,"LabelBMFont")
			p_fight:setText(GetNumOnBarByType(tabBarData[GetColumNum("ColumnType5")],tabBarData[GetColumNum("Column5")]))
		else
			local pFgihtNum = LabelBMFont:create()
			pFgihtNum:setFntFile("Image/imgres/main/fight.fnt")
			pFgihtNum:setPosition(ccp(-10,-20))
			pFgihtNum:setAnchorPoint(ccp(0,0.5))
			pFgihtNum:setText(GetNumOnBarByType(tabBarData[GetColumNum("ColumnType5")],tabBarData[GetColumNum("Column5")]))
			self.img_fight_bg:addChild(pFgihtNum,0,1000)
		end
	else
		self.img_fight_bg:setVisible(false)
	end
end

local function Update_Bar(self)
	
	InitUI(self)
end
--[[local function InitVars()
	m_pBarLayer = nil 
end]]--
function AddCoinBar(nType)
	--InitVars()
	local pCoinLayer = {}
	pCoinLayer.m_pCoinBarLayer = TouchGroup:create()
	pCoinLayer.m_pCoinBarLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/TipsCoinBar.json" ) )
	pCoinLayer.m_pCoinBarLayer:setPosition(ccp(260,590))
	pCoinLayer.nLayerType = nType
	pCoinLayer.Update = Update_Bar
	InitUI(pCoinLayer)
	return pCoinLayer
end