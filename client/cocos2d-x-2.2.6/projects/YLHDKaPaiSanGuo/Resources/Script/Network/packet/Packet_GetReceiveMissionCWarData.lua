module("Packet_GetReceiveMissionCWarData", package.seeall)


local m_funSuccessCallBack = nil
local m_funSuccessCallBack_LevelUp = nil
local m_funSuccessCallBack_ShiLian = nil

function CreatePacket(nType, nMissionID)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_GET_WAR_TASK_INFO)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nType)

	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall, nFunCallType)
	if nFunCallType ~= nil then
		if nFunCallType == 1 then
			m_funSuccessCallBack_LevelUp = funCall
		elseif nFunCallType == 2 then
			m_funSuccessCallBack_ShiLian = funCall
		end
	else
		m_funSuccessCallBack = funCall
	end
end

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local ntype  = pNetStream:Read()

	local function GetLevelUpMissionBegin(  )
		--判断当前国家三国任务是否发布
		if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WEI or 
			ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_SHU or 
			ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_LV_UP_WU then

			return true
		end

		return false
	end

    local function GetShiLianMissionBegin(  )
        --判断当前国家试炼任务是否发布
        if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_TRIAL then

            return true
        end

        return false
    end

	if status == 1 then	
		if ntype == E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS then
			print("国家任务数据解析")
			require "Script/serverDB/server_NormalMissionCWarDB"
			server_NormalMissionCWarDB.SetTableBuffer(PacketData)
			if m_funSuccessCallBack ~= nil then
				m_funSuccessCallBack()
				m_funSuccessCallBack = nil
			end	
		end

		if GetLevelUpMissionBegin() == true then
			print("国家升级任务数据解析")
			require "Script/serverDB/server_NormalMissionCWarLevelUpDB"
			server_NormalMissionCWarLevelUpDB.SetTableBuffer(PacketData)
			if m_funSuccessCallBack_LevelUp ~= nil then
				m_funSuccessCallBack_LevelUp()
				m_funSuccessCallBack_LevelUp = nil
			end	
		end

		if GetShiLianMissionBegin() == true then
			print("国家试炼任务数据解析")
			require "Script/serverDB/server_NormalMissionCWarShiLianDB"
			server_NormalMissionCWarShiLianDB.SetTableBuffer(PacketData)
			if m_funSuccessCallBack_ShiLian ~= nil then
				m_funSuccessCallBack_ShiLian()
				m_funSuccessCallBack_ShiLian = nil
			end	
		end

	else
		TipLayer.createTimeLayer("请求国战任务数据失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_GET_WAR_TASK_INFO,Server_Excute)