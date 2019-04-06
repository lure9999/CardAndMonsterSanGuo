require "Script/Common/Common"
require "Script/Main/MissionNormal/MissionNormalData"
require "Script/Main/MissionNormal/MissionNormalLogic"
require "Script/Common/RewardLogic"

module("MissionNormalRewardLayer", package.seeall)

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 

local MainScene_PopUILayer				= 	MainScene.PopUILayer

local GetBoxScore						=	MissionNormalData.GetBoxScore
local GetBoxMaxScore					=	MissionNormalData.GetBoxMaxScore
local GetMissionName					=	MissionNormalData.GetMissionName
local GetMissionText					=	MissionNormalData.GetMissionText
local GetMissionIcon					=	MissionNormalData.GetMissionIcon
local GetMissionRewardIcon				=	MissionNormalData.GetMissionRewardIcon
local GetMisiionOrderRewID				=	MissionNormalData.GetMisiionOrderRewID
local GetMissionPath					=	MissionNormalData.GetMissionPath
local GetCondNum						=	MissionNormalData.GetCondNum
local GetCurSocre						=	MissionNormalData.GetCurSocre
local GetBoxState						=	MissionNormalData.GetBoxState
local GetMissionRewardItemData			=	MissionNormalData.GetMissionRewardItemData
local GetMissionRewardItemDataNum		=	MissionNormalData.GetMissionRewardItemDataNum
local GetRewardPath						=	MissionNormalData.GetRewardPath
local GetItemResID						=	MissionNormalData.GetItemResID
local GetMissionRewardDataNum 			=	MissionNormalData.GetMissionRewardDataNum

local GetRewardTable 					=	RewardLogic.GetRewardTable

local ShowGoodsLayer					=	MissionNormalLogic.ShowGoodsLayer

local m_MissionNormalRewardLayer = nil
local m_CallBack = nil
local m_RewardTab = nil

local function InitVars()
	m_MissionNormalRewardLayer = nil
	m_CallBack = nil
	m_RewardTab = nil
end

local Mission_State = {
	FinishedNotReceived 			= 0,  --完未领取
	NotFinished						= 1,  --未完成
	HaveReceived 					= 2,  --完成已领取
	MissionFaied 					= 3,  --任务失败
}

local function CreateLabel( text, size, color, fontName, pos, isAnchor )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	if isAnchor == true then
		label:setAnchorPoint(ccp(0,0.5))
	end
	return label
end

local function _Button_Return_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
		m_MissionNormalRewardLayer:removeFromParentAndCleanup(true)
		InitVars()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Button_Receive_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
        sender:setScale(1.0)
        if m_CallBack ~= nil then
        	ShowGoodsLayer(nil, m_RewardTab, m_CallBack)
    		m_MissionNormalRewardLayer:removeFromParentAndCleanup(true)
			InitVars()
        end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function InitUI( nRewardID )
	local _RewardTab = GetRewardTable( nRewardID )

	local tab_Coin = _RewardTab[1]
	local tab_Item = _RewardTab[2]

	local nIndex = 1

	for key,value in pairs(tab_Coin) do
		local nNum 		   = value.CoinNum
		local Image_Reward = tolua.cast(m_MissionNormalRewardLayer:getWidgetByName("Image_Reward_"..nIndex),"ImageView")
		local Image_Item   = tolua.cast(Image_Reward:getChildByName("Image_Item"),"ImageView")
		local nNumLabel    = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT3, "x"..nNum, ccp(-50, -40), COLOR_Black, COLOR_White, false, ccp(0, 0), 1)
		local nPath        = value.CoinPath
		Image_Item:loadTexture(nPath)
		Image_Reward:setVisible(true)
		Image_Reward:addChild(nNumLabel)
		local tab = {}
		tab[1] = value.CoinID
		tab[2] = nNum
		table.insert(m_RewardTab, tab)
		nIndex = nIndex + 1
	end

	for key,value in pairs(tab_Item) do
		local nNum 		   = value.ItemNum
		local Image_Reward = tolua.cast(m_MissionNormalRewardLayer:getWidgetByName("Image_Reward_"..nIndex),"ImageView")
		local Image_Item   = tolua.cast(Image_Reward:getChildByName("Image_Item"),"ImageView")
		local nNumLabel    = StrokeLabel_createStrokeLabel(18, CommonData.g_FONT3, "x"..nNum, ccp(-50, -40), COLOR_Black, COLOR_White, false, ccp(0, 0), 1)
		local nPath        = value.ItemPath
		Image_Item:loadTexture(nPath)
		Image_Reward:setVisible(true)
		Image_Reward:addChild(nNumLabel)
		local tab = {}
		tab[1] = value.ItemID
		tab[2] = nNum
		table.insert(m_RewardTab, tab)
		nIndex = nIndex + 1
	end	

end

--create entrance
function CreateMissionNormalRewardLayer( nType, nScore, nBoxRewardID, nCallBack )
	m_MissionNormalRewardLayer = TouchGroup:create()
	m_MissionNormalRewardLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MissionRewardLayer.json"))

	m_RewardTab = {}

	--说明
	local Image_TitleBg = tolua.cast(m_MissionNormalRewardLayer:getWidgetByName("Image_TitleBg"),"ImageView")
	local nLabel    	= StrokeLabel_createStrokeLabel(30, CommonData.g_FONT1, nScore.."积分每日任务奖励", ccp(0, 0), COLOR_Black, ccc3(255,233,131), true, ccp(0, 0), 2)
	Image_TitleBg:addChild(nLabel)
	--领取按钮
	local Button_Receive = tolua.cast(m_MissionNormalRewardLayer:getWidgetByName("Button_Receive"),"Button")
	local nReceiveLabel    = StrokeLabel_createStrokeLabel(36, CommonData.g_FONT1, "领取", ccp(0, 0), COLOR_Black, COLOR_White, true, ccp(0, 0), 3)
	Button_Receive:addChild(nReceiveLabel)

	if nCallBack ~= nil then m_CallBack = nCallBack end

	InitUI( nBoxRewardID )

	if nType == Mission_State.FinishedNotReceived then
		--显示领取按钮
		Button_Receive:setVisible(true)
		Button_Receive:setTouchEnabled(true)
		Button_Receive:addTouchEventListener(_Button_Receive_CallBack)
	else
		--不显示领取按钮
		Button_Receive:setVisible(false)
		Button_Receive:setTouchEnabled(false)
	end
    --按钮事件设置
    local Button_Return = tolua.cast(m_MissionNormalRewardLayer:getWidgetByName("Button_Return"),"Button")
	if Button_Return == nil then
		print("Button_Return is nil")
		return false
	else
		Button_Return:addTouchEventListener(_Button_Return_CallBack)
	end

    
	return  m_MissionNormalRewardLayer
end