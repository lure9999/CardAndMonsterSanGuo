require "Script/Common/Common"
require "Script/Common/CommonData"
require "Script/Main/Mail/MailData"

module("MailLogic", package.seeall)

local GetMailInfo					= MailData.GetMailInfo
local GetSingerMailInfo 			= MailData.GetSingerMailInfo
local GetSingerMailInfo_ChildMess	= MailData.GetSingerMailInfo_ChildMess
local GetSingerMailRewardData		= MailData.GetSingerMainRewardInfo
local GetMailData 					= MailData.GetMailData
local GetMainDataChild				= MailData.GetMainDataChild
local GetDelMailID					= MailData.GetDelID

local function GetMailMaxNums( )
	local mailData = GetMailData()
	return #mailData
end

--local MailBoxMaxNum = 100
local MAIL_ADD_NUM = 4
local MAIL_ADD_NUM_INSERT = 4

local count_now_add = 0
local count_now_begin = 1

local function GetRewardData(  )
	local rewardSet = {}
	local mailData = GetMailData()
	local rewardNum = 1
	for key,value in pairs(mailData) do
		if value["Type"] == "2" then
			rewardSet[rewardNum] = {}
			local rewardData = GetSingerMailRewardData(value)
			rewardSet[rewardNum]["PostId"] = value["PostId"]
			rewardSet[rewardNum]["银币"] = rewardData["SliverNums"]
			rewardSet[rewardNum]["元宝"] = rewardData["GoldNums"]
			rewardSet[rewardNum]["钻石"] = rewardData["DiamondNums"]
			rewardNum = rewardNum + 1
		end
	end 
	return rewardSet
end

local function SortMailFromDate( pData, SortWay)
	local function sortAsc(a,b)
		if SortWay == false then 
			return a.Time < b.Time
		else
			return a.Time > b.Time
		end
	end
	table.sort(pData,sortAsc)
end

local function SortMailFromStatus( pData, SortWay)
	local function sortAscStatus( a,b )
		if SortWay == false then
			return a.Status < b.Status
		else
			return a.Status > b.Status
		end
	end
	table.sort(pData,sortAscStatus)
end

local function SortMailFromType( pData, SortWay)
	local function sortAscType( a,b )
		if SortWay == false then
			return a.Type < b.Type
		else
			return a.Type > b.Type
		end
	end
	table.sort(pData,sortAscType)
end

--[[
local function removeMailFromMailBox (pRemoveData, pData)
	local ReadData = pRemoveData["Read"]
	local UnReadData_Text = pRemoveData["UnRead_Text"]
	local UnReadData_Reward = pRemoveData["UnRead_Reward"]
	local function removeMail( TypeData,DataName )
		SortMailFromDate(TypeData,false)
		for key,value in pairs (TypeData) do 
			local delIndexNum = value["Index"]
			print("delIndexNum ---- "..delIndexNum)
			for ind,res in pairs (pData) do 
				local baseIndexNum = res["Index"]
				if delIndexNum == baseIndexNum then
					if #pData > MailBoxMaxNum then 
						table.remove(pData,ind)
					else
						print("邮箱容量未满")
					end
				else
					print("不删除此邮件"..delIndexNum)
				end
			end
		end
		--移除完毕后判断现有邮件数量和邮箱总量
		if #pData > MailBoxMaxNum then
			print("删完"..DataName.."邮件后剩余邮件数依然超标，需删除未读邮件")
			return false
		else
			print("删完"..DataName.."邮件后剩余邮件数已经达标")
			return true
		end
	end

	if #ReadData > 0 then	--当存在已读邮件时首先删除已读邮件
		print("----当前存在已读邮件，先删除已读邮件")
		local deleteOver_Read = removeMail(ReadData, "Read")
		if deleteOver_Read == false then
			local deleteOver_UnReadText = removeMail(UnReadData_Text, "UnRead_Text")
			if deleteOver_UnReadText == false then
				local deleteOver_UnReadReward = removeMail(UnReadData_Reward, "UnRead_Reward")
			end
		end
	elseif #UnReadData_Text > 0 then
		print("----当前不存在已读邮件，先删除未读的文本邮件")
		local deleteOver_UnReadText = removeMail(UnReadData_Text, "UnRead_Text")
		if deleteOver_UnReadText == false then
			local deleteOver_UnReadReward = removeMail(UnReadData_Reward, "UnRead_Reward")
		end
	elseif #UnReadData_Reward > 0 then
		print("----当前不存在已读邮件，先删除未读的文本邮件")
		removeMail(UnReadData_Reward, "UnRead_Reward")
	else
		print("----不会进来的")
	end
end
--]]
--[[
local function mailGrouping( mailBoxData )
	local mailBoxIndexData = {}
	local groupMail = {}
	local groupMail_Read = {}
	local groupMail_UnRead_Text = {}
	local groupMail_UnRead_Reward = {}
	for i=1,#mailBoxData do
		local singerMail = GetSingerMailInfo(i,mailBoxData)
		local mailStatus = singerMail["Status"] 
		local mailRewards = singerMail["Type"] 
		singerMail["Index"] = i
		if mailStatus == "1" then
			if mailRewards == "1" then 
				table.insert(groupMail_Read,singerMail) 								--已读
			end  		 
		elseif mailStatus == "0" then										 			--未读
			if mailRewards == "2" then 
				table.insert(groupMail_UnRead_Reward,singerMail) 	   					--未读有附件	
			elseif 
				mailRewards == "1" then table.insert(groupMail_UnRead_Text,singerMail)	--未读无附件	
			end
		end
		table.insert(mailBoxIndexData,singerMail)
	end
	groupMail["Read"] = groupMail_Read
	groupMail["UnRead_Text"] = groupMail_UnRead_Text
	groupMail["UnRead_Reward"] = groupMail_UnRead_Reward
	return groupMail,mailBoxIndexData
end
--]]

function SystemAutoDelete()
	local mailBoxData = GetMailData()
	local maxNum = GetMailMaxNums()
	local sortData = {}
	if maxNum > MailBoxMaxNum then
		print("邮箱已满,开始删除")
		local groupMail = {}
		local mailBoxIndexData = {}
		groupMail,mailBoxIndexData = mailGrouping(mailBoxData)
		removeMailFromMailBox(groupMail, mailBoxIndexData)
		--删除完毕后对data进行排序
		sortData = SortMailList(mailBoxIndexData)
	else
		print("邮箱未满")
		sortData = SortMailList(mailBoxData)
	end
	printTab(sortData)
	return sortData
end

local function mailGrouping( mailBoxData )
	local mailBoxIndexData = {}
	local groupMail = {}
	local groupMail_Read = {}
	local groupMail_Read_Reward = {}
	local groupMail_UnRead_Text = {}
	local groupMail_UnRead_Reward = {}
	for i=1,#mailBoxData do
		local singerMail = GetSingerMailInfo(i,mailBoxData)
		local mailStatus = singerMail["Status"] 
		local mailRewards = singerMail["hasReward"] 
		if mailStatus == 2 then
			if mailRewards == 0 then 
				table.insert(groupMail_Read,singerMail) 								--已读无附件
			elseif mailRewards == 1 then
				table.insert(groupMail_Read_Reward,singerMail) 							--已读有附件 
			end  		 
		elseif mailStatus == 1 then										 				--未读
			if mailRewards == 1 then 
				table.insert(groupMail_UnRead_Reward,singerMail) 	   					--未读有附件	
			elseif 
				mailRewards == 0 then table.insert(groupMail_UnRead_Text,singerMail)	--未读无附件	
			end
		end
	end
	groupMail["Read"] = groupMail_Read
	groupMail["Read_Reward"] = groupMail_Read_Reward
	groupMail["UnRead_Text"] = groupMail_UnRead_Text
	groupMail["UnRead_Reward"] = groupMail_UnRead_Reward
	return groupMail
end

function SortMailList(pData)
	local nMailData = {}
	if pData == nil then
		nMailData = GetMailData()
	else
		nMailData = pData
	end 
	 
	local NewData = {}
	if #nMailData > 0 then 
		local groupMail = mailGrouping(nMailData)
		--三组邮件按日期首先排序
		for key,value in pairs(groupMail) do
			SortMailFromDate(value,true)
		end
		--再按未读有附件，未读无附件，已读无附件顺序插入数组
		local groupMail_Read = groupMail["Read"]
		local groupMail_ReadReward = groupMail["Read_Reward"]
		local groupMail_UnReadText = groupMail["UnRead_Text"]
		local groupMail_UnReadReward = groupMail["UnRead_Reward"]
		local function insertMail(chidData, parentData )
			for key, value in pairs (chidData) do
					table.insert(parentData,value)
			end
		end
		insertMail(groupMail_UnReadReward,NewData)
		insertMail(groupMail_UnReadText,NewData)
		insertMail(groupMail_ReadReward,NewData)
		insertMail(groupMail_Read,NewData)
	else
		print("没有邮件")
	end
	return NewData
end

function DateFormatConversion(pMailDataSingle)
	local dateStr = string.format("%d",pMailDataSingle["Time"])
	local temp = os.date("*t", dateStr)
	local strDate = temp.year.."-"..temp.month.."-"..temp.day
	return strDate
end

function UpdateMailItemShowStatus( nMailStatus )
	if nMailStatus == 2 then 
		return true
	elseif nMailStatus == 1 then  
		return false
	end
end

function RemoveSingerMail( pData )
	for key,value in pairs(pData) do
		if value["ID"] == GetDelMailID() then
			table.remove(pData,key)
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

--检查邮件数量 如果小于 < 5 则直接加载 如果大于>5 则分页加载
function UpdateListItem( pData,loadlMailCallBack,m_MailList )
	clearListView(m_MailList)
	RunGetListAction(m_MailList,loadlMailCallBack,pData)
end
