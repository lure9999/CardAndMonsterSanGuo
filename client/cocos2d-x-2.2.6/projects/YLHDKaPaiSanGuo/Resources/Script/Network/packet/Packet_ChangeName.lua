--修改玩家的名称 celina

module("Packet_ChangeName", package.seeall)
--local cjson	= require "json"



local Send_Cmd = {
	token 		= 2,
	GlobalID	= 3,
	old			= 4,
	new			= 5,
}

local m_funSuccessCallBack = nil

--sNewName 新名称
function CreatPacket(sNewName)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CHANGE_NICKNAME )
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(sNewName)
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
		--修改成功
		if m_funSuccessCallBack~=nil then
			m_funSuccessCallBack()
		end
	else
		NetWorkLoadingLayer.loadingShow(false)
		if status==11 then
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(901,nil)
			pTips = nil
		elseif status==1023 then
			TipLayer.createTimeLayer("资源不足", 2)
		else
			TipLayer.createTimeLayer("修改失败", 2)
		end
		
		
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CHANGE_NICKNAME,Server_Excute)