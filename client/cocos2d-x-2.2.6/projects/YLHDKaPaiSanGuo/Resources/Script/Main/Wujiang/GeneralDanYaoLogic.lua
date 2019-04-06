-- 武将丹药逻辑层

require "Script/Common/Common"
require "Script/Common/ConsumeLogic"
require "Script/serverDB/danyao"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralDanYaoData"

module("GeneralDanYaoLogic", package.seeall)

local m_bEnoughLv = false
local m_bEnoughItem = false
local m_bPreActivite = false

-- 需要的数据接口
local GetConsumeItemData 	= ConsumeLogic.GetConsumeItemData
local ReturnType 			= GeneralBaseData.ReturnType
local GetConsumeTab			= ConsumeLogic.GetConsumeTab
local GetGeneralName 		= GeneralBaseData.GetGeneralName
local ConvertNumToCNChar	= GeneralBaseData.ConvertNumToCNChar

local GetDanYaoNeedLv		= GeneralDanYaoData.GetDanYaoNeedLv
local GetDanYaoItemId 		= GeneralDanYaoData.GetDanYaoItemId
local GetDadnYaoAttrId 		= GeneralDanYaoData.GetDadnYaoAttrId


-- 判断前置丹药是否激活
function CheckPrevDanYaoState( nCurIdx, nIdx )
	if nIdx==nCurIdx+1 then
		return true
	else
		return false
	end
end

-- 判断等级是否满足
function CheckGeneralLv( nGeneralLv, nDanYaoLv, nIdx)
	local nNeedLevel = GetDanYaoNeedLv( nDanYaoLv, nIdx )
	if nGeneralLv<nNeedLevel then
		return false
	else
		return true
	end
end

-- 判断消耗物品是否满足
function CheckConsumeItem( tabConsume )
	 for i=1,#tabConsume do
		 local tabConsumeItemData = GetConsumeItemData(tabConsume[i].ConsumeID, tabConsume[i].nIdx, tabConsume[i].ConsumeType, tabConsume[i].IncType)
		 if tabConsumeItemData.Enough==false then
		 	return false
		 end
	 end
	 return true
end

-- 判断丹药是否能激活
function CheckDanYaoState( nCurIdx, nIdx, nConsumeID, nGeneralLv, nDanYaoLv )
	local bRet = true
	if CheckGeneralLv(nGeneralLv, nDanYaoLv, nIdx)==false then
		SetEnoughLv(false)
		bRet = false
	else
		SetEnoughLv(true)
	end

	if CheckPrevDanYaoState( nCurIdx, nIdx ) == false then
		SetPrevState(false)
		bRet = false
	else
		SetPrevState(true)
	end

	SetEnoughItem(true)
	local tabConsume = GetConsumeTab( GeneralBaseData.MAX_CONSUMETYPE_COUNT, nConsumeID)
	if CheckConsumeItem( tabConsume ) == false then
		SetEnoughItem(false)
		bRet = false
	end

	return bRet
end

-- 设置等级是否满足
function SetEnoughLv( bEnough )
	m_bEnoughLv = bEnough
end

-- 设置物品是否满足
function SetEnoughItem( bEnough )
	m_bEnoughItem = bEnough
end

-- 设置前置状态是否满足
function SetPrevState( bState )
	m_bPreActivite = bState
end

-- 获得丹药的数据信息
function GetDanYaoItemData( nCurLv, nCurIdx, nIdx,  nConsumeID ,nGeneralLv )

	local tabDanYaoInfo = {}
	local nState = GeneralDanYaoData.ActiviteState.NotActivite
	local bEnoughLv = true
	local bEnoughItem = true
	local bPreActivite = true
	if nIdx<=nCurIdx then
		nState = GeneralDanYaoData.ActiviteState.Activited
	else
		nState = GeneralDanYaoData.ActiviteState.CanActivite
		if CheckPrevDanYaoState( nCurIdx, nIdx )==false then
			bPreActivite = false
			nState = GeneralDanYaoData.ActiviteState.NotActivite
		end
		if CheckGeneralLv(nGeneralLv, nCurLv, nIdx)==false then
			nState = GeneralDanYaoData.ActiviteState.NotActivite
			bEnoughLv = false
		end
		local tabConsume = GetConsumeTab( GeneralBaseData.MAX_CONSUMETYPE_COUNT, nConsumeID)
		if CheckConsumeItem(tabConsume)==false then
			bEnoughItem = false
			nState = GeneralDanYaoData.ActiviteState.NotActivite
		end
	end
	tabDanYaoInfo.DanYaoLv 		= nCurLv
	tabDanYaoInfo.Index 		= nIdx
	tabDanYaoInfo.DanYaoID 		= GetDanYaoItemId( nCurLv, nIdx )
	tabDanYaoInfo.ConsumeID		= nConsumeID
	tabDanYaoInfo.AttrID 		= GetDadnYaoAttrId( nCurLv, nIdx )
	tabDanYaoInfo.State 		= nState
	tabDanYaoInfo.bEnoughLv 	= bEnoughLv
	tabDanYaoInfo.bEnoughItem	= bEnoughItem
	tabDanYaoInfo.bPreActivite 	= bPreActivite

	return tabDanYaoInfo
end

-- 获得丹药状态文字
function GetDanYaoStateText( nState )
	local strState = nil
	if nState==GeneralDanYaoData.ActiviteState.NotActivite then
		strState = "未激活"
	elseif nState==GeneralDanYaoData.ActiviteState.CanActivite then
		strState = "可激活"
	elseif nState==GeneralDanYaoData.ActiviteState.Activited then
		strState = "已激活"
	end
	return strState
end

-- 合成丹药条件判断
function _HeChengDanYao_CallBack_( nGrid, tabDanYaoInfo )
	if tabDanYaoInfo.State == GeneralDanYaoData.ActiviteState.NotActivite then
		local strName = GetGeneralName(nGrid)
		if tabDanYaoInfo.bPreActivite==false then
			TipLayer.createTimeLayer("前置丹药未激活！", 1)
			return false
		end
		if tabDanYaoInfo.bEnoughLv==false then
			TipLayer.createTimeLayer("{" .. strName .. "}的等级不够啊！", 1)
			return false
		end

		if tabDanYaoInfo.bEnoughItem==false then
			TipLayer.createTimeLayer("咱们的物资不够啊！", 1)
			return false
		end
	end

	return true
end

function _HeChengDanYao_CallBack_No_Tips( nGrid, tabDanYaoInfo )
	if tabDanYaoInfo.State == GeneralDanYaoData.ActiviteState.NotActivite then
		local strName = GetGeneralName(nGrid)
		if tabDanYaoInfo.bPreActivite==false then
			return false
		end
		if tabDanYaoInfo.bEnoughLv==false then
			return false
		end

		if tabDanYaoInfo.bEnoughItem==false then
			return false
		end
	end

	return true
end

-- 获取金丹进阶的提示文字
function GetConfrimTipText(nLv)
	local strText = nil
	if nLv<GeneralDanYaoData.MAX_DANYAO_COUNT then
		local strNum = ConvertNumToCNChar(nLv)
		strText = "主公，你当真要进入{金丹"..strNum.."转}境界了吗？！"
	else
		strText = "主公，你当真要进入{鸿蒙待诏}境界了吗？！"
	end

	return strText
end