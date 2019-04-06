--add by celina发送服务器的步骤

module("Packet_SetNewGuide", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

local m_funSuccessCallBack = nil
--nMenuIndex 服务器的大步骤，nSubIndex服务的子步骤，nSSubIndex客户端的步骤，nType客户端的子步骤的值，分为1或者-1
function CreatPacket(nMenuIndex,nSubIndex,nSSubIndex,nType,tabData)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_SET_NEWBIE_GUIDE_FLAG)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	print(tonumber(nMenuIndex)-1,nSubIndex,nSSubIndex,nType)
	Pause()
	pNetStream:Write(tonumber(nMenuIndex)-1)
	pNetStream:Write(nSubIndex)
	pNetStream:Write(nSSubIndex)
	pNetStream:Write(nType)
	
	if tabData~=nil then
		for i=1 ,#tabData do
			print(nIndex)
			print("i:"..i)
			print(tabData[i])
			pNetStream:Write(tabData[i])
		end
	end
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
	print(PacketData)
	Pause()
	if status == 1 then
		local nResult = pNetStream:Read()
		if tonumber(nResult) ==1 then
			if m_funSuccessCallBack~=nil then
				m_funSuccessCallBack()
				m_funSuccessCallBack = nil 
			end
		else
			--新手引导失败
			local function ClickOK()
				CCDirector:sharedDirector():endToLua()
			end
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1659,ClickOK)
			pTips = nil
			
		end
	else
		print("get updateBaseinfo error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_SET_NEWBIE_GUIDE_FLAG_RESULT,Server_Excute)
