--比武界面 celina
--比武界面 celina

module("CompetitionLayer", package.seeall)

require "Script/Common/TimeManager"
require "Script/Main/Dungeon/CompetitionData"
require "Script/Main/Dungeon/CompetitionLogic"
require "Script/Main/Dungeon/CompetitionMidLayer"
require "Script/Main/Dungeon/CompetitionUnderLayer"
require "Script/Main/Dungeon/CompetitionMatrixInfo"
--变量
local m_competitionLayer = nil 
local m_flush_time = nil
local m_pTimeManager =nil 
--数据
local GetHeadImgPath_layer = CompetitionData.GetHeadImgPath
local GetHeadColorPath_layer = CompetitionData.GetHeadColorPath
local GetLevel_layer = CompetitionData.GetLevel
local GetPower_layer = CompetitionData.GetPower
local GetHistoryRank_layer = CompetitionData.GetHistoryRank
local GetRankNameByID   = CompetitionData.GetRankNameByID
local GetRank_layer = CompetitionData.GetRank
local GetPlayerName = CompetitionData.GetPlayerName
--逻辑
local GetRankID_layer = CompetitionLogic.GetRankID
local ShowMatrixInfo  = CompetitionMatrixInfo.ShowMatrixInfo
local ToMatrixLayer = CompetitionLogic.AddAnotherLayer
--local SaveCompeteTime     = CompetitionLogic.SaveCompeteTime
local nChallengeRank = 0 --要挑战的名次

local function InitVars()
	m_competitionLayer = nil 
	m_flush_time = false
	--m_pTimeManager = nil 
	nChallengeRank = 0
end

function SetFlushTime(bFlush)
	m_flush_time  = bFlush
end
function GetFlushTime()
	return m_flush_time
end

function SetChallengeRank(nRank)
	nChallengeRank = nRank
end
function GetChallengeRank()
	return nChallengeRank
end
function GetPTimeManager()

	return m_pTimeManager
end
local function _Img_Head_CallBack()
	ToMatrixLayer(m_competitionLayer,ShowMatrixInfo(true),2000)
end
local function ShowCompetitionInfo()
	--头像
	local img_head = tolua.cast(m_competitionLayer:getWidgetByName("img_general"),"ImageView")
	local pControl = UIInterface.MakeHeadIcon(img_head, ICONTYPE.PLAYER_ICON, nil, nil)
	CreateItemCallBack(pControl,false,_Img_Head_CallBack,nil)
	
	--等级
	local label_lv = tolua.cast(m_competitionLayer:getWidgetByName("Label_num_rank_general"),"Label")
	
	label_lv:setText(GetLevel_layer())
	--名字
	--GetRankNameByID(GetRankID_layer(GetRank_layer()))
	local lable_name = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,GetPlayerName(),ccp(0,4),COLOR_Black,ccc3(255,192,55),true,ccp(0,-3),3)
	
	--名字的背景
	local img_nameBG = tolua.cast(m_competitionLayer:getWidgetByName("img_general_name"),"ImageView")
	lable_name:setPosition(ccp(35,3))
	AddLabelImg(lable_name,5,img_nameBG)
	--战斗力
	local label_fight = tolua.cast(m_competitionLayer:getWidgetByName("Label_num_zdl_general"),"Label")
	label_fight:setText(GetPower_layer())
	--历史最高排名
	local label_historyRank = tolua.cast(m_competitionLayer:getWidgetByName("Label_num_history"),"Label")
	label_historyRank:setText(GetHistoryRank_layer())
	--背景层
	local Panel_info = tolua.cast(m_competitionLayer:getWidgetByName("Panel_info"),"Layout")
	--当前排名
	if tonumber(GetRank_layer())<=10000 then
		local labelRank = LabelBMFont:create()
		labelRank:setFntFile("Image/imgres/common/num/num_rank.fnt")
		labelRank:setText(GetRank_layer())
		labelRank:setPosition(ccp(710,34))
		AddLabelImg(labelRank,1000,Panel_info)
	else
		local img_Rank = ImageView:create()
		img_Rank:loadTexture("Image/imgres/compete_bw/jhwr.png")
		img_Rank:setPosition(ccp(720,34))
		AddLabelImg(img_Rank,1000,Panel_info)
	end
	
end
local function ShowCompetitionMid()
	CompetitionMidLayer.CompetitionMidInfo(m_competitionLayer)
end
local function ShowCompetitionUnder()
	CompetitionUnderLayer.CompetitionUnderInfo(m_competitionLayer,ShowCompetitionInfo)
end

function ShowUpTips()
	if m_competitionLayer~= nil then
		if tonumber(GetRank_layer()) == tonumber(nChallengeRank) then
			--排名提示1647
			nChallengeRank = 0
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1647,nil,tonumber(GetRank_layer()))
			pTips = nil
		end
	end
end


local function InitUI()
	--基本信息
	ShowCompetitionInfo()
	--中间的按钮以及时间
	ShowCompetitionMid()
	--下面部分
	ShowCompetitionUnder()
end
local function Update()
	if m_competitionLayer~=nil then
		ShowCompetitionInfo()
		CompetitionUnderLayer.UpdateUnderLayer()
	end

end

local function _Btn_Back_Competition_CallBack()
	local pBarManager = MainScene.GetBarManager()
	pBarManager:Delete(CoinInfoBarManager.EnumLayerType.EnumLayerType_Biwu)
	m_competitionLayer:removeFromParentAndCleanup(true)
	m_competitionLayer = nil
	--获得已经消失的时间，计算保存时间
	--SaveTime(CompetitionUnderLayer.GetTime())
	--SaveCompeteTime()
	
	MainScene.PopUILayer()
	MainScene.GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_COMPETIONLAYER)
	MainScene.UpdataMainVars()
end

function CreateCompetitonLayer()
	InitVars()
	
	m_competitionLayer = TouchGroup:create()
	m_competitionLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer.json" ) )
	MainScene.GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_COMPETIONLAYER,Update)
	if m_pTimeManager== nil then
		m_pTimeManager = TimeManager.CreateTimeManager()
	end
	InitUI()
	--返回按钮
	local pBarManager = MainScene.GetBarManager()
	if pBarManager~=nil then
		pBarManager:Create(m_competitionLayer,CoinInfoBarManager.EnumLayerType.EnumLayerType_Biwu)
	end
	local btn_back_Competition = tolua.cast(m_competitionLayer:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack(btn_back_Competition,nil,0,_Btn_Back_Competition_CallBack)
	
	return m_competitionLayer
end