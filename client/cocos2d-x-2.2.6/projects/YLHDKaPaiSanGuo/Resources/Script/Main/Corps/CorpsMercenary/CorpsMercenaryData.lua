require "Script/serverDB/server_MercenaryInfoDB"
require "Script/serverDB/server_MercenaryRobotDB"
require "Script/serverDB/server_MercenaryRefreshDB"
require "Script/serverDB/server_MercenaryCampInfo"
require "Script/serverDB/coin"
require "Script/serverDB/legioicon"
require "Script/serverDB/globedefine"
require "Script/serverDB/resimg"
require "Script/serverDB/consume"
require "Script/serverDB/technolog"
require "Script/serverDB/effect"
require "Script/serverDB/item"
require "Script/serverDB/mercenary"
require "Script/serverDB/vipfunction"
module("CorpsMercenaryData",package.seeall)

--得到VIP需求等级
function GainVIPGrid( nIndex )
	local tab = vipfunction.getDataById(nIndex)
	return tab[5]
end

--获取佣兵格子解锁等级
function GetMercenaryGridLevel( nIndex )
	local tab = globedefine.getDataById("Mercenary")
	local GridLevel = tab[nIndex+1]
	return GridLevel
end

--获取已有佣兵的信息
function GetYetMercenaryInfo(  )
	return server_MercenaryInfoDB.GetCopyTable()
end
--获取佣兵剩余时间
function GetTabIndeXTime( index)
	local tab = GetYetMercenaryInfo()
	return tab[index].times
end

function GetYetMercenaryID( nIndex )
	return server_MercenaryInfoDB.GetMercenaryID(nIndex)
end

--获取佣兵等级
function GetTabIndeXLevel( index )
	return server_MercenaryInfoDB.GetLevel(index)
end

--获取佣兵机器人的信息
function GetMercenaryRobotInfo(  )
	return server_MercenaryRobotDB.GetCopyTable()
end

function GetMercenaryRefreshRobot(  )
	return server_MercenaryRefreshDB.GetCopyTable()
end
--获取可刷新次数
function  GetRefreshNum(  )
	return server_MercenaryRobotDB.GetRefreshNum()
end
function GetYetRefreshNum(  )
	return server_MercenaryRefreshDB.GetRefreshNum()
end

--得到品质框图像路径
function GetColorImgPath( nTempID )
	return string.format("Image/imgres/common/color/wj_pz%d.png",nTempID)
end
--获得佣兵头像path
function GetRobotImg( nTempID )
	return resimg.getFieldByIdAndIndex(nTempID,"icon_path")
end

--得到佣兵的折扣系数
function GetHireRebate( num )
	local hireRebateTab = globedefine.getDataById("Mercenary_Hire")
	local discount_factor = hireRebateTab[num]/1000
	return discount_factor
end

function GetRewenRebate( num )
	local hireRebateTab = globedefine.getDataById("Mercenary_Renew")
	local discount_factor = hireRebateTab[num]/1000
	return discount_factor
end
--得到允许续费最大天数
function GetDayRebate(  )
	local hireRebateTab = globedefine.getDataById("Mercenary_Renew")

	return tonumber(hireRebateTab[5])
end

--得到续费的折扣
function GetXuFeiDis( nGrid )
	local hireRebateTab = globedefine.getDataById("Mercenary_Renew")
	return tonumber(hireRebateTab[nGrid]/1000)
end
--得到佣兵续费的消耗
function GetXuFeiConsum( nMercenaryID )
	-- local mercHireID = mercenary.getFieldByIdAndIndex(nMercenaryID,"MercHireID")
	local tab = mercenary.getArrDataBy2Field("RobType",nMercenaryID)
	
	local h_Data = ConsumeLogic.GetExpendData(tab[1][4])
	return h_Data
end
--得到刷新消耗货币类型及消耗数量
function GetRefreshConsum(  )
	local consumID = globedefine.getFieldByIdAndIndex("Legio_YongBing","Para_5")
	local refreshConsum = ConsumeLogic.GetExpendData(consumID)
	return refreshConsum.TabData[1]["ItemNeedNum"],refreshConsum.TabData[1]["IconPath"]
end

function GetTeffectPara( nTempID ,num)
	local tabData = effect.getDataById(nTempID)
	local mercHireID = mercenary.getFieldByIdAndIndex(tabData[num],"MercHireID")
	local h_Data = ConsumeLogic.GetExpendData(mercHireID)
	-- printTab(h_Data)
	-- Pause()
	local consumeTab = consume.getDataById(mercHireID)
	local dis_count = GetHireRebate(num-1)
	local CostNum = consumeTab[3]*dis_count -- 获取消耗数量
	local dis_costNum = math.floor(CostNum)
	local coinTab = coin.getDataById(consumeTab[2])
	local costImg = resimg.getFieldByIdAndIndex(coinTab[2],"icon_path")--获取消耗图片路径
	return h_Data.TabData[1]["ItemNeedNum"],h_Data.TabData[1]["IconPath"],dis_count,consumeTab[3]

end

function GetMercenaryHireConsum( nMercenaryID,num )
	-- local mercHireID = mercenary.getFieldByIdAndIndex(nMercenaryID,"MercHireID")
	local tab = mercenary.getArrDataBy2Field("RobType",nMercenaryID)
	
	local h_Data = ConsumeLogic.GetExpendData(tab[1][3])
	local dis_count = GetHireRebate(num-1)
	return h_Data.TabData[1]["ItemNeedNum"],h_Data.TabData[1]["IconPath"],dis_count
end

--通过全局定义表获得免费刷新次数
function GetFreeRefreshNum(  )
	local GlobeFreeNum = globedefine.getFieldByIdAndIndex("Legio_YongBing","Para_4")
	return GlobeFreeNum
end

function GetHireTotalNum(  )
	local tableHire = globedefine.getDataById("Mercenary")
	return tableHire[1],tableHire[2],tableHire[3],tableHire[4]
end

--得到佣兵阵营头像等信息
function GetMercenaryCampInfo(  )
	return server_MercenaryCampInfo.GetCopyTable()
end
--得到血战消耗的信息
function GetBloodConsumInfo(  )
	return server_MercenaryCampInfo.GetBComsumTable()
end
--得到雇佣消耗的信息
function GetHireConsumInfo(  )
	return server_MercenaryCampInfo.GetHConsumTable()
end

function GetBHConsumPath( nTempID )
	local rmgID = coin.getFieldByIdAndIndex(nTempID,"ResID")
	return resimg.getFieldByIdAndIndex(rmgID,"icon_path")
end

function GetConsumItem( nTempID )
	local imgID = item.getFieldByIdAndIndex(nTempID,"res_id")
	return resimg.getFieldByIdAndIndex(rmgID,"icon_path")
end

function GetMoneyNumByID( nIndex )
	local moneyNum = 0
	if tonumber(nIndex) == 1 then
		moneyNum = CommonData.g_MainDataTable.silver
	elseif tonumber(nIndex) == 2 then
		moneyNum = CommonData.g_MainDataTable.gold
	elseif tonumber(nIndex) == 3 then
		moneyNum = CommonData.g_MainDataTable.tili
	elseif tonumber(nIndex) == 4 then
		moneyNum = CommonData.g_MainDataTable.naili
	elseif tonumber(nIndex) == 10 then
		moneyNum = CommonData.g_MainDataTable.Family_Prestige
	elseif tonumber(nIndex) == 13 then
		m,moneyNum = CorpsData.GetCorpsMoney()
	end
	return moneyNum
end

--使用本地时间算出佣兵剩余时间
function GetResTime(  )
	--佣兵剩余时间
	local ResdiumTime = os.date("*t")
	local m_sec = tonumber(ResdiumTime.sec)
	local m_min = tonumber(ResdiumTime.min)
	local m_hour = tonumber(ResdiumTime.hour)
	local n_sec = 0
	local n_min = 0
	local n_hour = 24
	local s_sec = 0
	local s_min = 0
	local s_hour = 0
	local totalTime = 0
	if m_hour <= 24 then
		if m_sec == 0 then
			if m_min == 0 then
				s_hour = n_hour - m_hour
			else
				s_min = 60 - m_min
				s_hour = n_hour - 1 - m_hour
			end
		else
			if m_min == 0 then
				s_sec = 60 - m_sec
				m_min = 59
				s_hour = n_hour - 1 - m_hour
			else
				s_sec = 60 - m_sec
				s_min = 59 - m_min
				s_hour = n_hour - 1 - m_hour
			end 
		end
		totalTime = s_hour*3600 + s_min*60 + s_sec + 4*3600 + 5*60

	else
		if m_sec == 0 then
			if m_min == 0 then
				s_hour = 4 - m_hour
			else
				s_min = 60 - m_min
				s_hour = 4 - 1 - m_hour
			end
		else
			if m_min == 0 then
				s_sec = 60 - m_sec
				m_min = 59
				s_hour = 4 - 1 - m_hour
			else
				s_sec = 60 - m_sec
				s_min = 59 - m_min
				s_hour = 4 - 1 - m_hour
			end 
		end
		totalTime = s_hour*3600 + s_min*60 + s_sec + 5*60
	end
	local ss_hour = math.floor(totalTime/3600)
	local ss_min = math.ceil(totalTime/60) - ss_hour*60
	if tonumber(ss_min) == 60 then
		ss_hour = ss_hour + 1
		ss_min = ss_min - 1
	end
	return totalTime,ss_hour,ss_min
end