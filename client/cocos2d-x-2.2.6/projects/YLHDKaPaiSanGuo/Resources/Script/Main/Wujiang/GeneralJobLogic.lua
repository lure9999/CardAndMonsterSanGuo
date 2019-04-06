require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralJobData"

module("GeneralJobLogic", package.seeall)
local m_tabAttr = {}
local m_nSelGeneralId = nil
local m_nCurSelIndex  = nil

local GetConsumeParaAType		= ConsumeLogic.GetConsumeParaAType
local GetConsumeTypeName		= ConsumeLogic.GetConsumeTypeName
local GetConsumeTab				= ConsumeLogic.GetConsumeTab
local GetConsumeItemData		= ConsumeLogic.GetConsumeItemData
local GetItemsData				= ConsumeLogic.GetItemsData

local GetMaxSpecialLv 			= GeneralJobData.GetMaxSpecialLv
local GetZhuanJingConsumeId 	= GeneralJobData.GetZhuanJingConsumeId
local GetJobNeedLv				= GeneralJobData.GetJobNeedLv
local GetNextGeneralID			= GeneralJobData.GetNextGeneralID
local GetSpecialConsumeId		= GeneralJobData.GetSpecialConsumeId

function SetSelGeneralId( nGeneralId )
	m_nSelGeneralId = nGeneralId
end

function GetSelGeneralId(  )
	return m_nSelGeneralId
end

function GetCurSelIndex( )
	if m_nCurSelIndex ~= nil then
		return m_nCurSelIndex
	end
end

function SetCurSelIndex( nIndex )
	if m_nCurSelIndex ~= nil then
		m_nCurSelIndex = nIndex
	end
end

function GetTabGeneralId (  )
	local tabGeneralId = {}
	for i=1, GeneralJobData.GeneralJobData.MAX_JOB_COUNT do
		if i<=#CommonData.g_MainZhuanJingTable and CommonData.g_MainZhuanJingTable[i]["GeneralID"]>0 then
			table.insert(tabGeneralId, CommonData.g_MainZhuanJingTable[i]["GeneralID"])
			if CommonData.g_MainZhuanJingTable[i]["JiHuo"]==GeneralJobData.JobState.StartUp then
				m_nSelGeneralId =  CommonData.g_MainZhuanJingTable[i]["GeneralID"]
				m_nCurSelIndex  = i - 1
			end
			-- printTab(CommonData.g_MainZhuanJingTable[i])
		end
	end
	return tabGeneralId
end

-- 获取当前选中职业的状态
function GetJobStateByGeneralID( nGeneralId )
	for i=1, GeneralJobData.MAX_JOB_COUNT do
		if i<=#CommonData.g_MainZhuanJingTable and CommonData.g_MainZhuanJingTable[i]["GeneralID"]>0 then
			if CommonData.g_MainZhuanJingTable[i]["GeneralID"]==nGeneralId then
				return CommonData.g_MainZhuanJingTable[i]["JiHuo"]
			end
		end
	end
	return nil
end

-- 通过GeneralID获取主将专精信息
function UpdateSpecialInfoByGeneralID (nGeneralId)
	m_tabAttr = {}
	for i=1, GeneralJobData.MAX_JOB_COUNT do
		if i<=#CommonData.g_MainZhuanJingTable and CommonData.g_MainZhuanJingTable[i]["GeneralID"]>0 then
			if CommonData.g_MainZhuanJingTable[i]["GeneralID"]==nGeneralId then
				for j=1, GeneralJobData.SPECIAL_COUNT do
					local temp = {}
					temp.AttrID = CommonData.g_MainZhuanJingTable[i]["Info0"..tostring(j)]["ZhuanJingAttributeID"]
					temp.AttrLv = CommonData.g_MainZhuanJingTable[i]["Info0"..tostring(j)]["ZhuanJingAttributeLV"]
					table.insert(m_tabAttr, temp)
				end
			end
		end
	end
end

function GetSpecialState( nIdx )
	local nSpecState = GeneralJobData.SpecialState.NotActivite
	if GetJobStateByGeneralID(m_nSelGeneralId)==GeneralJobData.JobState.NotActivite then
		return GeneralJobData.SpecialState.NotActivite
	end

	if GetSpecialLv(nIdx)>=GetMaxSpecialLv(m_nSelGeneralId, nIdx) then
		return GeneralJobData.SpecialState.MaxLv
	end

	return GeneralJobData.SpecialState.Normal
end

function GetSpecialId( nIdx )
	if m_tabAttr==nil or #m_tabAttr == 0 then
		return 
	end
	--Pause()
	return m_tabAttr[nIdx].AttrID
end

function GetSpecialLv( nIdx )
	return m_tabAttr[nIdx].AttrLv
end

function GetSpecialValue( nIdx )
	if m_tabAttr[nIdx].AttrLv<1 then
		return 0
	else
		return attributincremental.getFieldByIdAndIndex( m_tabAttr[nIdx].AttrID, "Inc_Att_"..tostring(m_tabAttr[nIdx].AttrLv))
	end
end

-- 获取星魂数量
function GetNeedXingHunNum( nGeneralId, nIdx, nSpecialLv )
	local nConsumeId = GetSpecialConsumeId(nGeneralId, nIdx, nSpecialLv+1, 1)

	local tabConsume =  GetConsumeTab(GeneralJobData.MAX_CONSUME_COUNT, nConsumeId)
	local tabConsumeItemData = {}

	for i=1, #tabConsume do
		if tabConsume[i].ConsumeType==ConsumeType.XingHun then
			tabConsumeItemData = GetConsumeItemData(tabConsume[i].ConsumeID, tabConsume[i].nIdx, tabConsume[i].ConsumeType, tabConsume[i].IncType, nSpecialLv, 1)
		end
	end

	return tabConsumeItemData
end


function CheckSpecLvUp( nIdx )
	local nSpecialLv = GetSpecialLv(nIdx)

	if nSpecialLv>=GetMaxSpecialLv(m_nSelGeneralId, nIdx) then
		return GeneralJobData.SpecErrorState.MaxLv
	end

	local nConsumeId = GetSpecialConsumeId(m_nSelGeneralId, nIdx)
	local tabConsume = GetConsumeTab(GeneralJobData.MAX_CONSUMETYPE_COUNT, nConsumeId)
	-- printTab(tabConsume)
	for i=1, #tabConsume do
		local tabConsumeItemData = GetConsumeItemData(tabConsume[i].ConsumeID, tabConsume[i].nIdx, tabConsume[i].ConsumeType, tabConsume[i].IncType, GetSpecialLv(nIdx), 1)
		-- printTab(tabConsumeItemData)
		if tabConsumeItemData.Enough==false then
			return GeneralJobData.SpecErrorState.NotEnouthItem
		end
	end

	return GeneralJobData.SpecErrorState.CanLvUp
end

function CheckUpgradeLv( nGeneralId )
	local nNextLv = GetJobNeedLv(nGeneralId)
	if CommonData.g_MainDataTable.level>=nNextLv then
		return true
	else
		return false
	end
end

function CheckUpgradeConsumeItems( tabConItemsData )
	-- printTab(tabConItemsData)
	for i=1, #tabConItemsData do
		if tabConItemsData[i].Enough == false then
			return tabConItemsData[i].Name
		end
	end
	return nil
end

function CheckUpgradeState( nGeneralId, tabConItemsData )
	if CheckUpgradeLv(nGeneralId)==false then
		TipLayer.createTimeLayer("主将等级过低!", 2)
		return false
	end

	local strName = CheckUpgradeConsumeItems(tabConItemsData)
	if strName~=nil then
		TipLayer.createTimeLayer("{"..strName.."}".."不足!", 2)
		return false
	end

	return true
end