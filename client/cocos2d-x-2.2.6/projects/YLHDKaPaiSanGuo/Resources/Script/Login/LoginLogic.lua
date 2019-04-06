
--create by celina ----
--登陆逻辑部分---
--require "Script/Network/network"


module("LoginLogic", package.seeall)


--联网的调用和隐藏
local  showNetWorkLayer = NetWorkLoadingLayer.loadingShow
local  hideNetWorkLayer = NetWorkLoadingLayer.loadingHideNow

local m_login_over_callback = nil 

	
	
function GetDynamicID()
	for key,value in pairs (CommonData.g_ServerListTable) do 
		if getServerName() == value["ServerName"]  then
			return value["MapServerDynamicID"]
		end
	end
	return 0
end
	
function checkHaveAccount()
	--现在还没有账号记录，先
	--local name = 
end

local function LinkLoginMS()
	local function LoginOver(nFirst)
		hideNetWorkLayer()
		--print("LinkLoginMS")
		--print(nFirst)
		--Pause()
		if nFirst ~= nil and tonumber(nFirst) == 1 then
			--之前没有创建角色
			--print("之前没有创建角色")
			--Pause()
			if m_login_over_callback~=nil then
				m_login_over_callback(0)
				m_login_over_callback = nil
			end
		else
			--print("之前创建角色")
			--Pause()
			if m_login_over_callback~=nil then
				m_login_over_callback(1)
				m_login_over_callback = nil
			end
		end
	end
	--print("LinkLoginMS")
	--Pause()
	Packet_LoginMS.SetSuccessCallBack(LoginOver)
	network.NetWorkEvent(Packet_LoginMS.CreatPacket())
end

local function LinkLoginMS_ReLink()
	local function LoginOver(nFirst)
		hideNetWorkLayer()
		
		if nFirst ~= nil and tonumber(nFirst) == 1 then
			--之前没有创建角色
			--print("之前没有创建角色")
			--Pause()
			if m_login_over_callback~=nil then
				m_login_over_callback(0)
				m_login_over_callback = nil
			end
		else
			--print("之前创建角色")
			--Pause()
			if m_login_over_callback~=nil then
				m_login_over_callback(1)
				m_login_over_callback = nil
			end
		end
	end
	--print("LinkLoginMS")
	--Pause()
	Packet_LoginMS.SetSuccessCallBack(LoginOver)
	network.NetWorkEvent_Opt(Packet_LoginMS.CreatPacket())
end

local function LinkJoinMS(bLoginGS)	
	--print("LinkJoinMS")
	--Pause()
	if bLoginGS == true then
		Packet_JoinMS.SetSuccessCallBack(LinkLoginMS)
		network.NetWorkEvent(Packet_JoinMS.CreatPacket())
	else
		
		showNetWorkLayer(false)
		
		--断开重新连接
		print("1=======")
		network.LuaNetWorkConect(false)
		LoginLayer.SetEnterTouch()
		AccountLoginLayer.SetEnterGame(true)
	end
end

local function LinkJoinMS_ReLink(bLoginGS)	
	
	if bLoginGS == true then
		Packet_JoinMS.SetSuccessCallBack(LinkLoginMS_ReLink)
		network.NetWorkEvent_Opt(Packet_JoinMS.CreatPacket())
	else
		
		showNetWorkLayer(false)
		
		--断开重新连接
		print("2=======")
		network.LuaNetWorkConect(false)
		LoginLayer.SetEnterTouch()
		AccountLoginLayer.SetEnterGame(true)
	end
end

local function LinkGS()
	showNetWorkLayer(true)
	
	Packet_LoginGS.SetSuccessCallBack(LinkJoinMS)
	print("LinkGS")
	network.NetWorkEvent(Packet_LoginGS.CreatPacket())
end

local function LinkGS_ReLink()
	showNetWorkLayer(true)
	
	Packet_LoginGS.SetSuccessCallBack(LinkJoinMS_ReLink)
	
	network.NetWorkEvent_Opt(Packet_LoginGS.CreatPacket())
end


function dealLogin(stateCallBack)
	m_login_over_callback = stateCallBack
	LinkGS()
	
end

function dealLogin_ReLink(stateCallBack)
	m_login_over_callback = stateCallBack
	LinkGS_ReLink()
	
end


function DealSDKLogin(strID,strKey)
	local function SDKLogin(nTag)
		if nTag ==0 then
			--创建角色
			StartScene.changeCreateRoleScene()
			--StartScene.changeLayer(CreateRoleLayer.createNewRoleLayer())
		elseif nTag ==1 then
			
			local function getSuccessful()
				--print("getSuccessful")
				--Pause()
				--callBackSuccess()
				LoginCommon.ShowLoading()
			end
			
			GetLoginData(getSuccessful)
		end
	end
	m_login_over_callback = SDKLogin
	local function GetOK()
		local serverName = getServerName()
		saveServerName(serverName)
		--写dataeye
		if CommonData.IsDataeye() == true then
			require "DataEye/luaScript/DCAccount"
			DCAccount.setGameServer(serverName)
		end
		Packet_LoginGS.SetSuccessCallBack(LinkJoinMS)
		network.NetWorkEvent(Packet_SDKLogin.CreatPacket(strID,strKey))
	end
	NetWorkLoadingLayer.ClearLoading()
	showNetWorkLayer(true)
	Packet_ServerList.SetSuccessCallBack(GetOK)
	network.NetWorkEvent(Packet_ServerList.CreatPacket())
	
end
--断线重新连接
function DealSDKLogin_Again(strID,strKey)
	print("DealSDKLogin_Again")
	local function SDKLoginAgain(nTag)
		print("重连成功")
		network.SetReLinkState(0)
		print("m_Rellink == 0")
		network.NetWorkReLink_Packet()
		if nTag ==0 then
			--创建角色
			StartScene.changeCreateRoleScene()
		elseif nTag ==1 then
			local function getSuccessful()
				local bMainScene = CCUserDefault:sharedUserDefault():getBoolForKey("isMainScene")
				if bMainScene == false then
					LoginCommon.ShowLoading()
				end
			end
			GetLoginData(getSuccessful)
		end
	end
	m_login_over_callback = SDKLoginAgain
	Packet_LoginGS.SetSuccessCallBack(LinkJoinMS_ReLink)
	network.NetWorkEvent_Opt(Packet_SDKLogin.CreatPacket(strID,strKey))	
end

function getServerID(server_name)
	for key,value in pairs(CommonData.g_ServerListTable) do
		if value["ServerName"] == server_name then
			--print("key"..key)
			--Pause()
			return key,value["MapServerDynamicID"] 
		end
	end
	--print("getServerID Error not find server_name = " .. server_name)
	return 1,CommonData.g_ServerListTable[1]["MapServerDynamicID"]
end
--获得服务器列表
function getServerList(listCallBack)
	-- 显示loading界面
	NetWorkLoadingLayer.ClearLoading()
	showNetWorkLayer(true)
	local function getList()
		hideNetWorkLayer()
		if listCallBack~=nil then
			listCallBack()
		end
	end
	Packet_ServerList.SetSuccessCallBack(getList)
	network.NetWorkEvent(Packet_ServerList.CreatPacket())
end
function SaveUserInfo(m_strText_username,m_strText_password)
	CCUserDefault:sharedUserDefault():setStringForKey("userName", m_strText_username)
	CCUserDefault:sharedUserDefault():setStringForKey("userPassword",m_strText_password)
end

function SaveFightSet( nFightState )
	CCUserDefault:sharedUserDefault():setBoolForKey("FightSet", nFightState)
end

function GetFightSet()
	return CCUserDefault:sharedUserDefault():getBoolForKey("FightSet")
end

function GetUserName()
	return CCUserDefault:sharedUserDefault():getStringForKey("userName")
end
function GetPassWord()
	return CCUserDefault:sharedUserDefault():getStringForKey("userPassword")
end

local function getUserServerName()
	return CCUserDefault:sharedUserDefault():getStringForKey("server_name")
end
function getServerName()
	if table.getn(CommonData.g_ServerListTable) <= 0 then
		return nil 
	end
	local select_name = getUserServerName()
	if select_name == "" then
		return CommonData.g_ServerListTable[1]["ServerName"]
	end
	return select_name
end
function getServerListCount()
	local count = #CommonData.g_ServerListTable
	return count
end
function getServerNameByID(nID)	
	if table.getn(CommonData.g_ServerListTable) <= 0 then
		return nil 
	end
	return CommonData.g_ServerListTable[nID]["ServerName"]
end

--检测服务器是否为空
local function checkServerHave()
	if table.getn(CommonData.g_ServerListTable) <= 0 then
		return false
	end
	return true
end

--检测服务器有没有当前选择的
function checkServer()
	local serverName = getServerName()
	local bHave = checkServerHave()
	if bHave == false then
		return "没有服务器列表"
	end
	for key,value in pairs(CommonData.g_ServerListTable) do 
		if value["ServerName"] == serverName then
			return ""
		end
	end
	return "当前服务器不可用，请重新选择"
end



function saveServerName(str_name)
	CommonData.g_nCurServerIndex ,CommonData.g_nCurServerMapID= getServerID(str_name)
	CCUserDefault:sharedUserDefault():setStringForKey("server_name",str_name)
end
local tab= {
	"基础数据",
	"邮件",
	"背包",
	"装备",
	"武将",
	"阵容",
	"专精",
	"副本",
	"副本",
	"副本",
	"签到",
	"VIP领取",
}
function GetLoginData(callLoading)
	
	local nDataCount = 0
	local function CheckOver(nPacketID,nType)	
		print("nPacketID:"..nPacketID)
		if nType~=nil then
			print("nType:"..nType)
		end
		nDataCount = nDataCount +1
		print("nDataCount:"..nDataCount)
		print(tab[nDataCount])
		if nDataCount == 12 then 
			print("进入登录")
			NetWorkLoadingLayer.loadingHideNow()
			callLoading()
		end
	end
	

	Packet_GetBaseData.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetBaseData.CreatPacket())
	
	Packet_GetMailList.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetMailList.CreatPacket())

	Packet_GetItemList.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetItemList.CreatPacket())

	Packet_GetEquipList.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetEquipList.CreatPacket())

	Packet_GetGeneralList.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetGeneralList.CreatPacket())

	Packet_GetMatrix.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetMatrix.CreatPacket())

	Packet_GetZhuanJing.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_GetZhuanJing.CreatPacket())

	Packet_GetFuBenInfo.SetSuccessCallBack(CheckOver,  DungeonsType.Normal)
	network.NetWorkEvent(Packet_GetFuBenInfo.CreatPacket(DungeonsType.Normal))

	Packet_GetFuBenInfo.SetSuccessCallBack(CheckOver, DungeonsType.Elite)
	network.NetWorkEvent(Packet_GetFuBenInfo.CreatPacket(DungeonsType.Elite))

	Packet_GetFuBenInfo.SetSuccessCallBack(CheckOver, DungeonsType.Activity)
	network.NetWorkEvent(Packet_GetFuBenInfo.CreatPacket(DungeonsType.Activity))

	Packet_SignInReward.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_SignInReward.CreatePacket())
	
	Packet_VIPRewardStatus.SetSuccessCallBack(CheckOver)
	network.NetWorkEvent(Packet_VIPRewardStatus.CreatePacket())

	NetWorkLoadingLayer.loadingShow(true)
end

local function CheckAscii(strCheck,nType)
	if strCheck ==nil or strCheck == "" then
		if nType == 1 then
			TipLayer.createTimeLayer("请输入账号", 2)
			
		else
			--TipLayer.createTimeLayer("请输入密码", 2)
			--print("====================")
		end
		return false
	end
	local bSpace = false
	local bWord = false
	local bFeiFa = true
	local nEng = 0
	for i=1,#strCheck do 
		local nAscii = string.byte(strCheck,i)
		local byteCount = 1
		if nAscii == 32 then
			bSpace = true
		end
		if nAscii<48 then
			return false
		end
		if nAscii>57 and nAscii<65 then
			return false
		end
		if nAscii>90 and nAscii<97 then
			return false
		end
		if nAscii>122 and nAscii<=127 then
			return false
		end
		if nAscii>0 and nAscii<=127 then
			byteCount = 1
		else
			bWord = true
		end
		--local char = string.sub(str, i, i+byteCount-1)
		i = i + byteCount -1
		if byteCount == 1 then
			nEng = nEng +1
		end
	end
	if bSpace == true then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1623,nil)
		pTips = nil
		return false
	end
	if bWord == true then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1624,nil)
		pTips = nil
		return false
	end	
	if nEng <= 12 and nEng>=6 then
		return true
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1625,nil)
		pTips = nil
		return false
	end

end
--检测账号规则
local function checkAccountInput(str_account)
	local bCheck = CheckAscii(str_account,1)
	return bCheck
end
--检测账号是否被占用
local function checkAccountHave(str_account)
	--目前只检测本地保存的那个账号，，，，暂时不检测
	--[[local sNowName = GetUserName()
	if sNowName == str_account then
		return false
	end]]--
	return true
end
local function checkPasswordInput(str_password) 
	local bCheck = CheckAscii(str_password,2)
	return bCheck
end
local function checkPasswordAgain(str_password,str_a_paddword)
	if str_password ~= str_a_paddword then
		return false
	end
	return true
end
function CheckRegisterLogin(str_account,str_mm,str_amm)
	--检测账号是否符合规则
	if checkAccountInput(str_account) == true then
		--检测账号是否被占用
		if checkAccountHave(str_account) == false then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1626,nil)
			pTips = nil
			return false
		else
			--检测密码是否符合规则
			if checkPasswordInput(str_mm) == false then
				local pTips = TipCommonLayer.CreateTipLayerManager()
				pTips:ShowCommonTips(1627,nil)
				pTips = nil
				return false
			else
				if str_amm~=nil then
					--检测确认密码是否符合规则
					if checkPasswordAgain(str_mm,str_amm) == false then
						local pTips = TipCommonLayer.CreateTipLayerManager()
						pTips:ShowCommonTips(1628,nil)
						pTips = nil
						return false
					else
						return true
					end
				else
					return true
				end
			end
		end
	else
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1625,nil)
		pTips = nil
		return false
	end
	
end

function checkEnterLogin()
	-- 6 < * < 16
	--[[Pause()
	if string.len(GetUserName()) <= 5 or string.len(GetPassWord()) <= 5 then
		return false
	end
	return true]]--
	--print("checkEnterLogin")
	return CheckRegisterLogin(GetUserName(),GetPassWord(),nil)
end
--检测之前的是否有账号，有，返回之前的账号列表（功能等服务器协调好在写）
local function getTableAccount ()
	local table_l = {}
	for i=1,4 do 
		local new_table = {}
		new_table.a_name ="yanyanyan"..i
		new_table.a_mm   = "1111111"
		table.insert(table_l,new_table)
		new_table = nil 
	end
	return table_l
end
function getTableByTag(nTag)
	local table_l = getTableAccount()
	return table_l[nTag]
end
function CheckAccountCount()
	local table_account ={} --[[getTableAccount()
	local myTable = {}
	myTable.a_name = GetUserName()
	myTable.a_mm  =GetPassWord()
	table.insert(table_account,myTable)
	myTable = nil 
	
	local endTable = {}
	endTable.a_name = "其他账号"
	endTable.a_mm  = ""
	table.insert(table_account,endTable)
	endTable = nil ]]--
	return table_account
end
--add celina
--[[local function GetDownLoadVersionNow(sVersion)
	local n = string.find(sVersion,"|")
	return string.sub(sVersion,0,n-1)
end
function CheckBUpdate()
	--下载入口
	local g_strVersion = getAllUpdateVersion(CommonData.g_szFtpUrl .. "/rootver.ini")
	--得到版本后再和本地的g_CUR_VERSION 比较一下如果本地的版本号大那么也不下载
	if g_strVersion~=""then
		local dVersion = tonumber(GetDownLoadVersionNow(g_strVersion))
		if tonumber(dVersion)<tonumber(CommonData.g_CUR_VERSION) then
			return false
		end
		LoginLayer.deleteLayer()
		--AutoUpdateLayer.createAutoUpdateLayer(strAllVer)
		--LoadingNewLayer.CreateLoadingLayer( LOADING_TYPE.LOADING_TYPE_DOWN_LOAD,strAllVer )
		
		LoadingNewLayer.ShowLoading(true,LOADING_TYPE.LOADING_TYPE_DOWN_LOAD,g_strVersion,false)
		return true
	end
	return false
end]]--
