--夺宝逻辑celina

module("DobkLogic", package.seeall)

require "Script/Main/Dobk/DobkSelectLayer"
require "Script/Main/Item/GetGoodsLayer"
require "Script/Main/Item/ItemData"

--数据
local GetItemCount = DobkData.GetItemCount
local GetItemNeedCount = DobkData.GetItemNeedCount
local GetResID         = CreateRoleData.GetResID
local GetBoxTabData    = DobkData.GetBoxTabData
local GetItemGridByID  = DobkData.GetItemGridByID
local GetCurEquipNum   = DobkData.GetCurEquipNum
local GetTabSPData = DobkData.GetTabSPData
local GetExpendNL = DobkData.GetExpendNL
local GetPlayerNaili = DobkData.GetPlayerNaili

local BagItemIsFull  = ItemData.BagItemIsFull
local BagEquipIsFull = ItemData.BagEquipIsFull
local BagWJIsFull = ItemData.BagWJIsFull

function CheckBDobk(nTempID,nType)
	local nCurNum = GetItemCount(nTempID,nType)
	local nTotalNum = GetItemNeedCount(nTempID)
	if tonumber(nCurNum) >= tonumber(nTotalNum) then
		return false
	end
	return true
end

--夺宝增加检测背包是否已满
local function CheckBBagIsFull()
	if ( BagEquipIsFull()== true ) or ( BagItemIsFull()== true ) then
		return false
	end
	return true
end
--开箱子需要增加武将的判断
function CheckBOpenBox()
	if CheckBBagIsFull()== false or BagWJIsFull()== true then
		return false
	end
	return true
end
--参数说明，fCallBack--得到数据 以后的回调函数
function ToDobkSelect(nTempID,fCallBack)
	if CheckBBagIsFull() == false then
		TipLayer.createTimeLayer("您的背包已满", 2)
		return
	end
	local function GetDobkResult()
		NetWorkLoadingLayer.loadingShow(false)
		--到选择对手界面
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_DobkEnemy.SetSuccessCallBack(GetDobkResult)
	network.NetWorkEvent(Packet_DobkEnemy.CreatPacket(DOBK_TYPE.DOBK_TYPE_SW,nTempID))
	NetWorkLoadingLayer.loadingShow(true)
	
end

function GetResultDobk(eID,fCallBack,nTimes)
	--fCallBack()
	local function GetDobkResult()
		--NetWorkLoadingLayer.loadingShow(false)
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_GetDobkResult.SetSuccessCallBack(GetDobkResult)
	network.NetWorkEvent(Packet_GetDobkResult.CreatPacket(DOBK_TYPE.DOBK_TYPE_SW,DobkLayer.GetSelectSpID(),nTimes,eID))
	--NetWorkLoadingLayer.loadingShow(true)
end

function AddImageAction(nID,nTag,pos,mLayer,bFlix,fCallBack,nType)
	if nID== nil then
		nID = 6015
	end
	--local pObject = UIInterface.GetAnimateByIDAnimation(GetResID(nID),Ani_Def_Key.Ani_attack)
	local pObject = UIInterface.GetAnimateByIDAnimation(GetResID(nID),nType)
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if fCallBack~=nil then
				fCallBack()
			end
		end
	end
	pObject:getAnimation():setMovementEventCallFunc(onMovementEvent)
				
	pObject:setPosition(pos)
	
	if bFlix == true then
		pObject:setScaleX(-1.6)
		pObject:setScaleY(1.6)
	else
		pObject:setScale(1.6)
	end
	if mLayer:getNodeByTag(nTag)~=nil then
		mLayer:removeNodeByTag(nTag)
	end
	
	mLayer:addNode(pObject,nTag,nTag)
	return pObject:getAnimation()
end

function GetBWin()
	if tonumber(server_dobkResultData.GetDobkResult(1)) == 0 then
		return false
	end
	return true
end

function CheckBEnoughByItemID(nTempID,nType)
	return not CheckBDobk(nTempID,nType)
end
local function ToGoodsLayer()
	
	local tabNew = {}
	for key,value in pairs(GetBoxTabData()) do 
		local tableN ={}
		tableN[1] = value.itemID
		tableN[2] = value.count
		table.insert(tabNew,tableN)
	end
	GetGoodsLayer.createGetGoods(tabNew,nil)
end
function ToGetGoods(mType,fCallBack)
	local function GetGoods()
		NetWorkLoadingLayer.loadingShow(false)
		GetDobkLayerData(mType,fCallBack)
		ToGoodsLayer()
	end
	Packet_OpenDobkBox.SetSuccessCallBack(GetGoods)
	network.NetWorkEvent(Packet_OpenDobkBox.CreatPacket())	
	NetWorkLoadingLayer.loadingShow(true)
end
function GetDobkSPDataByType(nType)
	return GetTabSPData(nType)
end

function GetDobkLayerData(nType,fCallBack)
	local function GetDataOver()
		NetWorkLoadingLayer.loadingShow(false)
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_DobkInfo.SetSuccessCallBack(GetDataOver)
	network.NetWorkEvent(Packet_DobkInfo.CreatPacket(nType))
	NetWorkLoadingLayer.loadingShow(true)
end
local function CheckBCanHC()
	if GetCurEquipNum()>= 240 then
		return false
	end
	return true
end

function ToSPHC(nType,nTempID,fCallBack)
	if CheckBCanHC() == false then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(503,nil)
		--TipCommonLayer.CreateTipsLayer(503,TIPS_TYPE.TIPS_TYPE_EQUIP,nil,nil,nil)
		pTips = nil
		return 
	end
	local function useOver()
		NetWorkLoadingLayer.loadingHideNow()
		--合成完了以后需要重新刷新列表
		GetDobkLayerData(nType,fCallBack)
		
	end
	Packet_UseItem.SetSuccessCallBack(useOver)
	--[[print(nTempID)
	print(GetItemGridByID(nTempID))
	Pause()]]--
	network.NetWorkEvent(Packet_UseItem.CreatPacket(GetItemGridByID(nTempID), 1,  nTempID))
	NetWorkLoadingLayer.loadingShow(true)
end

--得到还差几个可以合成
function GetNeedSpNum(nTempID,nType)
	local nCurNum = tonumber(GetItemCount(nTempID,nType))
	local nTotalNum = tonumber(GetItemNeedCount(nTempID))
	return nTotalNum-nCurNum
end

function GetItemAction()
	--local action1 = CCMoveTo:create(0.2,pos)
	--local action2 = CCDelayTime:create(0.2)
	local action1 = CCScaleTo:create(0.1,0.8)
	local action2 = CCScaleTo:create(0.1,0.68)
	local array = CCArray:create()
	array:addObject(action1)
	array:addObject(action2)
	return CCSequence:create(array)
end
function GetTitleAction(fCallBack)
	local action1 = CCScaleTo:create(0.1,1.2)
	local action2 = CCScaleTo:create(0.1,1.0)
	local action3 = CCCallFunc:create(fCallBack)
	local array = CCArray:create()
	array:addObject(action1)
	array:addObject(action2)
	array:addObject(action3)
	return CCSequence:create(array)
end
function GetLabelAction(fCallBack)
	local action1 = CCDelayTime:create(0.001)
	local action2 = CCCallFuncN:create(fCallBack)
	local array = CCArray:create()
	array:addObject(action1)
	array:addObject(action2)
	return CCRepeatForever:create(CCSequence:create(array))
end
--得到第几个
function GetItemNum(nItemID,nType,tabData)
	
	for key,value in pairs(tabData) do 
		print(value.itemID)
		if tonumber(value.itemID) == tonumber(nItemID) then
			return key
		end
	end
	return 0
end

function CheckNaiLi(nNum)
	if GetPlayerNaili()<(tonumber(GetExpendNL())*nNum) then
		return false
	end
	return true
end

function CheckDobkOpen()
	local tabDobk = MainScene.CheckVIPFunction(enumVIPFunction.eVipFunction_28)
	if tabDobk~=nil then
		if tonumber(tabDobk.vipLimit) == 0 then
			return false
		end
	end
	return true
end