module("Packet_GetBaseData", package.seeall)
require "Script/Main/MainScene"

--local cjson	= require "json"

local m_funSuccessCallBack = nil




local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
}

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GETBASEDATA)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	
	print("发送BaseData")
	return pNetStream:GetPacket()

end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		-- print("Packet_GetBaseData")
		require "Script/serverDB/server_mainDB"
		server_mainDB.SetTableBuffer(PacketData)
	
		CommonData.g_MainDataTable.name = pNetStream:Read()
		CommonData.g_MainDataTable.gender = pNetStream:Read()
		CommonData.g_MainDataTable.level = pNetStream:Read()
		CommonData.g_MainDataTable.tili = pNetStream:Read()
		CommonData.g_MainDataTable.naili = pNetStream:Read()
		CommonData.g_MainDataTable.power = pNetStream:Read()
		CommonData.g_MainDataTable.exp = pNetStream:Read()
		CommonData.g_MainDataTable.lvexp = pNetStream:Read()
		CommonData.g_MainDataTable.gold = pNetStream:Read()
		CommonData.g_MainDataTable.silver = pNetStream:Read()
		CommonData.g_MainDataTable.vip = pNetStream:Read()
		CommonData.g_MainDataTable.VIPExp = pNetStream:Read()
		CommonData.g_MainDataTable.official = pNetStream:Read()
		CommonData.g_MainDataTable.max_tili = pNetStream:Read()
		CommonData.g_MainDataTable.max_naili = pNetStream:Read()
		CommonData.g_MainDataTable.GeneralExpPool = pNetStream:Read()
		CommonData.g_MainDataTable.BiWu_Prestige = pNetStream:Read()
		CommonData.g_MainDataTable.Family_Prestige = pNetStream:Read()
		CommonData.g_MainDataTable.ZhanJiang_Prestige = pNetStream:Read()
		CommonData.g_MainDataTable.XingHun = pNetStream:Read()
		CommonData.g_MainDataTable.JobID = pNetStream:Read()
		CommonData.g_MainDataTable.JobGeneralID = pNetStream:Read()
		CommonData.g_MainDataTable.nGrid = pNetStream:Read()
		CommonData.g_MainDataTable.nHeadID = pNetStream:Read()
		--[[if CommonData.g_MainDataTable.nHeadID==nil then
			CommonData.g_MainDataTable.nHeadID = 141
		end]]--
		CommonData.g_MainDataTable.nModeID = pNetStream:Read()
		CommonData.g_MainDataTable.nLuckydrawNum_Sliver = pNetStream:Read()
		CommonData.g_MainDataTable.nLuckydrawNum_Gold = pNetStream:Read()
		CommonData.g_MainDataTable.nLuckydrawTime_Sliver = pNetStream:Read()
		CommonData.g_MainDataTable.nLuckydrawTime_Gold = pNetStream:Read()
		CommonData.g_MainDataTable.nCorps = pNetStream:Read()
		CommonData.g_MainDataTable.Info01 = {}
		
		--MainScene.Update()
		--[[
		local tableTemp = pNetStream:Read()
		
    	for key, value in pairs(tableTemp) do
    		CommonData.g_MainDataTable.Info01[key] = {}
    		CommonData.g_MainDataTable.Info01[key]["GeneralID"] = value[1]
    		CommonData.g_MainDataTable.Info01[key]["JiHuo"] = value[2]
    		CommonData.g_MainDataTable.Info01[key]["Info01"] = {}
    		CommonData.g_MainDataTable.Info01[key]["Info01"]["ZhuanJingAttributeID"] =value[3][1]
    		CommonData.g_MainDataTable.Info01[key]["Info01"]["ZhuanJingAttributeLV"] =value[3][2]
    		CommonData.g_MainDataTable.Info01[key]["Info02"] = {}
    		CommonData.g_MainDataTable.Info01[key]["Info02"]["ZhuanJingAttributeID"] =value[4][1]
    		CommonData.g_MainDataTable.Info01[key]["Info02"]["ZhuanJingAttributeLV"] =value[4][2]
    		CommonData.g_MainDataTable.Info01[key]["Info03"] = {}
    		CommonData.g_MainDataTable.Info01[key]["Info03"]["ZhuanJingAttributeID"] =value[5][1]
    		CommonData.g_MainDataTable.Info01[key]["Info03"]["ZhuanJingAttributeLV"] =value[5][2]
    		CommonData.g_MainDataTable.Info01[key]["Info04"] = {}
    		CommonData.g_MainDataTable.Info01[key]["Info04"]["ZhuanJingAttributeID"] =value[6][1]
    		CommonData.g_MainDataTable.Info01[key]["Info04"]["ZhuanJingAttributeLV"] =value[6][2]
    	end
	--]]
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(MS_C_NET_MSG_ID.MS_C_GETBASEDATA_RETURN)
			m_funSuccessCallBack = nil
		end
		require "Script/Main/MainScene"
		--[[if MainScene.GetControlUI() ~= nil then
			MainScene.UpdataMainVars()
		end]]--
		if MainScene.GetObserver()~=nil then
			MainScene.GetObserver():Notify()
		end
		require "Script/Main/Corps/CorpsScene"
		if CorpsScene.GetPCorpsLayer() ~= nil then
			CorpsScene.GetUpdateMoney(0,0)
		end
	else
		print("get database data error the status is 0")
	end
	pNetStream = nil

	print("CommonData.g_MainDataTable")
	--printTab(CommonData.g_MainDataTable)
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GETBASEDATA_RETURN,Server_Excute)