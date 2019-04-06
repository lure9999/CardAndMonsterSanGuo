
--玩家设置逻辑 celina


module("UserSettingLogic", package.seeall)

require "Script/Login/CreateRoleData"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Corps/CorpsLogic"


local GetAnimationFileName = CreateRoleData.GetRoleAnimationFileName
local GetAnimationName     = CreateRoleData.GetRoleAnimationName
local GetID                = CreateRoleData.GetResID

local GetGerneralTempID    = UserSettingData.GetGerneralTempID
local GetJiHuoDataByGID    = UserSettingData.GetJiHuoDataByGID
local GetJTID              = UserSettingData.GetJTID
local GetUserSex           = UserSettingData.GetUserSex
local GetCountryTag        = UserSettingData.GetCountryTag
local GetDeCountry         = UserSettingData.GetDeCountry
local GetChangeNameExpend   = UserSettingData.GetChangeNameExpend
local GetGerneralTab = UserSettingData.GetGerneralTab
local GetChangeNameTimes = UserSettingData.GetChangeNameTimes




function GetRoleActionByID(m_id_role)
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(GetAnimationFileName(m_id_role))
	local PayArmature = CCArmature:create(GetAnimationName(m_id_role))
	
    PayArmature:getAnimation():play(GetAniName_Res_ID(GetID(m_id_role), Ani_Def_Key.Ani_stand))

	return PayArmature

end
function CheckNameOK(strName)
	return CreateRoleLogic.checkName(strName)
	--[[if string.len(strName)>12 then
		--TipCommonLayer.CreateTipsLayer(902,TIPS_TYPE.TIPS_TYPE_NONE,nil,nil)
		local pTipsManager = TipCommonLayer.CreateTipLayerManager()
		pTipsManager:ShowCommonTips(902,nil)
		pTipsManager = nil
		return false
	elseif string.len(strName)<3 then
		local pTipsManager = TipCommonLayer.CreateTipLayerManager()
		pTipsManager:ShowCommonTips(1486,nil)
		pTipsManager = nil
		return false
	end
	return true ]]--
end
local function CheckConsumeOK()
	if GetChangeNameTimes() <1 then
		return true
	end
	local tab = GetChangeNameExpend()
	return tab[1].Enough
end
function ToChangeName(sName,fCallBack)
	if CheckNameOK(sName) == true then
		if CheckConsumeOK() == true then
			local function GetChangeResult()
				NetWorkLoadingLayer.loadingShow(false)
				if fCallBack~=nil then
					fCallBack()
				end
			end
			Packet_ChangeName.SetSuccessCallBack(GetChangeResult)
			network.NetWorkEvent(Packet_ChangeName.CreatPacket(sName))
			NetWorkLoadingLayer.loadingShow(true)
		else
			TipLayer.createTimeLayer("消耗品不足",2)
		end
	end
end
--得到符合条件的武将的ID
local function GetZhuJiangImageData()
	local tableJHID = {}
	for key,value in pairs (CommonData.g_MainZhuanJingTable) do 
		if tonumber(value.JiHuo) > 0 then
			local tableTempID = {}
			tableTempID.tempID = value.GeneralID
			table.insert(tableJHID,tableTempID)
		end
	end
	local tableGetID = {}
	
	for key,value in pairs(tableJHID) do 
		for key,value in pairs(GetJiHuoDataByGID(value.tempID)) do 
			local tabJH = {}
			tabJH.tempID = value.tempID
			table.insert(tableGetID,tabJH)
		end	
		
	end
	for key,value in pairs(tableGetID) do 
		if value.tempID~=nil then
			table.insert(tableJHID,value)
		end
	end
	return tableJHID
end
function GetImageData()
	local tableMain = GetZhuJiangImageData()
	local tabAllGerneral = GetGerneralTab()
	local tabImageGernal = {}
	for key,value in pairs(tabAllGerneral) do 
		local typeGerneral = tonumber(GeneralBaseData.GetGeneralType(value["ItemID"]))
		if ( tonumber(value["Info02"]["Lv"]) >= 40 ) and (server_generalDB.IsMainGeneralByTempID(value["ItemID"])== false) 
			and typeGerneral~=5 then
			local tabN = {}
			tabN.tempID = value["ItemID"]
			table.insert(tabImageGernal,tabN)
		end
	end
	for key,value in pairs(tabImageGernal) do 
		table.insert(tableMain,value)
	end
	return tableMain
end
function GetGerneralRow(nCount,perCount)
	local nRow = math.ceil(nCount/perCount)
	return nRow
end
function GetGerneralCol(nCount,perCount)
	local col_now = 0 
	if nCount<perCount then
		col_now = nCount
	else
		col_now =perCount
	end
	return col_now
end

local function InitGerneralHeadIcon(mScrollview,tabData,nIndex,nRow,nCol,width,height,fCallBack)
	local m_size_view = mScrollview:getInnerContainerSize()
	mScrollview:setClippingType(1)
	local tempID = tabData[nIndex].tempID
	local img_gerneral_bg = ImageView:create()
	img_gerneral_bg:setPosition(ccp(width+(nCol-1)*97,height-(nRow-1)*99))
	img_gerneral_bg:setScale(0.68)
	local pControl = UIInterface.MakeHeadIcon(img_gerneral_bg, ICONTYPE.HEAD_ICON, tempID, nil,nil,nil,nil)
	pControl:setTag(TAG_GRID_ADD+tonumber(tempID))
	CreateItemCallBack(pControl,false,fCallBack,nil)
	mScrollview:addChild(img_gerneral_bg,0,TAG_GRID_ADD+tonumber(tempID))
end
function GetTabLength(tableData)
	local nIndex = 0
	for key,value in pairs(tableData) do 
		nIndex = nIndex+1
	end
	return nIndex
end
function AddWJHeadIcon(mScrollview,tabData,width,height,fCallBack,nNum,isHead)
	
	local length = 0 
	if isHead == true then
		length = GetTabLength(tabData)
	else
		length =table.getn(tabData)
	end
	local nRow = GetGerneralRow(length,nNum)
	local nCol = GetGerneralCol(length,nNum)
	
	
	if length%nNum == 0 then
		nRow = nRow+1
	end
	for i=1, nRow-1 do 
		for j=1,nCol do 
			InitGerneralHeadIcon(mScrollview,tabData,nNum*i+j-nNum,i,j,width,height,fCallBack)
		end
	end
	if nRow>0 then
		if table.getn(tabData)%nNum ~= 0 then
			for i=1,table.getn(tabData)%nNum do 
				InitGerneralHeadIcon(mScrollview,tabData,(nRow-1)*nNum+0+i,nRow,i,width,height,fCallBack)
			end
		end
	end
end

function GetUserActionByID(m_id_role)
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(GetAnimationFileName(m_id_role))
	local PayArmature = CCArmature:create(GetAnimationName(m_id_role))
	
    PayArmature:getAnimation():play(GetAniName_Res_ID(GetID(m_id_role), Ani_Def_Key.Ani_stand))

	return PayArmature

end
function GetScrollViewHeight(nRow)
	--一屏幕显示三行左右
	local nPing = math.ceil(nRow/3)
	return nPing*360
end
function ToSaveImage(nModelID,nHeadID,fCallBack)
	local function SaveOver()
		NetWorkLoadingLayer.loadingShow(false)
		local pTips= TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1006,nil)
		pTips = nil
		--TipCommonLayer.CreateTipsLayer(1006,TIPS_TYPE.TIPS_TYPE_NONE,nil,nil)
		if fCallBack~=nil then
			fCallBack()
		end
	end
	Packet_SaveModel.SetSuccessCallBack(SaveOver)
	network.NetWorkEvent(Packet_SaveModel.CreatPacket(nModelID,nHeadID))
	NetWorkLoadingLayer.loadingShow(true)
end
--离开军团
function ToDesertJT()
	CorpsLogic.LeaveCorps()
end
--叛离国家
function ToDesertCountry(pParent)
	--AddLabelImg(pNewLayer,500,pParent)
	--先走一个协议获取国家的等级，在另一个协议获取国家的战斗力
	
	local function GetLvOk()
		local function GetOK(nWe,nSh,nWu)	
			NetWorkLoadingLayer.loadingHideNow()
			local tab = {}
			table.insert(tab,nWe)
			table.insert(tab,nSh)
			table.insert(tab,nWu)
			AddLabelImg(UserDesertCountry.CreateUserDesertCountry(tab),500,pParent)
		end
		--获得国家的战斗力
		Packet_GetCountryFight.SetSuccessCallBack(GetOK)
		network.NetWorkEvent(Packet_GetCountryFight.CreatPacket())
	end
	--获得国家的等级
	Packet_GetCountryLevelUpData.SetSuccessCallBack(GetLvOk)
	network.NetWorkEvent(Packet_GetCountryLevelUpData.CreatePacket(GetCountryTag()))
	NetWorkLoadingLayer.loadingShow(true)
	
end

function CheckBHaveJT()
	if tonumber(GetJTID()) == 0 then
		return false
	end
	return true
end
--中间和两边的动作
function Action_MidSide(f_CallBack,pos,color,nScale)
	local action_move = CCMoveTo:create(0.3, pos)
	local action_tint = CCTintTo:create(0.3, color, color, color)
	local action_scale = CCScaleTo:create(0.3, nScale)
	local action_call  = CCCallFunc:create(f_CallBack)
	local array_group = CCArray:create()
	array_group:addObject(action_move)
	array_group:addObject(action_tint)
	array_group:addObject(action_scale)
	local action_group= CCSpawn:create(array_group)
	local action = CCSequence:createWithTwoActions(action_group,
					action_call)
	return action
end
--边上到边上
function Action_SideToSide(f_CallBack,pos)
	local action_move = CCMoveTo:create(0.3, pos)--移动
	local action_scale1 = CCScaleTo:create(0.15,0.6)
	local action_scale2 = CCScaleTo:create(0.15,0.72)
	
	local array_scale = CCArray:create()
	array_scale:addObject(action_scale1)
	array_scale:addObject(action_scale2)
	
	
	local action_scale = CCSequence:create(array_scale)
	
	
	local action_g = CCSpawn:createWithTwoActions(action_move,action_scale)
	local action_call  = CCCallFunc:create(f_CallBack)
	local action = CCSequence:createWithTwoActions(action_g,action_call)
	--[[local array_groupSide = CCArray:create()
	array_groupSide:addObject(action_move)
	array_groupSide:addObject(action_scale1)
	array_groupSide:addObject(action_scale2)]]--
	return action
	
end
function ActionBG()
	local action1 = CCFadeTo:create(0.15,100)
	local action2 = CCFadeTo:create(0.15,200)
	local action_fade = CCSequence:createWithTwoActions(action1,action2)
	return action_fade
end

local function GetTuiJianPath(nTag)
	if nTag == 1 then
		return "Image/imgres/corps/weiqi.png"
	end
	if nTag == 2 then
		return "Image/imgres/corps/shuqi.png"
	end
	if nTag == 3 then
		return "Image/imgres/corps/wuqi.png"
	end
end
local function GetTabCountryFlagInfo()
	local tabFlag = {}
	for i=1,3 do 
		local t = {}
		t.imgPath = GetTuiJianPath(i)
		t.nCountry =i 
		table.insert(tabFlag,t)
	end
	return tabFlag
end
function GetFlagInfo()
	local tabCountryFlag = GetTabCountryFlagInfo()
	local tjTag = CCUserDefault:sharedUserDefault():getIntegerForKey("country")
	table.remove(tabCountryFlag,tjTag)
	local tab = {}
	tab.imgPath = GetTuiJianPath(tjTag)
	tab.nCountry = tjTag
	table.insert(tabCountryFlag,2,tab)
	return tabCountryFlag
end

local function CheckBDesert()
	if UnitTime.GetCurWday() ~= 1 then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1434,nil)
		pTips = nil
		return false
	end
	return true
end
function DealDesertCountry(nTag,m_pLayer)
	--if CheckBDesert() == true then
		--处理叛国
		local function TeasonOK()
			NetWorkLoadingLayer.loadingShow(false)
			UserSettingLayer.UpdateCountry()
			m_pLayer:removeFromParentAndCleanup(true)
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1488,nil,GetDeCountry(nTag))
			pTips =  nil
		end
		Packet_TreasonCountry.SetSuccessCallBack(TeasonOK)
		network.NetWorkEvent(Packet_TreasonCountry.CreatPacket(nTag))
		NetWorkLoadingLayer.loadingShow(true)
	--end
end
--根据选中的国家对象，得到选中的国家的Tag
function GetCountryByImg(pImg,tabData)
	for i=1,3 do 
		local img = tolua.cast(tabData[i].img,"ImageView")
		if img:getTag() == pImg:getTag() then
			return tabData[i].country
		end
	end
end
--获得国家的战斗力
function GetFightCountry(nTag,tabFight)
	for i=1,3 do 
		if i== tonumber(nTag) then
			return tabFight[i]
		end
	end
end
--交换顺序
function DealCountryTag(bShun,tabData)
	local newTab = {}
	if bShun == true then
		
		newTab[1] = tabData[2]
		newTab[2] = tabData[3]
		newTab[3] = tabData[1]
		
	else
		newTab[1] = tabData[3]
		newTab[2] = tabData[1]
		newTab[3] = tabData[2]
	end
	return newTab
end