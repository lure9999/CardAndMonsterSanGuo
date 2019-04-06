require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralBaseUILogic"
require "Script/Main/LuckyDraw/LuckyDrawLogic"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/general"
require "Script/Audio/AudioUtil"
require "Script/serverDB/server_LuckyDrawItemDB"
require "Script/Main/Item/ItemData"

module("ShowGeneral", package.seeall)

local IsHaveGeneral							= LuckyDrawLogic.IsHaveGeneral
local GetGeneralQuality						= GeneralBaseData.GetGeneralQuality
local PlayGeneralAnimationByGeneralId		= GeneralBaseUILogic.PlayGeneralAnimationByGeneralId
local GetItemEventParaC						= ItemData.GetItemEventParaC
local CreateStrokeLabel 					= LabelLayer.createStrokeLabel
local GegAnimationId						= GeneralBaseData.GegAnimationId
local GetAnimationData						= GeneralBaseData.GetAnimationData

local function HandleShowPanelClickEvent( self )
	self.PanelShow:removeAllChildrenWithCleanup(true)
	self.PanelShow:setVisible(false)
	self.PanelShow:setTouchEnabled(false)
	self.PanelShow:removeFromParentAndCleanup(true)
end

local function AddGratzImage( pPanelShow, nZOrder, nGeneralID ,nColor ,nType)
	local str
	if tonumber(nType) == 5 then
		str = "Image/imgres/luckydraw/tip_hufa.png"
	else
		str = "Image/imgres/luckydraw/tip_wj.png"
	end
	local pImageGratz = ImageView:create()
	pImageGratz:loadTexture("Image/imgres/luckydraw/gratz.png")
	pImageGratz:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 - 80 + CommonData.g_Origin.x, 540))
	local pGernalType = ImageView:create()
	pGernalType:loadTexture(str)
	pGernalType:setPosition(ccp((pImageGratz:getPositionX() + pImageGratz:getContentSize().width * 0.5) + pGernalType:getContentSize().width * 0.5 + 20, 540))
	pPanelShow:addChild(pImageGratz, nZOrder, nZOrder)
	pPanelShow:addChild(pGernalType, nZOrder, nZOrder)
end

local function AddTipLabel( pPanelShow, nGeneralId, nZOrder )
	local nNum = GetItemEventParaC(nGeneralId)
	local pLabelNumTip = CreateStrokeLabel(30, CommonData.g_FONT1, "已拥有此英雄，为你转换成将魂"..tostring(nNum).."个", ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 150), COLOR_Black, ccc3(254,244,84), true, ccp(0, -2), 2)
	pPanelShow:addChild(pLabelNumTip, nZOrder, nZOrder)
	local pLabelTip = CreateStrokeLabel(30, CommonData.g_FONT1, "将魂可用于武将升星", ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 110), COLOR_Black, ccc3(254,244,84), true, ccp(0, -2), 2)
	pPanelShow:addChild(pLabelTip, nZOrder, nZOrder)
end

local function AddConfirmBtn( self, pPanelShow, nZOrder )

	local function _BtnOK_LuckyDrawItem_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			sender:setScale(1.0)
			HandleShowPanelClickEvent( self )
		elseif  eventType == TouchEventType.began then
			sender:setScale(0.9)
		elseif  eventType == TouchEventType.canceled then
			sender:setScale(1.0)
		end
	end

	local pBtnConfirm = Button:create()
	pBtnConfirm:loadTextures("Image/imgres/common/btn_bg.png","Image/imgres/common/btn_bg.png","")
	local pLabel = CreateStrokeLabel(36, CommonData.g_FONT1, "确定", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	pBtnConfirm:addChild(pLabel)
	pBtnConfirm:setName("BtnOk")
	pBtnConfirm:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, 120))
	pBtnConfirm:setVisible(true)
	pBtnConfirm:setTouchEnabled(true)
	pBtnConfirm:addTouchEventListener(_BtnOK_LuckyDrawItem_CallBack)
	pPanelShow:addChild(pBtnConfirm, nZOrder, nZOrder)
end

local function GetAniNameByGeneralId( nGeneralId )
	local nColor = GetGeneralQuality(nGeneralId)
	if nColor<=3 then
		return "wujiangchouqubeijin_l"
	elseif nColor>=5 then
		return "wujiangchouqubeijin_c"
	else
		return "wujiangchouqubeijin_z"
	end
end

function CutText(str)
    local list = {}
    local len = string.len(str)
    local i = 1 
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        i = i + shift
        table.insert(list, char)
    end
    return list, len
end

local function AddHeroName( nParent, nGeneralID ,nColor ,nZOrder)
	local pNameBg = ImageView:create()
	pNameBg:loadTexture("Image/imgres/luckydraw/nameBg.png")
	pNameBg:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2 - 180 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2 + 50))
	
	local name = general.getFieldByIdAndIndex(nGeneralID,"Name")
	local nameTab = CutText(name)
	local nBeginNum = 1
	if nameTab[1] == "护" then
		nBeginNum = 4
	end
	local jNum = -32
	local nIndexNum = 1
	local nAddNum = 12
	for i=nBeginNum,table.getn(nameTab) do
		if table.getn(nameTab) == 2 or table.getn(nameTab) - 3 == 2 then
			jNum = -46
			nAddNum = 15
		end
		local nameLabel = Label:create()
		nameLabel:setPosition(ccp(-2,jNum * (nIndexNum - 1)))
		nameLabel:setFontSize(30)
		nameLabel:setTag(i)
		nameLabel:setFontName(CommonData.g_FONT1)
		nameLabel:setText(nameTab[i])
		if tonumber(nColor) == 3 then
			nameLabel:setColor(ccc3(0,219,255))
		elseif tonumber(nColor) == 4 then
			nameLabel:setColor(ccc3(175,0,255))
		elseif tonumber(nColor) == 5 then
			nameLabel:setColor(ccc3(255,166,0))
		end
		pNameBg:addChild(nameLabel)
		nIndexNum = nIndexNum + 1
	end
	--优化坐标
	local nPtNum = table.getn(nameTab)
	if nBeginNum ~= 1 then
		nPtNum = table.getn(nameTab) - 4
		nBeginNum = 4
	end
	for i=nBeginNum,table.getn(nameTab) do
		if pNameBg:getChildByTag(i) ~= nil then
			pNameBg:getChildByTag(i):setPosition(ccp(-2,pNameBg:getChildByTag(i):getPositionY() + nAddNum * nPtNum))
		end
	end
	nParent:addChild(pNameBg ,nZOrder, 99)
end

local function HandleShowPanelClickEventNext( self )
	if self.CurIndex + 1 > table.getn(self.nGeneralIdTab) then
		HandleShowPanelClickEvent(self)
		return
	end
	local pLayer = tolua.cast(self.PanelShow:getWidgetByName("AniLayer"), "Layout")
	pLayer:removeAllChildrenWithCleanup(true)
	pLayer:removeAllNodes()
	if self.PanelShow:getChildByTag(99) ~= nil then
		self.PanelShow:getChildByTag(99):removeFromParentAndCleanup(true)
	end

	self.CurIndex = self.CurIndex + 1
	local nItemId = self.nGeneralIdTab[self.CurIndex]
	local nGeneralId = tonumber(item.getFieldByIdAndIndex(nItemId,"res_id"))
	--printTab(self.nGeneralIdTab)
	--print(self.CurIndex, nItemId, nGeneralId)

	--更新动画
	if pLayer:getNodeByTag(166) == nil then
		--创建动画
		CommonInterface.GetAnimationByName( "Image/imgres/effectfile/wujiangchouqubeijing.ExportJson",
											"wujiangchouqubeijing",GetAniNameByGeneralId(nGeneralId), pLayer,
											ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2),
											nil, nGeneralId)
		PlayGeneralAnimationByGeneralId(nGeneralId, pLayer, Ani_Def_Key.Ani_attack, 1/2, 1/3, 1.8)

	end
	--更新姓名
	local nZOrder = nGeneralId+100
	local nColor  = general.getFieldByIdAndIndex(nGeneralId,"Colour")
	AddHeroName(self.PanelShow, nGeneralId ,nColor ,nZOrder)
end

local function CreateGerenelLayer( self, nGeneralIdTab, nIndex )

	self.nGeneralIdTab = nGeneralIdTab
	local nItemId = self.nGeneralIdTab[nIndex]
	local nGeneralId = tonumber(item.getFieldByIdAndIndex(nItemId,"res_id"))

	local function _PanelShow_LuckyDrawItem_CallBack( sender,eventType )
		if eventType == TouchEventType.ended then
			HandleShowPanelClickEventNext( self )
		end
	end

	self.CurIndex = nIndex

	self.PanelShow = TouchGroup:create()
	local pLayer = Layout:create()
	pLayer:setName("AniLayer")
	pLayer:setSize(CCSize(1140, 640))
	pLayer:setContentSize(CCSizeMake(1140, 640))
	pLayer:setTouchEnabled(true)
	pLayer:setZOrder(9999)
	pLayer:setTag(166)
	self.PanelShow:addWidget( pLayer )
	self.PanelShow:setTouchPriority(-129)
	pLayer:addTouchEventListener(_PanelShow_LuckyDrawItem_CallBack)

	local nZOrder = nGeneralId+100
	local nColor  = general.getFieldByIdAndIndex(nGeneralId,"Colour")
	local nType   = general.getFieldByIdAndIndex(nGeneralId,"Type")

	AddGratzImage(self.PanelShow, nZOrder, nGeneralId, nColor, nType)

	--[[if IsHaveGeneral( self.m_tabOldGeneral, nGeneralId )==true then
		self.PanelShow:setTouchEnabled(true)
		AddTipLabel( self.PanelShow, nGeneralId, nZOrder )
	else
		self.PanelShow:setTouchEnabled(false)
		AddConfirmBtn(self, self.PanelShow, nZOrder)
	end]]
	--创建动画
	CommonInterface.GetAnimationByName( "Image/imgres/effectfile/wujiangchouqubeijing.ExportJson",
										"wujiangchouqubeijing",GetAniNameByGeneralId(nGeneralId), pLayer,
										ccp(CommonData.g_sizeVisibleSize.width/2 + CommonData.g_Origin.x, CommonData.g_sizeVisibleSize.height/2),
										nil, nGeneralId)
	PlayGeneralAnimationByGeneralId(nGeneralId, pLayer, Ani_Def_Key.Ani_attack, 1/2, 1/3, 1.8)
	--创建姓名
	AddHeroName(self.PanelShow, nGeneralId ,nColor ,nZOrder)

	return self.PanelShow
end

function Create(  )
	local tab = {
		CreateGerenelLayer 			= CreateGerenelLayer,
	}

	return tab
end

