
--夺宝开始celina

module("DobkStartLayer", package.seeall)
require "Script/Main/Dobk/DobkWinLayer"
require "Script/Main/Dobk/DobkTenLayer"
--变量
local m_layer_start = nil 
local m_b_getData  = false
local m_times  = 0
local m_eID  = nil
local m_modelID = nil
local m_action_end = nil 

--数据

local GetPlayerModelID = DobkData.GetPlayerModelID

--逻辑


--界面
local CreateDobkWinLayer = DobkWinLayer.CreateDobkWinLayer
local CreateDobkTenLayer = DobkTenLayer.CreateDobkTenLayer

local function InitVars()
	m_layer_start = nil
	m_b_getData = false
	m_times = 0
	m_eID = nil
	m_modelID = nil
	m_action_end = false
end
function GetStartLayer()
	return m_layer_start
end
local function CallBack()
	m_layer_start:removeFromParentAndCleanup(true)
	InitVars()
end
local function ToResultLayer()
	--到结果界面
	if DobkLogic.GetBWin() == true then
		--到胜利界面
		if m_times == 1 then
			AddLabelImg(CreateDobkWinLayer(CallBack,m_eID,m_modelID,m_times),1000,m_layer_start)
		else
			--掠夺十次
			AddLabelImg(CreateDobkTenLayer(CallBack),1000,m_layer_start)	
		end
	else
		--到失败界面
		--print("失败")
		if m_times == 1 then
			AddLabelImg(CreateDobkWinLayer(CallBack,m_eID,m_modelID,m_times),1000,m_layer_start)
		else
			--掠夺十次
			AddLabelImg(CreateDobkTenLayer(CallBack),1000,m_layer_start)	
		end
	end
end
local function ShowResult()
	--结果已经出来了
	m_b_getData = true
	if m_action_end== true then
		ToResultLayer()
	end
end

local function EndAction()
	m_action_end = true
	if m_b_getData == true then
		
		ToResultLayer()
	end
end

local function EndVSAction()
	local panelStart = tolua.cast(m_layer_start:getWidgetByName("Panel_Start"),"Layout")
	DobkLogic.AddImageAction(GetPlayerModelID(),10,ccp(panelStart:getContentSize().width*0.2+80,200),panelStart,false,nil,Ani_Def_Key.Ani_attack)
	DobkLogic.AddImageAction(m_modelID,11,ccp(panelStart:getContentSize().width*0.8-80,200),panelStart,true,EndAction,Ani_Def_Key.Ani_attack)
end
local function PlayVsAnimation()
	local panelStart = tolua.cast(m_layer_start:getWidgetByName("Panel_Start"),"Layout")
	local imgVS = ImageView:create()
	imgVS:loadTexture("Image/imgres/dobk/vs.png")
	imgVS:setPosition(ccp(panelStart:getContentSize().width/2,panelStart:getContentSize().height/2))
	AddLabelImg(imgVS,200,panelStart)
	imgVS:setScale(2.0)
	
	local action1 = CCScaleTo:create(0.2, 0.8)
	local action2 = CCScaleTo:create(0.1, 1.0)
	local action3 = CCCallFunc:create(EndVSAction)
	local array = CCArray:create()
	array:addObject(action1)
	array:addObject(action2)
	array:addObject(action3)
	imgVS:runAction(CCSequence:create(array))
end

local function InitUI(eID)
	--先播放VS的动画
	PlayVsAnimation()
	--得到我的形象ID，得到玩家的形象ID
	local panelStart = tolua.cast(m_layer_start:getWidgetByName("Panel_Start"),"Layout")
	DobkLogic.AddImageAction(GetPlayerModelID(),10,ccp(panelStart:getContentSize().width*0.2+80,200),panelStart,false,nil,Ani_Def_Key.Ani_stand)
	DobkLogic.AddImageAction(eID,11,ccp(panelStart:getContentSize().width*0.8-80,200),panelStart,true,nil,Ani_Def_Key.Ani_stand)
end

function CreateDobkFightLayer(eID,modelID,nTimes)
	InitVars()
	m_layer_start = TouchGroup:create()
	m_layer_start:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/DobkStart.json" ) )
	m_times = nTimes
	m_eID = eID
	m_modelID = modelID
	DobkLogic.GetResultDobk(eID,ShowResult,nTimes)
	InitUI(modelID)
	return m_layer_start
end