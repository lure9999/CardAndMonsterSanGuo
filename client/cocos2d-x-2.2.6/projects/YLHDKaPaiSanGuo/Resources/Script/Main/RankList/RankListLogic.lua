require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/RankList/RankListData"
module("RankListLogic", package.seeall)

local MAIL_ADD_NUM = 5
local MAIL_ADD_NUM_INSERT = 5

local count_now_add = 0
local count_now_begin = 1

function GetRankNameByData( nRankingNum )
	local tabRank = RankListData.GetRankNameByID(nRankingNum)
	for key,value in pairs(tabRank) do
		if tonumber(nRankingNum) >= tonumber(value[1]) and tonumber(nRankingNum) <= tonumber(value[2]) then
			return value[3]
		elseif tonumber(nRankingNum) >= tonumber(value[1]) and tonumber(nRankingNum) > tonumber(value[2]) and tonumber(value[2]) <= 0 then
			return value[3]
		end

	end
	
end

local function CheckAction(count)
	if count <= MAIL_ADD_NUM then return true end
	return false
end

local function CheckAddListOver(tableData)
	if #tableData > count_now_add then return false end
	return true
end

local function GetActionArray(callback)
	local array_action = CCArray:create()
	array_action:addObject(CCDelayTime:create(0.5))
	array_action:addObject(CCCallFunc:create(callback))
	local action_list = CCSequence:create(array_action)
	array_action:removeAllObjects()
	array_action = nil 
	return action_list
end

function RunGetListAction(pAction,loadlMailCallBack,tableData)
	pAction:stopAllActions()
	count_now_add = 0
	if CheckAction(#tableData) == true then
		--如果数量较小直接加载
		if loadlMailCallBack~=nil then	
			--到界面里面去加载
			loadlMailCallBack(count_now_begin,#tableData)
		end
	else
		loadlMailCallBack(count_now_begin,MAIL_ADD_NUM)
		count_now_add = MAIL_ADD_NUM
		local function listCheckCallBack()
			pAction:stopAllActions()
			if CheckAddListOver(tableData) == false then
				if (count_now_add + MAIL_ADD_NUM_INSERT) > #tableData then
					--pAction:stopAllActions()
					loadlMailCallBack(count_now_add + 1,count_now_add + (#tableData - count_now_add))
				else
					loadlMailCallBack(count_now_add + 1,(MAIL_ADD_NUM_INSERT + count_now_add))
					count_now_add = count_now_add + MAIL_ADD_NUM_INSERT
					pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
				end
			end
		end
		pAction:runAction(CCRepeatForever:create(GetActionArray(listCheckCallBack))) 
	end
end
local function clearListView(list)
	if list:getItems():count()~=0 then
		list:removeAllItems()
	end
end

--检查排行榜数量 如果小于 < 5 则直接加载 如果大于>5 则分页加载
function UpdateListItem( pData,loadlMailCallBack,m_MailList )
	clearListView(m_MailList)
	RunGetListAction(m_MailList,loadlMailCallBack,pData)
end