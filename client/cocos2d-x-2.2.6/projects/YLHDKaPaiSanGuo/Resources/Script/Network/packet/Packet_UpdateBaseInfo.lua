
--更新基本数据 celina


module("Packet_UpdateBaseInfo", package.seeall)
--local cjson	= require "json"



--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()

	if status == 1 then
		local list = pNetStream:Read()
		
		require "Script/serverDB/server_mainDB"
		server_mainDB.UpdateBaseInfo(list)
		
		require "Script/Main/Corps/CorpsLayer"
		if CorpsLayer.GetCorpsLayer() ~= nil then
			CorpsLayer.EnterCorpsScene()
		end
		require "Script/Main/Corps/CorpsScene"
		require "Script/Main/Corps/CorpsMessHallLayer"
		if CorpsScene.GetPScene() ~= nil then
			if CorpsMessHallLayer.GetHallLayer() ~= nil then
				CorpsScene.GetUpdateMoney(0,0)
			else
				CorpsScene.GetUpdateMoney(0,1)
			end
		end
		
		require "Script/Main/HeroUpgrade/HeroUpGradeLayer"
		for key,value in pairs(list) do
			if tonumber(value[1]) == 3 then
				if tonumber(value[2]) > 2 then
					HeroUpGradeLayer.showUpLayer(tonumber(value[2]))
					return
				end

			end

		end
		
	else
		print("get updateBaseinfo error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_UPDATE_BASE,Server_Excute)