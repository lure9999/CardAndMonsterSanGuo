module("Packet_NormalFubenTimes", package.seeall)


local m_funSuccessCallBack = nil


function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end

--解析包逻辑
function Server_Excute( PacketData )
	--每一个关卡当前可购买次数
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status   = pNetStream:Read()
	local sceneId  = pNetStream:Read()
	local pointId  = pNetStream:Read()
	local stars    = pNetStream:Read()
	local cd       = pNetStream:Read()
	local times    = pNetStream:Read()
	local SurplusBuytimes    = pNetStream:Read()
	--[[print("stars = "..stars)
	print("cd = "..cd)
	print("times = "..times)
	print("SurplusBuytimes = "..SurplusBuytimes)
	Pause()]]
	
	if status == 1 then	
		print(sceneId.."更新关卡"..pointId.."数据")
		require "Script/serverDB/server_fubenDB"
		server_fubenDB.UpdateNormalPointData(sceneId, pointId, stars, cd, times, SurplusBuytimes)
	else
		TipLayer.createTimeLayer("获取关卡失败", 2)	
	end

	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_UPDATE_FUBEN_BUY_COUNT,Server_Excute)