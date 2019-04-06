
--比武说明界面
module("CompetitionInfoLayer", package.seeall)

require "Script/Common/RewardLogic"
--

--变量
local m_competitionInfoLayer = nil 
--数据
local GetRank   = CompetitionData.GetRank
local GetRankNameByID   = CompetitionData.GetRankNameByID
local GetRank_layer = CompetitionData.GetRank
local GetRewardID = CompetitionData.GetRewardID

--逻辑
local GetRankID_layer = CompetitionLogic.GetRankID

local GetRewardTable = RewardLogic.GetRewardTable

local function InitVars()
	m_competitionInfoLayer = nil
end

local function ShowReward(panel)
	local nRewardID = GetRankID_layer(GetRank_layer(GetRank()))
	local tableDataReward = GetRewardTable(GetRewardID(nRewardID))
	
	local tableCoinData = tableDataReward[1]
	local tableItemData = tableDataReward[2]
	printTab(tableCoinData)
	printTab(tableItemData)
	local posY = 0
	if table.getn(tableCoinData)<= 3 then
		posY = -2
		-- posY = -97
	else
		-- posY = -147
		posY = -52
	end
	--银币部分
	for key,value in pairs(tableCoinData) do 
		local img_coin = ImageView:create()
		img_coin:loadTexture(value.CoinPath)
		img_coin:setPosition(ccp(156+(key-1)*190,55)) ---47
		if string.find(value.CoinPath,"yuanbao")~= 0 then
			img_coin:setScale(0.5)
		else
			img_coin:setScale(value.CoinScale)
		end
		
		AddLabelImg(img_coin,2000+tonumber(key),panel)
		local label_num_coin = Label:create()
		label_num_coin:setFontSize(22)
		label_num_coin:setColor(ccc3(128,57,39))
		label_num_coin:setPosition(ccp(236+(key-1)*185,55))
		label_num_coin:setText(value.CoinNum)
		AddLabelImg(label_num_coin,3000+tonumber(key),panel)
	end
	--道具部分
	for key,value in pairs(tableItemData) do 
		local img_item = ImageView:create()
		img_item:loadTexture(value.ItemPath)
		img_item:setPosition(ccp(156+(key-1)*190,posY))
		img_item:setScale(0.5)
		AddLabelImg(img_item,4000+tonumber(key),panel)
		local label_num_item = Label:create()
		label_num_item:setFontSize(22)
		label_num_item:setColor(ccc3(128,57,39))
		label_num_item:setPosition(ccp(236+(key-1)*185,posY))
		label_num_item:setText(value.ItemNum)
		AddLabelImg(label_num_item,5000+tonumber(key),panel)
	end
end
local function ShowUI()
	--比武说明
	local img_bg = tolua.cast(m_competitionInfoLayer:getWidgetByName("img_bg_name"),"ImageView")
	local lable_PlayerName = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,"比武说明",ccp(0,4),COLOR_Black,ccc3(239,193,55),true,ccp(0,-3),3)
	AddLabelImg(lable_PlayerName,100,img_bg)
	
	local scrollViewInfo = tolua.cast(m_competitionInfoLayer:getWidgetByName("ScrollView_info"),"ScrollView")
	scrollViewInfo:setClippingType(1)
	
	local panel = tolua.cast(m_competitionInfoLayer:getWidgetByName("Panel_11"),"Layout")
	--排名
	local labelRank = LabelBMFont:create()
	labelRank:setFntFile("Image/imgres/common/num/num_rank.fnt")
	labelRank:setText(GetRank())
	labelRank:setPosition(ccp(180,146))
	AddLabelImg(labelRank,1000,panel)
	--名字
	local img_bg_name = tolua.cast(m_competitionInfoLayer:getWidgetByName("img_bg_cw"),"ImageView")
	local lableName = Label:create()
	lableName:setFontSize(20)
	lableName:setText(GetRankNameByID(GetRankID_layer(GetRank_layer())))
	AddLabelImg(lableName,1,img_bg_name)
	
	--奖励
	ShowReward(panel)
	
end
local function _Btn_Colse_CallBack()
	m_competitionInfoLayer:removeFromParentAndCleanup(true)
end
function ShowCompetitionInfo()
	InitVars()
	
	m_competitionInfoLayer =  TouchGroup:create()
	m_competitionInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer_Info.json" ) )
	
	ShowUI()
	--关闭按钮
	local btn_close = tolua.cast(m_competitionInfoLayer:getWidgetByName("btm_close"),"Button")
	CreateBtnCallBack(btn_close,nil,nil,_Btn_Colse_CallBack,nil,nil,nil,nil)
	
	return m_competitionInfoLayer

end


