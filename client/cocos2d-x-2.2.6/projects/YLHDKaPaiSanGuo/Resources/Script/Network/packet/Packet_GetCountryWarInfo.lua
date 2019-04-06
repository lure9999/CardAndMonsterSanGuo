--��ù�ս�������Ϣ celina

module("Packet_GetCountryWarInfo", package.seeall)

--local cjson	= require "json"

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}
local m_cityID = 0
local m_type = 0
local m_funSuccessCallBack = nil
--nCityID 0��ʾ�˳��ۿ� nType ==1 ��ʾ���й�ս��2��ʾ����
function CreatPacket(nCityID,nType)
	m_cityID = tonumber(nCityID)
	m_type = tonumber(nType)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_BS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_BS_LOOK_CITY)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)
	pNetStream:Write(nCityID)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--�������߼�
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	--print(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			--AtkCityScene.SetUpdateList(false)
			local bData = false
			if tonumber(m_type) == 1 then
				if tonumber(m_cityID)~=0 then
					bData = true 	
				end
			end
			if tonumber(m_type) == 2 then
				if tonumber(m_cityID)~=-1 then
					bData = true 
				end
			end
			if bData == true then
				require "Script/serverDB/server_getCountryWarInfo"
				--Pause()
				server_getCountryWarInfo.SetTableBuffer(PacketData)
			end
		else
			print("��ս����δ��������ִ��GetCountryWarInfoЭ��")
		end
	--else
		--AtkCityScene.CloseAtkCityScene()
	else
		--���еİ�ť����ȡ��
	end 
	if m_funSuccessCallBack ~= nil then
		m_funSuccessCallBack(status)
		m_funSuccessCallBack = nil
	end
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_LOOK_RESULT,Server_Excute)
