--FileName:CorpsLogic
--Author:xuechao
--Purpose:军团逻辑Lua
require "Script/Common/Common"
require "Script/Common/CommonData"

module("CorpsLogic",package.seeall)
require "Script/Main/Corps/CorpsData"

local GetMemberList = CorpsData.GetMemberList
local GetPrisonDB   = CorpsData.GetPrisonDB

--或得物品ID
function GetIconItemID( nitemid )
	return legioicon.getFieldByIdAndIndex(nitem,"iconid")
end
--或得物品路径
function GetIconPath( nitem )
	local iconid = legioicon.getFieldByIdAndIndex(nitem,"iconid")
	return resimg.getFieldByIdAndIndex(iconid,"icon_path")
end

function SetApplySet( nApplyState )
	CCUserDefault:sharedUserDefault():setBoolForKey("ApplySet", nApplyState)
end

function GetApplySet(  )
	return CCUserDefault:sharedUserDefault():getBoolForKey("ApplySet")
end

function SortCorpsFromStatus( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return a.Status > b.Status
		else
			return a.Status < b.Status
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

function SortCorpsFromLevel( pData, SortWay )
	local function sortAsclevel( a, b )
		if SortWay == true then
			return a.level > b.level
		else
			return a.level < b.level
		end
	end
	table.sort( pData, sortAsclevel )
end


function SortCorpsList( pData )
	local nCorpsData = {}
	if pData == nil then
		nCorpsData = CorpsData.GetCorpsListData
	else
		nCorpsData = pData
	end

	if #nCorpsData > 0 then
		for key,value in pairs(nCorpsData) do
			print(key,value)
			SortCorpsFromLevel(value,true)--GetApplySet
			--SortCorpsFromStatus(value,true)
		end
	end
	return nCorpsData
end

function SearchId( id, tableData )
	for key,value in pairs(tableData) do
		if value == id then
			return true
		end
	end
	return false
end

function GetSearchId( id, tableData )
	for key,value in pairs(tableData) do
		
		if tonumber(value["id"]) == tonumber(id) then
			return true
		end
	end
	return false
end

function CheckName( name, tableData )
	for key,value in pairs(tableData) do
		if value == name then
			return true
		end
	end
	return false
end

function cleanListView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:removeAllItems()
	end 
end

function cleanListItem( pListView ,item)
	pListView:removeItem(item)
end

function ChangeIcon( nCorpsIconID )
	CCUserDefault:sharedUserDefault():setStringForKey("mCorpsIconID",nCorpsIconID)
	--return iconid
end

function GetCorpsIconID(  )
	return CCUserDefault:sharedUserDefault():getStringForKey("mCorpsIconID")
end

--存储到本地
function SaveCorpsInfo(m_strText_name,m_flagID,m_countryID,m_CorpsOnlyID)
	CCUserDefault:sharedUserDefault():setStringForKey("name",m_strText_name)
	CCUserDefault:sharedUserDefault():setStringForKey("flagID",m_flagID)
	CCUserDefault:sharedUserDefault():setStringForKey("countryID",m_countryID)
	CCUserDefault:sharedUserDefault():setStringForKey("CorpsOnlyID",m_CorpsOnlyID)
end

function SaveCountryID( m_countryID )
	CCUserDefault:sharedUserDefault():setStringForKey("countryID",m_countryID)
end

function CreateCommonInfoWidget( pListViewTemp )
	local pListViewMemberInfo = pListViewTemp:clone()
	local peer = tolua.getpeer(pListViewTemp)
	tolua.setpeer(pListViewMemberInfo,peer)
	return pListViewMemberInfo
end

--刷新列表
function RequestRefreshView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:requestRefreshView()
	end 
end

function CheckMessHallLV( nlv, tableData )
	if tonumber(tableData[2]) == nlv then
		return true
	end
	return false
end

function checkCampCountry( nId )
	local str = nil
	if nId == 1 then
		str = "魏国"
	elseif nId == 2 then
		str = "蜀国"
	elseif nId == 3 then
		str = "吴国"
	end
	return str
end

--检测国家战力是否过高
function CheckCountryPower( n_countryID,m_BeginPower,m_MiddlePower,m_EndPower)
	local BeishuNUm = CorpsData.GetPowerBeishu()
	local num = BeishuNUm/100
	if n_countryID == 1 then
		if (m_BeginPower >= (m_MiddlePower*num)) or (m_BeginPower >= (m_EndPower*num))then
			return true			
		end
	elseif n_countryID == 2 then
		if (m_MiddlePower >= (m_BeginPower*num)) or (m_MiddlePower >= (m_EndPower*num))then
			return true			
		end
	elseif n_countryID == 3 then
		if (m_EndPower >= (m_MiddlePower*num)) or (m_EndPower >= (m_BeginPower*num))then
			return true
		end
	end
	return false
end

--计算字符串的长度
function ComminuteText(str)
    local list = {}
    local len = string.len(str)
    local i = 1 
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i + shift - 1)
        i = i + shift
        table.insert(list, char)
    end
	return table.getn(list)
end

function CheckSentText( str )
	local i = 1
	local resultStr = ""
	while true do
		if str == "" then
			resultStr = str
		else
			local c= string.sub(str,i,i)
			local b = string.byte(c)
			if b > 128  then
				local chars = string.sub(str,i,i+2)
				resultStr = resultStr .. chars
				i = i + 3
			else
				if b == 32 then
					--print("empty")
				else
					local chars = string.sub(str,i,i)
					resultStr = resultStr .. chars
				end
				i = i + 1
			end		
		end
		if i > #str then
			break
		end
	end
	return resultStr
end

function CheckTextIsLimit( str )
	local i = 1
	local resultStr = ""
	while true do
		if str == "" then
			resultStr = str
		else
			local c= string.sub(str,i,i)
			local b = string.byte(c)
				if b > 128  then
					i = i + 3
				else
					i = i + 1
				end	
		end
	end
	return true
end

function CheckNameIsSuit( str )
	local bSpace = false
	local nEng = 0
	for i=1,#str do 
		local nAscii = string.byte(str,i)
		local byteCount = 1
		if nAscii == 32 then
			bSpace = true
		end
		 if nAscii>0 and nAscii<=127 then
			byteCount = 1
		elseif nAscii>=192 and nAscii<223 then
			byteCount = 2
		elseif nAscii>=224 and nAscii<239 then
			byteCount = 3
		elseif nAscii>=240 and nAscii<=247 then
			byteCount = 4
		end
		i = i + byteCount -1
		if byteCount == 1 then
			nEng = nEng +1
		end
	end
	local pTips = TipCommonLayer.CreateTipLayerManager()
	
	if bSpace == true then
		pTips:ShowCommonTips(1468,nil)
		pTips = nil
		return false
	end
	if nEng>12 then
		pTips:ShowCommonTips(1469,nil)
		pTips = nil
		return false
	end
end

local function JudgePositionID( valueTab )
	local personID = CommonData.g_nGlobalID
	local positionID = 0
	for key,value in pairs(valueTab) do
		if SearchId(personID,value) == true then
			positionID = value.position
		end
	end
	if tonumber(positionID) == 0 then
		return true
	end
	return false
end

--判断是否是军团长
function CheckIsCorpsLead(fCallBack) 
	if fCallBack == true then
		return
	end
	local tab = {}
	local personID = CommonData.g_nGlobalID
	local positionID = 0
	tab = GetMemberList()
	if next(tab) ~= nil then
		for key,value in pairs(tab) do
			if SearchId(personID,value) == true then
				positionID = value.position
			end
		end
		if tonumber(positionID) == 0 then
			fCallBack(true)
		else
			fCallBack(false)
		end
	else
		local function GetSuccessCallback(  )
			NetWorkLoadingLayer.loadingHideNow()
			local tableTemp = GetMemberList()
			for key,value in pairs(tableTemp) do
				if SearchId(personID,value) == true then
					positionID = value.position
				end
			end
			if tonumber(positionID) == 0 then
				fCallBack(true)
			else
				fCallBack(false)
			end
		end
		Packet_CorpsGetMemList.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsGetMemList.CreatePacket())
		NetWorkLoadingLayer.loadingShow(true)
		
	end
end

function LeaveCorps( callBack )
	local nCorpsID = server_mainDB.getMainData("nCorps")
	if nCorpsID > 0 then
		local function GetStatus( is_status )
			if is_status == true then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1432,nil)
				pTips = nil
			else
				local function LevelFunction( isLevel )
					if isLevel == true then
						local function GetSuccessCallback(  )
							NetWorkLoadingLayer.loadingHideNow()
							local pTips = TipCommonLayer.CreateTipLayerManager()
							pTips:ShowCommonTips(1474,nil)
							pTips = nil
							if callBack ~= nil then
								callBack()
							end
						end
						Packet_CorpsLeave.SetSuccessCallback(GetSuccessCallback)
						network.NetWorkEvent(Packet_CorpsLeave.CreatePacket())
						NetWorkLoadingLayer.loadingShow(true)
					end
				end
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1455,LevelFunction)
			end
		end
		CheckIsCorpsLead(GetStatus)
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1060,nil)
		pTips = nil
	end
end

--根据国家ID显示相对应的动画效果
function GetAnimationByCountryID( sender )
	local animationAction = nil
	local cur_CountryID = server_mainDB.getMainData("nCountry")
	if cur_CountryID == 1 then
		animationAction = "zhenying_wei02"
	elseif cur_CountryID == 2 then
		animationAction = "zhenying_shu02"
	elseif cur_CountryID == 3 then
		animationAction = "zhenying_wu02"
	end
	CommonInterface.GetAnimationByName("Image/Fight/animation/Scene_juntuan/Scene_juntuan_zhenying/Scene_juntuan_zhenying.ExportJson", 
			"Scene_juntuan_zhenying", 
			animationAction, 
			sender, 
			ccp(0, -5),
			nil,
			14091)
end

--创建军团的回调
function CreateCorpsCallBack( strEdit,m_CorpsIconID, m_countryID,callBack)
	if CheckNameIsSuit(strEdit) == false then
		return
	end
	local resultStr= CheckSentText(strEdit)
	local strLen = string.len(resultStr)
	-- local is_limit = CorpsLogic.CheckTextIsLimit(strEdit)
	local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
	local function CreateCorps( isCreate )
		if isCreate == false then
			local tableDatas = CorpsData.GetCorpsListData()
			local nName = nil
			local nCorpsId = nil
			local tablename = {}
			for key,value in pairs(tableDatas) do
				nName =  CorpsData.GetCorpsName(key)
				nCorpsId = value.level
				table.insert(tablename,nName)
			end				

			if isCorps > 0 then
				TipLayer.createTimeLayer("已经加入军团!!!")
			else
				if CheckName(resultStr,tablename) ==true then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1410,nil)
					pTips = nil
				elseif resultStr == "" then
					local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1416,nil)
					pTips = nil
				else			
					if strLen <= 24 and strLen >= 3 then
						local function GetSuccessCallBack(  )
							NetWorkLoadingLayer.loadingHideNow()
							local is_corps = server_mainDB.getMainData("nCorps")
							local function GetSuccessCallbacks(  )
								if callBack ~= nil then
									callBack()
								end
							end
							Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallbacks)
							network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
							NetWorkLoadingLayer.loadingShow(true)

						end
							
						local m_CorpsIconIDNUm = tonumber(m_CorpsIconID)
						Packet_CreateCorps.SetSuccessCallBack(GetSuccessCallBack)
						network.NetWorkEvent(Packet_CreateCorps.CreatePacket(resultStr,m_CorpsIconIDNUm,m_countryID))
						-- NetWorkLoadingLayer.ClearLoading()
						NetWorkLoadingLayer.loadingShow(true)
					else
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1409,nil)
						pTips = nil
					end
				end
			end
		end
	end
	local corpsMoneyTab = CorpsData.GetCorpsCamp()
	local tabExpendData = ConsumeLogic.GetExpendData(corpsMoneyTab[1])
	local imgPath = tabExpendData.TabData[1]["IconPath"]
	local c_name = CorpsData.GetCreateCorpsConsumName()
	local pTips = TipCommonLayer.CreateTipLayerManager()
	pTips:ShowCommonTips(1414,CreateCorps,tabExpendData.TabData[1]["ItemNeedNum"],c_name)
end

--申请加入的回调
function ApplyCorpsCallBack( CorpslimitType,pTag ,isapplycancenl,CorpsNeedLevel,callBack1,callBack2,callBack3)
	local HeroLevel = tonumber(server_mainDB.getMainData("level"))
	local pCorpsTagID = tonumber(pTag)
	if CorpslimitType == 2 then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1408,nil)
		pTips = nil
	else
		if HeroLevel >= CorpsNeedLevel then
			if isapplycancenl == false then
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					if CorpslimitType == 1 then
						-- LabelLayer.setText(m_BtnText,"取消申请")
						if callBack1 ~= nil then
							callBack1()
						end
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1407,nil)
						pTips = nil
						-- isapplycancenl = true
					elseif CorpslimitType == 0 then
						local isCorps = tonumber(server_mainDB.getMainData("nCorps"))
						if isCorps > 0 then
							local function GetSuccessCallback(  )
								-- NetWorkLoadingLayer.loadingHideNow()
								--[[if CorpsScene.GetPScene() == nil then
									Cleanlayer()

									CorpsScene.CreateCorpsScene()
									NetWorkLoadingLayer.ClearLoading()
								else
									print("已经是军团场景了")
								end]]--
								MainScene.SetCurParent(false)
								if callBack2 ~= nil then
									callBack2()
								end
							end
							Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
							network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
							-- NetWorkLoadingLayer.loadingShow(true)
						end
					end
							
				end
				Packet_CorpsApply.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsApply.CreatePacket(pCorpsTagID))
				NetWorkLoadingLayer.loadingShow(true)
			elseif isapplycancenl == true then
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					-- LabelLayer.setText(m_BtnText,"申请加入")
					-- isapplycancenl = false
					if callBack3 ~= nil then
						callBack3()
					end
				end				
				Packet_CorpsApplyCanncel.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsApplyCanncel.CreateStream(pCorpsTagID))
				NetWorkLoadingLayer.loadingShow(true)
							
			end
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1404,nil)
			pTips = nil
		end
	end
end

function CheckMerStatus( tab )
	for key,value in pairs(tab) do
		if next(value) == nil then
			return true
		end
	end
	return false
end

function CheckSpiritStatus( tab )
	for key,value in pairs(tab) do
		if tonumber(value["is_open"]) == 1 then
			return true
		end
	end
	return false
end

function CheckPrisonGrid(  )
	require "Script/serverDB/server_GetPrisonGridInfo"
	local tabDB = server_GetPrisonGridInfo.GetCopyTable()
	for key,value in pairs(tabDB) do
		local tabTemp = GetPrisonDB(key)
		if tonumber(value["cur_num"])/tonumber(tabTemp[3]) >= 1 then
			return true
		end
	end
	return false
	
	
end