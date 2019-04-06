
--分享界面 celina



module("CompetitionSharedLayer", package.seeall)

require "Script/Main/Dungeon/SharedWorldAndGhuiLayer"

--变量
local m_competitionSharedSelectLayer = nil 
--界面
local ToSharedWorldLayer = CompetitionLogic.AddAnotherLayer
local GetSharedWorldLayer = SharedWorldAndGhuiLayer.ShowSharedWorldAndGHuiLayer

local function InitVars()
	m_competitionSharedSelectLayer = nil 
end
local function _Btn_Shared_GH_CallBack()
	
end
local function _Btn_Shared_World_CallBack()
	ToSharedWorldLayer(m_competitionSharedSelectLayer,GetSharedWorldLayer(),100)
end
local function _Btn_Shared_Friend_CallBack()
	
end


local function ShowUI()
	local btn_shred_gonghui= tolua.cast(m_competitionSharedSelectLayer:getWidgetByName("btn_1"),"Button")
	CreateBtnCallBack(btn_shred_gonghui,"分享到公会",20,_Btn_Shared_GH_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil)
	
	local btn_shred_world= tolua.cast(m_competitionSharedSelectLayer:getWidgetByName("btn_2"),"Button")
	CreateBtnCallBack(btn_shred_world,"分享到世界",20,_Btn_Shared_World_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil)

	local btn_shred_friend= tolua.cast(m_competitionSharedSelectLayer:getWidgetByName("btn_3"),"Button")
	CreateBtnCallBack(btn_shred_friend,"分享到好友",20,_Btn_Shared_Friend_CallBack,ccc3(74,34,9),ccc3(255,245,133),nil,nil)	
end

local function _Btn_Colse_Shared_CallBack()
	m_competitionSharedSelectLayer:removeFromParentAndCleanup(true)
	m_competitionSharedSelectLayer = nil 
end

function ShowCompetitionSharedSelectLayer()
	InitVars()
	
	m_competitionSharedSelectLayer =  TouchGroup:create()
	m_competitionSharedSelectLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer_SharedButton.json" ) )
	
	ShowUI()
	--关闭按钮
	local btn_close_shared = tolua.cast(m_competitionSharedSelectLayer:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(btn_close_shared,nil,nil,_Btn_Colse_Shared_CallBack,nil,nil,nil,nil)
	
	return m_competitionSharedSelectLayer
end