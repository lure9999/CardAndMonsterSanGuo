--攻城战的场景逻辑 celina


module("AtkCitySceneLogic", package.seeall)
require "Script/Main/CountryWar/AtkCityArmyInfoLayer"

--数据
local GetResID         = CreateRoleData.GetResID

--local GetMyTeamBlood = AtkCityData.GetMyTeamBlood
--local GetOtherTeamBlood = AtkCityData.GetOtherTeamBlood
local GetWarTime = AtkCityData.GetWarTime
--界面
local CreateArmyInfoLayer = AtkCityArmyInfoLayer.CreateArmyInfoLayer
function CheckBHaveBtn(nType)
	--如果是迷雾的话，没有btn
	if tonumber(nType) == 2 then
		return false
	end
	return true
end

function GetWarListPlayer(strState,fCallBack)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan01_ren/Scene_guozhan01_ren.ExportJson")
	local PayArmature = CCArmature:create("Scene_guozhan01_ren")
	
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if fCallBack~= nil then
				fCallBack()
			end
		end
	end
	PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
    PayArmature:getAnimation():play(strState)

	return PayArmature
end

--添加人物的动作
function AddWarAction(nID,nTag,pos,mLayer,bFlix,fCallBack,nType)
	if nID== nil then
		nID = 6015
	end
	local pObject = UIInterface.GetAnimateByIDAnimation(GetResID(nID),nType)
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			if fCallBack~=nil then
				fCallBack()
			end
		end
		if nType == Ani_Def_Key.Ani_cheers then
			if movementType == 2 then
				if fCallBack~=nil then
					fCallBack()
				end
			end
		end
		
	end
	pObject:getAnimation():setMovementEventCallFunc(onMovementEvent)
				
	pObject:setPosition(pos)
	
	if bFlix == true then
		pObject:setScaleX(-1.0)
		pObject:setScaleY(1.0)
	else
		pObject:setScale(1.0)
	end
	if mLayer:getNodeByTag(nTag)~=nil then
		mLayer:removeNodeByTag(nTag)
	end
	
	mLayer:addNode(pObject,nTag,nTag)
	return pObject:getAnimation()
end
function GetCountryImgPathByName(strCountryName)
	--[[local pathBase = "Image/imgres/common/country/"
	if strCountryName == "魏" then
		return pathBase.."country_1.png"
	end
	if strCountryName == "蜀" then
		return pathBase.."country_2.png"
	end
	if strCountryName == "吴" then
		return pathBase.."country_3.png"
	end
	if strCountryName == "群" then
		return pathBase.."country_4.png"
	end]]--
	if tonumber(strCountryName) >=5 and tonumber(strCountryName)~=8 then
		strCountryName = 5 
	end
	return "Image/imgres/common/country/country_"..strCountryName..".png"
end
function GetTimeOneAction(nTime,fCallBack)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(nTime))
	array:addObject(CCCallFunc:create(fCallBack))
	
	local action = CCSequence:create(array)
	return action
end
function GetTimeAction(nTime,fCallBack)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(nTime))
	array:addObject(CCCallFunc:create(fCallBack))
	
	local action = CCSequence:create(array)
	return CCRepeatForever:create(action)
end

--[[function GetMyResult()
	GetMyResult
	return math.random(0,1)
end]]--

local function GetWarData(nWarType,nType,nPage,fCallBack)
	local function GetOK()
		NetWorkLoadingLayer.loadingShow(false)
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_GetWarList.SetSuccessCallBack(GetOK)
	network.NetWorkEvent(Packet_GetWarList.CreatPacket(nWarType,nType,nPage))
	NetWorkLoadingLayer.loadingShow(true)
end
--请求军队列表信息nType1表示是攻方的，2表示是守方的
function ToShowArmyInfo(nType,pParent,nWarType)
	--直接取当前服务器推送的信息 2016年1.4修改为主动向服务器获取
	local function GetWarListOver()
		NetWorkLoadingLayer.loadingShow(false)
		AddLabelImg(CreateArmyInfoLayer(nType,nWarType),200,pParent)
	end
	GetWarData(nWarType,nType,1,GetWarListOver)
end

function CheckBAtk(myNum,otherNum,isBWin)
	if isBWin == true then
		--攻方胜利，判断 守方是否还有人
		if otherNum<1 then
			return false
		end
		return true
	end
	if isBWin == false then
		--守方胜利，判断攻方是否还有人
		if myNum<1 then
			return false
		end
		return true
	end
	return true
end

function GetBloodTimes()
	local statyTime = tonumber(GetWarTime())-2
	if statyTime<3 then
		statyTime = 3
	end
	local nTimes = math.floor(statyTime/3)+1
	return nTimes
end
function GetDamageMy(nHP)
	local statyTime = tonumber(GetWarTime())-2
	if statyTime<3 then
		statyTime = 3
	end
	local nTimes = math.floor(statyTime/3)+1
	if statyTime%3 ~=0 then
		nTimes = nTimes +1
	end
	return math.floor(nHP/nTimes)
end
function GetDamageOther(nHP)
	local statyTime = tonumber(GetWarTime())-2
	if statyTime<3 then
		statyTime = 3
	end
	local dTimes = math.floor((statyTime/3))+1
	if statyTime%3 ~=0 then
		dTimes = dTimes +1
	end
	return math.floor(nHP/dTimes)
end
function GetFirstBlood(nHP)
	local nNowTime = tonumber(GetWarTime())
	if nNowTime<2 then
		nNowTime = 2
	end
	local statyTime = nNowTime-2
	
	local nTimesBlood = math.floor((statyTime/3))
	
	if statyTime%3 ~=0 then
		nTimesBlood = nTimesBlood+1
	end
	if nTimesBlood==0 then
		nTimesBlood  = 1
	end
	return math.floor(nHP/nTimesBlood)
end

function ToSingleFight(nType)
	--请求数据
	local function ShowSingleFight(pNetStream)
		--NetWorkLoadingLayer.loadingShow(false)
		--NetWorkLoadingLayer.ClearLoading()
		require "Script/Fight/BaseScene"
		BaseScene.createBaseScene() 
		BaseScene.InitSingleFightData(pNetStream)				
		BaseScene.EnterBaseScene()
	end
	Packet_GetWarSingleFightData.SetSuccessCallBack(ShowSingleFight)
	network.NetWorkEvent(Packet_GetWarSingleFightData.CreatPacket(nType))
	--NetWorkLoadingLayer.loadingShow(true)
	
end
function ToWarFight(pTime,nCityID,nType)
	pTime:SaveTime()
	--到战斗界面
	local function ShowWarFightData(pNetStream)
		--NetWorkLoadingLayer.loadingShow(false)
		--NetWorkLoadingLayer.ClearLoading()
		require "Script/Fight/BaseScene"
		BaseScene.createBaseScene() 
		BaseScene.InitWarFightData(pNetStream)				
		BaseScene.EnterBaseScene()
	end
	Packet_GetCountryWarFightData.SetSuccessCallBack(ShowWarFightData)
	network.NetWorkEvent(Packet_GetCountryWarFightData.CreatPacket(nCityID,nType))
	--NetWorkLoadingLayer.loadingShow(true)
end

function CheckBSub(tabArmyList)
	if #tabArmyList<=12 then
		return true
	end
	return false
end
--[[function ToSubAnimation(tabArmyList,curRowNum)
	if CheckBSub(tabArmyList) == true then
		local tabCurRowList = tabArmyList[curRowNum]
		if tabCurRowList~=nil then
			local pSigledPerson = tabCurRowList[#tabCurRowList]
			if pSigledPerson~=nil then
				pSigledPerson:removeFromParentAndCleanup(true)
			end
		end
	end
end]]--

function SetWarHeadState(nHeadIndex)
	CountryWarScene.SetPlayerState(nHeadIndex+1,PlayerState.E_PlayerState_Solo)
end

function CheckBHaveWJ(nTabNum)
	if nTabNum>0 then
		return true
	end
	return false
end
function ExitGuanZhan(nGType)
	--Packet_GetCountryWarInfo.SetSuccessCallBack(fCallBack)
	--Pause()
	local nCityID = 0 
	if tonumber(nGType) == 2 then
		nCityID = -1 
	end
	network.NetWorkEvent(Packet_GetCountryWarInfo.CreatPacket(nCityID,nGType))
end
function UpdateTabData(bChoose,tag,tabData)
	if bChoose== false then
		--取消选择
		for key,value in pairs(tabData) do 
			if tonumber(value.Type) == tonumber(tag) then
				table.remove(tabData,key)
			end
		end
	else
		local tab = {}
		tab.Type = tag
		table.insert(tabData,tab)
	end
	return tabData
end

function GetStateStr(nType)
	if tonumber(nType) == 1 then
		return "空闲"
	elseif tonumber(nType) == 2 then
		return "移动"
	elseif tonumber(nType) == 3 then
		return "国战"
	elseif tonumber(nType) == 4 then
		return "上阵"
	elseif tonumber(nType) == 5 then
		return "单挑"
	elseif tonumber(nType) == 6 then
		return "休息"
	elseif tonumber(nType) == 7 then
		return "撤退"
	elseif tonumber(nType) == 8 then
		return "突进"
	elseif tonumber(nType) == 9 then
		return "战斗"
	elseif tonumber(nType) == 10 then
		return "血战"
	elseif tonumber(nType) == 11 then
		return "坚守"
	elseif tonumber(nType) == 12 then
		return "迷雾"
	elseif tonumber(nType) == 13 then
		return "监牢"
	else
		return ""
	end
end
function GetCountryNameByType(nType)
	if nType == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
		return "魏"
	elseif nType == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
		return "蜀"
	elseif nType == COUNTRY_TYPE.COUNTRY_TYPE_WU then
		return "吴"
	end
end
function GetCountryNameByIndex(nIndex)
	if tonumber(nIndex) == 1 then
		return "魏"
	end
	if tonumber(nIndex) == 2 then
		return "蜀"
	end
	if tonumber(nIndex) == 3 then
		return "吴"
	end
	if tonumber(nIndex) == 4 then
		return "群"
	end
	if tonumber(nIndex)< 8 and  tonumber(nIndex) >4 then
		return "蛮"
	end
	if tonumber(nIndex) == 8 then 
		return "黄"
	end
end

function ToTellSingleFihgt(nType,fCallBack)
	local function GetOK(nState,list)
		NetWorkLoadingLayer.loadingShow(false)
		if fCallBack~=nil then
			fCallBack(nState,list)
		end
	end
	Packet_WarSingleFight.SetSuccessCallBack(GetOK)
	network.NetWorkEvent(Packet_WarSingleFight.CreatPacket(nType))
	NetWorkLoadingLayer.loadingShow(true)

end
function GetTabIndexByType(tab,nType)
	for i=1,#tab do 
		if tonumber(tab[i].Type) == nType then
			return i
		end
	end
	return 1
end

function ToAvatar(m_parent,m_child)
	AddLabelImg(m_child,layerAtkWarAvatar_Tag,m_parent)
end

function ToServerAvatar(nNum,nWJType,nCityTag)
	local function GetAvatar(status)
		NetWorkLoadingLayer.loadingShow(false)
		if tonumber(status) == 1 then
			TipLayer.createTimeLayer("分身成功",2)
		else
			TipLayer.createTimeLayer("分身失败",2)
		end
	end
	Packet_Avatar.SetSuccessCallBack(GetAvatar)
	network.NetWorkEvent(Packet_Avatar.CreatPacket(nWJType,tonumber(nNum),nCityTag))
	NetWorkLoadingLayer.loadingShow(true)

end
function GetPersonRowAndCol(nCount)
	local j = math.floor(nCount%3)
	if j==0 then
		j = 3
	end
	local i = math.floor((nCount-1)/3 )

	return i+1,j
end
function CheckBEnoughExpend(tab,num)
	if tab[1].Enough == false then
		return false
	end
	if tonumber(tab[1].ItemNeedNum)*num>tonumber(tab[1].ItemNum) then
		return false 
	end
	return true
end
function GetEnoughMaxNum(tab,num)
	return math.floor(tab[1].ItemNum/tonumber(tab[1].ItemNeedNum))
end
--nWarType 攻城战的类型，是普通还是迷雾，nType,攻方还是守方，nPage要获得第几页的数据
function ToGetNextPageData(nWarType,nType,nPage,fCallBack)
	GetWarData(nWarType,nType,nPage,fCallBack)
end

function GetPageTotal(nNum)
	local nInteger,nRemain = math.modf(nNum/11)
	if nRemain~=0 then
		return nInteger+1
	end
	return nInteger
end
--补位，要补位的列，以及位置， tabList,要增加的队列,以及父类对象
function CoverTeamList(col,row,posX,posY,tabList,bAtk,pParent)
	if row>3 then
		print("行出错")
		print(col,row)
		row =3 
		--Pause()
		return 
	end
	if col >4 then 
		print("列出错")
		print(col,row)
		col =4 
		--Pause()
		return 
	end
	--检测如果有人则不加了
	if tabList[row]~=nil then
		if tabList[row][col]~=nil then
			return 
		end
	end
	local pWarPlayerCover = GetWarListPlayer("ren0"..row.."_stand")
	if bAtk == false then
		pWarPlayerCover:setScaleX(-1.0)
	end
	pWarPlayerCover:setPosition(ccp(posX,posY))
	pParent:addNode(pWarPlayerCover,1200,1200)
	if tabList==nil then
		tabList = {}
		print("要补得为空了")
		--Pause()
	end
	if tabList[row] == nil then
		tabList[row] = {}
	end
	table.insert(tabList[row],pWarPlayerCover)
	--return tabList
end
--初始化队伍列表
function InitTeamList(tabTeamList,nTeamNum,bAtk,pParent)
	if tabTeamList~=nil then
		for key,value in pairs(tabTeamList) do 
			for key1,value1 in pairs(value) do 
				local pPlayer = tolua.cast(value1,"CCArmature")
				if pPlayer~=nil then
					pPlayer:removeFromParentAndCleanup(true)
					pPlayer = nil
				end
			end
		end
	end
	local aCount = 0 
	tabTeamList = {}
	--将数据分成三排保存
	for i=1,3 do 
		tabTeamList[i] = {}
	end
	for i=1,4 do 
		local tabNum = {}
		for j=1,3 do 
			aCount = aCount +1
			
			if aCount>nTeamNum then
				return tabTeamList
			end
			local pWarPlayer = GetWarListPlayer("ren0"..j.."_stand")
			if bAtk == true then
				if pParent:getNodeByTag(1000+aCount)~= nil then
					pParent:removeNodeByTag(1000+aCount)
				end
				pWarPlayer:setPosition(ccp(233-(j-1)*23-(i-1)*125,293-(j-1)*95))
				pParent:addNode(pWarPlayer,1000+aCount,1000+aCount)
			else
				if pParent:getNodeByTag(2000+aCount)~= nil then
					pParent:removeNodeByTag(2000+aCount)
				end
				pWarPlayer:setScaleX(-1.0)
				pWarPlayer:setPosition(ccp(911+(j-1)*23+(i-1)*125,293-(j-1)*95))
				pParent:addNode(pWarPlayer,2000+aCount,2000+aCount)
			end
			
			table.insert(tabTeamList[j],pWarPlayer)
		end
	end
	return tabTeamList
end
--检测队列是否要变化
local function CheckTeamNumChange(tabTeam,nTeamNum)
	if tabTeam~=nil and nTeamNum>=12 and GetTeamNumByTab(tabTeam)>=12 then
		return false
	end
end
--往队列里面增加人
function DealAddPersonToList(tabTeamNow,nAddNum,bAtk,pParent)
	--直接加到队尾
	
	local nNowNum = GetTeamNumByTab(tabTeamNow)
	for i=1,nAddNum do
		local nAdd = nNowNum+i
		if nAdd>12 then
			nAdd = nAdd -12
		end
		
		local col,row  = GetPersonRowAndCol(nAdd)
		
		local posX = nil
		local posY = nil 
		
		if bAtk == true then
			posX = 233-(row-1)*23-(col-1)*125
			posY = 365-(row-1)*98
		else
			posX = 911+(row-1)*23+(col-1)*125
			posY = 365-(row-1)*98
		end
		--[[print("DealAddPersonToList=====================")
		print(nAdd)
		print(col,row )
		print("1====")]]--
		
		CoverTeamList(col,row,posX,posY,tabTeamNow,bAtk,pParent)
	end
	
end

--获得Team的数量
local function GetTabNum(tab)
	local nCount = 0
	for key,value in pairs(tab) do 
		nCount = nCount+1
	end
	return nCount
end
--往队列里面减人
function DealRemovePersonOnList(tabTeam,nDelNum)
	local nCount = GetTeamNumByTab(tabTeam)
	--要减掉的行和列
	--[[print("删掉之前的数量",nCount)
	print("************************")
	printTab(tabTeam)
	print("************************")
	Pause()]]--
	for i=1,nDelNum do 
		local col ,row = GetPersonRowAndCol(nCount-(i-1))
		if tabTeam == nil then
			return 
		end
		local pPerson = tabTeam[row][col]
		if pPerson== nil then
			return 
		end
		pPerson:setVisible(false)
		pPerson:removeFromParentAndCleanup(true)
		table.remove(tabTeam[row],col)
		print("删掉某行某列",row,col)
	end
	--[[print("0000000000000000000000000000")
	printTab(tabTeam)
	print("0000000000000000000000000000")
	Pause()]]--
end
function GetTeamNumByTab(tabTeam)
	if tabTeam==nil then
		return 0
	end
	local n = 0 
	for i=1,#tabTeam do 
		n = n + #tabTeam[i]
	end
	return n
end
--改变更新队伍数量
function ChangeTeamNum(tabTeam,nTeamNum,bAtk,pParent)
	--队伍数量不变
	if tabTeam== nil then
		return 
	end
	
	if CheckTeamNumChange(tabTeam,nTeamNum) == false then
		return 
	end
	if nTeamNum>12 then
		nTeamNum = 12
	end
	if nTeamNum>GetTeamNumByTab(tabTeam) then
		--说明要添加人
		DealAddPersonToList(tabTeam,tonumber(nTeamNum)-tonumber(GetTeamNumByTab(tabTeam)),bAtk,pParent)
	elseif 	nTeamNum<GetTeamNumByTab(tabTeam) then
		--说明要减少人
		DealRemovePersonOnList(tabTeam,tonumber(GetTeamNumByTab(tabTeam))-tonumber(nTeamNum))
	end
end

function CheckIndex(nIndex,tab)
	if tab==nil then
		return nIndex
	end
	local tabIndex = tab[nIndex]
	if #tabIndex == 0 then
		if GetTeamNumByTab(tab)>0 then
			for key,value in pairs(tab) do 
				if #value>0 then
					nIndex = key
					return nIndex
				end
			end
		end
	end
	return nIndex
end
--根据当前时间检测是否已经消耗了血

function GetStayHPByTime(nHP)
	local m_curTime = AtkCityData.GetWarTime()
	local m_totalTime = AtkCityData.GetTotalTime()
	if m_curTime<=2 then
		return 0 
	end
	if m_curTime == m_totalTime then
		return 0
	end
	return 0
	--[[local m_pastTime = m_totalTime- m_curTime
	
	local statyTime = tonumber(m_totalTime)-2
	if statyTime<3 then
		statyTime = 3
	end
	local nTimes = math.floor(statyTime/3)+1
	local m_pastHP = math.floor((nHP/nTimes)*m_pastTime) --已经消耗的血量
	return m_pastHP]]--
end
--检测缓存的数据中最新一组的数据已经打了多长时间
--[[function CheckNewBufferData(nBufferTime)
	local nowTime = UnitTime.GetCurTime()--当前的时间
	local nBufferEnter = server_getCountryWarInfo.GetNewDataTime()--最新一组数据进来的时间
	local nPastTime =  nowTime-nBufferEnter
	local nStayBufferTime  = nBufferTime-nPastTime --最新一组还剩余的时间
	if nStayBufferTime>2 then
		return nStayBufferTime
	end
	return 0
end]]--
--时间修改为分加秒的形式
function GetTimeShowText(nSceneds)
	local nMin = math.floor(nSceneds/60)
	local nSend = nSceneds%60
	local strTime = string.format("0%d:%d",nMin,nSend)
	return strTime
end