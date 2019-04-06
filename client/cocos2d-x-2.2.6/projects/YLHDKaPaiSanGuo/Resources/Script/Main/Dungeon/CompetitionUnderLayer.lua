--比武界面下面部分的信息 celina


module("CompetitionUnderLayer", package.seeall)

require "Script/Main/Dungeon/CompetitionMatrixInfo"

--变量
local nSceneds = 0 
local nExitTime  = 0
local LableTime = nil
local mLayer = nil 
local nTimes = 0
local updateCallBack = nil
local updateCount = 0
--数据
local GetVSTimes = CompetitionData.GetVSTimes
local GetVSTime  = CompetitionData.GetVSTime
local GetPlayerDataByIndex = CompetitionData.GetPlayerDataByIndex
local GetGridGerneral   = CompetitionData.GetGridGerneral
local GetRankByPID = CompetitionData.GetRankByPID
local GetCosumeData = CompetitionData.GetCosumeData
local GetTotalTimes = CompetitionData.GetTotalTimes
local GetRank_layer = CompetitionData.GetRank
--逻辑
local GetActionCountDown = CompetitionLogic.GetActionCountDown
local DealScenedsToStr = CompetitionLogic.DealScenedsToStr
local AskPlayerData    = CompetitionLogic.AskPlayerData
local GetImageActionByID = CompetitionLogic.GetImageActionByID
local GetPlayerScale   = CompetitionLogic.GetPlayerScale
local ToPvPScene       = CompetitionLogic.ToPvPScene
local GetStrChangeRow  = CompetitionLogic.GetStrChangeRow
local CheckBVS         = CompetitionLogic.CheckBVS
local CheckBConsume    = CompetitionLogic.CheckBConsume
--local SaveCompeteTime         = CompetitionLogic.SaveCompeteTime
local GetPastTime      = CompetitionLogic.GetPastTime

--layer
local ToMatrixLayer = CompetitionLogic.AddAnotherLayer
local ShowMatrixInfo  = CompetitionMatrixInfo.ShowMatrixInfo

--更新购买时间的
local function UpdateAddCDTime(nEnable)
	local panel_cd = tolua.cast(mLayer:getWidgetByName("Panel_CD"),"Layout")
	local img_addTime = tolua.cast(mLayer:getWidgetByName("img_add_time"),"ImageView")
	if nEnable == false then
		img_addTime:loadTexture("Image/imgres/common/add_1.png")
		panel_cd:setTouchEnabled(false)
	else
		img_addTime:loadTexture("Image/imgres/common/add_2.png")
		panel_cd:setTouchEnabled(true)
		--Pause()
	end
end
--更新购买次数的
local function UpdateAddTimes(lTimes)
	local panel_times = tolua.cast(mLayer:getWidgetByName("Panel_Times"),"Layout")
	local img_addTimes = tolua.cast(mLayer:getWidgetByName("img_add_times"),"ImageView")
	if tonumber(lTimes) ~= 0 then
		img_addTimes:loadTexture("Image/imgres/common/add_1.png")
		panel_times:setTouchEnabled(false)
	else
		panel_times:setTouchEnabled(true)
		img_addTimes:loadTexture("Image/imgres/common/add_2.png")
	end
end
local function DealToTime()
	LableTime:stopAllActions()
	--[[local PanelCD = tolua.cast(mLayer:getWidgetByName("Panel_CD"),"Layout")
	PanelCD:setVisible(false)]]--
	UpdateAddCDTime(false)
end

local function FlushTime()
	
	nSceneds = nSceneds -1 
	--LabelLayer.setText(LableTime,DealScenedsToStr(nSceneds))
	LableTime:setText(DealScenedsToStr(nSceneds))
	
	if nSceneds <= 0 then
		DealToTime()
	end
end
function GetTime()
	if nSceneds~=nil then
		return nSceneds
	end
	return 0
end
local function ShowVsTime(mPanel,nTime)
	--时间的显示;
	if nTime~=nil then
		nSceneds = nTime
		LableTime:stopAllActions()
		LableTime:setText(DealScenedsToStr(nSceneds))
		if tonumber(nSceneds)~=0 then
			UpdateAddCDTime(true)
		else
			UpdateAddCDTime(false)
		end
		return 
	else
		nSceneds = GetPastTime(nExitTime)
		
	end
	if tonumber(nSceneds)~=0 then
		UpdateAddCDTime(true)
	else
		UpdateAddCDTime(false)
	end
	LableTime = tolua.cast(mLayer:getWidgetByName("Label_time_cd"),"Label")--LabelLayer.createStrokeLabel(18,CommonData.g_FONT1,DealScenedsToStr(nSceneds),ccp(0,4),ccc3(23,5,5),ccc3(255,87,35),true,ccp(0,-2),2)
	LableTime:setText(DealScenedsToStr(nSceneds))
	
	--[[LableTime:setPosition(ccp(98,40))
	AddLabelImg(LableTime,101,mPanel)]]--
	if LableTime~=nil then
		LableTime:stopAllActions()
	end
	LableTime:runAction(GetActionCountDown(FlushTime))
end
local function UpdateVSTimes(nTimes)
	--[[local panel_bg = tolua.cast(mLayer:getWidgetByName("Panel_compete"),"Layout")
	if panel_bg:getChildByTag(100)~=nil then
		LabelLayer.setText(panel_bg:getChildByTag(100),nTimes)
	end]]--
	local labelTimes = tolua.cast(mLayer:getWidgetByName("Label_times_num"),"Label")
	labelTimes:setText(nTimes.."/"..GetTotalTimes())
end


local function _Btn_Challenge_CallBack(nGrid)
	--点击挑战
	--local panel_cd = tolua.cast(mLayer:getWidgetByName("Panel_CD"),"Layout")
	print("点击挑战")
	print("nSceneds:"..nSceneds)
	print("nTimes:"..nTimes)
	if  tonumber(nSceneds)== 0 and tonumber(nTimes)~=0 then
		if CheckBConsume() == true then
			
			CompetitionLayer.SetFlushTime(true)
			--开始计时
			--nSceneds = COMPETITION_TIME
			--SaveCompeteTime()
			--服务器记录的是差值，所以自己暂时记录一下进战斗的时间
			nExitTime = os.time()
			nTimes = nTimes-1
			CompetitionLayer.SetChallengeRank(GetRankByPID(nGrid))
			ToPvPScene(nGrid,GetRankByPID(nGrid))
		else
			TipLayer.createTimeLayer("体力不足",2)
		end
	else
		if nSceneds~=0 then
			TipLayer.createTimeLayer("挑战CD中",2)
		else
			TipLayer.createTimeLayer("挑战次数不足",2)
		end
	end
end
local function _Layout_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		--点击查看阵容
		local nIndex = sender:getTag()-TAG_GRID_ADD
		ToMatrixLayer(mLayer,ShowMatrixInfo(false,nIndex),2000)
	end
end
local function AddImagePlayer(nID,nIndex)
	local LayerRole = tolua.cast(mLayer:getWidgetByName("Panel_"..nIndex),"Layout")
	if LayerRole:getNodeByTag(1)~=nil then
		LayerRole:removeNodeByTag(1)
	end
	LayerRole:setTouchEnabled(true)
	local playerObject = GetImageActionByID(nID)
	playerObject:setPosition(ccp(100,20))
	
	--马超是1.1
	--主角是1.2
	LayerRole:setTag(TAG_GRID_ADD+nIndex)
	LayerRole:addTouchEventListener(_Layout_CallBack)
	playerObject:setScale(GetPlayerScale(nID))
	LayerRole:addNode(playerObject,1,1)
	
end
local function ShowCopetitionPlayer()
	--local panelPlayer = tolua.cast(mLayer:getWidgetByName("Panel_role"),"Layout")
	for i=1,3 do 
		local playerTab = GetPlayerDataByIndex(i)
		
		--排名
		local LableRank = tolua.cast(mLayer:getWidgetByName("Label_rank_"..i),"Label")
		LableRank:setText("排名："..playerTab.pRank)
		--等级
		local LableLevel = tolua.cast(mLayer:getWidgetByName("Label_rank_num_"..i),"Label")
		LableLevel:setText(playerTab.pLevel)
		--战斗力
		local LableFight = tolua.cast(mLayer:getWidgetByName("Label_num_zdl_"..i),"Label")
		LableFight:setText(playerTab.pFight)
		local btn_challenge = tolua.cast(mLayer:getWidgetByName("btn_role_compete_"..i),"Button")
		
		local panelInfo = tolua.cast(mLayer:getWidgetByName("Panel_1"..i),"Layout")
		panelInfo:setTouchEnabled(false)
		--名字playerTab.pName
		
		local label_name = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,GetStrChangeRow(playerTab.pName),ccp(0,4),ccc3(74,34,9),ccc3(255,245,133),true,ccp(0,-2),2)
		--label_name:setDimenSions(CCSize(22,250))
		label_name:setPosition(ccp(24,70))
		AddLabelImg(label_name,100,panelInfo)
		CreateBtnCallBack(btn_challenge,"挑战",24,_Btn_Challenge_CallBack,COLOR_Black,COLOR_White,playerTab.pID,3)
		
		AddImagePlayer(playerTab.pModelID,i)
		
	end
	--[[AddImagePlayer(80011,1)
	AddImagePlayer(6002,2)
	AddImagePlayer(6006,3)]]--
end

local function _Btn_ChangePlyer_CallBack()
	--换一批成员
	AskPlayerData(ShowCopetitionPlayer)
end
local function _Btn_AddTimes_CallBack(sender,eventType)
	--增加挑战次数
	if eventType == TouchEventType.ended then
		--[[print("增加挑战次数")
		TipLayer.createTimeLayer("功能待开发",2)]]--
		local tabVIP = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_15)
		if tonumber(tabVIP.vipLimit) == 0 then
			local function ToVIP()
				MainScene.GoToVIPLayer(1)
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			if tonumber(tabVIP.level) == -1 then
				pTips:ShowCommonTips(1634,ToVIP,tabVIP.vipLevel)
			else
				pTips:ShowCommonTips(1505,ToVIP,tabVIP.level,tabVIP.vipLevel)
			end
			pTips = nil
			return
		else
			--去购买
			local function ToBuy(bBuy)
				if bBuy == true then
					local function BuyOK()
						nTimes = GetTotalTimes()
						UpdateVSTimes(nTimes)
						UpdateAddTimes(nTimes)
					end
					MainScene.BuyCountFunction(enumVIPFunction.eVipFunction_15,nil,nil,BuyOK)
				end
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1508,ToBuy,tabVIP.NeedNum)
			pTips = nil
		end
	end
end
local function _Btn_AddVSTime_CallBack(sender,eventType)
	--增加挑战时间
	if eventType == TouchEventType.ended then
		--print("增加挑战时间")
		local tabVIPTime = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_19)
		if tonumber(tabVIPTime.vipLimit) == 0 then
			local function ToVIP()
				MainScene.GoToVIPLayer(1)
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			if tonumber(tabVIPTime.level) == -1 then
				pTips:ShowCommonTips(1634,ToVIP,tabVIPTime.vipLevel)
			else
				pTips:ShowCommonTips(1505,ToVIP,tabVIPTime.level,tabVIPTime.vipLevel)
			end
			pTips = nil
			return
		else
			--去购买
			local function ToBuy(bBuy)
				if bBuy == true then
					--TipLayer.createTimeLayer("服务器购买没开发",2)
					local function BuyOK()
						--nExitTime = 0 
						CompetitionLayer.SetFlushTime(false)
						local panel_cd = tolua.cast(mLayer:getWidgetByName("Panel_CD"),"Layout")
						ShowVsTime(panel_cd,0)
					end
					MainScene.BuyCountFunction(enumVIPFunction.eVipFunction_19,nil,nil,BuyOK)
				end
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1509,ToBuy,tabVIPTime.NeedNum)
			pTips = nil
		end
	end
end
function UpdateUnderLayer(bClear)
	local panel_cd = tolua.cast(mLayer:getWidgetByName("Panel_CD"),"Layout")
	if CompetitionLayer.GetFlushTime() == true then
		
		updateCount = updateCount +1
		if updateCount == 2 then
			--nTimes = nTimes-1
			updateCount = 0
		end
		UpdateVSTimes(nTimes)
		UpdateAddTimes(nTimes)
		if CheckBVS(nExitTime) == true then
			--panel_cd:setVisible(false)
			--print("1=====")
			--Pause()
			UpdateAddCDTime(false)
		else
			--panel_cd:setVisible(true)  
			--print("2=====")
			--Pause()
			UpdateAddCDTime(true)
			ShowVsTime(panel_cd)
			CCUserDefault:sharedUserDefault():setIntegerForKey("time_now",0)
		end
	end
	
	ShowCopetitionPlayer()
	--[[if tonumber(GetRank_layer()) == tonumber(CompetitionLayer.GetChallengeRank()) then
		--排名提示1647
		CompetitionLayer.SetChallengeRank(0)
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1647,nil,tonumber(GetRank_layer()))
		pTips = nil
	end]]--
	
end
local function InitUI(pLayer)
	local img_consume = tolua.cast(pLayer:getWidgetByName("img_consume"),"ImageView")
	local tabData = GetCosumeData()
	local tabConsume = tabData.TabData 
	img_consume:loadTexture(tabConsume[1].IconPath)
	local label_consume_num = tolua.cast(pLayer:getWidgetByName("Label_consume"),"Label")
	label_consume_num:setText("X"..tabConsume[1].ItemNeedNum)
end
function CompetitionUnderInfo(pLayer,infoCallBack,m_pTimeManager)
	mLayer = pLayer
	updateCallBack = infoCallBack
	nExitTime = 0
	--local panel_bg = tolua.cast(pLayer:getWidgetByName("Panel_compete"),"Layout")
	updateCount = 0
	InitUI(pLayer)
	nTimes = GetVSTimes()
	local labelTimes = tolua.cast(pLayer:getWidgetByName("Label_times_num"),"Label")
	labelTimes:setText(nTimes.."/"..GetTotalTimes())
	--倒计时
	local panel_cd = tolua.cast(pLayer:getWidgetByName("Panel_CD"),"Layout")
	panel_cd:setTouchEnabled(true)
	panel_cd:addTouchEventListener(_Btn_AddVSTime_CallBack)
	--次数
	local panel_times = tolua.cast(pLayer:getWidgetByName("Panel_Times"),"Layout")
	panel_times:setTouchEnabled(true)
	panel_times:addTouchEventListener(_Btn_AddTimes_CallBack)
	UpdateAddTimes(nTimes)
	--[[local lableTimes = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,GetVSTimes(),ccp(0,4),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
	lableTimes:setPosition(ccp(100,242))]]--
	--增加挑战次数
	--[[local btn_add_vsTimes = tolua.cast(pLayer:getWidgetByName("btn_add_times"),"Button")
	CreateBtnCallBack(btn_add_vsTimes,nil,nil,_Btn_AddTimes_CallBack,nil,nil,nil,nil)]]--
	
	--增加挑战时间
	--[[local btn_add_vsTime = tolua.cast(pLayer:getWidgetByName("btn_add_cd"),"Button")
	CreateBtnCallBack(btn_add_vsTime,nil,nil,_Btn_AddVSTime_CallBack,nil,nil,nil,nil)]]--
	
	--AddLabelImg(lableTimes,100,panel_bg)
	
	
	--if CCUserDefault:sharedUserDefault():getStringForKey("compete_show") == "" then
	--	panel_cd:setVisible(false)
	--else
		print("1========================")
		if CheckBVS(nExitTime) == true then
			--panel_cd:setVisible(false)
			nSceneds = 0
			UpdateAddCDTime(false)
		else
			--panel_cd:setVisible(true)  
			UpdateAddCDTime(true)
			print("调用2")
			ShowVsTime(panel_cd)
		end
	--end
	
	
	
	ShowCopetitionPlayer()
	--换一批
	local btn_changePlayer = tolua.cast(pLayer:getWidgetByName("btn_change"),"Button")
	CreateBtnCallBack(btn_changePlayer,"换一批",24,_Btn_ChangePlyer_CallBack,COLOR_Black,COLOR_White,true,3)
end


