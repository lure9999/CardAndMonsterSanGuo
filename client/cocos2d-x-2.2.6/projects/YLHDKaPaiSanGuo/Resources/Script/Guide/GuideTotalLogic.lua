--引导主界面的 逻辑  celina
module("GuideTotalLogic", package.seeall)
require "Script/Common/UIGotoManager"

--数据
local GetGuideGroupDataByIndex_Logic = GuideTotalData.GetGuideGroupDataByIndex
local GetIndexByValue_Logic = GuideTotalData.GetIndexByValue
local GetSceneIndexBySceneID_Logic = GuideTotalData.GetSceneIndexBySceneID
local GetTotalCopyTimes_Logic = GuideTotalData.GetTotalCopyTimes
local GetCopyTimes_Logic     = GuideTotalData.GetCopyTimes
local GetGuideTipsByIndex_Logic = GuideTotalData.GetGuideTipsByIndex

function ToGuideSubUI(nIndex)
	--local m_GotoManager = UIGotoManager.CreateUIGotoManager()
	--m_GotoManager:CreateObj()
	local m_GotoManager = CommonData.g_GuildeManager
	if m_GotoManager==nil then
		m_GotoManager = UIGotoManager.CreateUIGotoManager()
		m_GotoManager:CreateObj()
	end
	local tab = GetGuideGroupDataByIndex_Logic(nIndex)
	local nType = tab[GetIndexByValue_Logic("Type")]
	local para1 = tab[GetIndexByValue_Logic("para1")]
	local para2 = tab[GetIndexByValue_Logic("para2")]
	local para3 = tab[GetIndexByValue_Logic("para3")]
	local tabNew = {}
	if tonumber(para1)~=0 then
		table.insert(tabNew,GetSceneIndexBySceneID_Logic(tonumber(nType),para1))
	end
	if tonumber(para2)~=0 then
		table.insert(tabNew,para2)
	end
	if tonumber(para3)~=0 then
		table.insert(tabNew,para3)
	end
	if #tabNew == 0 then
		m_GotoManager:ReplaceUI(tonumber(nType))
	end
	if #tabNew==1 then
		m_GotoManager:ReplaceUI(tonumber(nType),tabNew[1])
	end
	if #tabNew==2 then
		m_GotoManager:ReplaceUI(tonumber(nType),tabNew[1],tabNew[2])
	end
	if #tabNew==3 then
		m_GotoManager:ReplaceUI(tonumber(nType),tabNew[1],tabNew[2],tabNew[3])
	end
end
--获得副本的次数
function GetCopyTimesInfo(nType,nSceneID,para2)
	if tonumber(nSceneID) == 0 then
		return ""
	end
	local strTimes = GetCopyTimes_Logic(tonumber(nType),nSceneID,para2)
	if strTimes~=nil then
		return "( "..strTimes.."/"..GetTotalCopyTimes_Logic(nSceneID).." )"
	end
	return ""
end
--添加提示
function UpdateAddInfo(nDropID,pImgTips)
	if pImgTips~=nil then
		local label = pImgTips:getChildByTag(1)
		if label~=nil then
			label:setText(GetGuideTipsByIndex_Logic(nDropID))
		end
	end
end