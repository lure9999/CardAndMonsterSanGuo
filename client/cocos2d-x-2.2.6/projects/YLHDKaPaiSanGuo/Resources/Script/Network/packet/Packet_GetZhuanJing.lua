module("Packet_GetZhuanJing", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
}

function CreatPacket( )

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GETZHUANJIANG)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	print("Packet_GetZhuanJing")
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
		   
	--print(PacketData)
	if status == 1 then
		--print("Packet_GetZhuanJing")
		
		local tableTemp = pNetStream:Read()
		
    	for key, value in pairs(tableTemp) do
    		CommonData.g_MainZhuanJingTable[key] = {}
    		CommonData.g_MainZhuanJingTable[key]["GeneralID"] = value[1]
    		CommonData.g_MainZhuanJingTable[key]["JiHuo"] = value[2]
    		CommonData.g_MainZhuanJingTable[key]["Info01"] = {}
    		CommonData.g_MainZhuanJingTable[key]["Info01"]["ZhuanJingAttributeID"] =value[3][1]
    		CommonData.g_MainZhuanJingTable[key]["Info01"]["ZhuanJingAttributeLV"] =value[3][2]
    		CommonData.g_MainZhuanJingTable[key]["Info02"] = {}
    		CommonData.g_MainZhuanJingTable[key]["Info02"]["ZhuanJingAttributeID"] =value[4][1]
    		CommonData.g_MainZhuanJingTable[key]["Info02"]["ZhuanJingAttributeLV"] =value[4][2]
    		CommonData.g_MainZhuanJingTable[key]["Info03"] = {}
    		CommonData.g_MainZhuanJingTable[key]["Info03"]["ZhuanJingAttributeID"] =value[5][1]
    		CommonData.g_MainZhuanJingTable[key]["Info03"]["ZhuanJingAttributeLV"] =value[5][2]
    		CommonData.g_MainZhuanJingTable[key]["Info04"] = {}
    		CommonData.g_MainZhuanJingTable[key]["Info04"]["ZhuanJingAttributeID"] =value[6][1]
    		CommonData.g_MainZhuanJingTable[key]["Info04"]["ZhuanJingAttributeLV"] =value[6][2]
    	end

		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack(MS_C_NET_MSG_ID.MS_C_GETZHUANJIANG_RETURN)
			m_funSuccessCallBack = nil
		end
		require "Script/Main/MainScene"
		if MainScene.GetControlUI() ~= nil then
			MainScene.UpdataMainVars()
		end
	else
		print("get database data error the status is 0")
	end
	pNetStream = nil

	-- print("CommonData.g_MainZhuanJingTable")
	-- printTab(CommonData.g_MainZhuanJingTable)
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GETZHUANJIANG_RETURN,Server_Excute)