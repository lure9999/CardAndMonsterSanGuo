--比武界面逻辑 celina


module("CompetitionLogic", package.seeall)



--数据
local GetArenaTable = CompetitionData.GetArenaTable
local GetKeyArenaByStr  = CompetitionData.GetKeyArenaByStr
local GetBWConsumeID = CompetitionData.GetBWConsumeID
local GetEndTimeVS  = CompetitionData.GetEndTimeVS

local GetAnimationFileName = CreateRoleData.GetRoleAnimationFileName
local GetAnimationName     = CreateRoleData.GetRoleAnimationName
local GetID                = CreateRoleData.GetResID



local curShowTime = 0
local curExitUITime = 0
local function GetNumByStr(strUse)
	local rankID = string.sub(strUse,string.find(strUse,"_")+1,string.len(strUse))
	
	return tonumber(rankID)
end
--根据名次获得排名表的ID
function GetRankID(nRank)
	local tableArea = GetArenaTable()
	for key,value in pairs(tableArea) do 
		local maxValue = tonumber(value[GetKeyArenaByStr("RankMin")])
		local minValue = tonumber(value[GetKeyArenaByStr("RankMax")])
		
		if maxValue == -1 then
			if nRank>=minValue then
				return GetNumByStr(key)
			end
		else
			if nRank>=minValue and nRank<=maxValue then
				return GetNumByStr(key)
			end
		end
		
	end
	return 0
end
--获得倒计时的动作
function GetActionCountDown(fCallBack)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(1))
	array:addObject(CCCallFunc:create(fCallBack))
	
	local action = CCSequence:create(array)
	return CCRepeatForever:create(action)
end
function DealScenedsToStr(nSceneds)
	
	local nHour = math.floor(nSceneds/60 )
	local nMinute = nSceneds%60
	if nHour<0 then
		nHour = 0
	end
	
	local strTime = nil
	if nMinute<10 then
		strTime = string.format("%d:0%d",nHour,nMinute)
	else
		strTime = string.format("%d:%d",nHour,nMinute)
	end
	
	return strTime
end

function AddAnotherLayer(baseLayer,addLayer,nTag)
	if baseLayer:getChildByTag(nTag)~=nil then
		addLayer:setVisible(false)
		addLayer:removeFromParentAndCleanup(true)
	end
	baseLayer:addChild(addLayer,nTag,nTag)
end





function GetImageActionByID(m_id_role)
	print("m_id_role:"..m_id_role)
	if tonumber(m_id_role) == 0 then
		return 
	end
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(GetAnimationFileName(m_id_role))
	local PayArmature = CCArmature:create(GetAnimationName(m_id_role))
	
    PayArmature:getAnimation():play(GetAniName_Res_ID(GetID(m_id_role), Ani_Def_Key.Ani_stand))

	return PayArmature

end

function GetActionScale(nTempID)
	if server_generalDB.IsMainGeneralByTempID(nTempID) ==  true then
		return 1.3
	elseif tonumber(nTempID) == 6006 then
		--马超
		return 1.2
	else
		return 1.5
	end
	return 0
end
function GetPlayerScale(tempID)
	if server_generalDB.IsMainGeneralByTempID(tempID) ==  true then
		return 1.1
	else
		--[[if tonumber(tempID) == 6006 then
			return 1.1
		else]]--
			return 1.3
		--end
	end
	return 0
end

function AskPlayerData(updateCallBack)
	local function GetCompetitionData()
		NetWorkLoadingLayer.loadingShow(false)
		if updateCallBack~=nil then
			updateCallBack()
		end
	end
	Packet_GetCompetitionData.SetSuccessCallBack(GetCompetitionData)
	network.NetWorkEvent(Packet_GetCompetitionData.CreatPacket())
	NetWorkLoadingLayer.loadingShow(true)

end
function ToPvPScene(pID,nRank)
	local function getOver(pNetStream)
		--print("Packet_GetPvpInfo getOver")	
		NetWorkLoadingLayer.loadingShow(false)
		if pNetStream ~= false then
			require "Script/Fight/BaseScene"
			BaseScene.createBaseScene()
			BaseScene.InitServerPKData(pNetStream)					
			BaseScene.EnterBaseScene()
		end
	end
	Packet_GetPvpInfo.SetSuccessCallBack(getOver)
	network.NetWorkEvent(Packet_GetPvpInfo.CreatPacket(1000, 1,pID,nRank))
	NetWorkLoadingLayer.loadingShow(true)	
end
function GetHoursByScends(nSceneds)
	
	
	--local GetNowTime = os.time()
	--local pastTime = GetNowTime - nSceneds
	local nMin = math.floor(nSceneds/60)
	local nHour = math.floor(nMin/60)
	local nDay =  math.floor(nHour/24)
	local nMonth =  math.floor(nDay/30)
	local nYear = math.floor(nMonth/12)
	if nSceneds<=60 then
		return nSceneds.."秒前"
	end
	if nYear>0 then
		return  nYear.."年前"
	end
	if nMonth>0 then
		return  nMonth.."月前"
	end
	if nDay>0 then
		return nDay.."天前"
	end
	if nHour>0 then
		return  nHour.."小时前"
	end
	if nMin>0 then
		return  nMin.."分钟前"
	end
	
	
end
function ToSeeRecord(nID)
	local function getReordOver(pNetStream)
		NetWorkLoadingLayer.loadingShow(false)
		require "Script/Fight/BaseScene"
		BaseScene.createBaseScene()
		BaseScene.InitServerPKData(pNetStream)					
		BaseScene.EnterBaseScene()
	end
	Packet_GetPerRecordData.SetSuccessCallBack(getReordOver)
	network.NetWorkEvent(Packet_GetPerRecordData.CreatPacket(nID))
	NetWorkLoadingLayer.loadingShow(true)
end
function GetStrChangeRow(str)
	if str == "" or str== nil then
		return str
	end
	local startPos = 1
	
	local tabStr = {}
	local resultStr = ""
	while(true) do
		local c = string.sub(str,startPos,startPos)
		local b = string.byte(c)
		if b>128 then
			table.insert(tabStr,string.sub(str,startPos,startPos+2))
			startPos = startPos +3
		else
			if b==32 then
				print("空格字符")
				table.insert(tabStr," ")
			else
				table.insert(tabStr,c)
			end
			startPos = startPos +1
		end
		if startPos>#str then
			break
		end
		
		
	end
	for key,value in pairs(tabStr) do 
		if value=="." then
			resultStr = resultStr.." "..value.."\n"
		else
			resultStr = resultStr..value.."\n"
		end
		
	end
	return resultStr
end


--[[function SaveExitTime()
	
	CCUserDefault:sharedUserDefault():setStringForKey ("compete_show",tostring(CompetitionUnderLayer.GetTime()))
	
	local newSceneds = os.time()
		
	CCUserDefault:sharedUserDefault():setStringForKey ("exitGameTime",tostring(newSceneds))
end]]--
--[[--记录到本地的话下线的时候才记录
function SaveCompeteTime()
	CompetitionLayer.GetPTimeManager():SaveTime()
end]]--


function GetPastTime(nSceneds)
	--[[local exitGameTime = CCUserDefault:sharedUserDefault():getStringForKey ("exitGameTime")
	local exitShowTime = CCUserDefault:sharedUserDefault():getStringForKey ("compete_show")
	local inGameTime = os.time()
	local pastTime = inGameTime - exitGameTime
	if tonumber(pastTime)>= tonumber(exitShowTime) then
		--说明不用倒计时了
		return 0 
	end
	return ( tonumber(exitShowTime) - tonumber(pastTime) )]]--
	local endTime = GetEndTimeVS()
	--local curTime = os.time()
	--local stayTime = tonumber(endTime)-tonumber(curTime) 
	if nSceneds~= 0 then
		local pasTime = os.time() - nSceneds
		endTime = endTime-pasTime
	end
	if endTime>0 then
		return endTime
	end
	return 0
end
--检测是否到了时间，可以挑战，（时间修改为服务器记录）
function CheckBVS(nTime)
	--[[if CCUserDefault:sharedUserDefault():getStringForKey ("compete_show") == "" then
		--新用户上来没有挑战过
		return true
	end
	if nTime~=nil then
		if GetPastTime(nTime)~=0 then
			--说明还有剩余时间不可以挑战
			return false
		end
	else
		if GetTimeByUserDefault() ~= 0 then
			return false
		end
		
	end
	
	return true]]--
	local pasTime = 0
	local endTime = GetEndTimeVS()
	print("endTime:"..endTime)
	
	if nTime~=0 then
		print("nTime:"..nTime)
		pasTime = os.time() - nTime
		print("pasTime:"..pasTime)
		endTime = endTime-pasTime
		print("endTime:"..endTime)
		print("000000000000000000000000000000")
	end
	
	if endTime<=0 then
		return true
	end
	
	return false
end
--检测挑战的消耗
function CheckBConsume()
	--得到消耗ID 
	return ConsumeLogic.CheckBConsumeByID(GetBWConsumeID())
end

function CheckBiWuOpen()
	local tabDobk = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_27)
	if tabDobk~=nil then
		if tonumber(tabDobk.vipLimit) == 0 then
			return false
		end
	end
	return true
end