
--更新到新手引导 celina


module("Packet_GetNewGuide", package.seeall)

--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	if status == 1 then
		local nMenuIndex = pNetStream:Read()
		local nSubIndex = pNetStream:Read()
		if tonumber(nMenuIndex) == -1 then
			--代表当前没有新手引导服务器缺推了新手引导
			print("当前没有新手引导服务器出错")
			return
		end
		--接到有新手引导卡住界面去引导
		if CommonData.OPEN_GUIDE == 1 then
			if MainScene.GetbMainScene()== false then
				local function fCallBack()
					NewGuideManager.CreateNewGuideManager(tonumber(nMenuIndex)+1,tonumber(nSubIndex))
				end
				
				local pScene = MainScene.GetPScene()
				if pScene~=nil then
					
					NewGuideManager.CreateNewGuideManager(tonumber(nMenuIndex)+1,tonumber(nSubIndex))
				else
					MainScene.SetPScene(true)
				end
			else
				NewGuideManager.CreateNewGuideManager(tonumber(nMenuIndex)+1,tonumber(nSubIndex))
			end
			
		end
	else
		print("get updateBaseinfo error the status is 0")
	end 
	pNetStream = nil
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_CURRENT_NEWBIE_GUIDE_FLAG,Server_Excute)