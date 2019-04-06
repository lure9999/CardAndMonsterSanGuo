-- for CCLuaEngine traceback
require "Script/Common/Common"
require "Script/Fight/simulationStl"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/CountryWarRaderLayer"
require "Script/Main/CountryWar/ClickCityLayer"
require "Script/Main/CountryWar/PathFinding"
require "Script/Main/CountryWar/CountryUILayer"
require "Script/Main/CountryWar/CountryWarDef"
require "Script/Main/CountryWar/CountryWarCityManager"
require "Script/Main/CountryWar/ClickCityLogic"
require "Script/Main/CountryWar/CityNode"
require "Script/Main/CountryWar/PlayerNode"
require "Script/Main/CountryWar/AtkChooseCity"
require "Script/Main/CountryWar/AtkCityData"
require "Script/Main/CountryWar/CountryChildLayer"
require "Script/Main/CountryWar/MistyManager"
require "Script/Main/CountryWar/CountryWarManager"
require "Script/Login/LoadingNewLayer"	

module("CountryWarScene", package.seeall)

require "Script/Main/CountryWar/CountryWarEventManager"

local StrokeLabel_createStrokeLabel 	= 	LabelLayer.createStrokeLabel 
local UIInterface_CreatAnimateByResID 	= 	UIInterface.CreatAnimateByResID
local GetChooseWJ						=	AtkChooseCity.GetChooseWJ

local CreateRaderLayer					=	CountryWarRaderLayer.CreateRaderLayer
local InitRaderPtData					=	CountryWarRaderLayer.InitPtData
local GetCurPtX							=	CountryWarRaderLayer.GetCurPtX
local GetCurPtY							=	CountryWarRaderLayer.GetCurPtY
local UpdateArea						=	CountryWarRaderLayer.UpdateArea
local MoveToArea						=	CountryWarRaderLayer.MoveToArea

local GetCityMaxNum						=	CountryWarData.GetCityMaxNum
local GetCityTagByIndex					= 	CountryWarData.GetCityTagByIndex
local GetCityCampByIndex				=	CountryWarData.GetCityCampByIndex
local GetCityNameByIndex				=	CountryWarData.GetCityNameByIndex
local GetGeneralResId					= 	CountryWarData.GetGeneralResId
local GetLinkCityData					=	CountryWarData.GetLinkCityData
local AnalyzeRoadPt						= 	CountryWarData.AnalyzeRoadPt
local GetAroundLinkCity					=	CountryWarData.GetAroundLinkCity
local GetCityCountry					=	CountryWarData.GetCityCountry
local GetCityState						=	CountryWarData.GetCityState
local GetTeamCity						=	CountryWarData.GetTeamCity
local GetTeamTab 						=	CountryWarData.GetTeamTab
local GetTeamLevel 						=	CountryWarData.GetTeamLevel
local GetTeamFace 						=	CountryWarData.GetTeamFace
local GetTeamName 						=	CountryWarData.GetTeamName
local GetTeamBlood 						=	CountryWarData.GetTeamBlood
local GetTeamTargetCity 				=	CountryWarData.GetTeamTargetCity
local GetTeamBloodCity					=	CountryWarData.GetTeamBloodCity
local GetTeamBloodCityTime				=	CountryWarData.GetTeamBloodCityTime
local GetPlayerCountry 					=	CountryWarData.GetPlayerCountry
local GetTeamLife						=	CountryWarData.GetTeamLife
--远征军
local GetExpeDitionCount				=	CountryWarData.GetExpeDitionCount
local GetExpeDitionIndex				=	CountryWarData.GetExpeDitionIndex
local GetExpeDitionGrid					=	CountryWarData.GetExpeDitionGrid
local GetExpeDitionCityID				=	CountryWarData.GetExpeDitionCityID
local GetExpeDitionDataByIndex			=	CountryWarData.GetExpeDitionDataByIndex
local UpdateDataByGrid					=	CountryWarData.UpdateDataByGrid
local GetDataByGrid						=	CountryWarData.GetDataByGrid
local GetMainCityByCountry				=	CountryWarData.GetMainCityByCountry
local SetCityLockByState2				=	CountryWarData.SetCityLockByState2


local GetIndexByCTag					=	CountryWarLogic.GetIndexByCTag
local GetLinkPoint						=	CountryWarLogic.GetLinkPoint
local PlayHeroAnimation					=	CountryWarLogic.PlayHeroAnimation
local CountDistanceByPoint				=	CountryWarLogic.CountDistanceByPoint
local CountCurPointIsInArea				=	CountryWarLogic.CountCurPointIsInArea
local numIsIntab						=	CountryWarLogic.numIsIntab
local JudgePtInEffectiveTab				=	CountryWarLogic.JudgePtInEffectiveTab
local JudgePtInAreType					=	CountryWarLogic.JudgePtInAreType
local CreateLabel 						=	CountryWarLogic.CreateLabel
local CountCurPoints 					=	CountryWarLogic.CountCurPoints
local GetCityIsRetreat					=	CountryWarLogic.GetCityIsRetreat
local GetCityIsDart						=	CountryWarLogic.GetCityIsDart
local GetCurActType						=	CountryWarLogic.GetCurActType
local InsertSomeTeamInfo				=	CountryWarLogic.InsertSomeTeamInfo
local DelSomeTeamInfo					=	CountryWarLogic.DelSomeTeamInfo
local UpdateSomeTeamInfo				=	CountryWarLogic.UpdateSomeTeamInfo
local JudgeUpdateType					=	CountryWarLogic.JudgeUpdateType
local JudgeCityCenter					=	CountryWarLogic.JudgeCityCenter
local JudgeCityLock 					=	CountryWarLogic.JudgeCityLock
local JudgeCityManZu					=	CountryWarLogic.JudgeCityManZu
local JudgeIsEnemyMainCity				=	CountryWarLogic.JudgeIsEnemyMainCity
--action create
local CreateCity						=	CountryWarLogic.CreateCity

local SetRoleState						=	CountryUILayer.SetRoleState

local ToGetWarTCList					=	ClickCityLogic.ToGetWarTCList
local GetWarCTData 						=	AtkCityData.GetWarCTData

--Loading 界面接口
--[[local UI_Loading_Show 					= 	LoadingLayer.Show
local UI_Loading_SetResTable 			= 	LoadingLayer.SetResTable
local UI_Loading_GetLoadingUI 			= 	LoadingLayer.GetLoadingUI
local UI_Loading_SetCallBackFun 		= 	LoadingLayer.SetCallBackFun]]--

local UI_Loading_Show			  = LoadingNewLayer.ShowLoading
local UI_Loading_GetLoadingUI     = LoadingNewLayer.GetLoadingLayerUI
local UI_Loading_SetResTable      = LoadingNewLayer.SetLoadResTable
local UI_Loading_SetCallBackFun   = LoadingNewLayer.SetFCallBack


local m_CountryWarPanel = nil
local m_bClicked 		= nil
local m_nClickedCount   = nil
local m_CityTab			= nil
local m_ClickPanel		= nil
local m_TabHeroInfo		= {}
local m_TabArea			= {}
local m_TabUICallBack	= {}
local m_RaderLayer		= nil
local m_CurAreaNum		= nil
local nAreaType			= nil
local m_CurNodePt		= nil
local m_RadarMoveScale  = nil
local m_pWardScene		= nil
local m_MapPanel		= nil
local m_CurAreaTab		= {}
local m_NodeObjTab 		= {}
local m_PlayerTab 		= {}
local m_CurScrollAreaNum= nil
local m_EventObj 		= nil
local m_InnerPos		= nil
local m_ScreenRect		= nil
local m_WillTeamer 		= nil
local m_IsLeaveFromMine = nil
local m_InnerLeavePt 	= nil
local m_CurUIState		= nil
local m_CurClickCity    = nil
local m_nUILayer 		= nil
local m_DartTab 		= {}
local m_RetreatTab 		= {}
local m_TeamTab			= {}
local m_EventObjTab   	= {}
local m_ActType 		= nil
local m_CodeRunningBegin= nil
local m_CodeRunningEnd  = nil
local m_nCreateParent   = nil
local m_MistyPanel 		= nil 
local m_InitCity 		= nil
local m_NewCity 		= nil
local m_MistyObj 		= nil
local m_CWarObj 		= nil
local m_CallBackFromParent = nil
local m_TabCityArea 	= {}   	--每个城市对应的区域
local m_UITab 			= nil
local m_ComeInCallBack  = nil
local m_IsSingleBack    = nil

local function InitVars()
	m_bClicked 		 	= nil
	m_nClickedCount  	= nil
	m_CityTab		  	= nil
	m_ClickPanel		= nil
	m_TabHeroInfo		= nil
	m_TabArea			= nil
	m_RaderLayer		= nil
	m_ScrollOffset		= nil
	m_ScrollInitPt		= nil
	m_ScrollNewPt		= nil
	--m_pWardScene		= nil
	m_MapPanel			= nil
	m_CurScrollAreaNum	= nil
	m_EventObj 			= nil
	m_InnerPos			= nil
	m_ScreenRect		= nil
	m_WillTeamer 		= nil
	m_IsLeaveFromMine   = nil
	m_InnerLeavePt 		= nil
	m_CurUIState		= nil
	m_CurClickCity    	= nil
	m_nUILayer 			= nil
	m_ActType 			= nil
	m_CodeRunningBegin  = nil
	m_CodeRunningEnd    = nil
    m_DartTab 			= {}
    m_RetreatTab 		= {}
    m_EventObjTab   	= {}
    m_MistyPanel 		= nil
    m_NewCity 			= nil
    m_MistyObj 			= nil
    m_CWarObj 			= nil
    m_UITab 			= nil
    --m_ComeInCallBack  	= nil
end

local tabCountryVertex = {1,31,35,5}

local CreateParent_Type = 
{
	Parent_MainScene  = 0,
	Parent_CropScene  = 1,
	Parent_FightScene = 2,
}

local City_Ani_Name = {
	Normal		=	"putong_n",
	Normal_S	=	"putong_d",
}

local City_State = {
	Normal 		=	0,
	Surround 	=	1,
	GuildWar 	=	2,
}

local MAP_WIDTH		= 5700 
local MAP_HEIGHT	= 4480

function GetCountryMapPanel(  )
	return m_CountryWarPanel
end

local function CityActionState( nState )
	for key, value in pairs(m_NodeObjTab) do
		value:SetCitytHeart(nState)
	end
end
--得到当前离开pos
function SetMapCurPt( )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local inner = ScrollView_Map:getInnerContainer()
	local x = inner:getPositionX()
	local y = inner:getPositionY()

	m_InnerLeavePt = ccp(x,y)
end
--设置是否从国战页面离开的bool值
function SetLevelSceneFromCountryWar( nState )
	m_IsLeaveFromMine = nState
	SetMapCurPt()
end

function GetLevelSceneFromCountryWar(  )
	return m_IsLeaveFromMine
end

function GetCenterCityPercent( nCityTag )
	--取得点击层
	local nCenterNode = m_ClickPanel:getChildByTag(nCityTag)
	local nCenterX = nCenterNode:getPositionX()
	local nCenterY = nCenterNode:getPositionY()
	return nCenterX,nCenterY
end

--设置国战地图跳转到离开时的pos
function SetMapToLeavePt(  )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local inner = ScrollView_Map:getInnerContainer()
	inner:setPosition(ccp(m_InnerLeavePt.x, m_InnerLeavePt.y))
end

local function CheckShowArea(nTab, nAreaNum)
	-- 检测显示区域
	for j=1,35 do
		local narea = m_MapPanel:getChildByTag(10000 + j)
		if numIsIntab(j,nTab) == true then
			--print(j.."区域显示")
			narea:setVisible(true)
			for i=1,table.getn(m_TabArea[j]["areaNode"]) do
				local node = m_TabArea[j]["areaNode"][i]  		--显示该区域的所有城市node节点
				node:setVisible(true)
			end
		else
			--print(j.."区域隐藏")
			narea:setVisible(false)
			for i=1,table.getn(m_TabArea[j]["areaNode"]) do
				local node = m_TabArea[j]["areaNode"][i]		--隐藏该区域的所有城市node节点
				node:setVisible(false)
			end
		end
	end
end

local function GetShowAreaTab( nType )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local inner = ScrollView_Map:getInnerContainer()
	local innerX = inner:getPositionX()
	local innerY = inner:getPositionY()
	local ptPt = ccp(math.abs(innerX) + CommonData.g_nDeginSize_Width * 0.5,math.abs(innerY)+ CommonData.g_nDeginSize_Height * 0.5)
	m_ScreenRect.origin.x = math.abs(innerX) - MAP_WIDTH/5 * 0.5
	m_ScreenRect.origin.y = math.abs(innerY) - MAP_HEIGHT/7 * 0.5
	--检测当前区域是否发生改变
	if ptPt ~= nil then
		local nCurAreaNum = CountCurPoints(ptPt, MAP_WIDTH/5, MAP_HEIGHT/7)
		if m_CurScrollAreaNum ~= nCurAreaNum then
			CheckShowArea(m_TabArea[nCurAreaNum]["aroundArea"], nCurAreaNum)
			--区域发生变化算出rect
		else
			--区域没有变化
		end
		m_CurScrollAreaNum = nCurAreaNum
	end
end 

local function ReturnMainCity( )
	m_CountryWarPanel:setVisible(false)
	m_CountryWarPanel:setPositionX(-10000)
	AudioUtil.playBgm("audio/bgm/music_z.mp3",true)
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")	
	if ScrollView_Map:getNodeByTag(1899) ~= nil then
		ScrollView_Map:removeNodeByTag(1899)
		ClickCityLayer.InitVars()
	end

	if m_nCreateParent == CreateParent_Type.Parent_MainScene then
		MainScene.SetClickStateByCountryWar(false)
		MainScene.AddSystemBtn(false)
		print("离开国战,返回主场景 x = "..CommonData.g_CountryWarLayer:getPositionX())
		--Pause()
		MainScene.HideMain(true)

	elseif m_nCreateParent == CreateParent_Type.Parent_CropScene then
		CorpsScene.SetClickStateByCountryWar(false)
		MainScene.SetClickStateByCountryWar(false)
		print(CommonData.g_CountryWarLayer:getPositionX(), CommonData.g_CountryWarLayer:getPositionY())
		print("离开国战,返回军团场景 x = "..CommonData.g_CountryWarLayer:getPositionX())
		--Pause()
		CorpsScene.HideCorps(true)

	end

	if m_pWardScene ~= nil then
		m_pWardScene:removeFromParentAndCleanup(true)
	end

	--返回主城停止心跳包
	CityActionState(false)
end

local function OpenRadarLayer( ... )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local inner = ScrollView_Map:getInnerContainer()
	--print(inner:getPositionX(),inner:getPositionY())
	MoveToArea(inner:getPositionX(),inner:getPositionY())
	if m_CountryWarPanel:getChildByTag(899) == nil then
		m_CountryWarPanel:addChild(m_RaderLayer,899)
		CountryWarRaderLayer.PlayRadarAni()
	end
end

local function GetCurState(  )
	return 0
end

local function JudgeMoveMap( nMap,sender )
	local nPosX = sender:convertToWorldSpace(ccp(0, 0)).x
	local nPosY = sender:convertToWorldSpace(ccp(0, 0)).y
	local w_Width = MAP_WIDTH - CommonData.g_nDeginSize_Width
	local w_Height = MAP_HEIGHT - CommonData.g_nDeginSize_Height
	--当前点击的坐标已0.5,0.5锚点 + 距离屏幕边缘距离 - 屏幕宽度  = 要移动的距离 / 滚动区域的大小 = 滚动的百分比
	local isXMove = false
	local isYMove = false
	local disX,percentX
	if nPosX >= CommonData.g_nDeginSize_Width - 150 then
		disX = (sender:getPositionX() + 200) - CommonData.g_nDeginSize_Width
		percentX = disX / w_Width * 100
		isXMove = true
	elseif nPosX <= 150 then
		disX = sender:getPositionX() - 200
		percentX = disX / w_Width * 100
		isXMove = true		
	end
	--Y轴移动
	local disY,percentY
	if nPosY >= CommonData.g_nDeginSize_Height - 150 then
		disY = (sender:getPositionY() - CommonData.g_nDeginSize_Height * 0.4) - 200
		percentY = disY / w_Height * 100
		isYMove = true
	elseif nPosY <= 150 then
		disY = sender:getPositionY() - 200
		percentY = disY / w_Height * 100
		isYMove = true		
	end
	if isXMove == true and isYMove == false then
		nMap:scrollToPercentHorizontal(percentX,0.5,true)
	elseif isXMove == false and isYMove == true then
		nMap:scrollToPercentVertical(100 - percentY,0.5,true)
	elseif isXMove == true and isYMove == true then
		nMap:scrollToPercentBothDirection(ccp(percentX,(100 - percentY)),0.5,true)
	else
		print("不调整")         
	end
end

function MoveToPt( targetPt )
	m_CountryWarPanel:setVisible(true)
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local inner = ScrollView_Map:getInnerContainer()
	local isBasePointX = false
	local isBasePointY = false
	--判断当前点是否在有效区域内
	local nPerX,nPerY,areaX,areaY
	if targetPt ~= nil then
		m_CurAreaNum = CountCurPoints(targetPt, MAP_WIDTH/5, MAP_HEIGHT/7)
		if JudgePtInEffectiveTab(targetPt, MAP_WIDTH/5, MAP_HEIGHT/7, m_TabArea) then
			--在有效区域内移动以中心点移动
			--print("当前城市在中间区域")
			nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
			nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height)  * 100
			nAreaType = City_Area.Eff_Normal
		else
			nAreaType = JudgePtInAreType(m_CurAreaNum)
			if nAreaType == City_Area.NoEff_Left then
				--print("当前城市在左边区域")
				if targetPt.x <= CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height)  * 100
			elseif nAreaType == City_Area.NoEff_Right then
				--print("当前城市在右边区域")
				if targetPt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height)  * 100
			elseif nAreaType == City_Area.NoEff_Left_Bottom then
				--print("当前城市在左下角区域")
				if targetPt.x <= CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if targetPt.y <= CommonData.g_nDeginSize_Height * 0.54 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Left_Top then
				--print("当前城市在左上角区域")
				if targetPt.x <= CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if targetPt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Right_Top then
				--print("当前城市在右上角区域")
				if targetPt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if targetPt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end	
			elseif nAreaType == City_Area.NoEff_Right_Bottom then
				--print("当前城市在右下角区域")
				if targetPt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if targetPt.y <= CommonData.g_nDeginSize_Height * 0.54 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Bottom then
				--print("当前城市在底部区域")
				nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				if targetPt.y <= CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Top then
				--print("当前城市在顶部区域")
				nPerX = (targetPt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				if targetPt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (targetPt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			else
			 	--print("未知错误"..nAreaType)		
			end
		end
		if nPerX ~= nil and nPerY ~= nil then 
			if nPerX < 0 then nPerX = 0 end
			if nPerX > 100 then nPerX = 100 end
			if nPerY < 0 then nPerY = 0 end
			if nPerY > 100 then nPerY = 100 end

			ScrollView_Map:scrollToPercentBothDirection(ccp(nPerX,nPerY),0.5,true)
		end
	end
	m_CurNodePt = ccp(targetPt.x, targetPt.y)
	m_InnerPos = CCPoint(inner:getPositionX(), inner:getPositionY())
	UpdateArea(m_CurAreaNum, nAreaType ,nPerX, nPerY, isBasePointX, isBasePointY)
	GetShowAreaTab()
end

function SetNewCity( nCityID )
	if m_NewCity == nil then
		m_NewCity = nCityID
	end
end

function MoveToHeroPt( nHeroCity, nTimes, isNewGuilde, isEnd )
	m_CountryWarPanel:setVisible(true)
	m_IsLeaveFromMine = false
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local inner = ScrollView_Map:getInnerContainer()
	local isBasePointX = false
	local isBasePointY = false

	--判断当前点是否在有效区域内
	local nPerX,nPerY,areaX,areaY
	local heroC = nil
	if nHeroCity ~= nil then
		heroC = nHeroCity
	else
		heroC = m_TabHeroInfo.City
	end
	if ScrollView_Map:getChildByTag(heroC) ~= nil then
		local x  =  ScrollView_Map:getChildByTag(heroC):getPositionX()
		local y  =  ScrollView_Map:getChildByTag(heroC):getPositionY()
		m_CurNodePt = ccp(x,y)
		--m_CurAreaNum = CountCurPointIsInArea(m_CurNodePt, MAP_WIDTH/5, MAP_HEIGHT/7, m_TabArea)
		m_CurAreaNum = CountCurPoints(m_CurNodePt, MAP_WIDTH/5, MAP_HEIGHT/7)
		if JudgePtInEffectiveTab(m_CurNodePt, MAP_WIDTH/5, MAP_HEIGHT/7, m_TabArea) then
			--在有效区域内移动以中心点移动
			nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
			nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height)  * 100
			nAreaType = City_Area.Eff_Normal
		else
			--以0,0点移动(判断是上下左右)
			nAreaType = JudgePtInAreType(m_CurAreaNum)
			if nAreaType == City_Area.NoEff_Left then
				--print("当前城市在左边无效区域.."..CommonData.g_nDeginSize_Width)
				if m_CurNodePt.x <= CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
			elseif nAreaType == City_Area.NoEff_Right then
				--print("当前城市在右边无效区域.."..CommonData.g_nDeginSize_Width)
				if m_CurNodePt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
			elseif nAreaType == City_Area.NoEff_Left_Bottom then
				--print("当前城市在左下角无效区域.."..CommonData.g_nDeginSize_Width)
				if m_CurNodePt.x <= CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if m_CurNodePt.y <= CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Left_Top then
				--print("当前城市在左上角无效区域.."..CommonData.g_nDeginSize_Width)
				if m_CurNodePt.x <= CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if m_CurNodePt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Right_Top then
				--print("当前城市在右上角无效区域.."..CommonData.g_nDeginSize_Width)
				if m_CurNodePt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if m_CurNodePt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Right_Bottom then
				--print("当前城市在右下角无效区域.."..CommonData.g_nDeginSize_Width)
				if m_CurNodePt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
					nPerX = m_TabArea[m_CurAreaNum].BeginX / (MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100		
				else
					isBasePointX = true
					nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				end
				if m_CurNodePt.y <= CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Bottom then
				--print("当前城市在底部无效区域.."..CommonData.g_nDeginSize_Width)
				nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				if m_CurNodePt.y <= CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			elseif nAreaType == City_Area.NoEff_Top then
				--print("当前城市在顶部无效区域.."..CommonData.g_nDeginSize_Width)
				nPerX = (m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5) /(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100
				if m_CurNodePt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
					nPerY = 100 - m_TabArea[m_CurAreaNum].BeginY / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				else
					isBasePointY = true
					nPerY = 100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5) / (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100
				end
			else
			 	print("未知错误"..nAreaType)		
			end
		end
		--print(nPerX,nPerY,nAreaType,areaX,areaY)
		if nPerX ~= nil and nPerY ~= nil then 
			if nPerX < 0 then nPerX = 0 end
			if nPerX > 100 then nPerX = 100 end
			if nPerY < 0 then nPerY = 0 end
			if nPerY > 100 then nPerY = 100 end
			local pTime = 0.5
			if nTimes ~= nil then
				pTime = nTimes
			end
			if isNewGuilde == true then
				if isEnd == true then
					ScrollView_Map:jumpToPercentBothDirection(ccp(nPerX,nPerY))
				else
					ScrollView_Map:scrollToPercentBothDirection(ccp(nPerX,nPerY),pTime,false)
				end
			else
				if nHeroCity ~= nil then 
					ScrollView_Map:scrollToPercentBothDirection(ccp(nPerX,nPerY),pTime,true)
				else
					ScrollView_Map:jumpToPercentBothDirection(ccp(nPerX,nPerY))
				end
			end
		end
	end
	m_InnerPos = CCPoint(inner:getPositionX(), inner:getPositionY())
	UpdateArea(m_CurAreaNum, nAreaType ,nPerX, nPerY, isBasePoint, isBasePointY)
	GetShowAreaTab()
	m_WillTeamer = nHeroCity
end

function OpenCountryWarLayer( )
	m_CountryWarPanel:setVisible(true)
	m_IsLeaveFromMine = false

	AudioUtil.playBgm("audio/bgm/music_g.mp3",true)
	
	if m_NewCity == nil then
		SetMapToLeavePt()
	else
		MoveToHeroPt(m_NewCity)
		m_NewCity = nil
	end
	CityActionState(true)
	if m_nUILayer ~= nil then
		CountryUILayer.AddChat()
		m_nUILayer:setTouchEnabled(true)
	end

	if m_pWardScene ~= nil then
		m_pWardScene:removeFromParentAndCleanup(true)
		--返回军团或者主场景加载国战场景文件
		local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
		ScrollView_Map:addNode(m_pWardScene, 1299, 1299)
	end

	if m_nCreateParent == CreateParent_Type.Parent_MainScene then
   		MainScene.HideMain( false )
   	elseif m_nCreateParent == CreateParent_Type.Parent_CropScene then
   		CorpsScene.HideCorps( false )
   	end

end

function RemoveAtkChooseLayer( )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	if ScrollView_Map:getNodeByTag(1900) ~= nil then
		ScrollView_Map:getNodeByTag(1900):setVisible(false)
		ScrollView_Map:removeNodeByTag(1900)
		m_CurUIState = CityEventState.E_CityEventState_Normal
	end
	SetMapCurPt()

	m_EventObj:RemoveAllRoad(m_ClickPanel)
end

local function CountryMapMove()
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	--大的世界地图移动回调
	local nScrollX = GetCurPtX()
	local nScrollY = GetCurPtY()
	if nAreaType == City_Area.Eff_Normal then
		--print("正常状态滚动")
		if nScrollX ~=nil then 
			ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
		end
		if nScrollY~=nil then
			ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
		end	
	elseif nAreaType == City_Area.NoEff_Left then
		--print("左边无效区域状态滚动.."..m_CurNodePt.y)
		if nScrollX ~=nil then 
			if m_CurNodePt.x <= CommonData.g_nDeginSize_Width * 0.5 then
				ScrollView_Map:jumpToPercentHorizontal((m_TabArea[m_CurAreaNum].BeginX  + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
			else
				ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)				
			end
		end
		if nScrollY~=nil then
			ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5  + nScrollY)/ (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
		end	
	elseif nAreaType == City_Area.NoEff_Right then
		--print("右边无效区域状态滚动")
		if nScrollX ~= nil then 
			if m_CurNodePt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
				ScrollView_Map:jumpToPercentHorizontal((m_TabArea[m_CurAreaNum].BeginX  + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
			else
				ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)				
			end
		end
		if nScrollY~=nil then
			ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5  + nScrollY)/ (MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
		end	
	elseif nAreaType == City_Area.NoEff_Left_Bottom then
		--print("左下角无效区域状态滚动")
		if nScrollX ~=nil then 
			if m_CurNodePt.x <= CommonData.g_nDeginSize_Width * 0.5 then
				ScrollView_Map:jumpToPercentHorizontal((m_TabArea[m_CurAreaNum].BeginX  + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
			else
				ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)				
			end
		end
		if nScrollY~=nil then
			if m_CurNodePt.y <= CommonData.g_nDeginSize_Height * 0.5 then
				ScrollView_Map:jumpToPercentVertical(100 - (m_TabArea[m_CurAreaNum].BeginY + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			else
				ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			end
		end
	elseif nAreaType == City_Area.NoEff_Left_Top then
		--print("左上角无效区域状态滚动")
		if nScrollX ~=nil then 
			if m_CurNodePt.x <= CommonData.g_nDeginSize_Width * 0.5 then
				ScrollView_Map:jumpToPercentHorizontal((m_TabArea[m_CurAreaNum].BeginX  + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
			else
				ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)				
			end
		end
		if nScrollY~=nil then
			if m_CurNodePt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
				ScrollView_Map:jumpToPercentVertical(100 - (m_TabArea[m_CurAreaNum].BeginY + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			else
				ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			end
		end	
	elseif nAreaType == City_Area.NoEff_Right_Top then
		--print("右上角无效区域状态滚动")
		if nScrollX ~=nil then 
			if m_CurNodePt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
				ScrollView_Map:jumpToPercentHorizontal((m_TabArea[m_CurAreaNum].BeginX  + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
			else
				ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)				
			end
		end
		if nScrollY~=nil then
			if m_CurNodePt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
				ScrollView_Map:jumpToPercentVertical(100 - (m_TabArea[m_CurAreaNum].BeginY + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			else
				ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			end
		end	
	elseif nAreaType == City_Area.NoEff_Right_Bottom then
		--print("右下角无效区域状态滚动")
		if nScrollX ~=nil then 
			if m_CurNodePt.x >= MAP_WIDTH - CommonData.g_nDeginSize_Width * 0.5 then
				ScrollView_Map:jumpToPercentHorizontal((m_TabArea[m_CurAreaNum].BeginX  + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
			else
				ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)				
			end
		end
		if nScrollY~=nil then
			if m_CurNodePt.y <= CommonData.g_nDeginSize_Height * 0.5 then
				ScrollView_Map:jumpToPercentVertical(100 - (m_TabArea[m_CurAreaNum].BeginY + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			else
				ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			end
		end
	elseif nAreaType == City_Area.NoEff_Bottom then
		--print("下边无效区域状态滚动")
		if nScrollX ~=nil then 
			ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
		end
		if nScrollY~=nil then
			if m_CurNodePt.y <= CommonData.g_nDeginSize_Height * 0.5 then
				ScrollView_Map:jumpToPercentVertical(100 - (m_TabArea[m_CurAreaNum].BeginY + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			else
				ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			end
		end
	elseif nAreaType == City_Area.NoEff_Top then
		--print("顶部无效区域状态滚动")
		if nScrollX ~=nil then 
			ScrollView_Map:jumpToPercentHorizontal((m_CurNodePt.x - CommonData.g_nDeginSize_Width * 0.5 + nScrollX )/(MAP_WIDTH - CommonData.g_nDeginSize_Width) * 100)
		end
		if nScrollY~=nil then
			if m_CurNodePt.y >= MAP_HEIGHT - CommonData.g_nDeginSize_Height * 0.5 then
				ScrollView_Map:jumpToPercentVertical(100 - (m_TabArea[m_CurAreaNum].BeginY + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			else
				ScrollView_Map:jumpToPercentVertical(100 - (m_CurNodePt.y - CommonData.g_nDeginSize_Height * 0.5 + nScrollY)/(MAP_HEIGHT - CommonData.g_nDeginSize_Height) * 100)
			end
		end				
	end
	GetShowAreaTab()
end

--得到当前某种状态的角色都是哪些
function GetCurStateRole( nRoleState_1, nRoleState_2, nTarCity )
	local tab = {}
	if m_PlayerTab["MainGeneral"] ~= nil then
		if m_PlayerTab["MainGeneral"]:GetState() == nRoleState_1 or m_PlayerTab["MainGeneral"]:GetState() == nRoleState_2 then
			if GetTeamLife(0) == false then
				if nTarCity ~= nil then
					if m_PlayerTab["MainGeneral"]:GetCurNode() ~= nTarCity then
						print("MainGeneral"..nTarCity)
						table.insert(tab, PlayerType.E_PlayerType_Main)
					end
				else
					table.insert(tab, PlayerType.E_PlayerType_Main)
				end
			end
		end
	end
	if m_PlayerTab["Teamer1"] ~= nil then
		if m_PlayerTab["Teamer1"]:GetState() == nRoleState_1 or m_PlayerTab["Teamer1"]:GetState() == nRoleState_2 then
			if GetTeamLife(1) == false then
				if nTarCity ~= nil then
					if m_PlayerTab["Teamer1"]:GetCurNode() ~= nTarCity then
						print("Teamer1"..nTarCity)
						table.insert(tab, PlayerType.E_PlayerType_1)
					end
				else
					table.insert(tab, PlayerType.E_PlayerType_1)
				end
			end
		end
	end
	if m_PlayerTab["Teamer2"] ~= nil then
		if m_PlayerTab["Teamer2"]:GetState() == nRoleState_1 or m_PlayerTab["Teamer2"]:GetState() == nRoleState_2 then
			if GetTeamLife(2) == false then
				if nTarCity ~= nil then
					if m_PlayerTab["Teamer2"]:GetCurNode() ~= nTarCity then	
						print("Teamer2"..nTarCity)
						table.insert(tab, PlayerType.E_PlayerType_2)
					end
				else
					table.insert(tab, PlayerType.E_PlayerType_2)
				end
			end
		end
	end
	if m_PlayerTab["Teamer3"] ~= nil then
		if m_PlayerTab["Teamer3"]:GetState() == nRoleState_1 or m_PlayerTab["Teamer3"]:GetState() == nRoleState_2 then
			if GetTeamLife(3) == false then
				if nTarCity ~= nil then
					if m_PlayerTab["Teamer3"]:GetCurNode() ~= nTarCity then
						print("Teamer3"..nTarCity)
						table.insert(tab, PlayerType.E_PlayerType_3)
					end
				else
					table.insert(tab, PlayerType.E_PlayerType_3)
				end
			end
		end
	end

	return tab
end
--得到某种状态的角色
function GetStateRole( nRoleState_1 )
	local tab = {}
	if m_PlayerTab["MainGeneral"] ~= nil then
		if m_PlayerTab["MainGeneral"]:GetState() == nRoleState_1 then
			table.insert(tab, PlayerType.E_PlayerType_Main)
		end
	end
	if m_PlayerTab["Teamer1"] ~= nil then
		if m_PlayerTab["Teamer1"]:GetState() == nRoleState_1 or m_PlayerTab["Teamer1"]:GetState() == nRoleState_2 then
			table.insert(tab, PlayerType.E_PlayerType_1)
		end
	end
	if m_PlayerTab["Teamer2"] ~= nil then
		if m_PlayerTab["Teamer2"]:GetState() == nRoleState_1 or m_PlayerTab["Teamer2"]:GetState() == nRoleState_2 then
			table.insert(tab, PlayerType.E_PlayerType_2)
		end
	end
	if m_PlayerTab["Teamer3"] ~= nil then
		if m_PlayerTab["Teamer3"]:GetState() == nRoleState_1 or m_PlayerTab["Teamer3"]:GetState() == nRoleState_2 then
			table.insert(tab, PlayerType.E_PlayerType_3)
		end
	end

	return tab
end

function GetBloodWarOrDefenseRole( nTarCity )
	local tab = {}

	local function IsRight( nState )
		if nState == PlayerState.E_PlayerState_Free or 
		   nState == PlayerState.E_PlayerState_Move or 
		   nState == PlayerState.E_PlayerState_Fight or 
		   nState == PlayerState.E_PlayerState_CWar or
		   nState == PlayerState.E_PlayerState_Battle or
		   nState == PlayerState.E_PlayerState_Rest then

		   return true
		end

		return false
	end
	if m_PlayerTab["MainGeneral"] ~= nil then
		if IsRight(m_PlayerTab["MainGeneral"]:GetState()) == true then
			if m_PlayerTab["MainGeneral"]:GetCurNode() ~= nTarCity then
				print("MainGeneral"..nTarCity)
				table.insert(tab, PlayerType.E_PlayerType_Main)
			end
		end
	end
	if m_PlayerTab["Teamer1"] ~= nil then
		if IsRight(m_PlayerTab["Teamer1"]:GetState()) == true then
			if m_PlayerTab["Teamer1"]:GetCurNode() ~= nTarCity then
				print("Teamer1"..nTarCity)
				table.insert(tab, PlayerType.E_PlayerType_1)
			end
		end
	end
	if m_PlayerTab["Teamer2"] ~= nil then
		if IsRight(m_PlayerTab["Teamer2"]:GetState()) == true then
			if m_PlayerTab["Teamer2"]:GetCurNode() ~= nTarCity then	
				print("Teamer2"..nTarCity)
				table.insert(tab, PlayerType.E_PlayerType_2)
			end
		end
	end
	if m_PlayerTab["Teamer3"] ~= nil then
		if IsRight(m_PlayerTab["Teamer3"]:GetState()) == true then
			if m_PlayerTab["Teamer3"]:GetCurNode() ~= nTarCity then
				print("Teamer3"..nTarCity)
				table.insert(tab, PlayerType.E_PlayerType_3)
			end
		end
	end

	return tab
end

function GetCurWJCityTag( nCurTag )
	local function IsStateRight( nState )
		if nState == PlayerState.E_PlayerState_Fight or nState == PlayerState.E_PlayerState_CWar or nState == PlayerState.E_PlayerState_Battle then
			return true
		end

		return false
	end
	--查看当前点击城市上是否有武将
	local tabIn = {}
	if m_PlayerTab["MainGeneral"] ~= nil then
		if m_PlayerTab["MainGeneral"]:GetCurNode() == nCurTag then
			if IsStateRight(m_PlayerTab["MainGeneral"]:GetState()) == true then
				table.insert(tabIn, PlayerType.E_PlayerType_Main) 
			end
		end
	end
	if m_PlayerTab["Teamer1"] ~= nil then
		if m_PlayerTab["Teamer1"]:GetCurNode() == nCurTag then
			if IsStateRight(m_PlayerTab["Teamer1"]:GetState()) == true then
				table.insert(tabIn, PlayerType.E_PlayerType_1)
			end
		end
	end
	if m_PlayerTab["Teamer2"] ~= nil then
		if m_PlayerTab["Teamer2"]:GetCurNode() == nCurTag then
			if IsStateRight(m_PlayerTab["Teamer2"]:GetState()) == true then
				table.insert(tabIn, PlayerType.E_PlayerType_2)
			end
		end
	end
	if m_PlayerTab["Teamer3"] ~= nil then
		if m_PlayerTab["Teamer3"]:GetCurNode() == nCurTag then
			if IsStateRight(m_PlayerTab["Teamer3"]:GetState()) == true then
				table.insert(tabIn, PlayerType.E_PlayerType_3)
			end
		end
	end
	local tab = {}
	for i=1,table.getn(tabIn) do
		table.insert(tab, m_TeamTab[tabIn[i]])
	end

	return tab
end

local function ResaveMainLayer( nState )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	if ScrollView_Map ~= nil then
		--m_pWardScene:setVisible(nState)
		ScrollView_Map:setVisible(nState)
		CountryUILayer.HideUILayer(nState)
		m_ClickPanel:setVisible(nState)
		if nState == false then
			SetMapCurPt()			--隐藏页面，记录当前坐标
		else
			SetMapToLeavePt()		--显示页面，跳转到离开前的坐标
		end
	else
		print("nil nil nil")
	end
end

local function _Click_WatchWar_CallFunc( nState, nActionState, nCTag )
	ResaveMainLayer(nState)
	CityActionState(nState)
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	if ScrollView_Map:getNodeByTag(1899) ~= nil then
		ScrollView_Map:getNodeByTag(1899):setVisible(false)
		ScrollView_Map:removeNodeByTag(1899)
		ClickCityLayer.InitVars()
	end
	if nActionState ~= nil and nCTag ~= nil then
		--获得当前空闲的武将列表
		--local tabFree = GetCurStateRole(PlayerState.E_PlayerState_Free)
		local pCityPtX,pCityPtY = GetCenterCityPercent(nCTag)
		--[[if nActionState == CityEventState.E_CityEventState_Dart then
			--突进事件
			m_CurUIState = CityEventState.E_CityEventState_Dart
			m_EventObj:CityEventByRoleDart( CityEventState.E_CityEventState_Dart, ScrollView_Map, pCityPtX, pCityPtY)
		elseif nActionState == CityEventState.E_CityEventState_Retreat then
			--撤退事件
			m_CurUIState = CityEventState.E_CityEventState_Retreat
			m_EventObj:CityEventByRoleRetreat(CityEventState.E_CityEventState_Retreat, ScrollView_Map, pCityPtX, pCityPtY)
			local tabb = {}
			tabb[1] = 192
			m_EventObj:AddShowRoadAni( nCTag, tabb, m_ClickPanel )
		end]]
	end		
	if nState == false and nCTag ~= nil then 		--准备进入观战
		return GetCurWJCityTag(nCTag)
	else
		return nil
	end	
end

local function onTouchEvent(sender, eventType)
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local ptPt = nil
	if eventType == TouchEventType.began then
	elseif eventType == TouchEventType.moved then
	elseif eventType == TouchEventType.ended then
		if ScrollView_Map:getNodeByTag(1899) ~= nil then
			ScrollView_Map:removeNodeByTag(1899)
			ClickCityLayer.InitVars()
		end
	end
end

--坚守回调
local function _Click_Defense_CallFunc(  )
	if ScrollView_Map:getNodeByTag(1899) ~= nil then
		ScrollView_Map:removeNodeByTag(1899)
		ClickCityLayer.InitVars()
	end
end

function StopActType( )
	print("结束血战/坚守")
	if m_ActType == nil then
		--UI界面直接创建的血战/坚守界面
		local nTarCity = CountryUILayer.GetTarCityID()
		if nTarCity ~= nil then 
			m_ActType = GetCurActType(nTarCity)
			print("nTarCity = "..nTarCity)
			print("m_ActType = "..m_ActType)
		else
			print("CountryWarScene 950")
			--Pause()
		end
	end
	if m_PlayerTab["MainGeneral"] ~= nil then
		if m_ActType == PlayerState.E_PlayerState_BloodWar then
			m_PlayerTab["MainGeneral"]:SetBloodState(false)
		elseif m_ActType == PlayerState.E_PlayerState_Defense then
			m_PlayerTab["MainGeneral"]:SetDefenseState(false)
		end
	end
	if m_PlayerTab["Teamer1"] ~= nil then
		if m_ActType == PlayerState.E_PlayerState_BloodWar then
			m_PlayerTab["Teamer1"]:SetBloodState(false)
		elseif m_ActType == PlayerState.E_PlayerState_Defense then
			m_PlayerTab["Teamer1"]:SetDefenseState(false)
		end
	end
	if m_PlayerTab["Teamer2"] ~= nil then
		if m_ActType == PlayerState.E_PlayerState_BloodWar then
			m_PlayerTab["Teamer2"]:SetBloodState(false)
		elseif m_ActType == PlayerState.E_PlayerState_Defense then
			m_PlayerTab["Teamer2"]:SetDefenseState(false)
		end
	end
	if m_PlayerTab["Teamer3"] ~= nil then
		if m_ActType == PlayerState.E_PlayerState_BloodWar then
			m_PlayerTab["Teamer3"]:SetBloodState(false)
		elseif m_ActType == PlayerState.E_PlayerState_Defense then
			m_PlayerTab["Teamer3"]:SetDefenseState(false)
		end
	end
end

function OpenBloodOrDefenseRewardUI(  )
	local pRewardLayer = AtkCityResultLayer.CreateAtkWarResultLayer(3,nil)
	pRewardLayer:setPosition(ccp(0,0))
	local pScene = MainScene.GetPScene()
	if m_nCreateParent == 1 then
		pScene = CorpsScene.GetPScene()
	end
	if pScene ~= nil then
		pScene:addChild(pRewardLayer,100)
	end
	--print("m_nCreateParent = "..m_nCreateParent)
end

function SetUIBtnBloodOrDefense( nState, nStr )
	CountryUILayer.SetBtnBloodOrDefense(nState, nStr)
end

function GetWJByCity( nCityTag )
	local tabFree = GetCurStateRole(PlayerState.E_PlayerState_Free, PlayerState.E_PlayerState_Move, nCityTag)
	local tab = {}
	for key,value in pairs(tabFree) do
		table.insert(tab, m_TeamTab[value])
	end
	
	return tab
end

local function JudgeIsBloodOrDefense(  )
	local tab = {}
	if m_PlayerTab["MainGeneral"] ~= nil then
		--print(m_PlayerTab["MainGeneral"]:GetBloodState(), m_PlayerTab["MainGeneral"]:GetDefenseState())
		--Pause()
	 	if m_PlayerTab["MainGeneral"]:GetBloodState() == true or m_PlayerTab["MainGeneral"]:GetDefenseState() == true then
	 		print(m_PlayerTab["MainGeneral"]:GetBloodState(), m_PlayerTab["MainGeneral"]:GetDefenseState())
	 		print("主将在血战/坚守中")
	 		table.insert(tab, PlayerType.E_PlayerType_Main)
	 	end
	end
	if m_PlayerTab["Teamer1"] ~= nil then
	 	if m_PlayerTab["Teamer1"]:GetBloodState() == true or m_PlayerTab["Teamer1"]:GetDefenseState() == true then
	 		print("Teamer1在血战/坚守中")
	 		table.insert(tab, PlayerType.E_PlayerType_1)
	 	end
	end
	if m_PlayerTab["Teamer2"] ~= nil then
	 	if m_PlayerTab["Teamer2"]:GetBloodState() == true or m_PlayerTab["Teamer2"]:GetDefenseState() == true then
	 		print("Teamer2在血战/坚守中")
	 		table.insert(tab, PlayerType.E_PlayerType_2)
	 	end
	end
	if m_PlayerTab["Teamer3"] ~= nil then
	 	if m_PlayerTab["Teamer3"]:GetBloodState() == true or m_PlayerTab["Teamer3"]:GetDefenseState() == true then
	 		print("Teamer3在血战/坚守中")
	 		table.insert(tab, PlayerType.E_PlayerType_3)
	 	end
	end
	if table.getn(tab) > 0 then
		return true,tab
	else
		print("没有在血战/坚守中的队伍")
		return false,nil
	end
end

local function _Click_City_CallFunc( sender, eventType )
	
	------------------------------------------Callback logic--------------------------------------------------

	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")

	local pCityPtX,pCityPtY = GetCenterCityPercent(sender:getTag())

	--召集回调
	local function _Click_ZhaoJi_Callfunc( )
		if m_PlayerTab["MainGeneral"] ~= nil then
			m_PlayerTab["MainGeneral"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_Main, PlayerState.E_PlayerState_Move)
		end
		if m_PlayerTab["Teamer1"] ~= nil then
			m_PlayerTab["Teamer1"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_1, PlayerState.E_PlayerState_Move)
		end
		if m_PlayerTab["Teamer2"] ~= nil then
			m_PlayerTab["Teamer2"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_2, PlayerState.E_PlayerState_Move)
		end
		if m_PlayerTab["Teamer3"] ~= nil then
			m_PlayerTab["Teamer3"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_3, PlayerState.E_PlayerState_Move)
		end

		if ScrollView_Map:getNodeByTag(1899) ~= nil then
			ScrollView_Map:removeNodeByTag(1899)
			ClickCityLayer.InitVars()
		end
	end

	--血战/坚守回调
	local function _Click_BloodWarAndDefense_CallFunc( nTarCity )
		local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
		if ScrollView_Map:getNodeByTag(1899) ~= nil then
			ScrollView_Map:removeNodeByTag(1899)
			ClickCityLayer.InitVars()
		end
		--创建血战/坚守功能界面
		local function openTeamChoose()
			if m_nUILayer ~= nil then 
				--local tabFree = GetCurStateRole(PlayerState.E_PlayerState_Free, PlayerState.E_PlayerState_Move, sender:getTag())
				if m_nUILayer:getChildByTag(1990) == nil then 
					m_ActType = GetCurActType(sender:getTag())
					local nState,tab 	= JudgeIsBloodOrDefense()

					local nChildLayer = CountryChildLayer.CreateCountryChildLayer(m_ActType, GetCityNameByIndex(GetIndexByCTag(sender:getTag())), sender:getTag(), nState, tab)
					if nChildLayer ~= nil then
						m_nUILayer:addChild(nChildLayer,1001,1990)
					end
				else
					m_nUILayer:getChildByTag(1990):setTouchEnabled(true)
					m_nUILayer:getChildByTag(1990):setVisible(true)
					m_nUILayer:getChildByTag(1990):setPositionX(m_nUILayer:getChildByTag(1990):getPositionX() - 10000)
				end
			else
				print("UI层为空")
			end
		end	
		openTeamChoose()
	end

	--突进回调
	local function _Click_Dart_CallFunc( nState )
		if nState ~= nil then
			ResaveMainLayer(nState)
		end	

		local function RemoveRoad(  )
			m_EventObj:RemoveAllRoad(m_ClickPanel)
		end

		m_DartTab = {}
		m_DartTab = GetCityIsDart(sender:getTag(), GetPlayerCountry(), m_NodeObjTab)
		m_CurUIState = CityEventState.E_CityEventState_Dart
		local isDart = m_EventObj:CityEventByRoleDart( CityEventState.E_CityEventState_Dart, ScrollView_Map, pCityPtX, pCityPtY, RemoveRoad)
		if isDart == false then
			m_CurUIState = CityEventState.E_CityEventState_Normal
		else
			m_EventObj:AddShowRoadAni(sender:getTag(), m_DartTab, m_ClickPanel )
		end
		if ScrollView_Map:getNodeByTag(1899) ~= nil then
			ScrollView_Map:removeNodeByTag(1899)
			ClickCityLayer.InitVars()
		end	

	end

	--撤退回调
	local function _Click_Retreat_CallFunc( nState )

		m_RetreatTab = {}
		m_RetreatTab = GetCityIsRetreat(sender:getTag(), GetPlayerCountry(), m_NodeObjTab)
		m_CurUIState = CityEventState.E_CityEventState_Retreat

		if nState ~= nil then
			ResaveMainLayer(nState)
		end

		local function RemoveRoad(  )
			m_EventObj:RemoveAllRoad(m_ClickPanel)
		end

		local isRetreat = m_EventObj:CityEventByRoleRetreat(CityEventState.E_CityEventState_Retreat, ScrollView_Map, pCityPtX, pCityPtY, RemoveRoad)
	
		if isRetreat == false then
			m_CurUIState = CityEventState.E_CityEventState_Normal
		else
			m_EventObj:AddShowRoadAni(sender:getTag(), m_RetreatTab, m_ClickPanel )
		end
		if ScrollView_Map:getNodeByTag(1899) ~= nil then
			ScrollView_Map:removeNodeByTag(1899)
			ClickCityLayer.InitVars()
		end

	end

	--玩家移动回调
	local function _Click_PlayerMove_CallFunc( nType )
		if nType == PlayerType.E_PlayerType_Main then
			m_PlayerTab["MainGeneral"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_Main, PlayerState.E_PlayerState_Move)
		elseif nType == PlayerType.E_PlayerType_1 then
			m_PlayerTab["Teamer1"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_1, PlayerState.E_PlayerState_Move)
		elseif nType == PlayerType.E_PlayerType_2 then
			m_PlayerTab["Teamer2"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_2, PlayerState.E_PlayerState_Move)
		elseif nType == PlayerType.E_PlayerType_3 then
			m_PlayerTab["Teamer3"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_3, PlayerState.E_PlayerState_Move)
		end

		if ScrollView_Map:getNodeByTag(1899) ~= nil then
			ScrollView_Map:removeNodeByTag(1899)
			ClickCityLayer.InitVars()
		end
	end

	--回调tab
	local tabFunc = {}
	tabFunc["zhaoji"] = _Click_ZhaoJi_Callfunc
	tabFunc["guanzhan"] = _Click_WatchWar_CallFunc
	tabFunc["jianshou"] = _Click_BloodWarAndDefense_CallFunc
	tabFunc["xuezhan"] = _Click_BloodWarAndDefense_CallFunc
	tabFunc["tujin"] = _Click_Dart_CallFunc
	tabFunc["chetui"] = _Click_Retreat_CallFunc
	tabFunc["PlayerMove"] = _Click_PlayerMove_CallFunc
	--传给迷雾管理对象
	m_MistyObj:Fun_SetCallBackData(tabFunc)
	
	---------------------------------------Click Response logic-----------------------------------------------
	local aniName,aniName_s = ""
	if GetCurState() == City_State.Normal then
		aniName   = City_Ani_Name.Normal
		aniName_s = City_Ani_Name.Normal_S
	end
	local nClickNode 	= m_ClickPanel:getChildByTag(sender:getTag())
	local pAniNodeF 	= tolua.cast(nClickNode:getComponent("CCArmature"),"CCComRender")
	local pAniNode 		= tolua.cast(pAniNodeF:getNode(),"CCArmature")	
	local nCNode 		= m_NodeObjTab[sender:getTag()]
	if eventType == TouchEventType.ended then
		pAniNode:getAnimation():play(aniName)
		--锁定判断(黄巾军事件)
		if nCNode:GetIsCenter() == true then
			TipLayer.createTimeLayer("城池被锁定,请先攻打周边城市",2)
			return
		end
		--迷雾判断
		if nCNode:GetIsCenterMisty() == true then
			if nCNode:GetLockState() == true then
				if nCNode:GetMistyIndex() ~= -1 then
					m_MistyObj:Fun_InitMistyInfoLayer(m_nUILayer, nCNode:GetMistyIndex(), sender:getTag())
				end
				return
			else
				print("该城市迷雾已解锁")
			end
		else
			if nCNode:GetLockState() == true then
				TipLayer.createTimeLayer("城池被迷雾覆盖，无法到达。",2)
				return
			end
		end
		--是否为敌方主城
		if JudgeIsEnemyMainCity(sender:getTag()) == true then
			TipLayer.createTimeLayer("敌国主城,无法攻打",2)
			return
		end
		--创建城市信息
		--移动地图坐标（判断是否需要移动）
		JudgeMoveMap(ScrollView_Map,sender)

		if m_CurUIState == CityEventState.E_CityEventState_Normal then
			if ScrollView_Map:getNodeByTag(1899) ~= nil then
				ScrollView_Map:removeNodeByTag(1899)
				ClickCityLayer.InitVars()
			end
			m_CurClickCity = sender:getTag()
			if ScrollView_Map:getNodeByTag(1899) == nil then
				--参数tab
				local nSelf = nil
				if GetCityCountry(sender:getTag()) ~= GetPlayerCountry() then
					nSelf = 0
				else
					nSelf = 1
				end
				local tabSet = {}
				tabSet["nCityTag"] 		= sender:getTag()
				tabSet["nSelf"] 		= nSelf
				tabSet["nState"] 		= GetCityState(sender:getTag())
				tabSet["sName"] 		= GetCityNameByIndex(GetIndexByCTag(sender:getTag()))
				tabSet["sCounty"] 		= GetCityCountry(sender:getTag())
				tabSet["sEnemyCounty"] 	= 1
				tabSet["nNumMine"] 		= 50
				tabSet["nNumEnemy"] 	= 50
				local tabFree = GetCurStateRole(PlayerState.E_PlayerState_Free, PlayerState.E_PlayerState_Move, sender:getTag())
				local tab = {}
				for key,value in pairs(tabFree) do
					table.insert(tab, m_TeamTab[value])
				end
				tabSet["wj"]    		= tab

				--城市响应
				local function ShowCity()
					if tonumber(GetCityState(sender:getTag()))~= COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
						NetWorkLoadingLayer.loadingShow(false)
					end
					local pCitLayer = ClickCityLayer.CreateClickCityLayer(tabSet,tabFunc)
					local pCityPtX,pCityPtY = GetCenterCityPercent(sender:getTag())
					pCitLayer:setPosition(ccp(pCityPtX - 150,pCityPtY - 150))
					ScrollView_Map:addNode(pCitLayer,1301,1899)
				end
				if tonumber(GetCityState(sender:getTag())) == COUNTRYWAR_CITY_STATE.COUNTRYWAR_CITY_PEACE then
					ShowCity()
				else
					Packet_GetCityFightCountryInfo.SetSuccessCallBack(ShowCity)
					network.NetWorkEvent(Packet_GetCityFightCountryInfo.CreatPacket(sender:getTag()))
					NetWorkLoadingLayer.loadingShow(true)
				end		
			end
		elseif m_CurUIState == CityEventState.E_CityEventState_Dart then
			--突进UI
			local function Dart_CallBack( )
				local dartTab = GetChooseWJ()
				if numIsIntab(sender:getTag(), m_DartTab) == true then
					if table.getn(dartTab) > 0 then
						for i=1,table.getn(dartTab) do
							if dartTab[i] ~= nil then
								--发送移动之前再次判断是否可以突进
								if dartTab[i]["Type"] == PlayerType.E_PlayerType_Main - 1 then
									m_PlayerTab["MainGeneral"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_Main, PlayerState.E_PlayerState_Dart)
								elseif dartTab[i]["Type"] == PlayerType.E_PlayerType_1 - 1 then
									m_PlayerTab["Teamer1"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_1, PlayerState.E_PlayerState_Dart)
								elseif dartTab[i]["Type"] == PlayerType.E_PlayerType_2 - 1 then
									m_PlayerTab["Teamer2"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_2, PlayerState.E_PlayerState_Dart)
								elseif dartTab[i]["Type"] == PlayerType.E_PlayerType_3 - 1 then
									m_PlayerTab["Teamer3"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_3, PlayerState.E_PlayerState_Dart)
								end
							end
						end
						print("突进啦")
						m_CurUIState = CityEventState.E_CityEventState_Normal 
						RemoveAtkChooseLayer()
						--删除路点
						m_EventObj:RemoveAllRoad(m_ClickPanel)
					end
				else
					local pCityName = GetCityNameByIndex(GetIndexByCTag(sender:getTag()))
					TipLayer.createTimeLayer("无法突进到"..pCityName, 2)
					--print(sender:getTag().."无法突进")
				end
			end

			ToGetWarTCList(PlayerState.E_PlayerState_Dart,GetCurWJCityTag(m_CurClickCity),Dart_CallBack)
		
		elseif m_CurUIState == CityEventState.E_CityEventState_Retreat then
			--撤退UI
			local function Retreat_CallBack( )
				local retreatTab = GetChooseWJ()
				if numIsIntab(sender:getTag(), m_RetreatTab) == true then
					if table.getn(retreatTab) > 0 then
						for i=1,table.getn(retreatTab) do
							if retreatTab[i] ~= nil then
								--发送移动之前再次判断是否可以撤退
								if retreatTab[i]["Type"] == PlayerType.E_PlayerType_Main - 1 then
									m_PlayerTab["MainGeneral"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_Main, PlayerState.E_PlayerState_Give_Way)
								elseif retreatTab[i]["Type"] == PlayerType.E_PlayerType_1 - 1 then
									m_PlayerTab["Teamer1"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_1, PlayerState.E_PlayerState_Give_Way)
								elseif retreatTab[i]["Type"] == PlayerType.E_PlayerType_2 - 1 then
									m_PlayerTab["Teamer2"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_2, PlayerState.E_PlayerState_Give_Way)
								elseif retreatTab[i]["Type"] == PlayerType.E_PlayerType_3 - 1 then
									m_PlayerTab["Teamer3"]:PlayerMove(sender:getTag(), PlayerType.E_PlayerType_3, PlayerState.E_PlayerState_Give_Way)
								end
							end
						end
						print("撤退啦")
						m_CurUIState = CityEventState.E_CityEventState_Normal 
						RemoveAtkChooseLayer()
						--删除路点
						m_EventObj:RemoveAllRoad(m_ClickPanel)
					end
				else
					local pCityName = GetCityNameByIndex(GetIndexByCTag(sender:getTag()))
					TipLayer.createTimeLayer("无法撤退到"..pCityName, 2)
					--print(sender:getTag().."无法撤退")
				end
			end

			ToGetWarTCList(PlayerState.E_PlayerState_Give_Way,GetCurWJCityTag(m_CurClickCity),Retreat_CallBack)

		end
	elseif  eventType == TouchEventType.began then
		pAniNode:getAnimation():play(aniName_s)
	elseif eventType == TouchEventType.canceled then
		pAniNode:getAnimation():play(aniName)
	end
end

local function InitCityUI( nCityNode, nCamp, nName,nScrollParent,nCtag )
	--判断每个节点属于哪个区域,并放入表中
	local nAreaNum = CountCurPoints(ccp(nCityNode:GetNode():getPositionX(),nCityNode:GetNode():getPositionY()),MAP_WIDTH/5,MAP_HEIGHT/7)
	--print("nCtag = "..nCtag.." in Area "..nAreaNum)
	m_TabCityArea[nCtag] = nAreaNum
	local pAniNodeF = tolua.cast(nCityNode:GetNode():getComponent("CCArmature"),"CCComRender")
	local pAniNode = tolua.cast(pAniNodeF:getNode(),"CCArmature")	
	local rect = pAniNode:boundingBox()
	local rectWidth = rect.size.width
	local rectheight = rect.size.height

	local Btn_Node = Widget:create()
	Btn_Node:setEnabled(true)
	Btn_Node:setTouchEnabled(true)
	Btn_Node:ignoreContentAdaptWithSize(false)
    Btn_Node:setSize(CCSize(rectWidth, rectheight))
	Btn_Node:setTag(nCtag)
	Btn_Node:addTouchEventListener(_Click_City_CallFunc)
	Btn_Node:setPosition(ccp(nCityNode:GetNode():getPositionX(),nCityNode:GetNode():getPositionY()))
	Btn_Node:setVisible(false)
	nScrollParent:addChild(Btn_Node,1300)

	--城池姓名
	local label_Name = CreateLabel(nName..nCtag,22,ccc3(176,140,108),CommonData.g_FONT1,ccp(10, -39))
	--国家信息背景层
	local spriteBg = CCSprite:create("Image/imgres/countrywar/cityNameBg.png")
	spriteBg:setPosition(ccp(0,-39))
	--国家旗帜
	if nCamp == 5 or nCamp == 6 or nCamp == 7 then
		nCamp = 5
	end
	local spriteCamp = CCSprite:create("Image/imgres/common/country/country_"..nCamp..".png")
	spriteCamp:setScale(0.75)

	local width = spriteCamp:getContentSize().width * 0.5
	spriteCamp:setPosition(ccp(label_Name:getPositionX() - label_Name:getContentSize().width * 0.5 - width,label_Name:getPositionY()))
	nCityNode:GetNode():addChild(spriteCamp,99,999)
	nCityNode:GetNode():addChild(label_Name,99,100)
	nCityNode:GetNode():addChild(spriteBg,98,998)

	--初始化雷达坐标点
	if m_RaderLayer ~= nil then 
		InitRaderPtData(nCtag,nCityNode:GetNode():getPositionX(),nCityNode:GetNode():getPositionY(),nCamp)
	end

	return nAreaNum,nCtag
end

local function _Click_Special_CallBack( sender, eventType )
	local nClickNode 	= m_ClickPanel:getChildByTag(sender:getTag())
	local pAniNodeF 	= tolua.cast(nClickNode:getComponent("CCArmature"),"CCComRender")
	local pAniNode 		= tolua.cast(pAniNodeF:getNode(),"CCArmature")	

	if eventType == TouchEventType.began then
		--print(sender:getTag())
		pAniNode:getAnimation():play("putong_d")
		
	elseif eventType == TouchEventType.moved then
		pAniNode:getAnimation():play("putong_n")
	elseif eventType == TouchEventType.ended then
		pAniNode:getAnimation():play("putong_n")

		local pTag = sender:getTag()

		if pTag%2 == 0 then
			--返回军团
			local pParent = GetCurParent()
			if pParent == 1 then
				print("父节点是军团场景,直接返回到军团场景")
				local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
				if tonumber(isCorps) > 0 then
					ReturnMainCity()
					require "Script/Main/Corps/CorpsScene"
					local p_scene  = CorpsScene.GetPScene()
					CorpsScene.ShowHideCoinBar(true)
					ChatShowLayer.ShowChatlayer(p_scene)
					RemoveAtkChooseLayer()
				else
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1507,nil)
					pTips = nil
				end
			elseif pParent == 0 then
				print("父节点是主场景，创建军团场景并进入")
				if MainScene.ShowCorpsScene() ~= false then
					ReturnMainCity()
					ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
					RemoveAtkChooseLayer()
				end
			else
				ReturnMainCity()
				ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
				RemoveAtkChooseLayer()			
			end
		else
			--返回主城
			ReturnMainCity()
			ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
			RemoveAtkChooseLayer()
			local pParent = GetCurParent()
			--判断当前父节点是否是军团，如果是需要离开场景
			if tonumber(pParent) == 1 then
				if GetLeaveCorpsCallBack() ~= nil then
					GetLeaveCorpsCallBack()
					print("父节点是军团场景,返回主场景")
				else
					print("离开军团场景的回调为空")
				end
			else

				--print("父节点不是军团场景")

			end	
		end

		--CoinInfoBar.ShowHideBar(true)

	end
end

local function InitSpecialUI(  )
	-- 每个国家主城和军团入口

	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")

	local pName = "返回主城"

	local nCamp = 1

	for i=257,262 do
		local pSpecialNode = m_ClickPanel:getChildByTag( i )
		local pAniNodeF = tolua.cast(pSpecialNode:getComponent("CCArmature"),"CCComRender")
		local pAniNode = tolua.cast(pAniNodeF:getNode(),"CCArmature")	
		local rect = pAniNode:boundingBox()
		local rectWidth = rect.size.width
		local rectheight = rect.size.height	
		
		local Btn_Node = Widget:create()
		Btn_Node:setEnabled(true)
		Btn_Node:setTouchEnabled(true)
		Btn_Node:ignoreContentAdaptWithSize(false)
	    Btn_Node:setSize(CCSize(rectWidth, rectheight))
	    if i%2 == 0 then
	    	Btn_Node:setSize(CCSize(rectWidth, rectheight + 100))
	    end
		Btn_Node:setTag(i)
		Btn_Node:addTouchEventListener(_Click_Special_CallBack)
		Btn_Node:setPosition(ccp(pSpecialNode:getPositionX(),pSpecialNode:getPositionY()))
		Btn_Node:setVisible(false)
		ScrollView_Map:addChild(Btn_Node,1300)

		if i%2 == 0 then
			pName = "返回军团"
		else
			pName = "返回主城"
		end

		--城池姓名
		local label_Name = CreateLabel(pName..i,22,ccc3(176,140,108),CommonData.g_FONT1,ccp(10, -39))
		--国家信息背景层
		local spriteBg = CCSprite:create("Image/imgres/countrywar/cityNameBg.png")
		spriteBg:setPosition(ccp(0,-39))
		--国家旗帜
		if i == 257 or i == 258 then
			nCamp = 1
		elseif i == 259 or i == 260 then
			nCamp = 2
		elseif i == 261 or i == 262 then
			nCamp = 3
		end
		local spriteCamp = CCSprite:create("Image/imgres/common/country/country_"..nCamp..".png")
		spriteCamp:setScale(0.75)

		local width = spriteCamp:getContentSize().width * 0.5
		spriteCamp:setPosition(ccp(label_Name:getPositionX() - label_Name:getContentSize().width * 0.5 - width,label_Name:getPositionY()))
		pSpecialNode:addChild(spriteCamp,99,999)
		pSpecialNode:addChild(label_Name,99,100)
		pSpecialNode:addChild(spriteBg,98,998)

		--初始化雷达坐标点
		if m_RaderLayer ~= nil then 
			InitRaderPtData(i, pSpecialNode:getPositionX(), pSpecialNode:getPositionY(),nCamp, true)
		end
	end
	

end

local function InitCityData(  )
	for i=1,GetCityMaxNum() do
		local tab = {}
		local nCTag  = GetCityTagByIndex(i)
		local nClickNode = m_ClickPanel:getChildByTag(nCTag)
		tab.cityIndex = nCTag
		tab.InitialAlliance	= GetCityCountry(nCTag)
		tab.PtX = nClickNode:getPositionX()
		tab.PtY = nClickNode:getPositionY()
		tab.canMoveIndex = {}
		tab.canMoveIndex = GetAroundLinkCity(nCTag)
		tab.canMoveIndexPtTime = {}
		for j=1,table.getn(tab.canMoveIndex) do
			local nSourPtX = tab.PtX
			local nSourPtY = tab.PtY
			local ntarGet = tab.canMoveIndex[j]
			local linkData = GetLinkCityData(nCTag, ntarGet)
			tab.canMoveIndexPtTime[ntarGet] = {}
			local index = 1
			for k=1,table.getn(linkData) do
				local nPtX,nPtY = GetLinkPoint(linkData[k])
				local nConsTime = CountDistanceByPoint(ccp(nSourPtX, nSourPtY), ccp(nPtX, nPtY)) / 100 
				tab.canMoveIndexPtTime[ntarGet][index] = nConsTime
				nSourPtX = nPtX
				nSourPtY = nPtY
				index = index + 1
			end
			--最后一个路点到城市的时间也要算进去
			local nTarPtX,nTarPtY = GetCenterCityPercent(ntarGet)
			local nConsTime = CountDistanceByPoint(ccp(nSourPtX, nSourPtY), ccp(nTarPtX,nTarPtY)) / 100 
			tab.canMoveIndexPtTime[ntarGet][index] = nConsTime
		end
		m_CityTab[nCTag] = tab	
	end
end

local function InitCity( nParentNode ,nScrollView )

	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")

	for i=1,GetCityMaxNum() do
		local nAreaNum,nTag
		local nCTag  = GetCityTagByIndex(i)
		local nCamp = GetCityCountry(nCTag)
		local nCName = GetCityNameByIndex(i)
		local nClickNode = CityNode.Create()

		nClickNode:CreateCityNode(m_ClickPanel, nCTag, m_ScreenRect, GetCityState(nCTag), nCamp)

		nClickNode:GetNode():setVisible(false)

		--判断是否为中心城市
		if JudgeCityCenter(nCTag) == true then
			nClickNode:SetIsCenter(true)
		else
			--判断是否锁定
			if JudgeCityLock(nCTag) == true then
				nClickNode:SetIsLockByState2(true)
			end
		end

		m_NodeObjTab[nCTag] = nClickNode
		if nClickNode == nil then
			--print(nCTag)
		else 
			nAreaNum,nTag = InitCityUI(nClickNode,nCamp,nCName,nScrollView,nCTag)
		end
		local nNode = m_ClickPanel:getChildByTag(nTag)
		table.insert(m_TabArea[nAreaNum]["areaNode"],nNode)
	end

end

local function CountArea( nAreaTypeNum, nTab, nCurNum ,lineNum)
	if nAreaTypeNum == City_Area.NoEff_Left_Bottom then
		nTab = {nCurNum,nCurNum +1,nCurNum + lineNum,nCurNum + lineNum + 1}
	elseif nAreaTypeNum == City_Area.NoEff_Left then
		nTab = {nCurNum,nCurNum + 1,nCurNum + lineNum,nCurNum - lineNum,nCurNum + lineNum + 1,nCurNum - lineNum + 1}
	elseif nAreaTypeNum == City_Area.NoEff_Left_Top then	
		nTab = {nCurNum,nCurNum + 1,nCurNum - lineNum,nCurNum - lineNum + 1}
	elseif nAreaTypeNum == City_Area.NoEff_Top then
		nTab = {nCurNum,nCurNum + 1,nCurNum - 1,nCurNum - lineNum,nCurNum - 1 - lineNum,nCurNum + 1 - lineNum}
	elseif nAreaTypeNum == City_Area.NoEff_Bottom then
		nTab = {nCurNum,nCurNum + 1,nCurNum - 1,nCurNum + lineNum,nCurNum - 1 + lineNum,nCurNum + 1 + lineNum}
	elseif nAreaTypeNum == City_Area.NoEff_Right_Top then
		nTab = {nCurNum,nCurNum - 1,nCurNum - lineNum,nCurNum - lineNum - 1}
	elseif nAreaTypeNum == City_Area.NoEff_Right_Bottom then
		nTab = {nCurNum,nCurNum - 1,nCurNum + lineNum,nCurNum + lineNum - 1}
	elseif nAreaTypeNum == City_Area.NoEff_Right then
		nTab = {nCurNum,nCurNum - 1,nCurNum + lineNum,nCurNum - lineNum,nCurNum + lineNum - 1,nCurNum - lineNum - 1}
	elseif nAreaTypeNum == -1 then
		nTab = {nCurNum,nCurNum - 1,nCurNum + 1,nCurNum + lineNum,nCurNum - lineNum,nCurNum + lineNum - 1,nCurNum + lineNum + 1,nCurNum - lineNum - 1,nCurNum - lineNum + 1}
	end
	return nTab
end

local function _Scroll_CallFunc( sender,eventType )
	if eventType == 4 then
		GetShowAreaTab()
	end
end
--刷新国家UI
function RefreshCityUI( nCityID, nCountry )
	local nCityNode = m_NodeObjTab[nCityID]
	nCityNode:SetCityImgCountry( nCountry )
	if nCountry == 5 or nCountry == 6 or nCountry == 7 then
		nCountry = 5
	end
	local texture = CCTextureCache:sharedTextureCache():addImage("Image/imgres/common/country/country_"..nCountry..".png")
	local spriteCamp = tolua.cast(nCityNode:GetNode():getChildByTag(999), "CCSprite")
	spriteCamp:setTexture(texture)
end

function RefreshEventUI( nCityID, nState2Tab )
	local nCityNode = m_NodeObjTab[nCityID]
	--判断是否锁定，没有锁定则删除锁定动画
	local nLockState = tonumber(nState2Tab["LockState"])
	local nCenterCity = tonumber(nState2Tab["CenterCity"])
	local nConfusion = tonumber(nState2Tab["Confusion"])
	local nManZuEvent = tonumber(nState2Tab["ManZuEvent"])

	if nLockState == 0 then  --城池解锁了
		nCityNode:SetIsLockByState2(false)
		if m_CWarObj~= nil then
			m_CWarObj:Fun_DelLineAni(nCityID)
		end
	else
		nCityNode:SetIsLockByState2(true)

		--当前城市是锁定，判断周围城市是否有中心城
		local pArroundCityTab = GetAroundLinkCity(nCityID)
		for key,value in pairs(pArroundCityTab) do
			local pArroundCityNode = m_NodeObjTab[value]
			local bCenter = pArroundCityNode:GetIsCenter()
			if bCenter == true then
				--找到中心城市花连线
				m_CWarObj:Fun_FindCenterDrawLockLine(nCityID, pArroundCityNode:GetCityTag())
			end

		end

	end

	if nCenterCity == 1 then
		--print("创建能量罩和线"..nCityID)
		nCityNode:SetIsCenter(true)
		m_CWarObj:Fun_InitCWarEvent(CWAR_EVENTTYPE.LOCKCITY) 			--传入时间类型
	else
		nCityNode:SetIsCenter(false)
		m_CWarObj:Fun_DelLockAni(nCityID)
	end

	nCityNode:SetManzuEvent( nManZuEvent )

	if JudgeCityLock( nCityID ) == true or JudgeCityCenter( nCityID ) == true then
		--城市进入黄巾军事件
		CountryWarRaderLayer.Update_SJ_Add( nCityID, 2 )
	else
		--城市关闭黄巾军事件
		CountryWarRaderLayer.Update_SJ_Del( nCityID, 2 )
	end

	if JudgeCityManZu( nCityID ) == true then
		--城市进入蛮族事件
		CountryWarRaderLayer.Update_SJ_Add( nCityID, 1 )
	else
		--城市关闭蛮族事件
		CountryWarRaderLayer.Update_SJ_Del( nCityID, 1 )
	end

end

function RefreshCityState( nCityID, nState )
	local nCityNode = m_NodeObjTab[nCityID]
	nCityNode:SetCityState(nState) 
end

function RefreshCityCountry( nCityID, nCountry )
	m_CityTab[nCityID].InitialAlliance = nCountry
end

function GetEventManager(  )
	return m_EventObj
end

function GetScrollBase(  )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	return ScrollView_Map
end

function GetNodeObjArr()
	return m_NodeObjTab
end

function RoleForWardToCity( pObj, tab, DestroyFunc )
	local function SetHeroDirection( nCurX, nTarX, pObj )
		-- 改变当前英雄朝向
		if nCurX < nTarX then
			pObj:setScaleX(-0.7)
			pObj:setScaleY(0.7)
		else
			pObj:setScaleX(0.7)
			pObj:setScaleY(0.7)		
		end
	end

	local pCurPtX,pCurPtY = CountryWarScene.GetCenterCityPercent(tab[1])
	local pTarPtX,pTarPtY = CountryWarScene.GetCenterCityPercent(tab[2])
	local pFirstX = pCurPtX
	local pFirstY = pCurPtY
	local nMoveTime = nil
	SetHeroDirection(pTarPtX, pCurPtX, pObj)
	local nLinkTab = GetLinkCityData(tab[1],tab[2])

	local actionArrayMove = CCArray:create()
	local nPtX,nPtY
	for i=1,table.getn(nLinkTab) do
		nPtX,nPtY = GetLinkPoint(nLinkTab[i])
		local nCountPtX,nCountPtY = GetLinkPoint(nLinkTab[i])
		local function UpdateCurNodeState()
			SetHeroDirection(nCountPtX, pCurPtX, pObj)
			pCurPtX    = nCountPtX
			pCurPtY    = nCountPtY
		end
		local function CountMoveTime(nPtX,nPtY)
			nMoveTime = CountDistanceByPoint(CCPoint(nPtX,nPtY),CCPoint(pFirstX,pFirstY)) / 100
			pFirstX    = nPtX
			pFirstY    = nPtY
			return nMoveTime
		end
		actionArrayMove:addObject(CCCallFunc:create(UpdateCurNodeState))
		actionArrayMove:addObject(CCMoveTo:create(CountMoveTime(nPtX,nPtY),ccp(nPtX,nPtY)))
	end

	local function ForwardEnd( )
		PlayHeroAnimation(pObj,GetGeneralResId(CommonData.g_MainDataTable.nModeID),Ani_Def_Key.Ani_stand)
	end

	local function UpdateHeroDir()
		SetHeroDirection(pTarPtX, pCurPtX, pObj)
	end
	actionArrayMove:addObject(CCCallFunc:create(UpdateHeroDir))	
	nMoveTime		= CountDistanceByPoint(CCPoint(pTarPtX,pTarPtY),CCPoint(nPtX,nPtY)) / 100
	actionArrayMove:addObject(CCMoveTo:create(nMoveTime,ccp(pTarPtX,pTarPtY)))	
	actionArrayMove:addObject(CCCallFunc:create(ForwardEnd))
	actionArrayMove:addObject(CCCallFunc:create(DestroyFunc))
	pObj:runAction(CCSequence:create(actionArrayMove))
	PlayHeroAnimation(pObj,GetGeneralResId(CommonData.g_MainDataTable.nModeID),Ani_Def_Key.Ani_run)	
end

function SetPlayerState( nRoleType, nRoleState )
	if nRoleType == PlayerType.E_PlayerType_Main and m_PlayerTab["MainGeneral"] ~= nil  then
		m_PlayerTab["MainGeneral"]:SetState(nRoleState)
	end
	if nRoleType == PlayerType.E_PlayerType_1 and m_PlayerTab["Teamer1"] ~= nil  then
		m_PlayerTab["Teamer1"]:SetState(nRoleState)
	end
	if nRoleType == PlayerType.E_PlayerType_2 and m_PlayerTab["Teamer2"] ~= nil  then
		m_PlayerTab["Teamer2"]:SetState(nRoleState)
	end
	if nRoleType == PlayerType.E_PlayerType_3 and m_PlayerTab["Teamer3"] ~= nil  then
		m_PlayerTab["Teamer3"]:SetState(nRoleState)
	end
	SetRoleState(nRoleType, nRoleState)
end

function CountEnemyCityByEventManager()
	if m_EventObj ~= nil then 
		m_EventObj:CountEnemyCity(m_CityTab, m_NodeObjTab)
	end
end

function WatchMistyWar( nType )
	--迷雾观战
	local nIndex = nil
	if nType == PlayerType.E_PlayerType_Main - 1  then
		nIndex = m_PlayerTab["MainGeneral"]:GetAttackMistyIndex()
	elseif nType == PlayerType.E_PlayerType_1 - 1 then
		nIndex = m_PlayerTab["Teamer1"]:GetAttackMistyIndex()
	elseif nType == PlayerType.E_PlayerType_2 - 1 then
		nIndex = m_PlayerTab["Teamer2"]:GetAttackMistyIndex()
	elseif nType == PlayerType.E_PlayerType_3 - 1 then
		nIndex = m_PlayerTab["Teamer3"]:GetAttackMistyIndex()
	end

	local tabFunc = {}
	tabFunc["zhaoji"] = _Click_ZhaoJi_Callfunc
	tabFunc["guanzhan"] = _Click_WatchWar_CallFunc
	tabFunc["jianshou"] = _Click_BloodWarAndDefense_CallFunc
	tabFunc["xuezhan"] = _Click_BloodWarAndDefense_CallFunc
	tabFunc["tujin"] = _Click_Dart_CallFunc
	tabFunc["chetui"] = _Click_Retreat_CallFunc
	tabFunc["PlayerMove"] = _Click_PlayerMove_CallFunc

	if m_MistyObj ~= nil and nIndex ~= nil  then
		if nIndex >= 0 then
			local nMistyIndex = m_MistyObj:Fun_GetMistyFightingIndex(nIndex)
			local nCityID     = m_MistyObj:Fun_GetMistyFightingCity(nIndex)
			m_MistyObj:Fun_OpenWatchLayer(nCityID, nMistyIndex, tabFunc)
		end
	end
end

function Init( )

	if m_CountryWarPanel == nil then
		return
	end

	InitVars() 

	m_ScrollOffset 	  = ccp(0,0)
	m_ScrollInitPt 	  = ccp(0,0)
	m_ScrollNewPt	  = ccp(0,0)
	m_RadarMoveScale  = ccp(0,0)
	m_InnerLeavePt    = ccp(0,0)
	m_IsLeaveFromMine = false
	m_CurUIState 	  = CityEventState.E_CityEventState_Normal
	m_CountryWeiTab     = {}
    m_CountryShuTab     = {}
    m_CountryWuTab      = {}

	--当前英雄信息
	m_TabHeroInfo = {}
	if m_InitCity ~= nil then	
		m_TabHeroInfo.City              =	m_InitCity
	else
		m_TabHeroInfo.City 				= 	GetMainCityByCountry(GetPlayerCountry())				--城池
		--m_TabHeroInfo.City 				= GetTeamCity(PlayerType.E_PlayerType_Main - 1)
	end

	--初始化屏幕区域坐标
	m_TabArea = {}
	m_InnerPos = ccp(0,0)

	local nAreaDiffX = MAP_WIDTH  / 5
	local nAreaDiffY = MAP_HEIGHT / 7

    --初始化屏幕区域
    m_ScreenRect = CCRectMake(0,0,nAreaDiffX * 2,nAreaDiffY * 2)

	local ptNumX = 0
	local ptNumY = 0
	for i=1,35 do
		m_TabArea[i] 				= {}	
		if i % 5 == 1 then
			ptNumX = 0
		end	
		m_TabArea[i]["BeginX"] 			= ptNumX * nAreaDiffX
		m_TabArea[i]["BeginY"] 			= ptNumY * nAreaDiffY
		m_TabArea[i]["CenterPointX"] 	= m_TabArea[i]["BeginX"] + nAreaDiffX * 0.5
		m_TabArea[i]["CenterPointY"] 	= m_TabArea[i]["BeginY"] + nAreaDiffY * 0.5
		m_TabArea[i]["Tag"] 			= 10000 + i
		m_TabArea[i]["aroundArea"] 		= {}
		m_TabArea[i]["areaNode"]		= {}
		--判断属于什么类型区域
		local nTypeNum = JudgePtInAreType(i)
		local nOnelineNum = 5 			--几个数换一行
		m_TabArea[i]["aroundArea"] = CountArea(nTypeNum,m_TabArea[i]["aroundArea"],i,nOnelineNum)
		if i % 5 == 0 then
			ptNumY = ptNumY + 1
		end
		ptNumX = ptNumX + 1
	end

	--给UI界面的回调
	m_TabUICallBack["MainCity"] = ReturnMainCity
	m_TabUICallBack["Radar"] = OpenRadarLayer
	m_TabUICallBack["FindTeamer"] = MoveToPt
	m_TabUICallBack["MistyWar"] = MoveToPt
	m_TabUICallBack["BacktToNormal"] = RemoveAtkChooseLayer
	m_TabUICallBack["LeaveScene"] = m_CallBackFromParent
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
    local inner = ScrollView_Map:getInnerContainer()
    ScrollView_Map:ignoreAnchorPointForPosition(true)
    ScrollView_Map:setPosition(ccp(0,0))
    ScrollView_Map:addTouchEventListener(onTouchEvent)
    ScrollView_Map:addEventListenerScrollView(_Scroll_CallFunc)

	local innerWidth = ScrollView_Map:getInnerContainerSize().width
	local innerHeight = ScrollView_Map:getInnerContainerSize().height
    m_MapPanel = m_pWardScene:getChildByTag(10003)
    m_ClickPanel = m_pWardScene:getChildByTag(12000)
    m_MistyPanel = m_pWardScene:getChildByTag(13000)

    if nil ~= m_pWardScene then
    	ScrollView_Map:addNode(m_pWardScene,1299,1299)
    end
    --判断默认显示哪个城市为中心
    local percentX,percentY = GetCenterCityPercent(m_TabHeroInfo.City)

    m_CityTab = {}
   	--初始化雷达界面
	m_RaderLayer = CreateRaderLayer(MAP_WIDTH,MAP_HEIGHT,ccp(percentX,percentY),CountryMapMove)
	m_RaderLayer:retain()

	----迷雾管理对象创建
	m_MistyObj = MistyManager.Create()

	--初始化城池数据UI
    InitCity(m_pWardScene,ScrollView_Map)

    --初始化特殊的城池UI
    InitSpecialUI()

    --初始化城池数据
    InitCityData()

    --国家其他事件管理对象创建
	m_CWarObj  = CountryWarManager.Create()
	m_CWarObj:Fun_SetCMDByLockCity(m_ClickPanel, m_NodeObjTab)
	m_CWarObj:Fun_InitCWarEvent(CWAR_EVENTTYPE.LOCKCITY) 			--传入时间类型

end 

function InitMisty( )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")

    --迷雾数据管理
   	m_MistyObj:Fun_SetTouchLayer(ScrollView_Map)
    m_MistyObj:Fun_SetCityLayer(m_ClickPanel)
    m_MistyObj:Fun_SetObjData(m_NodeObjTab)
    m_MistyObj:Fun_SetCityAreaData(m_TabCityArea)
    m_MistyObj:Fun_SetAreaData(m_TabArea)
    m_MistyObj:Fun_SetMistyLayer(m_MistyPanel, true) 		--传进迷雾的UI层
    m_MistyObj:Fun_SetTeamUIData(m_TeamTab)
    m_MistyObj:Fun_SetPlayerData(m_PlayerTab)

    --迷雾初始化
    m_MistyObj:Fun_InitMistyCity()
	
end

function GetPosByCityID( nCityID )
	if m_ClickPanel ~= nil then
		local pNode = m_ClickPanel:getChildByTag(nCityID)
		local pPosX = pNode:convertToWorldSpace(ccp(0, 0)).x
		local pPosY = pNode:convertToWorldSpace(ccp(0, 0)).y
		return pPosX, pPosY
	end
end

function MistyCityUpdate( nFogIndex, nIndex, nTeamNum, nHp )
	if m_MistyObj ~= nil then
		m_MistyObj:Fun_UpdateMistyCityInfo(nFogIndex, nIndex, nTeamNum, nHp)
	end
end

function SetUILayerState( bState )
	if m_nUILayer ~= nil then
		
		m_nUILayer:setVisible( bState )

	end
end

function ExitCountryWar(  )
	ReturnMainCity()
	ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
	RemoveAtkChooseLayer()
end

--设置进入回调
function SetComeInCallBack( nCallBack )
	if nCallBack ~= nil then
		m_ComeInCallBack = nCallBack
	end
end

function InitTeamInfo( )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	m_UITab = {}

	for key,value in pairs(GetTeamTab()) do	
		if key == PlayerType.E_PlayerType_Main - 1 then
			local MainTeamCityID = GetTeamCity(PlayerType.E_PlayerType_Main - 1)
			local percentX_Main,percentY_Main = GetCenterCityPercent(MainTeamCityID)
			if m_PlayerTab["MainGeneral"] == nil then
				m_PlayerTab["MainGeneral"] = PlayerNode.Create()
				m_PlayerTab["MainGeneral"]:CreatePlayer(ScrollView_Map, MainTeamCityID, m_CityTab, ccp(percentX_Main,percentY_Main), m_ClickPanel, value["TeamRes"], PlayerType.E_PlayerType_Main)
				m_PlayerTab["MainGeneral"]:SetState(value["TeamState"])
			end
				--判断是否移动
			if GetTeamTargetCity(PlayerType.E_PlayerType_Main - 1) == -1 then 
				print("主将队伍静止中,未移动")
			else
				--当前正在移动中，取到目标城市进行移动
				local nTarCity = GetTeamTargetCity(PlayerType.E_PlayerType_Main - 1)
				print("主将向"..nTarCity.."移动中")
				--判断当前是国战移动还是普通移动
				if GetTeamBloodCity(PlayerType.E_PlayerType_Main - 1) == -1 then
					--正常移动
					m_PlayerTab["MainGeneral"]:PlayerMove(nTarCity, PlayerType.E_PlayerType_Main, PlayerState.E_PlayerState_Move)	
				else
					--血战移动
					m_PlayerTab["MainGeneral"]:PlayerMove(GetTeamBloodCity(PlayerType.E_PlayerType_Main - 1), PlayerType.E_PlayerType_Main, PlayerState.E_PlayerState_BloodWar)
				end
			end
			--UI使用数据
			m_UITab[PlayerType.E_PlayerType_Main] = {}
			m_TeamTab[PlayerType.E_PlayerType_Main] = {}
			m_UITab[PlayerType.E_PlayerType_Main]["nTempID"]  		= value["TeamRes"]
    		m_UITab[PlayerType.E_PlayerType_Main]["City"] 			= MainTeamCityID
    		m_UITab[PlayerType.E_PlayerType_Main]["Level"] 			= value["TeamLevel"]
    		m_UITab[PlayerType.E_PlayerType_Main]["FaceID"] 		= value["TeamFace"]
    		m_UITab[PlayerType.E_PlayerType_Main]["Type"] 			= PlayerType.E_PlayerType_Main
    		m_UITab[PlayerType.E_PlayerType_Main]["BloodMax"] 		= value["TeamBloodMax"]
    		m_UITab[PlayerType.E_PlayerType_Main]["BloodCur"] 		= value["TeamBloodCur"]
    		m_UITab[PlayerType.E_PlayerType_Main]["BloodTarCity"] 	= value["TeamBloodWCity"]
    		m_UITab[PlayerType.E_PlayerType_Main]["TeamState"] 		= value["TeamState"]
    		m_UITab[PlayerType.E_PlayerType_Main]["TeamName"]       = value["TeamName"]
    		m_TeamTab[PlayerType.E_PlayerType_Main]["itemID"]   = value["TeamRes"]
    		m_TeamTab[PlayerType.E_PlayerType_Main]["Type"] 	= PlayerType.E_PlayerType_Main
    		m_TeamTab[PlayerType.E_PlayerType_Main]["level"] 	= value["TeamLevel"]
		elseif key == PlayerType.E_PlayerType_1 - 1 then
			local TeamCityID_1 = GetTeamCity(PlayerType.E_PlayerType_1 - 1)
			local percentX_1,percentY_1 = GetCenterCityPercent(TeamCityID_1)
			if m_PlayerTab["Teamer1"] == nil then
				m_PlayerTab["Teamer1"] = PlayerNode.Create()
				m_PlayerTab["Teamer1"]:CreatePlayer(ScrollView_Map, TeamCityID_1, m_CityTab, ccp(percentX_1,percentY_1), m_ClickPanel, value["TeamRes"], PlayerType.E_PlayerType_1, GetTeamLife(1))		
				m_PlayerTab["Teamer1"]:SetState(value["TeamState"])
			end
			--判断是否移动
			if GetTeamTargetCity(PlayerType.E_PlayerType_1 - 1) == -1 then 
				print("队伍1静止中，未移动")
			else
				--当前正在移动中，取到目标城市进行移动
				local nTarCity = GetTeamTargetCity(PlayerType.E_PlayerType_1 - 1)
				print("队伍1向"..nTarCity.."移动中")		
				--判断当前是国战移动还是普通移动
				if GetTeamBloodCity(PlayerType.E_PlayerType_1 - 1) == -1 then
					--正常移动
					m_PlayerTab["Teamer1"]:PlayerMove(nTarCity, PlayerType.E_PlayerType_1, PlayerState.E_PlayerState_Move)	
				else
					--血战移动
					m_PlayerTab["Teamer1"]:PlayerMove(GetTeamBloodCity(PlayerType.E_PlayerType_1 - 1), PlayerType.E_PlayerType_1, PlayerState.E_PlayerState_BloodWar)
				end
			end
			--UI使用数据			
			m_UITab[PlayerType.E_PlayerType_1] = {}
			m_TeamTab[PlayerType.E_PlayerType_1] = {}
			m_UITab[PlayerType.E_PlayerType_1]["nTempID"]  		= value["TeamRes"]
    		m_UITab[PlayerType.E_PlayerType_1]["City"] 	 		= TeamCityID_1	
    		m_UITab[PlayerType.E_PlayerType_1]["Level"] 		= value["TeamLevel"]
    		m_UITab[PlayerType.E_PlayerType_1]["FaceID"] 		= value["TeamFace"]
    		m_UITab[PlayerType.E_PlayerType_1]["Type"] 			= PlayerType.E_PlayerType_1	
    		m_UITab[PlayerType.E_PlayerType_1]["BloodMax"] 		= value["TeamBloodMax"]
    		m_UITab[PlayerType.E_PlayerType_1]["BloodCur"] 		= value["TeamBloodCur"]
    		m_UITab[PlayerType.E_PlayerType_1]["BloodTarCity"] 	= value["TeamBloodWCity"]
    		m_UITab[PlayerType.E_PlayerType_1]["TeamState"] 	= value["TeamState"]
    		m_UITab[PlayerType.E_PlayerType_1]["TeamName"]      = value["TeamName"]
       		m_TeamTab[PlayerType.E_PlayerType_1]["itemID"]  = value["TeamRes"]
    		m_TeamTab[PlayerType.E_PlayerType_1]["Type"] 	= PlayerType.E_PlayerType_1
    		m_TeamTab[PlayerType.E_PlayerType_1]["level"] 	= value["TeamLevel"]
		elseif key == PlayerType.E_PlayerType_2 - 1 then
			local TeamCityID_2 = GetTeamCity(PlayerType.E_PlayerType_2 - 1)
			local percentX_2,percentY_2 = GetCenterCityPercent(TeamCityID_2)
			if m_PlayerTab["Teamer2"] == nil then
				m_PlayerTab["Teamer2"] = PlayerNode.Create()
				m_PlayerTab["Teamer2"]:CreatePlayer(ScrollView_Map, TeamCityID_2, m_CityTab, ccp(percentX_2,percentY_2), m_ClickPanel, value["TeamRes"], PlayerType.E_PlayerType_2, GetTeamLife(2))		
				m_PlayerTab["Teamer2"]:SetState(value["TeamState"])
			end
			--判断是否移动
			if GetTeamTargetCity(PlayerType.E_PlayerType_2 - 1) == -1 then 
				print("队伍2静止中，未移动")
			else
				--当前正在移动中，取到目标城市进行移动
				local nTarCity = GetTeamTargetCity(PlayerType.E_PlayerType_2 - 1)
				print("队伍2向"..nTarCity.."移动中")
				--判断当前是国战移动还是普通移动
				if GetTeamBloodCity(PlayerType.E_PlayerType_2 - 1) == -1 then
					--正常移动
					m_PlayerTab["Teamer2"]:PlayerMove(nTarCity, PlayerType.E_PlayerType_2, PlayerState.E_PlayerState_Move)	
				else
					--血战移动
					m_PlayerTab["Teamer2"]:PlayerMove(GetTeamBloodCity(PlayerType.E_PlayerType_2 - 1), PlayerType.E_PlayerType_2, PlayerState.E_PlayerState_BloodWar)
				end
			end
			--UI使用数据				
			m_UITab[PlayerType.E_PlayerType_2] = {}
			m_TeamTab[PlayerType.E_PlayerType_2] = {}
			m_UITab[PlayerType.E_PlayerType_2]["nTempID"]  		= value["TeamRes"]
    		m_UITab[PlayerType.E_PlayerType_2]["City"] 	 		= TeamCityID_2		
    		m_UITab[PlayerType.E_PlayerType_2]["Level"] 		= value["TeamLevel"]
    		m_UITab[PlayerType.E_PlayerType_2]["FaceID"] 		= value["TeamFace"]	
    		m_UITab[PlayerType.E_PlayerType_2]["Type"] 			= PlayerType.E_PlayerType_2
    		m_UITab[PlayerType.E_PlayerType_2]["BloodMax"] 		= value["TeamBloodMax"]
    		m_UITab[PlayerType.E_PlayerType_2]["BloodCur"] 		= value["TeamBloodCur"]
    		m_UITab[PlayerType.E_PlayerType_2]["BloodTarCity"] 	= value["TeamBloodWCity"]
    		m_UITab[PlayerType.E_PlayerType_2]["TeamState"] 	= value["TeamState"]
    		m_UITab[PlayerType.E_PlayerType_2]["TeamName"]      = value["TeamName"]
          	m_TeamTab[PlayerType.E_PlayerType_2]["itemID"]  = value["TeamRes"]
    		m_TeamTab[PlayerType.E_PlayerType_2]["Type"] 	= PlayerType.E_PlayerType_2
    		m_TeamTab[PlayerType.E_PlayerType_2]["level"] 	= value["TeamLevel"]
		elseif key == PlayerType.E_PlayerType_3 - 1 then
			local TeamCityID_3 = GetTeamCity(PlayerType.E_PlayerType_3 - 1)
			local percentX_3,percentY_3 = GetCenterCityPercent(TeamCityID_3)
			if m_PlayerTab["Teamer3"] == nil then
				m_PlayerTab["Teamer3"] = PlayerNode.Create()
				m_PlayerTab["Teamer3"]:CreatePlayer(ScrollView_Map, TeamCityID_3, m_CityTab, ccp(percentX_3,percentY_3), m_ClickPanel, value["TeamRes"], PlayerType.E_PlayerType_3, GetTeamLife(3))	
				m_PlayerTab["Teamer3"]:SetState(value["TeamState"])
			end
			--判断是否移动
			if GetTeamTargetCity(PlayerType.E_PlayerType_3 - 1) == -1 then 
				print("队伍3静止中，未移动")
			else
				--当前正在移动中，取到目标城市进行移动
				local nTarCity = GetTeamTargetCity(PlayerType.E_PlayerType_3 - 1)
				print("队伍3向"..nTarCity.."移动中")
				if GetTeamBloodCity(PlayerType.E_PlayerType_3 - 1) == -1 then
					--正常移动
					m_PlayerTab["Teamer3"]:PlayerMove(nTarCity, PlayerType.E_PlayerType_3, PlayerState.E_PlayerState_Move)	
				else
					--血战移动
					m_PlayerTab["Teamer3"]:PlayerMove(GetTeamBloodCity(PlayerType.E_PlayerType_3 - 1), PlayerType.E_PlayerType_3, PlayerState.E_PlayerState_BloodWar)
				end		
			end
			--UI使用数据				
			m_UITab[PlayerType.E_PlayerType_3] = {}
			m_TeamTab[PlayerType.E_PlayerType_3] = {}
			m_UITab[PlayerType.E_PlayerType_3]["nTempID"]  		= value["TeamRes"]
    		m_UITab[PlayerType.E_PlayerType_3]["City"] 	 		= TeamCityID_3		
    		m_UITab[PlayerType.E_PlayerType_3]["Level"] 		= value["TeamLevel"]
    		m_UITab[PlayerType.E_PlayerType_3]["FaceID"] 		= value["TeamFace"]
    		m_UITab[PlayerType.E_PlayerType_3]["Type"] 			= PlayerType.E_PlayerType_3	
    		m_UITab[PlayerType.E_PlayerType_3]["BloodMax"] 		= value["TeamBloodMax"]
    		m_UITab[PlayerType.E_PlayerType_3]["BloodCur"] 		= value["TeamBloodCur"]
    		m_UITab[PlayerType.E_PlayerType_3]["BloodTarCity"] 	= value["TeamBloodWCity"]
    		m_UITab[PlayerType.E_PlayerType_3]["TeamState"] 	= value["TeamState"]
    		m_UITab[PlayerType.E_PlayerType_3]["TeamName"]      = value["TeamName"]
            m_TeamTab[PlayerType.E_PlayerType_3]["itemID"]  = value["TeamRes"]
    		m_TeamTab[PlayerType.E_PlayerType_3]["Type"] 	= PlayerType.E_PlayerType_3
    		m_TeamTab[PlayerType.E_PlayerType_3]["level"] 	= value["TeamLevel"]
		end
	end
	--初始化远征军(针对citynode绑定)
	for i=1,GetExpeDitionCount() do
		local nExCityID = GetExpeDitionCityID(i)
		local nData     = GetExpeDitionDataByIndex(i)	
		if m_NodeObjTab[nExCityID] ~= nil then  --如果这个城池不为空，insert事件UI表现
			m_NodeObjTab[nExCityID]:InsertEventTab(nData)
		end
	end

	m_bClicked 		  = false
	m_nClickedCount   = 0

	--给迷雾层传入UI数据
	m_MistyObj:Fun_SetUITab(m_UITab)
    --添加UI层
    if m_nUILayer == nil then
	    m_nUILayer = CountryUILayer.CreateCountryUILayer(m_TabUICallBack, m_UITab, m_PlayerTab)
	    m_nUILayer:setPosition(ccp(0,0))
	    m_CountryWarPanel:addChild(m_nUILayer,1,2008)

	    --国战事件管理
	    m_EventObj = CountryWarEventManager.CreateCityObject()
	    --求出当前可攻击的城市
	    CountEnemyCityByEventManager()

		--跳转至主将城市
		if m_PlayerTab["MainGeneral"] ~= nil then
			if m_InitCity ~= nil then
				m_TabHeroInfo.City = m_InitCity
			else
				m_TabHeroInfo.City = GetTeamCity(PlayerType.E_PlayerType_Main - 1)
			end
		end

	    local action = CCArray:create()
		action:addObject(CCCallFunc:create(CountryWarScene.MoveToHeroPt))
		action:addObject(CCCallFunc:create(CountryUILayer.AddChat))

		if m_CountryWarPanel ~= nil then
			m_CountryWarPanel:runAction(CCSequence:create(action))
		end
		UI_Loading_Show(false)

		--AudioUtil.playBgm("audio/bgm/music_g.mp3",true)
		--m_CodeRunningEnd = os.clock()
		--if CommonData.g_BloodOrDefenseTime ~= -1 then
		--	CommonData.g_BloodOrDefenseTime = CommonData.g_BloodOrDefenseTime - (m_CodeRunningEnd-m_CodeRunningBegin)
		--end
		if m_ComeInCallBack ~= nil then
			m_ComeInCallBack()
		end
	end

	--更新雷达界面里的队伍信息
	if m_RaderLayer ~= nil then
		CountryWarRaderLayer.UpdateRaderTeamUI(m_UITab, 1)
	end

	CommonData.g_IsUnlockCountryWar = true
end

--添加远征军
function InertExpeSuchAs( nData )
	if m_NodeObjTab[nData["CityID"]] ~= nil then  --如果这个城池不为空，insert事件UI表现
		m_NodeObjTab[nData["CityID"]]:InsertEventTab(nData)

		--更新雷达的页签
		CountryWarRaderLayer.UpdateCity_Add( nData )
	end
end

function MoveExpeSuchAs( nGrid, nCityID )
	--首先删除原有城市里的事件表
	local nCurData = GetDataByGrid(nGrid)
	if nCurData == nil then
		print("Move城市时间表为空"..nCityID)
		return
	end

	--print("-----事件"..nGrid.."发生移动,离开城市"..nCurData["CityID"])
	if m_NodeObjTab[nCurData["CityID"]] ~= nil then  --如果这个城池不为空，删除事件表中的该事件
		m_NodeObjTab[nCurData["CityID"]]:DelEventByEventTab(nGrid)
	end
	--然后再更新数据源
	UpdateDataByGrid(nGrid, nCityID)
	--最后更新最新UI
	local nNewData	= GetDataByGrid(nGrid)
	--print("-----事件"..nGrid.."发生移动,进入城市"..nCityID)
	if m_NodeObjTab[nNewData["CityID"]] ~= nil then  --如果这个城池不为空，insert事件UI表现
		m_NodeObjTab[nNewData["CityID"]]:InsertEventTab(nNewData)

		--更新雷达的页签
		CountryWarRaderLayer.UpdateCity_Move( nNewData )
	end	
end

--删除远征军
function DelExpeSuchAs( nDelIndex, nGrid )
	if nGrid ~= nil and nDelIndex ~= nil then
		local nExCityID = GetExpeDitionCityID(nDelIndex)
		--print("彻底删除城市"..nExCityID.."远征军事件"..nGrid)
		if m_NodeObjTab[nExCityID] ~= nil then  --如果这个城池不为空，insert事件UI表现
			m_NodeObjTab[nExCityID]:DelEventByEventTab(nGrid)

			--更新雷达的页签
			CountryWarRaderLayer.UpdateCity_Del( nGrid )
		end
	else
		print("Error in CountryWarScene line 1860")
	end
end

function DelTeamerInfo( nIndex )
	print("删除一个佣兵"..nIndex)

	--删除动画对象， PlayerTab， TeamTab
	if nIndex == PlayerType.E_PlayerType_Main - 1 then
		if m_PlayerTab["MainGeneral"] ~= nil then
			m_PlayerTab["MainGeneral"]:GetPlayer():removeFromParentAndCleanup(true)
			m_PlayerTab["MainGeneral"] = nil
		end 
	elseif nIndex == PlayerType.E_PlayerType_1 - 1 then
		if m_PlayerTab["Teamer1"] ~= nil then
			print("del teamer1")
			m_PlayerTab["Teamer1"]:GetPlayer():removeFromParentAndCleanup(true)
			m_PlayerTab["Teamer1"] = nil	
		end
	elseif nIndex == PlayerType.E_PlayerType_2 - 1 then
		if m_PlayerTab["Teamer2"] ~= nil then
			print("del teamer2")
			m_PlayerTab["Teamer2"]:GetPlayer():removeFromParentAndCleanup(true)
			m_PlayerTab["Teamer2"] = nil			
		end
	elseif nIndex == PlayerType.E_PlayerType_3 - 1 then
		if m_PlayerTab["Teamer3"] ~= nil then
			print("del teamer3")
			m_PlayerTab["Teamer3"]:GetPlayer():removeFromParentAndCleanup(true)
			m_PlayerTab["Teamer3"] = nil	
		end
	end

	if m_TeamTab[nIndex+1] ~= nil then
		m_TeamTab[nIndex+1] = nil
	end

	--更新雷达界面里的队伍信息
	if m_RaderLayer ~= nil then
		CountryWarRaderLayer.DelRaderTeamUI(nIndex)
	end

	if m_nUILayer ~= nil then
		CountryUILayer.DelTeamUIByOne(nIndex)
	end
	--更新TeamMess数据源
	DelSomeTeamInfo(nIndex)
end

function UpdateTeamerInfo( nTab )
	local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
	local nTeamIndedx	 = nTab[1]

	--UI使用数据
	local tab				= {}
	tab["TeamIndex"]		= nTeamIndedx
	tab["Level"] 			= nTab[2]
	tab["FaceID"] 			= nTab[3]
	tab["nTempID"]  		= nTab[4]
	tab["Name"] 			= nTab[5]
	tab["BloodMax"] 		= nTab[6]
	tab["BloodCur"] 		= nTab[7]
	tab["TeamID"]			= nTab[8]
	tab["TeamState"] 		= nTab[9]

	local nTeamCityID 		= nTab[10]


	tab["City"] 			= nTeamCityID
	tab["Type"] 			= nTeamIndedx+1
	tab["TarCity"] 			= nTab[11]
	tab["BloodTarCity"] 	= nTab[12]	
	tab["CellTime"] 		= nTab[13]
	tab["TeamMistyIndex"] 	= nTab[14]

	m_TeamTab[nTeamIndedx+1] 				= {}
	m_TeamTab[nTeamIndedx+1]["itemID"]    	= nTab[4]
	m_TeamTab[nTeamIndedx+1]["Type"] 		= nTeamIndedx+1
	m_TeamTab[nTeamIndedx+1]["level"] 		= nTab[2]

	local bUpdateState = false


	--判断此次是更新还是增加
	if JudgeUpdateType(nTeamIndedx) == true then
		--更新	
		print("更新一个队伍"..nTeamIndedx) 
		UpdateSomeTeamInfo(tab, nTeamIndedx)
	else
		--新增
		print("新增一个新佣兵"..nTeamIndedx) 
		InsertSomeTeamInfo(tab)
		bUpdateState = true
	end

	local nPerX, nPerY 	= GetCenterCityPercent(nTeamCityID)

	if nTeamIndedx == PlayerType.E_PlayerType_Main - 1 then
		if m_PlayerTab["MainGeneral"] ~= nil then
			if m_PlayerTab["MainGeneral"]:GetPlayRes() ~= tonumber(nTab[4]) then
				print("更换MainGeneral形象为"..nTab[4])
				m_PlayerTab["MainGeneral"]:PlayerChangeAni(nTab[4])
			end
		else
			m_PlayerTab["MainGeneral"] = PlayerNode.Create()
			m_PlayerTab["MainGeneral"]:CreatePlayer(ScrollView_Map, nTeamCityID, m_CityTab, ccp(nPerX, nPerY), m_ClickPanel, nTab[4], PlayerType.E_PlayerType_Main)		
		end
	
	elseif nTeamIndedx == PlayerType.E_PlayerType_1 - 1 then
		if m_PlayerTab["Teamer1"] ~= nil then
			if m_PlayerTab["Teamer1"]:GetPlayRes() ~= tonumber(nTab[4]) then
				print("更换Teamer1形象为"..nTab[4])
				m_PlayerTab["Teamer1"]:PlayerChangeAni(nTab[4])
			end
		else
			m_PlayerTab["Teamer1"] = PlayerNode.Create()
			m_PlayerTab["Teamer1"]:CreatePlayer(ScrollView_Map, nTeamCityID, m_CityTab, ccp(nPerX, nPerY), m_ClickPanel, nTab[4], PlayerType.E_PlayerType_1)
		end			
	
	elseif nTeamIndedx == PlayerType.E_PlayerType_2 - 1 then
		if m_PlayerTab["Teamer2"] ~= nil then
			if m_PlayerTab["Teamer2"]:GetPlayRes() ~= tonumber(nTab[4]) then
				print("更换Teamer2形象为"..nTab[4])
				m_PlayerTab["Teamer2"]:PlayerChangeAni(nTab[4])
			end
		else
			m_PlayerTab["Teamer2"] = PlayerNode.Create()
			m_PlayerTab["Teamer2"]:CreatePlayer(ScrollView_Map, nTeamCityID, m_CityTab, ccp(nPerX, nPerY), m_ClickPanel, nTab[4], PlayerType.E_PlayerType_2)
		end		
		
	elseif nTeamIndedx == PlayerType.E_PlayerType_3 - 1 then
		if m_PlayerTab["Teamer3"] ~= nil then
			if m_PlayerTab["Teamer3"]:GetPlayRes() ~= tonumber(nTab[4]) then
				print("更换Teamer3形象为"..nTab[4])
				m_PlayerTab["Teamer3"]:PlayerChangeAni(nTab[4])
			end
		else
			m_PlayerTab["Teamer3"] = PlayerNode.Create()
			m_PlayerTab["Teamer3"]:CreatePlayer(ScrollView_Map, nTeamCityID, m_CityTab, ccp(nPerX, nPerY), m_ClickPanel, nTab[4], PlayerType.E_PlayerType_3)	
		end
		
	end

	if m_nUILayer ~= nil then
		CountryUILayer.UpdateTeamUIByOne(tab, bUpdateState)
	end

end

function GetTeamObj(  )
	return m_PlayerTab
end

function GetExpeDitionbj(  )
	return m_EventObjTab
end

-------------------------------------------------国战弱网断线后的同步更新begin-----------------------------------------------------
function CountryWarSyncUpdateByAllMess(  )
	-- 1.所有城市的同步刷新
	NetWorkLoadingLayer.loadingShow(true)
	print("------------------------------更新城市状态----------------------------------")
	for i=1,GetCityMaxNum() do
		local nCityID    = GetCityTagByIndex( i )
		local nCityNode  = m_NodeObjTab[nCityID]
		local nCountry 	 = GetCityCountry( nCityID )
		local nState     = GetCityState( nCityID )
		--是否需要更新城市所属国家
		if tonumber( nCityNode:GetCityImgCountry() ) ~= tonumber(nCountry) then
			print("Origin Country "..nCityNode:GetCityImgCountry().."City "..nCityID.." Need Update Country To "..nCountry)
			RefreshCityUI( nCityID, nCountry )
			CountryWarRaderLayer.UpdateCountry( nCountry, nCityID )
		end
		--是否需要更新城市状态
		if tonumber( nCityNode:GetState() ) ~= tonumber(nState) then
			print("Origin State "..nCityNode:GetState().."City "..nCityID.." Need Update State To "..nState)
			RefreshCityState( nCityID, nState )
		end
	end
	NetWorkLoadingLayer.loadingHideNow()
end

function CountryWarSyncUpdateByTeamMess(  )
	NetWorkLoadingLayer.loadingShow(true)
	print("------------------------------更新队伍状态----------------------------------")
	for key,value in pairs(GetTeamTab()) do	
		if key == PlayerType.E_PlayerType_Main - 1 then
			local MainTeamCityID = GetTeamCity(PlayerType.E_PlayerType_Main - 1)
			local percentX_Main,percentY_Main = GetCenterCityPercent(MainTeamCityID)
			if m_PlayerTab["MainGeneral"] ~= nil and tonumber(m_PlayerTab["MainGeneral"]:GetState()) ~= tonumber(value["TeamState"]) then
				m_PlayerTab["MainGeneral"]:ChangseTeamState(value["TeamState"])
				m_PlayerTab["MainGeneral"]:SetStopMove(ccp(percentX_Main,percentY_Main), MainTeamCityID)
				print("队伍0状态从"..m_PlayerTab["MainGeneral"]:GetState().."改变为"..value["TeamState"].." 移动到城市"..MainTeamCityID)
				
			end
		elseif key == PlayerType.E_PlayerType_1 - 1 and tonumber(m_PlayerTab["Teamer1"]:GetState()) ~= tonumber(value["TeamState"]) then
			local TeamCityID_1 = GetTeamCity(PlayerType.E_PlayerType_1 - 1)
			local percentX_1,percentY_1 = GetCenterCityPercent(TeamCityID_1)
			if m_PlayerTab["Teamer1"] ~= nil then
				m_PlayerTab["Teamer1"]:ChangseTeamState(value["TeamState"])
				m_PlayerTab["Teamer1"]:SetStopMove(ccp(percentX_1,percentY_1), TeamCityID_1)
				print("队伍1状态从"..m_PlayerTab["Teamer1"]:GetState().."改变为"..value["TeamState"].." 移动到城市"..TeamCityID_1)
			end
		elseif key == PlayerType.E_PlayerType_2 - 1 and tonumber(m_PlayerTab["Teamer2"]:GetState()) ~= tonumber(value["TeamState"]) then
			local TeamCityID_2 = GetTeamCity(PlayerType.E_PlayerType_2 - 1)
			local percentX_2,percentY_2 = GetCenterCityPercent(TeamCityID_2)
			if m_PlayerTab["Teamer2"] ~= nil then	
				m_PlayerTab["Teamer2"]:ChangseTeamState(value["TeamState"])
				m_PlayerTab["Teamer2"]:SetStopMove(ccp(percentX_2,percentY_2), TeamCityID_2)
				print("队伍2状态从"..m_PlayerTab["Teamer2"]:GetState().."改变为"..value["TeamState"].." 移动到城市"..TeamCityID_2)
			end
		elseif key == PlayerType.E_PlayerType_3 - 1 and tonumber(m_PlayerTab["Teamer3"]:GetState()) ~= tonumber(value["TeamState"]) then
			local TeamCityID_3 = GetTeamCity(PlayerType.E_PlayerType_3 - 1)
			local percentX_3,percentY_3 = GetCenterCityPercent(TeamCityID_3)
			if m_PlayerTab["Teamer3"] ~= nil then
				m_PlayerTab["Teamer3"]:ChangseTeamState(value["TeamState"])
				m_PlayerTab["Teamer3"]:SetStopMove(ccp(percentX_3,percentY_3), TeamCityID_3)
				print("队伍3状态从"..m_PlayerTab["Teamer3"]:GetState().."改变为"..value["TeamState"].." 移动到城市"..TeamCityID_3)
			end
		end
	end
	NetWorkLoadingLayer.loadingHideNow()
end

function CountryWarSyncUpdateByMistyMess(  )
	NetWorkLoadingLayer.loadingShow(true)
	print("------------------------------更新世界迷雾状态----------------------------------")
	if m_MistyObj ~= nil then

		m_MistyObj:Fun_UpdateSyncMisty()

	end

	NetWorkLoadingLayer.loadingHideNow()
end

-------------------------------------------------国战弱网断线后的同步更新end-----------------------------------------------------
function CreateCountryScene(nType, nCityID)
	m_InitCity = nCityID
	m_nCreateParent = nType
	m_CountryWarPanel = TouchGroup:create()									-- 背景层
	m_CountryWarPanel:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryWarLayer.json"))	

	--隐藏 Mainscene
	if m_nCreateParent == CreateParent_Type.Parent_MainScene then
   		MainScene.HideMain( false )
   	elseif m_nCreateParent == CreateParent_Type.Parent_CropScene then
   		CorpsScene.HideCorps( false )
   	end

    return m_CountryWarPanel
end

function SetLeaveCorpsCallBack( nCallBack )
	m_CallBackFromParent = nCallBack
end

function GetLeaveCorpsCallBack(  )
	if m_CallBackFromParent ~= nil then
		m_CallBackFromParent()
	end
end

function SetIsBackFromSingle( bState )
	if CommonData.g_CountryWarLayer ~= nil then
		m_IsSingleBack = bState
	end
end

--获得当前的父节点
function GetCurParent(  )
	if m_nCreateParent ~= nil then
		return m_nCreateParent
	end

	return nil
end
--更换父节点
function ChangeCurParentNode( nParent, nTypeID )
	if m_CountryWarPanel ~= nil then
		local ScrollView_Map = tolua.cast(m_CountryWarPanel:getWidgetByName("ScrollView_Map"), "ScrollView")
		m_CountryWarPanel:setVisible(false)
		if m_CountryWarPanel:getParent() ~= nil then
			m_CountryWarPanel:removeFromParentAndCleanup(false)
			print("有父节点 移除")
		else
			print("没有父节点，直接挂")
		end
		if nTypeID == 2 then
			--切到战斗场景
			nParent:addChild(m_CountryWarPanel, layerCountryWarTag, layerCountryWarTag)
			if m_pWardScene ~= nil then
				--战斗场景把场景文件卸载
				m_pWardScene:removeFromParentAndCleanup(true)
			end
		else
			--切到军团或者主场景
			nParent:addChild(m_CountryWarPanel, layerCountryWarTag, layerCountryWarTag)
			require "Script/Main/CountryWar/AtkCityScene"
			if AtkCityScene.GetBIntoGuanZhan() == true then
				AtkCityScene.SetOpenResult() 			--调用观战界面接口
				if m_pWardScene ~= nil then
					m_pWardScene:removeFromParentAndCleanup(true)
				end
				if m_pWardScene ~= nil then
					--返回军团或者主场景加载国战场景文件
					ScrollView_Map:addNode(m_pWardScene, 1299, 1299)
				end
			end
			--返回主场景要检查当前是否是从单挑场景回来的
			if m_IsSingleBack == true then
				m_CountryWarPanel:setVisible(true)
				m_IsSingleBack = false

				if m_pWardScene ~= nil then
					m_pWardScene:removeFromParentAndCleanup(true)
				end
				if m_pWardScene ~= nil then
					--返回军团或者主场景加载国战场景文件
					ScrollView_Map:addNode(m_pWardScene, 1299, 1299)
				end

			end		
		end
		m_nCreateParent = nTypeID
		print("切换父节点为 = "..nTypeID)
		CountryUILayer.AddChat()
	end
end

local function GetCountryWarResTab( )
	local tabRes = {}
	
	for i=1,35 do
		local num = i-1
		if i < 11 then
			tabRes[i] = "Image/Fight/Scene/Scene_guozhan/Scene_guozhan_00"..num..".png"
		else
			tabRes[i] = "Image/Fight/Scene/Scene_guozhan/Scene_guozhan_0"..num..".png"
		end
	end

	table.insert(tabRes, "Image/imgres/common/country/country_1.png")
	table.insert(tabRes, "Image/imgres/common/country/country_2.png")
	table.insert(tabRes, "Image/imgres/common/country/country_3.png")
	table.insert(tabRes, "Image/Fight/player/zhaoyun/zhaoyun.ExportJson")
	table.insert(tabRes, "Image/Fight/player/guanyu/guanyu.ExportJson")
	table.insert(tabRes, "Image/Fight/player/ganning/ganning.ExportJson")
	table.insert(tabRes, "Image/Fight/player/nanzhu_zs/nanzhu_zs.ExportJson")
	table.insert(tabRes, "Image/imgres/countrywar/Animation/Scene_guozhan_ludian01/Scene_guozhan_ludian01.ExportJson")
	table.insert(tabRes, "Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
	
	return tabRes
end

function AddLoadingUI()		
	local function CallBack( ... )		
		--初始化国战界面
		network.NetWorkEvent(Packet_CountryWarLoadFinish.CreatPacket(2))
		m_CodeRunningBegin = os.clock()
	end

	local function AddSceneFile()
	    m_pWardScene = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_guozhan.json")
	    m_pWardScene:retain()
	end
	local function ContinuAddSceneFile()
		UI_Loading_Show(true, LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil,true)
		UI_Loading_SetCallBackFun(CallBack)
	end

	--UI_Loading_SetResTable(GetCountryWarResTab(), 37)
	--print(GetCountryWarResTab())
	--Pause()
	UI_Loading_SetResTable(GetCountryWarResTab(), 37)
	local layerTemp = UI_Loading_GetLoadingUI(LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil)
	m_CountryWarPanel:addChild(layerTemp, 10, layerLoading_Tag)
	UI_Loading_Show(true,LoadingNewLayer.LOADING_TYPE.LOADING_TYPE_NONE,nil,false)
	--UI_Loading_SetCallBackFun(CallBack)

	local function AddSceneFileByTwice()
		local AsyncAction = CCArray:create()
		AsyncAction:addObject(CCCallFunc:create(AddSceneFile))
		AsyncAction:addObject(CCCallFunc:create(ContinuAddSceneFile))
		m_CountryWarPanel:runAction(CCSequence:create(AsyncAction))
	end

	UI_Loading_SetCallBackFun(AddSceneFileByTwice)
end

