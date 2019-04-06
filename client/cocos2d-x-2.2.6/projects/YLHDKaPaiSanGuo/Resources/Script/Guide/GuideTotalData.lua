

--引导主界面的 数据  celina
module("GuideTotalData", package.seeall)

require "Script/serverDB/item"
require "Script/serverDB/coin"
require "Script/serverDB/server_mainDB"
require "Script/serverDB/server_itemDB"
require "Script/serverDB/dropguide"
require "Script/serverDB/resimg"
require "Script/serverDB/scence"
require "Script/serverDB/point"
require "Script/serverDB/server_fubenDB"
require "Script/serverDB/shop"

--从银币开始记录在玩家身上的名字
local tabCoinName = {
	{["coinID"]=1,["coinName"]="silver",},--银币
	{["coinID"]=2,["coinName"]="gold",},--金币
	{["coinID"]=3,["coinName"]="tili",},--鸡腿（体力）
	{["coinID"]=4,["coinName"]="naili",},--令旗（耐力）
	{["coinID"]=5,["coinName"]="silver",},--主将经验
	{["coinID"]=6,["coinName"]="GeneralExpPool",},--武将经验
	{["coinID"]=9,["coinName"]="BiWu_Prestige",},--比武声望
	{["coinID"]=10,["coinName"]="Family_Prestige",},--军团声望
	{["coinID"]=17,["coinName"]="XingHun",},--星魂
	
}
local SwitchType = {
	TYPE_COMMON_COPY = 1,
	TYPE_PATA        = 2,
	TYPE_GENERAL_JOB = 3,
	TYPE_GENERAL     = 4,
	TYPE_BATTLE      = 5,--阵容
	TYPE_PICK_COPY   = 6,--精英副本
	TYPE_ACTIVITY_COPY = 7,--活动副本
	TYPE_ARENA       = 8,--比武界面（竞技场）
	TYPE_GROGSHOP    = 9,--酒馆界面
	TYPE_DOBK        = 10,
	TYPE_SHOP        = 11,--商店界面
	TYPE_ITEM        = 12,--背包
	TYPE_COUNTRY_WAR = 13,--国战界面
	TYPE_DANYAO      = 14,--丹药炼化
	TYPE_CROPS      = 15,--军团功能
	TYPE_TASK       = 16,--任务界面
	TYPE_CHONGZHI    = 17,--充值界面
}
--指引标题
local tabGuideTitle = {
	{["nGType"]= 1,["sGTitle"] = "主线副本"},
	{["nGType"]= 2,["sGTitle"] = "通天塔"},
	{["nGType"]= 6,["sGTitle"] = "精英副本"},
	{["nGType"]= 7,["sGTitle"] = "活动副本"},
	{["nGType"]= 8,["sGTitle"] = "比武功能"},
	{["nGType"]= 14,["sGTitle"] = "丹药炼化"},
	{["nGType"]= 17,["sGTitle"] = "充值"},
}
local tabGrogshop = {
	"英雄酒馆",
	"银币酒馆",
	"金币酒馆",
}
local tabDobk = {
	"夺宝奇兵",
	"神武夺宝",
	"宝马夺宝",
}
local tabItemTitle= {
	"背包",
	"消耗品背包",
	"碎片背包",
	"将魂背包",
	"装备背包",
	"宝物背包",
	"灵宝背包",
}
local tabTaskTitle = {
	"任务",
	"主线任务",
	"日常任务",
	"国战任务",
	"军团任务",
	"试炼任务",
	"升级任务",
}
local tabShopInfo = {
	"应龙小铺",
	"比武商店",
	"军团商店",
	"神秘商店",
}
function GetItemNameByType(nType,nItemID)
	if tonumber(nType) == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM then
		return item.getFieldByIdAndIndex(nItemID,"name")
	end
	if tonumber(nType) == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN then
		return ConsumeTypeName[nItemID+1]
	end
end
local function GetUserOwnNum(nCoinID)
	for key,value in pairs(tabCoinName) do 
		if tonumber(value.coinID)== tonumber(nCoinID) then
			return server_mainDB.getMainData(value.coinName)
		end
	end
	
end
function GetOwnNum(tabData)
	local nType = tabData.nType
	local nItemID = tabData.itemID
	if nType == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN then
		local  nPos = coin.getFieldByIdAndIndex(nItemID,"object")
		if tonumber(nPos) == 1 then
			--说明记录在玩家的身上
			return GetUserOwnNum(nItemID)
		end
	end
	if nType == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM then
		return server_itemDB.GetItemNumberByTempId(nItemID)
	end
end

local function GetGuideRoadID(nType,nTempID)
	if nType == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_COIN then
		return coin.getFieldByIdAndIndex(nTempID,"go")
	end
	if nType == GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM then
		return item.getFieldByIdAndIndex(nTempID,"GoGroup")
	end
end

function GetRoadData(tabItemData)
	local nType = tabItemData.nType
	local nItemID = tabItemData.itemID
	local guideID = GetGuideRoadID(nType,nItemID)
	local tab = dropguide.getArrDataByField("GuideID",guideID)
	return tab
end
function GetIndexByValue(fildName)
	return dropguide.getIndexByField(fildName)
end	
function GetIconPath(nResID)
	if nResID == nil or nResID == 0 then
		print("资源路径出错")
		return ""
	end
	return resimg.getFieldByIdAndIndex(nResID,"icon_path")
end
local function GetTitle(nType)
	for key,value in pairs(tabGuideTitle) do 
		if tonumber(nType) == tonumber(value.nGType) then
			return value.sGTitle
		end
	end
	return nil
end
local function GetIndexByStr(key)
	local n = string.find(key,"_")
	local strIndex = string.sub(key,n+1,string.len(key))
	return tonumber(strIndex)
end
function GetDropGuideIndex(sTips)
	local tab = dropguide.getTable()
	for key,value in pairs(tab) do 
		if value[9] == sTips then
			return GetIndexByStr(key)
		end
	end
end
local function GetShopTitle(para4,para1,tabItemData)
	local sTitleType = shop.getFieldByIdAndIndex(para1,"ShopName")
	if para4 == 1 then
		return sTitleType
	end
	if para4 == 2 then
		return sTitleType..GetItemNameByType(tabItemData.nType,tabItemData.itemID)
	end
end
function GetTitleByType(nType,para4,para1,tabData)
	--[[print(nType,para4,para1)
	Pause()]]--
	if tonumber(para4)==0 then
		return  GetTitle(nType)
	end
	if tonumber(nType)==tonumber(SwitchType.TYPE_GROGSHOP) then
		--酒馆界面
		return tabGrogshop[tonumber(para4)]
	end
	if tonumber(nType)==tonumber(SwitchType.TYPE_DOBK) then
		--夺宝界面
		return tabDobk[tonumber(para4)]
	end
	if tonumber(nType) == tonumber(SwitchType.TYPE_SHOP) then
		--商店界面
		return GetShopTitle(tonumber(para4),tonumber(para1),tabData)
	end
	if tonumber(nType) == tonumber(SwitchType.TYPE_DANYAO) then
		return "丹药炼化"
	end
	if tonumber(nType) == tonumber(SwitchType.TYPE_ITEM) then 
		return tabItemTitle[tonumber(para4)]
	end
	if tonumber(nType) == tonumber(SwitchType.TYPE_TASK) then 
		return tabTaskTitle[tonumber(para4)]
	end
	
end
function GetGuideGroupDataByIndex(nIndex)
	return dropguide.getDataById(nIndex)
end

local function GetSceneIndex(sSceneName)
	for key,value in pairs(scence.getTable()) do 
		if value[scence.getIndexByField("Name")] == sSceneName then
			return GetIndexByStr(key)
		end
	end
end
--获得战役名称
local function GetGateName(nGateID,nCopyIndex)
	local tab = scence.getArrDataByField("ID",nGateID)
	local sGateName = tab[1][scence.getIndexByField("Name")]
	
	local nCopyID = tab[1][scence.getIndexByField("ID_"..nCopyIndex)]--scence.getFieldByIdAndIndex(GetSceneIndex(sGateName),"ID_"..nCopyIndex)
	local sCopyName = point.getFieldByIdAndIndex(nCopyID,"Name")
	return sGateName,sCopyName
end
function GetSceneIndexBySceneID(nType,nGateID)
	if nType == SwitchType.TYPE_COMMON_COPY or 
	   nType == SwitchType.TYPE_PATA        or 
	   nType == SwitchType.TYPE_PICK_COPY   or 
	   nType == SwitchType.TYPE_ACTIVITY_COPY    then
		local tab = scence.getArrDataByField("ID",nGateID)
		local sGateName = tab[1][scence.getIndexByField("Name")]
		return GetSceneIndex(sGateName)
	else
		return nGateID
	end
end
local function SwitchTypeGetSubTitle(nType,sText,tab)
	if nType == SwitchType.TYPE_COMMON_COPY or 
	   nType == SwitchType.TYPE_PATA        or 
	   nType == SwitchType.TYPE_PICK_COPY   or 
	   nType == SwitchType.TYPE_ACTIVITY_COPY    then
		--需要通配战役名称和副本名称
		local para1 = tab[GetIndexByValue("para1")]
		local para2 = tab[GetIndexByValue("para2")]
		return string.format(sText,GetGateName(para1,para2))
	end
	if nType == SwitchType.TYPE_SHOP  then
		
		local para1 = tab[GetIndexByValue("para1")]
		return string.format(sText,tabShopInfo[tonumber(para1)])
	end
	if nType == SwitchType.TYPE_ITEM then
		local para2 = tab[GetIndexByValue("para2")]
		return string.format(sText,GetItemNameByType(GUIDE_MANAGER_TYPE.GUIDE_MANAGER_TYPE_ITEM,para2))
	end
	return ""
end
function GetSubTitle(nIndex)
	local tab = GetGuideGroupDataByIndex(nIndex)
	local nType = tab[GetIndexByValue("Type")]
	local subTitle = tab[GetIndexByValue("text")]
	local i = string.find(subTitle,"%%")
	if i~=nil then
		--说明有通配
		return SwitchTypeGetSubTitle(tonumber(nType),subTitle,tab)
	else
		return subTitle
	end
end
--获取副本已经进入次数 para1 场景的ID
function GetCopyTimes(nType,para1,para2)
	if nType == SwitchType.TYPE_COMMON_COPY then
		return server_fubenDB.GetPointLeftTimes(DungeonsType.Normal, para1, para2)
	end
	if nType == SwitchType.TYPE_PICK_COPY then
		return server_fubenDB.GetEliteFightedTimes()
	end
	if nType == SwitchType.TYPE_ACTIVITY_COPY then
		return server_fubenDB.GetPointLeftTimes(DungeonsType.Activity, para1, nil)
	end
	return nil
end
--获取一日可以进去的总次数
function GetTotalCopyTimes(para1)
	--print(para1)
	local tab = scence.getArrDataByField("ID",para1)
	--[[printTab(tab)
	print(scence.getIndexByField("RuleID"))
	Pause()]]--
	local ruleID = tab[1][scence.getIndexByField("RuleID")]
	local nTimes = scenerule.getFieldByIdAndIndex(ruleID,"Times") 
	if tonumber(nTimes)==-1 then
		return "无限"
	end
	return nTimes
	
end

function GetGuideTipsByIndex(nIndex)
	return dropguide.getFieldByIdAndIndex(nIndex,"Tips")
end