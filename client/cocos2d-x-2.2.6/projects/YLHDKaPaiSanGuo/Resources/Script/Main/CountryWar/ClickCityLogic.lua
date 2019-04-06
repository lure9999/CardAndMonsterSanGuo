
--点击城市界面的 逻辑 celina


module("ClickCityLogic", package.seeall)


local GetCityState  = CountryWarData.GetCityState

local GetCityCountry = CountryWarData.GetCityCountry
local GetPlayerCountry = CountryWarData.GetPlayerCountry

--从小到大
function GetActionBG()
	local action1 = CCScaleTo:create(0.1,1.0)
	--local action2 = CCCallFunc:create(fCallBack)
	return action1--CCSequence:createWithTwoActions(action1,action2)
end
--移动加回调
function GetActionBtn(pos,fCallBack)
	local action1 = CCMoveTo:create(0.2,pos)
	local action2 = CCCallFunc:create(fCallBack)
	return CCSequence:createWithTwoActions(action1,action2)
end

--根据武将的数量，以及Index，返回位置
function GetWJPosTabByNum(pImg,num)
	local r = pImg:getContentSize().width*0.5
	local tabPos ={}
	if num ==1 then
		table.insert(tabPos,ccp(0,r-16))
	end
	if num==2 then
		table.insert(tabPos,ccp(-106,82))
		table.insert(tabPos,ccp(108,82))
	end
	if num==3 then
		table.insert(tabPos,ccp(-r+29,38))
		table.insert(tabPos,ccp(0,r-16))
		table.insert(tabPos,ccp(124,38))
	end
	if num==4 then
		table.insert(tabPos,ccp(-r+29,38))
		table.insert(tabPos,ccp(-48,131))
		table.insert(tabPos,ccp(53,131))
		table.insert(tabPos,ccp(124,38))
	end
	return tabPos
	
	
end
--国家的icon的动作
function GetCityAction(fCallBack)
	local action1 = CCScaleTo:create(0.1,1.1)
	local action2 = CCScaleTo:create(0.1,1.0)
	local action3 = CCCallFunc:create(fCallBack)
	local array = CCArray:create()
	array:addObject(action1)
	array:addObject(action2)
	array:addObject(action3)
	return CCSequence:create(array)

end
local function CheckBGuanZhan(nCityID)
	if GetCityState(nCityID)== 0 then
		return false
	end
	return true
end
function ToGuanZhan(nCityID,fCallBack)
	if CheckBGuanZhan(nCityID) == false then
		TipLayer.createTimeLayer("当前激战已结束，不能观战",2)
		return 
	end
	local function GetWarCityInfo(nState)
		NetWorkLoadingLayer.loadingShow(false)
		if tonumber(nState)~= 1 then
			TipLayer.createTimeLayer("当前激战已结束，不能观战",2)
			return 
		end
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_GetCountryWarInfo.SetSuccessCallBack(GetWarCityInfo)
	
	network.NetWorkEvent(Packet_GetCountryWarInfo.CreatPacket(nCityID,1))
	NetWorkLoadingLayer.loadingShow(true)

end

local function StartFogGuanZhan(tabCallBack,nCityID,tabWJ)
	--到观战场景
	tabCallBack.guanzhan(false,nil,nCityID)
	if AtkCityScene.GetAtkCityScene()== nil then
		print("迷雾观战")
		--[[printTab(tabWJ)
		Pause()]]--
		AddLabelImg(AtkCityScene.CreateAtkCity(tabCallBack,nCityID,2,tabWJ),layerAtkWar_Tag,CountryWarScene.GetCountryMapPanel())
	end
end
--转换为武将的数据
local function GetWJFog(tabW)
	local tabWJ = {}
	for key,value in pairs(tabW) do 
		local tab = {}
		tab.Type = value[1]
		tab.itemID = CountryWarData.GetTeamRes(tonumber(value[1]))
		tab.level = CountryWarData.GetTeamLevel(tonumber(value[1]))
		table.insert(tabWJ,tab)
	end
	
	return tabWJ
end
--迷雾观战
function ToFogGuanZhan(nCityID,nFogIndex,tabWJ,tabCallBack)
	print("ToFogGuanZhan")
	
	local function GetFogCityInfo(nState)
		NetWorkLoadingLayer.loadingShow(false)
		if tonumber(nState)~= 1 then
			TipLayer.createTimeLayer("当前激战已结束，不能观战",2)
			return 
		end
		
		local tabFog = Packet_GetFogWarTeam.GetWJFogData()
		if tabFog~=nil then
			StartFogGuanZhan(tabCallBack,nCityID,GetWJFog(tabFog))
		else
			local function GetFogDataOK()
				local tabWJFog = Packet_GetFogWarTeam.GetWJFogData()
				
				if tabWJFog~=nil then
					CountryWarScene.GetCountryMapPanel():stopAllActions()
					--去观战
					StartFogGuanZhan(tabCallBack,nCityID,GetWJFog(tabWJFog))
				end
			end
			local actionArray = CCArray:create()
			actionArray:addObject(CCDelayTime:create(0.1))
			actionArray:addObject(CCCallFunc:create(GetFogDataOK))
			CountryWarScene.GetCountryMapPanel():runAction( CCSequence:create(actionArray) )
		end
	end
	Packet_GetCountryWarInfo.SetSuccessCallBack(GetFogCityInfo)
	network.NetWorkEvent(Packet_GetCountryWarInfo.CreatPacket(nFogIndex,2))
	NetWorkLoadingLayer.loadingShow(true)
end

function SetBtnState(btn,bState)
	btn:setVisible(bState)
	btn:setTouchEnabled(bState)
end

--去请求可突进撤退的列队信息
function ToGetWarTCList(nType,tabTCData,fCallBack)		
	local tabTypeData = {}
	for key,value in pairs(tabTCData) do 
		table.insert(tabTypeData,value.Type-1)
	end
	local function GetDataOK()
		NetWorkLoadingLayer.loadingShow(false)
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_GetWarTCList.SetSuccessCallBack(GetDataOK)
	network.NetWorkEvent(Packet_GetWarTCList.CreatPacket(nType,tabTypeData))
	NetWorkLoadingLayer.loadingShow(true)
end

function GetSelf(nCityTag)
	local nPlayerCity  = GetPlayerCountry()
	local nNowCity  = GetCityCountry(nCityTag)
	if tonumber(nPlayerCity)~= tonumber(nNowCity) then
		return 0
	end
	return 1
end
