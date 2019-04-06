
-- 军团场景 celina
require "Script/Common/Common"
--require "Script/Main/MainScene"
module("CorpsScene", package.seeall)
require "Script/Fight/simulationStl"
require "Script/Main/Corps/CorpsInfoSetLayer"
require "Script/Main/Corps/CorpsData"
require "Script/Main/Corps/CorpsLogic"
require "Script/Main/Chat/ChatLayer"
require "Script/Main/Corps/CorpsApplyListLayer"
require "Script/Main/Corps/CorpsMemberInfoLayer"
require "Script/Main/Corps/CorpsMemberManageLayer"
require "Script/Main/Corps/CorpsMessHallLayer"
require "Script/Main/Corps/CorpsPresentLayer"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceUpLayer"
require "Script/Main/Corps/CorpsDynamicLayer"
require "Script/Main/Chat/ChatShowLayer"
require "Script/Main/Corps/CorpsSpirit/CorpsSpiritlayer"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryLayer"
require "Script/Main/Corps/CorpsMercenary/CorpsMercenaryLayers"
-- require "Script/Main/Corps/CorpsTreeLayer"
require "Script/Main/Corps/CorpsGodTreeLayer"
require "Script/Main/Corps/CorpsContentLayer"
require "Script/Main/Corps/CorpsCoceralLayer/CorpsCoceralLayer"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"
require "Script/Main/Corps/CorpsEnumType"
require "Script/serverDB/technolog"
require "Script/Main/CountryWar/CountryWarScene"
require "Script/Main/Corps/CorpsShop/CorpsShopLayer"
require "Script/serverDB/server_CorpsGetInfoDB"
require "Script/Main/PrisonCell/PrisonCellLayer"
require "Script/Main/Corps/CorpsTopLayer"
require "Script/Common/CoinInfoBar"
require "Script/Main/AddPoint/AddPoint"

local GetCorpsListData 		= CorpsData.GetCorpsListData
local GetIndexByTag         = CorpsData.GetIndexByTag
local ShowInfoSettingLayer 	= CorpsInfoSetLayer.ShowInfoSettingLayer
local CreateApplyList 		= CorpsApplyListLayer.CreateApplyList
local ShowMemberLayer		= CorpsMemberInfoLayer.ShowMemberLayer
local CreateMemberLayer 	= CorpsMemberManageLayer.CreateMemberLayer
-- local CreateMemberLayer 	= CorpsContentLayer.CreateContentLayer
local SearchId 				= CorpsLogic.SearchId
local GetCorpsInfo 			= CorpsData.GetCorpsInfo
local GetCorpsCountry 		= CorpsData.GetCorpsCountry
local showDynamicLayer 		= CorpsDynamicLayer.showDynamicLayer
local GetScienceUpDate  	= CorpsScienceData.GetScienceUpdate
local GetScienceDonate      = CorpsScienceData.GetScienceDonate
local GetScienceHall        = CorpsScienceData.GetScienceHall
local GetIconDataID 		= CorpsData.GetIconDataID
local GetMemberList 		= CorpsData.GetMemberList
local CheckTechTime         = CorpsData.CheckTechTime
local CheckMerStatus        = CorpsLogic.CheckMerStatus
local CheckSpiritStatus     = CorpsLogic.CheckSpiritStatus
local CheckPrisonGrid       = CorpsLogic.CheckPrisonGrid
--变量
local m_pSceneCorps 		= nil--场景
local m_pSceneCorpsLayer 	= nil --背景层
local m_p_Back              = nil
local m_p_Middle            = nil
local m_p_Front             = nil
local tabTagScene 			= nil
local pBackScene 			= nil
local bClicked 				= false
local nClickedCount 		= 0
local m_pChatLayer 			= nil
local m_pShowChatFrame 		= false
local m_CorpsNeedLevel 		= nil
local m_CorpsPeople 		= nil
local m_CountryID 			= nil
local m_TreeHandTime 		= nil
local m_isClickCountryWar   = false
local tableTreeDB  			= {}
local valueData 			= {}
local tableHeroData 		= {}
local TreeStateNum 			= 0
local treePar1 				= nil
local treePar2 				= nil
local treePar3 				= nil
local treePar4 				= nil
local treePar5 				= nil
local treePar6 				= nil
local m_staLayerStack       = nil
local m_PointManger         = nil
local n_selectId            = 1
tableLevel            = {}
tableData             = {}
local tablePointDa = {}

n_GolbPosition = 0

TAG_SCENE_CORPS = 1 
TAG_LAYER_CORPS = 2

function InitVars()
	m_pSceneCorps 		= nil 
	m_pSceneCorpsLayer 	= nil 
	tabTagScene 		= nil
	m_CorpsNeedLevel 	= nil
	m_CorpsPeople 		= nil
	bClicked 			= false
	nClickedCount 		= 0
	m_CountryID 		= nil
	m_TreeHandTime 		= nil
	TreeStateNum 		= 0
	treePar6			= nil
	treePar5            = nil
	treePar4            = nil
	treePar3            = nil
	treePar2            = nil
	treePar1            = nil
	m_staLayerStack     = nil
	m_PointManger       = nil
	n_selectId          = 1
	tableTreeDB 		= {}
	tableLevel          = {}
	tableData           = {}
	tablePointDa        = {}
end
--到灵兽界面
local function ToLingShou()
	--AddLabelImg(ShowInfoSettingLayer(valueData),102,m_pSceneCorpsLayer)
end
--点击处理 
--key值顺序
--1,神树
--2牢狱
--3 国家
--4 捐献
--5 兵营
--6 科技
--7 灵兽
--8 任务
--9 商店
--10商会
--11 食堂

function SetClickStateByCountryWar( nState )
	m_isClickCountryWar = nState
end

local function _CorpsIcon_CallBack( sender,eventType )
	--玩家设置界面
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local tableNumLevel = {}
		tableNumLevel = tableLevel[2]
		local scenetemp = CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerCorpsTeachTag)
		if temp == nil then
			local m_corpsContentLayer = CorpsContentLayer.CreateContentLayer(C_CORPSCONTENTSTATUS.C_ContentSet,tableNumLevel) --C_ContentSet C_ContentMember
			scenetemp:addChild(m_corpsContentLayer,layerCorpsMemberTag,layerCorpsMemberTag)
		end
	end
end

function SetHeadIcon( nCorpsId )
	local Image_CorpsIcon = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_CorpsIcon"),"ImageView")
	local image_hBg = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_37"),"ImageView")
	local image_hkuang = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_CorpsIconBg"),"ImageView")
	Image_CorpsIcon:setZOrder(-1)
	if nCorpsId > 0 then
		local iconPath = resimg.getFieldByIdAndIndex(nCorpsId,"icon_path")
		Image_CorpsIcon:loadTexture(iconPath)
	end
	Image_CorpsIcon:setTouchEnabled(true)
	Image_CorpsIcon:addTouchEventListener(_CorpsIcon_CallBack)
end

function SetCorpsLevel( nlevel )
	if m_pSceneCorpsLayer == nil then
		return
	end
	local label_level = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Label_Level"),"Label")
	label_level:setText(nlevel)
end

function SetCorpsName( strName )
	local label_name = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Label_CorpsName"),"Label")
	if strName ~= nil then
		if label_name:getChildByTag(1000) ~= nil then
			LabelLayer.setText(label_name:getChildByTag(1000),strName)
		else
			local text = LabelLayer.createStrokeLabel(20, "微软雅黑", strName, ccp(0, 0), COLOR_Black, ccc3(253,194,30), true, ccp(0, -3), 3)
			label_name:addChild(text,0,1000)
		end
	end
	
end

function SetCorpsContribute( nNumber )
	local image_Contribute = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_10"),"ImageView")
	if image_Contribute:getChildByTag(1000) ~= nil then
		LabelLayer.setText(image_Contribute:getChildByTag(1000),nNumber)
	else
		local text = LabelLayer.createStrokeLabel(23,"微软雅黑",nNumber,ccp(0,0),ccc3(83,28,2), ccc3(161,85,20),true,ccp(0,-2),2)
		image_Contribute:addChild(text,0,1000)
	end
end

function SetCorpsMoney( nNumber )
	local image_Corpsmoney = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_11"),"ImageView")
	if image_Corpsmoney:getChildByTag(1000) ~= nil then
		LabelLayer.setText(image_Corpsmoney:getChildByTag(1000),nNumber)
	else
		local text = LabelLayer.createStrokeLabel(23,"微软雅黑",nNumber,ccp(0,0),ccc3(83,28,2), ccc3(161,85,20),true,ccp(0,-2),2)
		image_Corpsmoney:addChild(text,0,1000)
	end
end

local function SetCorpsPower( nNumber )
	local image_CorpsPower = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Image_12"),"ImageView")
	if image_CorpsPower:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(image_CorpsPower:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(nNumber)
	else
		local pText = LabelBMFont:create()		
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-10,-20))
		pText:setAnchorPoint(ccp(0,0.5))
		pText:setText(nNumber)
		image_CorpsPower:addChild(pText,0,1000)
	end 
end

local function SetCorpsNitificaInfo( strNotifica )
	local Notification = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("Label_notice"),"Label")
	Notification:setText(strNotifica)
end

function UpdateGodTreeState( tableTreeDBs )
	
	if m_pSceneCorpsLayer == nil then
		return
	end
	local status1,status2,status3,status4,status5 = CorpsData.GetTreeGolbeData()
	---神树的每种状态
	local m_p_Middle = pBackScene:getChildByTag(12000)
	-- tableTreeDB 神树的各种属性值
	
	local n_curCount = tableTreeDBs.nCurCount
	local n_MaxLimit = tableTreeDBs.nMaxLimite
	TreeStateNum = n_curCount/n_MaxLimit
	treePar1 = globedefine.getFieldByIdAndIndex("ShenShuArt","Para_1")
	treePar2 = globedefine.getFieldByIdAndIndex("ShenShuArt","Para_2")
	treePar3 = globedefine.getFieldByIdAndIndex("ShenShuArt","Para_3")
	treePar4 = globedefine.getFieldByIdAndIndex("ShenShuArt","Para_4")
	treePar5 = globedefine.getFieldByIdAndIndex("ShenShuArt","Para_5")
	treePar6 = globedefine.getFieldByIdAndIndex("ShenShuArt","Para_6")
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14017)
	local pCCNodeF = tolua.cast(nNode:getComponent("CCArmature"),"CCComRender")
	local pCCNode = tolua.cast(pCCNodeF:getNode(),"CCArmature")
	--local animationNameNormal = "zhenying_shu"
	if nNode ~= nil then
		if TreeStateNum >= tonumber(status1) and TreeStateNum < tonumber(status2) then
			animationNameNormal = "Animation1"
		elseif TreeStateNum >= tonumber(status2) and TreeStateNum < tonumber(status3) then
			animationNameNormal = "Animation3"
		elseif TreeStateNum >= tonumber(status3) and TreeStateNum < tonumber(status4) then
			animationNameNormal = "Animation5"
		elseif TreeStateNum >= tonumber(status4) and TreeStateNum < tonumber(status5) then
			animationNameNormal = "Animation7"
		elseif TreeStateNum >= tonumber(status5) then
			animationNameNormal = "Animation9"
		else
			animationNameNormal = "Animation1"
		end
	end
		
	pCCNode:getAnimation():play(animationNameNormal)
end

function UpdateCoutryState( nCountryID )
	local m_p_Middle = pBackScene:getChildByTag(12000)
	m_CountryID = nCountryID
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14019)
	local pCCNodeF = tolua.cast(nNode:getComponent("CCArmature"),"CCComRender")
	local pCCNode = tolua.cast(pCCNodeF:getNode(),"CCArmature")
	local animationNameNormal = "zhenying_shu"
	if nNode ~= nil then
		if m_CountryID == 1 then
			animationNameNormal = "zhenying_wei"
		elseif m_CountryID == 2 then
			animationNameNormal = "zhenying_shu"
		elseif m_CountryID == 3 then
			animationNameNormal = "zhenying_wu"
		end
	end
		
	pCCNode:getAnimation():play(animationNameNormal)
end

-- 得到全部科技的信息及科技建筑的状态
local function loadScienceLevel(  )
	local function GetSuccessCallback(  )
		tableLevel = CorpsData.GetScienceLevel()
		if CheckTechTime(tableLevel) == true then
			local m_p_Middle = pBackScene:getChildByTag(12000)
			local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14022)
			m_PointManger:ShowRedPoint(6,nNode,95,115)
		end
	end	
	Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
end

function CleanCorpsTopLayer(  )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local child = scenetemp:getChildByTag(115)
	if child ~= nil then
		child:setVisible(false)
	    child:setTouchEnabled(false)
    	child:removeFromParentAndCleanup(true)
    	child = nil
    else
    	
    end
end

function ShowHideCoinBar( is_Show )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local child = scenetemp:getChildByTag(115)
	if child ~= nil then

		child:setVisible(is_Show)
	    child:setTouchEnabled(is_Show)
    end
end

function loadCorpsTopLayer( m_GamPScene )
	if m_GamPScene == nil then
		m_GamPScene = GetPScene()
	end
	local c_TopLayer = CorpsTopLayer.ShowTopLayer(m_pSceneCorps,tableData,1)
	m_GamPScene:addChild(c_TopLayer,115,115)
end

function GetCorpsMoney(  )
	local m_coinNum = GetCorpsInfo()
	return m_coinNum[1][11]
end

function CreateSpiriteLayer( nRoot )
	local scenetemp = CCDirector:sharedDirector():getRunningScene()
	local temp = nRoot:getChildByTag(layerSpiritTag)
	if temp == nil then
		local function GetSpiriteCallBack(  )
			NetWorkLoadingLayer.loadingHideNow()
			local pCorpsSpirit = CorpsSpiritlayer.showSpiritLayer(nRoot)
			nRoot:addChild(pCorpsSpirit,layerSpiritTag,layerSpiritTag)
		end
		Packet_AniGetPerstige.SetSuccessCallBack(GetSpiriteCallBack)
		network.NetWorkEvent(Packet_AniGetPerstige.CreatePacket())
		NetWorkLoadingLayer.loadingShow(true)
	else
		print("已经是灵兽页面了")
	end
end

function GetPersonOffical(  )
	----通过获取成员列表信息来确定成员在军团中的职位
	local nGlobalID = CommonData.g_nGlobalID
	local function GetSuccessCallback(  )
		local tableTemp = GetMemberList()
		for key,value in pairs(tableTemp) do
			if SearchId(nGlobalID,value) == true then
				n_GolbPosition = value.position
				return
			end
		end
	end	
	Packet_CorpsGetMemList.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetMemList.CreatePacket())
end


local function UpdataCorpsInfo(  )	
	tableData = GetCorpsInfo()
	local corpsiconid = nil
	local corpslevel = nil
	local corpsname = nil
	local corpsid = nil
	local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
	local vip = tonumber(server_mainDB.getMainData("vip"))
	for key,value in pairs(tableData) do
		valueData["id"] 			= value[1]
		valueData["name"] 			= value[2]
		valueData["flag"] 			= value[6]
		valueData["level"] 			= value[3]
		valueData["people"] 		= value[4]
		valueData["needLevel"] 		= value[5]
		valueData["country"] 		= value[7]
		valueData["brief"] 			= value[8]
		valueData["limitType"] 		= value[9]
		valueData["m_uContribute"] 	= value[10] -- 军团总贡献
		valueData["m_uCorpsMoney"] 	= value[11] -- 军团币
		m_CorpsPeople = value[4]
		m_CorpsNeedLevel = value[5] 
		m_CountryID = value[7]
		SetHeadIcon(value[6])
		SetCorpsLevel(value[3])
		SetCorpsName(value[2])
		
		
	end
	GetPersonOffical()
end

--调整UI中元素的位置
local function SetPanelPosition( m_pCorpsLayer )
	local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
	local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
	local nOff_X = CommonData.g_Origin.x
	local nOff_Y = CommonData.g_Origin.y

	local Panel_HeadIcon = tolua.cast(m_pCorpsLayer:getWidgetByName("Panel_HeadIcon"),"Layout")

	local posHeadIconX = Panel_HeadIcon:getPositionX()

	Panel_HeadIcon:setPosition(ccp(posHeadIconX + nOff_X, Panel_HeadIcon:getPositionY() - nOff_Y))
end

local function _Click_MemberList_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local tableNumLevel = {}
		tableNumLevel = tableLevel[2]
		local scenetemp = CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerCorpsTeachTag)
		if temp == nil then
			local m_corpsContentLayer = CorpsContentLayer.CreateContentLayer(C_CORPSCONTENTSTATUS.C_ContentMember,tableNumLevel)
			scenetemp:addChild(m_corpsContentLayer,layerCorpsMemberTag,layerCorpsMemberTag)
		end
	end
end

function GetUpdateMoney( indexMoney ,nType)
	local n_Gold = server_mainDB.getMainData("gold")
	local n_Sliver = server_mainDB.getMainData("silver")
	local n_Tili = server_mainDB.getMainData("tili")
	local n_CorpsCon = server_mainDB.getMainData("Family_Prestige")

	if m_pSceneCorpsLayer == nil then
		return
	end
	if tonumber(nType) == 1 then
		local function GetSuccessCallback(  )
			local tableMoney = CorpsData.GetCorpsInfo()
			for key,value in pairs(tableMoney) do
				--NetWorkLoadingLayer.loadingHideNow()
				local n_Gold = server_mainDB.getMainData("gold")
				local n_Sliver = server_mainDB.getMainData("silver")
				local n_Tili = server_mainDB.getMainData("tili")
				local n_CorpsCon = server_mainDB.getMainData("Family_Prestige")

				CorpsTopLayer.SetGodMoney(n_Sliver)
				CorpsTopLayer.SetSliverMoney(n_Gold)
				CorpsTopLayer.SetContribute(n_CorpsCon)
				CorpsTopLayer.SetCorpsMoney(value[11])
			end
		end
		Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
	else
		CorpsTopLayer.SetGodMoney(n_Sliver)
		CorpsTopLayer.SetSliverMoney(n_Gold)
		CorpsTopLayer.SetContribute(n_CorpsCon)
		CorpsTopLayer.SetCorpsMoney(n_Tili)
	end
end

function GetConteobile( nIndex )
	local function GetSuccessCallback(  )
		local tableMoney = CorpsData.GetCorpsInfo()
		for key,value in pairs(tableMoney) do
			--NetWorkLoadingLayer.loadingHideNow()
			local n_Gold = server_mainDB.getMainData("gold")
			local n_Sliver = server_mainDB.getMainData("silver")
			local n_Tili = server_mainDB.getMainData("tili")

			local n_CorpsCon = server_mainDB.getMainData("Family_Prestige")

			CorpsTopLayer.SetGodMoney(n_Sliver)
			CorpsTopLayer.SetSliverMoney(n_Gold)
			CorpsTopLayer.SetContribute(n_CorpsCon)
			if nIndex == 0 then
				CorpsTopLayer.SetCorpsMoney(n_Tili)
			else
				CorpsTopLayer.SetCorpsMoney(value[11])
			end
		end
	end
	--Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
	--NetWorkLoadingLayer.loadingShow(true)
end

local function EnterScienceUpLayer( isUpScience )
	if isUpScience == true then
		local scenetemp = CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerCorpsTeachTag)
		if temp == nil then
			local function OpenTech(  )
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					local pTeachnologyLayer = CorpsScienceUpLayer.createTeachLayer(n_selectId-1)
					scenetemp:addChild(pTeachnologyLayer,layerCorpsTeachTag,layerCorpsTeachTag)
				end	
				Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			end
			local enterArray = CCArray:create()
			enterArray:addObject(CCCallFunc:create(GetPersonOffical))
			enterArray:addObject(CCCallFunc:create(OpenTech))
			scenetemp:runAction(CCSequence:create(enterArray))
		end
	end
end

function EnterPresentLayer( is_Enter )
	--捐献
	if is_Enter == false then
	local tableUpdateDonate = {}
	tableUpdateDonate = CorpsData.GetScienceLevel()
	local tableDonate = {}
	if #tableUpdateDonate == 0 then
		return
	end
	tableDonate = tableUpdateDonate[5]
	n_selectId = 5
	if tableDonate.m_nLevel > 0 then
		local ScienceID = 5
		local function GetDonateData()
			NetWorkLoadingLayer.loadingHideNow()
			CorpsScienceUpLayer.DestorySceneLayer()
			local tableConateDB = GetScienceDonate()
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local temp = scenetemp:getChildByTag(layerCorpsPresentTag)
			if temp == nil then
			-- CleanCorpsTopLayer()
			local pCorpsPresentLayer = CorpsPresentLayer.CreatePresentLayer(tableConateDB,tableDonate)
			scenetemp:addChild(pCorpsPresentLayer,layerCorpsPresentTag,layerCorpsPresentTag)									
			else
			print("已经是军团捐献页面了")
			end			
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_CorpsScienceUpDate.SetSuccessCallBack1(GetDonateData)
		network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(5))
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1458,EnterScienceUpLayer)
	end
	end
end

function ReturnPresentLayer(  )
	local tableUpdateDonate = {}
	tableUpdateDonate = CorpsData.GetScienceLevel()
	local tableDonate = {}
	if #tableUpdateDonate == 0 then
		return
	end
	tableDonate = tableUpdateDonate[5]
	n_selectId = 5
	if tableDonate.m_nLevel > 0 then
		local ScienceID = 5
		local function GetDonateData()
			NetWorkLoadingLayer.loadingHideNow()
			local tableConateDB = GetScienceDonate()
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local temp = scenetemp:getChildByTag(layerCorpsPresentTag)
			if temp == nil then
			local pCorpsPresentLayer = CorpsPresentLayer.CreatePresentLayer(tableConateDB,tableDonate)
			scenetemp:addChild(pCorpsPresentLayer,layerCorpsPresentTag,layerCorpsPresentTag)									
			else
			end			
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_CorpsScienceUpDate.SetSuccessCallBack1(GetDonateData)
		network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(5))
	end
end

function ReturnHallLayer(  )
	--食堂
	local tableUpdateMess = {}
	tableUpdateMess = CorpsData.GetScienceLevel()
	n_selectId = 4
	if #tableUpdateMess == 0 then
		return
	end
	local tableMessLevel = tableUpdateMess[4]
	if tableMessLevel.m_nLevel == 0 then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1458,EnterScienceUpLayer)
	else
		local ScienceID = 4
		local function JudgeTree()
			NetWorkLoadingLayer.loadingHideNow()
			tableTreeDB = GetScienceHall()
			local scenetemp =  CCDirector:sharedDirector():getRunningScene()
			local temp = scenetemp:getChildByTag(layerCorpsMessHallTag)
			if temp == nil then
				CleanCorpsTopLayer()
				local c_TopLayer = CorpsTopLayer.ShowTopLayer(m_pSceneCorps,tableData,0)
				m_pSceneCorps:addChild(c_TopLayer,115,115)
				local pCorpsMessHallLayer = CorpsMessHallLayer.CreateMessLayer(valueData,tableMessLevel)
				scenetemp:addChild(pCorpsMessHallLayer,layerCorpsMessHallTag,layerCorpsMessHallTag)									
			
			end		
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_CorpsScienceUpDate.SetSuccessCallBack2(JudgeTree)
		network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(4))
	end
end

function HideCorps( nState )
	if m_pSceneCorpsLayer ~= nil then 
		ShowHideCoinBar(nState)
		pBackScene:setVisible(nState)
		m_pSceneCorpsLayer:setVisible(nState)
	end
end

local function ActionClick(sender, eventType)
	local m_p_Middle = pBackScene:getChildByTag(12000)
	local animationNameClick = "Animation2"
	local animationNameNormal = "Animation1"
	local status1,status2,status3,status4,status5 = CorpsData.GetTreeGolbeData()
	if tabTagScene == nil then
		return
	end
	for key,value in pairs(tabTagScene) do 
		local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(value)
		if key == 3 then
			if m_CountryID == 1 then --valueData.country
				animationNameClick = "zhenying_wei01"
				animationNameNormal = "zhenying_wei"
			elseif m_CountryID == 2 then
				animationNameClick = "zhenying_shu01"
				animationNameNormal = "zhenying_shu"
			elseif m_CountryID == 3 then
				animationNameClick = "zhenying_wu01"
				animationNameNormal = "zhenying_wu"
			end
			
		elseif key == 1 then
			if TreeStateNum >= tonumber(status1) and TreeStateNum < tonumber(status2) then
				animationNameNormal = "Animation1"
				animationNameClick  = "Animation2"
			elseif TreeStateNum >= tonumber(status2) and TreeStateNum < tonumber(status3) then
				animationNameNormal = "Animation3"
				animationNameClick  = "Animation4"
			elseif TreeStateNum >= tonumber(status3) and TreeStateNum < tonumber(status4) then
				animationNameNormal = "Animation5"
				animationNameClick  = "Animation6"
			elseif TreeStateNum >= tonumber(status4) and TreeStateNum < tonumber(status5) then
				animationNameNormal = "Animation7"
				animationNameClick  = "Animation8"
			elseif TreeStateNum >= tonumber(status5) then
				animationNameNormal = "Animation9"
				animationNameClick  = "Animation10"
			else
				animationNameNormal = "Animation1"
				animationNameClick  = "Animation2"
			end
		else
			animationNameClick = "Animation2"
			animationNameNormal = "Animation1"
		end
		if nNode~=nil then
			local pCCNodeF = tolua.cast(nNode:getComponent("CCArmature"),"CCComRender")
			local pCCNode = tolua.cast(pCCNodeF:getNode(),"CCArmature")	
			local rect = pCCNode:boundingBox()					
			local nWi = rect.size.width
			local nHe = rect.size.height	
			local fAncPointX = pCCNode:getAnchorPointInPoints().x
			local fAncPointY = pCCNode:getAnchorPointInPoints().y				
			local ptPt = nil
			if eventType == TouchEventType.began then
				ptPt = sender:getTouchStartPos()
			elseif eventType == TouchEventType.moved then
				ptPt = sender:getTouchMovePos()
			elseif eventType == TouchEventType.ended then
				AudioUtil.PlayBtnClick()
				ptPt = sender:getTouchEndPos()
			end
			if ptPt ~= nil and ptPt.x >= pCCNode:convertToWorldSpace(ccp(0, 0)).x - fAncPointX and 
				ptPt.x <= pCCNode:convertToWorldSpace(ccp(0, 0)).x +nWi - fAncPointX then
				if ptPt.y >= pCCNode:convertToWorldSpace(ccp(0, 0)).y - fAncPointY and 
					ptPt.y <= pCCNode:convertToWorldSpace(ccp(0, 0)).y +nHe- fAncPointY then
					if eventType == TouchEventType.began then
						pCCNode:getAnimation():play(animationNameClick)
						bClicked = true
						nClickedCount = 0
					elseif eventType == TouchEventType.moved then
						--print("nClickedCount = "..nClickedCount)
						nClickedCount = nClickedCount + 1
						if nClickedCount == 5 then
							bClicked = false
							if pCCNode:getAnimation():getCurrentMovementID() ~= "Animation1" then
								pCCNode:getAnimation():play(animationNameNormal)
							end
						end
					elseif eventType == TouchEventType.ended then
						AudioUtil.PlayBtnClick()
						if bClicked == true then
							pCCNode:getAnimation():play(animationNameNormal)
							if key == 1 then
								local ScienceID = 1
								local tableUpdateTree = {}
								tableUpdateTree = CorpsData.GetScienceLevel()
								if #tableUpdateTree == 0 then
									return
								end
								tableTree = tableUpdateTree[1]
								n_selectId = ScienceID
								local function JudgeTree(  )
									NetWorkLoadingLayer.loadingHideNow()
									local scenetemp = CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(layerCopTree_tag)
									if temp == nil then
										local pGodtreeLayer = CorpsGodTreeLayer.ShowTreeLayer(tableTree)
										scenetemp:addChild(pGodtreeLayer,layerCopTree_tag,layerCopTree_tag)
									else
										print("已经是神树界面了")
									end
								end
								
								NetWorkLoadingLayer.loadingShow(true)
								Packet_CorpsScienceUpDate.SetSuccessCallBack(JudgeTree)
								network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(ScienceID))
								return
							elseif key == 2 then
								--牢房
								local function openPrison()
									NetWorkLoadingLayer.loadingHideNow()
									print("牢狱")
									local scenetemp = CCDirector:sharedDirector():getRunningScene()
									local temp = scenetemp:getChildByTag(layerPrisonTag)
									if temp == nil then
										local pPrisonLayer = PrisonCellLayer.ShowPrisonCellLayer()
										scenetemp:addChild(pPrisonLayer,layerPrisonTag,layerPrisonTag)
									else
										print("已经是牢房界面了")
									end
								end
								NetWorkLoadingLayer.loadingShow(true)
								Packet_GetPrisonGridInfo.SetSuccessCallBack(openPrison)
								network.NetWorkEvent(Packet_GetPrisonGridInfo.CreatePacket())
								return
							elseif key == 3 then
								--国家升级
								require "Script/Main/CountryWar/CountryLevelUpLayer"
								local function openCountryWarLevelUp()
									NetWorkLoadingLayer.loadingHideNow()


									local function GetOK(nWe,nSh,nWu)
										
										NetWorkLoadingLayer.loadingHideNow()
										local tab = {}
										tab[COUNTRY_TYPE.COUNTRY_TYPE_WEI] = nWe
										tab[COUNTRY_TYPE.COUNTRY_TYPE_SHU] = nSh
										tab[COUNTRY_TYPE.COUNTRY_TYPE_WU]  = nWu

										local scenetemp = CCDirector:sharedDirector():getRunningScene()
										local temp = scenetemp:getChildByTag(layerCountryWarLevelUp_tag)
										if temp == nil then
											local pCountryLevelUpLayer = CountryLevelUpLayer.CreateCountryLevelUpLay(1, tab)
											scenetemp:addChild(pCountryLevelUpLayer,layerCountryWarLevelUp_tag,layerCountryWarLevelUp_tag)
										else
											print("已经国家升级页面了")
										end

									end
									--获得国家的战斗力
									Packet_GetCountryFight.SetSuccessCallBack(GetOK)
									network.NetWorkEvent(Packet_GetCountryFight.CreatPacket())
									NetWorkLoadingLayer.loadingShow(true)

								end	
								NetWorkLoadingLayer.loadingShow(true)
								Packet_GetCountryLevelUpData.SetSuccessCallBack(openCountryWarLevelUp)
								network.NetWorkEvent(Packet_GetCountryLevelUpData.CreatePacket(GetCorpsCountry()))
								return
							elseif key == 4 then
								--捐献
								local tableUpdateDonate = {}
								tableUpdateDonate = CorpsData.GetScienceLevel()
								local tableDonate = {}
								if #tableUpdateDonate == 0 then
									return
								end
								tableDonate = tableUpdateDonate[5]
								n_selectId = 5
								if tableDonate.m_nLevel > 0 then
									local ScienceID = 5
									-- local tabType = {2,1,10,13}
									-- CoinInfoBar.UpdateCoinBar(tabType,true)
									local function GetDonatData()
										NetWorkLoadingLayer.loadingHideNow()
										local tableConateDB = {}
										tableConateDB = GetScienceDonate()
										if tonumber(tableConateDB["t_type"]) ~= 5 then
											return
										end
										local scenetemp =  CCDirector:sharedDirector():getRunningScene()
										local temp = scenetemp:getChildByTag(layerCorpsPresentTag)
										if temp == nil then
											-- CleanCorpsTopLayer()
											local pCorpsPresentLayer = CorpsPresentLayer.CreatePresentLayer(tableConateDB,tableDonate)
											scenetemp:addChild(pCorpsPresentLayer,layerCorpsPresentTag,layerCorpsPresentTag)									
										else
											print("已经是军团捐献页面了")
										end			
									end
									NetWorkLoadingLayer.loadingShow(true)
									Packet_CorpsScienceUpDate.SetSuccessCallBack1(GetDonatData)
									network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(5))
								else
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1458,EnterScienceUpLayer)
								end
								return 
							elseif key == 5 then
								--佣兵
								local tableUpdateYongBing = {}
								tableUpdateYongBing = CorpsData.GetScienceLevel()
								local tableYongbing = {}
								if #tableUpdateYongBing == 0 then
									return
								end
								tableYongbing = tableUpdateYongBing[7]
								n_selectId = 7
								-- CoinInfoBar.ShowHideBar(false)
								--[[if tableYongbing.m_nLevel == 0 then
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1458,EnterScienceUpLayer,nil)
									pTips = nil
								else]]--
									local function GetSuccessCallback(  )
										NetWorkLoadingLayer.loadingHideNow()
										print("调试佣兵信息的协议")
										local scenetemp = CCDirector:sharedDirector():getRunningScene()
										local temp = scenetemp:getChildByTag(layerCorpsMercenaryTag)
										if temp == nil then
											-- CleanCorpsTopLayer()
											-- local pMercenaryLayer = CorpsMercenaryLayer.showMercenaryLayer(tableYongbing)
											local pMercenaryLayer = CorpsMercenaryLayers.showMercenaryLayer(tableYongbing)
											scenetemp:addChild(pMercenaryLayer,layerCorpsMercenaryTag,layerCorpsMercenaryTag)
										else
											print("已经是佣兵页面了")
										end
									end
									Packet_CorpsYetMercenary.SetSuccessCallBack(GetSuccessCallback)
									network.NetWorkEvent(Packet_CorpsYetMercenary.CreatePacket())
									NetWorkLoadingLayer.loadingShow(true)
								-- end
								return
							elseif key == 6 then
								--科技
								-- GetPersonOffical()
								local scenetemp = CCDirector:sharedDirector():getRunningScene()
								local temp = scenetemp:getChildByTag(layerCorpsTeachTag)
								if temp == nil then
									local function OpenTech(  )
										local function GetSuccessCallback(  )
											NetWorkLoadingLayer.loadingHideNow()
											local pTeachnologyLayer = CorpsScienceUpLayer.createTeachLayer(0)
											scenetemp:addChild(pTeachnologyLayer,layerCorpsTeachTag,layerCorpsTeachTag)
										end	
										Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
										network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
										NetWorkLoadingLayer.loadingShow(true)
									end
									-- OpenTech()
									local enterArray = CCArray:create()
									enterArray:addObject(CCCallFunc:create(GetPersonOffical))
									enterArray:addObject(CCCallFunc:create(OpenTech))
									scenetemp:runAction(CCSequence:create(enterArray))
								end
								return
							elseif key == 7 then
								--ToLingShou()
								local tabSpiritTotal = CorpsData.GetScienceLevel()
								local tableSpiritLevel = {}
								tableSpiritLevel = tabSpiritTotal[10]
								n_selectId = 8

								if tableSpiritLevel.m_nLevel == 0 then
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1458,EnterScienceUpLayer,nil)
									pTips = nil
								else
									-- CleanCorpsTopLayer()
									CreateSpiriteLayer(m_pSceneCorpsLayer) --m_pSceneCorpsLayer
								end
								return
							elseif key == 8 then
								print("任务")

								local scenetemp = CCDirector:sharedDirector():getRunningScene()
								local temp = scenetemp:getChildByTag(layerMissionNormal_tag)
								if temp == nil then
									local function openMissionLayer()
										NetWorkLoadingLayer.loadingHideNow()
										local mission = MissionNormalLayer.CreateMissionNormalLayer(2)
										scenetemp:addChild(mission,layerMissionNormal_tag,layerMissionNormal_tag)

									end
									NetWorkLoadingLayer.loadingShow(true)

									Packet_GetReceiveMissionCorpsData.SetSuccessCallBack(openMissionLayer)
									network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket(2))
								end
								return
							elseif key == 9 then
								local tableUpdateShop = {}
								tableUpdateShop = CorpsData.GetScienceLevel()
								local nShopId = 3

								n_selectId = 6
								if #tableUpdateShop == 0 then
									return
								end
								local tableShopLevel = {}
								tableShopLevel = tableUpdateShop[6]

								if tableShopLevel.m_nLevel == 0 then
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1458,EnterScienceUpLayer,nil)
									pTips = nil
								else
									local function OpenCorpsShop()
										NetWorkLoadingLayer.loadingHideNow()
										local scenetemp =  CCDirector:sharedDirector():getRunningScene()
										local temp = scenetemp:getChildByTag(layerShopTag)

										if temp == nil then
											require "Script/Main/Mall/ShopLayer"
											local pLayerShop = ShopLayer.CreateShopLayer(nShopId)
											scenetemp:addChild(pLayerShop,layerShopTag,layerShopTag)
										else
											print("已经是商店界面了")
										end
									end
									Packet_GetShopList.SetSuccessCallBack(OpenCorpsShop)
									network.NetWorkEvent(Packet_GetShopList.CreatPacket(nShopId))
									NetWorkLoadingLayer.loadingShow(true)
								end
								return
							elseif key == 10 then
								local pTips = TipCommonLayer.CreateTipLayerManager()
								pTips:ShowCommonTips(1616,nil)
								pTips = nil

								return
							elseif key == 11 then
								--食堂
								local tableUpdateMess = {}
								tableUpdateMess = CorpsData.GetScienceLevel()
								n_selectId = 4
								if #tableUpdateMess == 0 then
									return
								end
								local tableMessLevel = tableUpdateMess[4]
								if tableMessLevel.m_nLevel == 0 then
									local pTips = TipCommonLayer.CreateTipLayerManager()
									pTips:ShowCommonTips(1458,EnterScienceUpLayer)
								else
									--[[local tabType = {2,1,3,10}
									CoinInfoBar.UpdateCoinBar(tabType,true)]]--
									local ScienceID = 4
									local function JudgeTree()
										NetWorkLoadingLayer.loadingHideNow()
										tableTreeDB = GetScienceHall()
										local scenetemp =  CCDirector:sharedDirector():getRunningScene()
										local temp = scenetemp:getChildByTag(layerCorpsMessHallTag)
										if temp == nil then
											CleanCorpsTopLayer()
											local c_TopLayer = CorpsTopLayer.ShowTopLayer(m_pSceneCorps,tableData,0)
											m_pSceneCorps:addChild(c_TopLayer,115,115)
											local pCorpsMessHallLayer = CorpsMessHallLayer.CreateMessLayer(valueData,tableMessLevel)
											scenetemp:addChild(pCorpsMessHallLayer,layerCorpsMessHallTag,layerCorpsMessHallTag)									
										else
											print("已经是军团食堂页面了")
										end		
									end
									NetWorkLoadingLayer.loadingShow(true)
									Packet_CorpsScienceUpDate.SetSuccessCallBack2(JudgeTree)
									network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(4))
								end
								return 
							elseif key == 12 then
								print("世界")

								if m_isClickCountryWar == false then
									
									OpenCountryWarMap(m_pSceneCorps)
								end

								return
							elseif key == 13 then
								print("主城")
								_Btn_Back_CallBack()
								return
							end
							return  
						end
					else
						if pCCNode:getAnimation():getCurrentMovementID() ~= animationNameNormal then
							pCCNode:getAnimation():play(animationNameNormal)
						end
					end
					return 
				end
			end
		end
	end
	
end
function _Btn_Back_CallBack()
	--先删除国战

	if CommonData.g_CountryWarLayer ~= nil then
		CommonData.g_CountryWarLayer:removeFromParentAndCleanup(false)
	end
	AudioUtil.PlayBtnClick()
	local coinLayer = m_pSceneCorps:getChildByTag(layerCoinBar_Tag)
	if coinLayer ~= nil then
		coinLayer:removeFromParentAndCleanup(true)
		coinLayer = nil
	end
	InitVars()
	tableHeroData = {}
	NetWorkLoadingLayer.ClearLoading()
	CCDirector:sharedDirector():popScene()

	local m_pMainSceneLayer = MainScene.GetControlUI()
	ChatShowLayer.ShowChatlayer(MainScene.GetControlUI())
	MainScene.SetCurParent(true)
end
local function InitData()
	tabTagScene = {}
	for i=1,11 do --170,180
		tabTagScene[i] = 14016+i
	end
	--添加两个功能建筑  世界  主城
	tabTagScene[12] = 14568 -- 世界
	tabTagScene[13] = 14569 -- 主城
end
function GetPScene()
	return m_pSceneCorps
end



function GetPCorpsLayer(  )
	return m_pSceneCorpsLayer
end

function GetPLayer(  )
	return m_pCorpsLayer
end

function OpenCountryWarMap(nParent, nCityID,nCallBack, nOpenCallBack)
	
	local temp = m_pSceneCorps:getChildByTag(layerCountryWarTag)
	function LeaveCorpsCallBack(  )
		CountryWarScene.SetLeaveCorpsCallBack(_Btn_Back_CallBack)
	end

	local bOpenTab = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_26)

	local function OpenCWar( nResult )
		LeaveCorpsCallBack()
		NetWorkLoadingLayer.loadingHideNow()
		--NetWorkLoadingLayer.ClearLoading()
		if nResult == 1 then
			if temp == nil then
				ShowHideCoinBar(false)
				if CommonData.g_CountryWarLayer == nil then	
					print("国战层不存在，创建国战层在军团场景上")																									
					CommonData.g_CountryWarLayer = CountryWarScene.CreateCountryScene(1, nCityID)
					CommonData.g_CountryWarLayer:retain()
					CountryWarScene.AddLoadingUI()
					if nCallBack ~= nil then
						CountryWarScene.SetComeInCallBack(nCallBack)
					end
					nParent:addChild(CommonData.g_CountryWarLayer, layerCountryWarTag, layerCountryWarTag)
					m_isClickCountryWar = true
					if nOpenCallBack ~= nil then
						nOpenCallBack( nResult )
					end
				else
					if nCityID ~= nil then
						CountryWarScene.SetNewCity(nCityID)
					end
					local actionLeave= CCArray:create()
					if CommonData.g_CountryWarLayer:isVisible() == false then
						--actionLeave:addObject(CCMoveBy:create(0.1,ccp(10000,0)))
						CommonData.g_CountryWarLayer:setPositionX(0)
					end
					actionLeave:addObject(CCCallFunc:create(CountryWarScene.OpenCountryWarLayer))
					CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
					print("国战曾已存在，直接显示")
					m_isClickCountryWar = true

				end

				if nOpenCallBack ~= nil then
					
					if tonumber(bOpenTab.vipLimit) == 0 then
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1643,nil,"国战",tonumber(bOpenTab.level))
						pTips = nil
						nOpenCallBack( 2 )
					else
						nOpenCallBack( 1 )
					end
					
				end

			else
				if nCityID ~= nil then
					CountryWarScene.SetNewCity(nCityID)
				end
				local actionLeave= CCArray:create()
				if CommonData.g_CountryWarLayer:isVisible() == false then
					--actionLeave:addObject(CCMoveBy:create(0.1,ccp(10000,0)))
					CommonData.g_CountryWarLayer:setPositionX(0)
				end
				if nCallBack ~= nil then
					CountryWarScene.SetComeInCallBack(nCallBack)
				end
				actionLeave:addObject(CCCallFunc:create(CountryWarScene.OpenCountryWarLayer))
				CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
				print("军团场景有国战层，直接进入")
				m_isClickCountryWar = true

				if nOpenCallBack ~= nil then
					
					if tonumber(bOpenTab.vipLimit) == 0 then
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1643,nil,"国战",tonumber(bOpenTab.level))
						pTips = nil
						nOpenCallBack( 2 )
					else
						nOpenCallBack( 1 )
					end
					
				end

			end
		elseif nResult == 2 then
			--等级不足
			if tonumber(bVipTab.vipLimit) == 0 then
				TipLayer.createTimeLayer(bOpenTab.level.."级开启国战", 2)
			end
			m_isClickCountryWar = false
		elseif nResult == 3 then
			TipLayer.createTimeLayer("国战服未开启", 2)
			m_isClickCountryWar = false
		end
	end
	--发送协议判断是否可以进入国战
	NetWorkLoadingLayer.loadingShow(true)
	Packet_CountryWarLoadFinish.SetSuccessCallBack(OpenCWar)
	network.NetWorkEvent(Packet_CountryWarLoadFinish.CreatPacket(1))	


end	



local function _Click_World_CallBack( sender, eventType )
	if eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.moved then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.ended then
		sender:setScale(1.0)
		--国战
		-- CleanCorpsTopLayer()
		AudioUtil.PlayBtnClick()
		if m_isClickCountryWar == false then
			ShowHideCoinBar(false)
			OpenCountryWarMap()
		end
	end
end
local function _Click_Reward_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		AudioUtil.PlayBtnClick()
		require "Script/Main/CountryReward/CountryRewardLayer"
		CountryRewardLayer.createRewardLayer(m_pSceneCorpsLayer)
	elseif eventType == TouchEventType.began then
		sender:setScale(0.9)
	end
end

local function AddButton( m_pCorpsLayer )
	local btn_reward = tolua.cast(m_pCorpsLayer:getWidgetByName("Button_reward"),"Button")
	require "Script/serverDB/server_RewardDB"
	-- local is_reward = server_RewardDB.JudgeIsOpen()
	local is_reward = false
	if is_reward == false then
		btn_reward:setVisible(false)
		btn_reward:setTouchEnabled(false)
	else
		btn_reward:setVisible(true)
		btn_reward:setTouchEnabled(true)
		btn_reward:addTouchEventListener(_Click_Reward_CallBack)
	end


end

function CorpsPushLayer( control )
	local scenetemp = CCDirector:sharedDirector():getRunningScene()
	local child = scenetemp:getChildByTag(control:getTag())
	
	if m_staLayerStack.m_endIndex~= 0  then
		local lastChild = m_staLayerStack:GetLastStack().child
		lastChild:retain()
		lastChild:removeFromParentAndCleanup(true)
	end
	local tableChild = {}
	tableChild.child = child
	m_staLayerStack:PushStack(tableChild)
end

function CorpsPopLayer( nGuide )
	local objext = m_staLayerStack:PopStack()
	local tableChild = m_staLayerStack:GetLastStack()
	local sceneNow = CCDirector:sharedDirector():getRunningScene()
	local layerTemp = nil
	if tableChild ~= nil then layerTemp = tableChild.child end
	if layerTemp ~= nil then
		sceneNow:addChild(layerTemp,layerTemp:getTag(),layerTemp:getTag())
		layerTemp:release()
	end
end

local function upDateCheckOpen(  )
	local m_p_Middle = pBackScene:getChildByTag(12000)
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14026)
	local pShopAniNodeF 	= tolua.cast(nNode:getComponent("CCArmature"),"CCComRender")
	local pShopAniNode 		= tolua.cast(pShopAniNodeF:getNode(),"CCArmature")
	CCArmatureSharder(pShopAniNode, SharderKey.E_SharderKey_SpriteGray)
end

function loadPacket(  )
	local tab = globedefine.getDataById("Legio_JuanXian")
	local globNum = tonumber(tab[4])
	if pBackScene == nil then
		return
	end
	local function DonateSuccessCallBack(  )
		tablePointDa = GetScienceDonate()
		local d_valueNum = globNum - tonumber(tablePointDa["nMoneyType"])
		if d_valueNum >= 1 then
			local m_p_Middle = pBackScene:getChildByTag(12000)
			local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14020)
			if nNode:getChildByTag(4) == nil then
				m_PointManger:ShowRedPoint(4,nNode,135,105)
			end
		end
	end
	Packet_CorpsScienceUpDate.SetSuccessCallBack1(DonateSuccessCallBack)
	network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(5))
end

function upDateHallPoint(  )
	local tab = globedefine.getDataById("Legio_JuanXian")
	local globNum = tonumber(tab[4])
	if pBackScene == nil then
		return
	end
	local function HallSuccessCallBack(  )
		local tabHallDB = GetScienceHall()
		if tonumber(tabHallDB["nMoneyType"]) == 0 then
			local m_p_Middle = pBackScene:getChildByTag(12000)
			local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14027)
			if nNode:getChildByTag(11) == nil then
				m_PointManger:ShowRedPoint(11,nNode,125,105)
			end
		end
	end
	Packet_CorpsScienceUpDate.SetSuccessCallBack2(HallSuccessCallBack)
	network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(4))
end

local function upDatePointTree(  )
	local m_p_Middle = pBackScene:getChildByTag(12000)
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14017)
	m_PointManger:ShowRedPoint(1,nNode,160,85)
end

local function upDatePointPrison(  )
	require "Script/serverDB/server_GetPrisonBoxInfo"
	local function GetSuccessBoxFull(  )
		local box_num = server_GetPrisonBoxInfo.GetBoxNum()
		
		local function openPrison(  )
			local is_true = CheckPrisonGrid()
			if m_pSceneCorpsLayer == nil then
				return
			end
			if tonumber(box_num) >= 1 or is_true == true then
				local m_p_Middle = pBackScene:getChildByTag(12000)
				local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14018)
				if nNode:getChildByTag(2) == nil then
					m_PointManger:ShowRedPoint(2,nNode,98,45)
				end
			end
		end
		Packet_GetPrisonGridInfo.SetSuccessCallBack(openPrison)
		network.NetWorkEvent(Packet_GetPrisonGridInfo.CreatePacket())
	end
	Packet_GetPrisonBoxRewardInfo.SetSuccessCallBack(GetSuccessBoxFull)
	network.NetWorkEvent(Packet_GetPrisonBoxRewardInfo.CreatePacket())
	
end

local function upDatePointHall(  )
	local m_p_Middle = pBackScene:getChildByTag(12000)
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14027)
	m_PointManger:ShowRedPoint(11,nNode,120,110)
end

function upDatePointMercenary(  )
	require "Script/serverDB/server_MercenaryInfoDB"
	
	local function GetSuccessCallback(  )
		local tabDB =server_MercenaryInfoDB.GetCopyTable()
		if CheckMerStatus(tabDB) == true then
			if m_pSceneCorpsLayer == nil then
				return 
			end
			local m_p_Middle = pBackScene:getChildByTag(12000)
			local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14021)
			
			if nNode:getChildByTag(5) == nil then
				m_PointManger:ShowRedPoint(5,nNode,195,130)
			end
		end
	end
	Packet_CorpsYetMercenary.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsYetMercenary.CreatePacket())
end

function SetRedPointMission(  )
	require "Script/Main/MissionNormal/MissionNormalData"
	local s_status = MissionNormalData.GetPromptState(3)
	local s_statusWar = MissionNormalData.GetPromptState(4)
	local s_statusSpecial = MissionNormalData.GetPromptState(5)
	local s_statusSpecial2 = MissionNormalData.GetPromptState(6)
	if m_pSceneCorpsLayer == nil then
		return 
	end
	local m_p_Middle = pBackScene:getChildByTag(12000)
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14024)
	
	if s_status == true or s_statusWar == true or s_statusSpecial == true or s_statusSpecial2 == true then
		if nNode:getChildByTag(8) == nil then
			m_PointManger:ShowRedPoint(8,nNode,130,100)
		end
	else
		if nNode:getChildByTag(8) ~= nil then
			nNode:getChildByTag(8):removeFromParentAndCleanup(true)
		end
	end
end

function upDatePointSpirit(  )
	require "Script/serverDB/server_AniPerstigeDB"
	
	local function GetSpiriteCallBack(  )
		local tabDB =server_AniPerstigeDB.GetCopyTable()
		if CheckSpiritStatus(tabDB) == true then
			if m_pSceneCorpsLayer == nil then
				return
			end
			local m_p_Middle = pBackScene:getChildByTag(12000)
			if m_p_Middle == nil then
				return
			end
			local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(14023)
			if nNode:getChildByTag(7) == nil then
				m_PointManger:ShowRedPoint(7,nNode,120,135)
			end
		end
	end
	Packet_AniGetPerstige.SetSuccessCallBack(GetSpiriteCallBack)
	network.NetWorkEvent(Packet_AniGetPerstige.CreatePacket())
end

function DeleteRedPoint( nTag )
	-- m_PointManger:DeleteRedPoint(nTag)
	local n_index = GetIndexByTag(nTag)
	if m_pSceneCorpsLayer == nil then
		return
	end
	local m_p_Middle = pBackScene:getChildByTag(12000)
	local nNode = m_p_Middle:getChildByTag(10005):getChildByTag(n_index)
	if nNode:getChildByTag(nTag) ~= nil then
		nNode:getChildByTag(nTag):removeFromParentAndCleanup(true)
	end
end

function CreateCorpsScene()
	InitVars()  
	m_pSceneCorps = CCScene:create()
	local m_nHanderTime = nil

	local function NetUpdata(dt)
		UpNetWork()
	end	

	local function SceneEvent(tag)
		if tag == "enter" then	
			Scence_OnBegin()
			UpdataCorpsInfo()
			m_nHanderTime  = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(NetUpdata, CommonData.g_nNetUpdataTime, false)

			--国战场景检测
			if CommonData.g_CountryWarLayer ~= nil then

				if CountryWarScene.GetLevelSceneFromCountryWar() == true then
					--是从国战层离开的
					local function callFunc(  )	
						CountryWarScene.SetMapToLeavePt()
					end 
					local actionLeave= CCArray:create()
					actionLeave:addObject(CCCallFunc:create(callFunc))
					CommonData.g_CountryWarLayer:runAction(CCSequence:create(actionLeave))
				end
			else
				print("国战层还未在军团场景创建")
			end

			
		end

		if tag == "enterTransitionFinish" then
			MainScene.SetCurParent(false)	
			UpdateCoutryState(m_CountryID)
			--UpdateGodTreeState()
			local ScienceID = 1
			local function JudgeTree()
				tableTreeDB = GetScienceUpDate()
				
				if next(tableTreeDB) == nil then
					return 
				end
				UpdateGodTreeState(tableTreeDB)					
			end
			Packet_CorpsScienceUpDate.SetSuccessCallBack(JudgeTree)
			network.NetWorkEvent(Packet_CorpsScienceUpDate.CreatePacket(ScienceID))

			--进入场景时候判断国战层是否存在，如果存在则直接挂接到本场景。
			local function JudgeParent_ByCorps( )
				print("进入军团场景，国战层存在，更换其到军团场景")
				local nParent = CountryWarScene.GetCurParent()
				if nParent == 1 then
					--现在的国战父节点是自己,什么都不用做
					print("nothing todo by corps")
				elseif nParent == 0 or nParent == 2 then
					--不是自己进行摘挂
					print("change my parent by corps")
					CountryWarScene.ChangeCurParentNode(m_pSceneCorps, 1)
				end	
			end
			if CommonData.g_CountryWarLayer ~= nil then
				JudgeParent_ByCorps()			--判断父节点
			end
			ChatShowLayer.ShowChatlayer(m_pSceneCorpsLayer)
		end	

		if tag == "exit" then	
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_nHanderTime)
			MainScene.SetCurParent(true)
		end	

		if tag == "exitTransitionStart" then		
		end	

		if tag == "cleanup" then		
		end	
	end
	m_pSceneCorps:registerScriptHandler(SceneEvent)
	InitData()
	--添加背景层
	m_pSceneCorpsLayer = TouchGroup:create()									-- 背景层
    m_pSceneCorpsLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsSceneLayer.json") )

    local arrayDate = CCArray:create()
    
    -- arrayDate:addObject(CCCallFunc:create(UpdataCorpsInfo))

	-----------------------------------------------------------------------------------------------------------
	--读取场景
	pBackScene = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_juntuan.json")--Scene_juntuan.json
	m_pSceneCorps:addChild(pBackScene, TAG_SCENE_CORPS, TAG_SCENE_CORPS)
	
	m_pSceneCorps:addChild(m_pSceneCorpsLayer, TAG_LAYER_CORPS, TAG_LAYER_CORPS)
	
	-- ChatShowLayer.ShowChatlayer(m_pSceneCorpsLayer)  
	--ScrollView
	local function onTouchEvent(sender, eventType)
		
		local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
		if isCorps <= 0 then
			if eventType == TouchEventType.ended then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1622,_Btn_Back_CallBack,nil) 
			pTips = nil
			return
			end
		else
			ActionClick(sender, eventType)
		end
        
	end
    local ScrollView_CorpsLayer = tolua.cast(m_pSceneCorpsLayer:getWidgetByName("ScrollView_SceneLayer"), "ScrollView")
    ScrollView_CorpsLayer:addTouchEventListener(onTouchEvent)
	
	m_p_Back = pBackScene:getChildByTag(13000)
	m_p_Middle = pBackScene:getChildByTag(12000)
	m_p_Front = pBackScene:getChildByTag(11000)
	
	local m_nBackCurX = ScrollView_CorpsLayer:getInnerContainer():getPositionX()
	local function settick(sender,eventType)
		if eventType== 4 then
			local inii = sender:getInnerContainer()
			local nX = inii:getPositionX()
			local posX = nX - m_nBackCurX
			if inii ~= nil then
				
				if nX ~= m_nBackCurX then
					m_p_Back:setPosition(ccp(m_p_Back:getPositionX()+posX*0.5, 0))
					m_p_Middle:setPosition(ccp(m_p_Middle:getPositionX()+posX, 0))
					m_p_Front:setPosition(ccp(m_p_Front:getPositionX()+posX*1.5, 0))
					m_nBackCurX = nX
				end
			end
		end
	end
	ScrollView_CorpsLayer:addEventListenerScrollView(settick)
	
	SetPanelPosition(m_pSceneCorpsLayer)

	AddButton(m_pSceneCorpsLayer)

	m_PointManger = AddPoint.CreateAddPoint()

	local function loadToplayer(  )
		local c_TopLayer = CorpsTopLayer.ShowTopLayer(m_pSceneCorps,tableData,2)
		m_pSceneCorps:addChild(c_TopLayer,115,115)
	end
	arrayDate:addObject(CCCallFunc:create(loadToplayer))
	m_pSceneCorps:runAction(CCSequence:create(arrayDate))
	loadPacket()
	loadScienceLevel()
	upDateCheckOpen()
	upDatePointMercenary()
	upDatePointSpirit()
	upDatePointPrison()
	upDateHallPoint()
	SetRedPointMission()
	

	m_staLayerStack = simulationStl.creatStack_Last()
	
	CCDirector:sharedDirector():pushScene(m_pSceneCorps)
end