local cjson = require "json"

module("server_mainDB", package.seeall)

local m_tableMainDB = {}

local tabUpdate = {
	"name",
	"gender",
	"level",
	"tili",
	"naili",
	"power",
	"exp",
	"lvexp",
	"gold",
	"silver",
	"vip",
	"VIPExp",
	"official",
	"max_tili",
	"max_naili",
	"GeneralExpPool",
	"BiWu_Prestige",
	"Family_Prestige",
	"ZhanJiang_Prestige",
	"XingHun",
	"JobID",
	"JobGeneralID",
	"nGrid",
	"nHeadID",
	"nModeID",
	"nLuckydrawNum_Sliver",
	"nLuckydrawNum_Gold",
	"nCountDown_Sliver",
	"nCountDown_Gold",
	"nCorps",
	"nCountry",
	"corpsName",
	"MonthCardA",
	"VIP_Limite",
	"NameTimes",--35
	"VipFuben",
	"VipActivity",
	"VipPata",
	"VipBiWu",
	"VipJT",
	"VipST",
	"VipBiWuCD",
	"VipJTRW",
	"BWTimes",
	"NumTask",
	"NumCorps",
	"NumFog",
	"NumTask_Shilian",
	"Guide",
	"ChatNum",
	"historyTour",
	"firstCharge",
}
function SetTableBuffer(buffer)
	m_tableMainDB = {}
	local pNetStream = NetStream()
    pNetStream:SetPacket(buffer)
	local status = pNetStream:Read()
	m_tableMainDB.name = pNetStream:Read()
	m_tableMainDB.gender = pNetStream:Read()--性别
	m_tableMainDB.level = pNetStream:Read()
	m_tableMainDB.tili = pNetStream:Read()
	m_tableMainDB.naili = pNetStream:Read()
	m_tableMainDB.power = pNetStream:Read() --战斗力
	m_tableMainDB.exp = pNetStream:Read() --主将经验
	m_tableMainDB.lvexp = pNetStream:Read()
	m_tableMainDB.gold = pNetStream:Read()
	m_tableMainDB.silver = pNetStream:Read()
	m_tableMainDB.vip = pNetStream:Read()
	m_tableMainDB.VIPExp = pNetStream:Read()
	m_tableMainDB.official = pNetStream:Read()
	m_tableMainDB.max_tili = pNetStream:Read()
	m_tableMainDB.max_naili = pNetStream:Read()
	m_tableMainDB.GeneralExpPool = pNetStream:Read()--武将经验
	m_tableMainDB.BiWu_Prestige = pNetStream:Read()--比武声望
	m_tableMainDB.Family_Prestige = pNetStream:Read()--军团声望
	m_tableMainDB.ZhanJiang_Prestige = pNetStream:Read()--
	m_tableMainDB.XingHun = pNetStream:Read()
	m_tableMainDB.JobID = pNetStream:Read()
	m_tableMainDB.JobGeneralID = pNetStream:Read()
	m_tableMainDB.nGrid = pNetStream:Read()
	m_tableMainDB.nHeadID = pNetStream:Read()
	--[[if tonumber(m_tableMainDB.nHeadID)==0 then
		m_tableMainDB.nHeadID = 141
	end]]--
	m_tableMainDB.nModeID = pNetStream:Read()
	m_tableMainDB.nLuckydrawNum_Sliver = pNetStream:Read()
	m_tableMainDB.nLuckydrawNum_Gold = pNetStream:Read()
	m_tableMainDB.nCountDown_Sliver = pNetStream:Read()
	m_tableMainDB.nCountDown_Gold = pNetStream:Read()
	m_tableMainDB.nCorps = pNetStream:Read()
	m_tableMainDB.nCountry = pNetStream:Read()
	m_tableMainDB.corpsName = pNetStream:Read()
	m_tableMainDB.MonthCardA = pNetStream:Read() --月卡A
	m_tableMainDB.MonthCardB = pNetStream:Read() --月卡B
	m_tableMainDB.VIP_Limite = pNetStream:Read() --读取VIP权限
	m_tableMainDB.VIP_Limite1 = pNetStream:Read()--读取VIP权限1
	m_tableMainDB.NameTimes = pNetStream:Read() 
	m_tableMainDB.VipFuben = pNetStream:Read()  --精英战役的挑战次数购买
	m_tableMainDB.VipActivity = pNetStream:Read()  --活动战役的挑战次数购买
	m_tableMainDB.VipPata = pNetStream:Read()  --爬塔重置次数购买
	m_tableMainDB.VipBiWu = pNetStream:Read()  --比武挑战次数购买
	m_tableMainDB.VipJT = pNetStream:Read()  --军团捐献次数购买
	m_tableMainDB.VipST = pNetStream:Read()  --食堂领取次数购买
	m_tableMainDB.VipBiWuCD = pNetStream:Read()  --比武CD购买
	m_tableMainDB.VipJTRW = pNetStream:Read()  --军团任务次数购买
	m_tableMainDB.BWTimes = pNetStream:Read()  --比武次数
	m_tableMainDB.NumTask = pNetStream:Read() --完成国战任务数量
	m_tableMainDB.NumCorps = pNetStream:Read() --完成军团任务数量
	m_tableMainDB.NumFog = pNetStream:Read() --解锁迷雾数量
	m_tableMainDB.NumTask_Shilian = pNetStream:Read() --试炼任务完成次数 
	m_tableMainDB.Guide   = pNetStream:Read() --新手引导
	m_tableMainDB.ChatNum   = pNetStream:Read()
	m_tableMainDB.historyTour = pNetStream:Read()
	m_tableMainDB.firstCharge = pNetStream:Read() -- vip首冲标记
end

function getMainData(keyData)
	return m_tableMainDB[keyData]
end
--更新基本数据 celina 更新的类型和更新的值
function UpdateBaseInfo(tab)
	for i=1,#tab do
		
		--写日志
		if CommonData.IsDataeye() == true then
			if tonumber(tab[i][1]) == 3 then --等级提升				
				require "DataEye/luaScript/DCAccount"
				DCAccount.setLevel(tonumber(tab[i][2]))				
			end
		end
		
		
		if tonumber(tab[i][1]) == 33 then
			m_tableMainDB[tabUpdate[tab[i][1]]] = tab[i][2]
			m_tableMainDB["MonthCardB"] = tab[i][3]
		elseif tonumber(tab[i][1]) == 34 then
			m_tableMainDB[tabUpdate[tab[i][1]]] = tab[i][2]
			m_tableMainDB["VIP_Limite1"] = tab[i][3]
		else
			m_tableMainDB[tabUpdate[tab[i][1]]] = tab[i][2]
		end
	end
	if MainScene.GetObserver()~=nil then
		MainScene.GetObserver():Notify()
	end
end

function release()
    m_tableMainDB = nil
    package.loaded["server_mainDB"] = nil
end