module("Packet_CreateCharacter", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	token		= 2,
	GlobalID	= 3,
	shopid 		= 4,
	itemid 		= 5,
	number 		= 6,
	price 		= 7,
}

function CreatPacket(nSex, nHead, strName, nNameCode,nCountry)

	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_CREATECHARACTER)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nSex)
	pNetStream:Write(nHead)
	pNetStream:Write(strName)
	pNetStream:Write(nNameCode)
	pNetStream:Write(nCountry)
	
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
	

	-- print("Packet_CreateCharacter")
	if status == 1 then
		if m_funSuccessCallBack ~= nil then
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	else
		--修改接口
		--TipCommonLayer.CreateTipsLayer(901,TIPS_TYPE.TIPS_TYPE_NONE,nil,nil,nil)
		NetWorkLoadingLayer.loadingHideNow()
		local pTip = TipCommonLayer.CreateTipLayerManager()
		pTip:ShowCommonTips(901,nil)
		pTip = nil
	end
	pNetStream = nil	
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CREATECHARACTER_RETURN,Server_Excute)