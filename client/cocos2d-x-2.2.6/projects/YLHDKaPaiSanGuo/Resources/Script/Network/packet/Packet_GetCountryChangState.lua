module("Packet_GetCountryChangState", package.seeall)

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
}

--解析包逻辑
function Server_Excute( PacketData )

	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	local list = pNetStream:Read()
 
	if status == 1 then
		if CommonData.g_IsUnlockCountryWar == true then
			print("Packet_GetCountryChangState")
			local CityId = list[1]
			local state = list[2]
			local nState2 = list[3]
			local country = list[4]
			--解析二级状态
			local nArr = CCArray:create()
			IntTrans(tonumber(nState2), 1, 1, nArr)
			local tabState2 = {}
	        for j=0,3 do
	            local nState2S = tolua.cast(nArr:objectAtIndex(j),"CCInteger")
	            local nStateNum2S = nState2S:getValue()
	            if j == 0 then
	                tabState2["LockState"] =  nStateNum2S
	            elseif j == 1 then
	                tabState2["CenterCity"] =  nStateNum2S
	            elseif j == 2 then
	                tabState2["Confusion"] =  nStateNum2S
	            elseif j == 3 then
	            	tabState2["ManZuEvent"] = nStateNum2S
	            end
	        end
	       -- printTab(tabState2)
	        --Pause()
	        CountryWarScene.RefreshEventUI(CityId, tabState2)
			--修改数据源
			require "Script/serverDB/server_CountryWarAllMesDB"
			require "Script/Main/CountryWar/CountryWarScene"
			require "Script/Main/CountryWar/CountryWarRaderLayer"
			if server_CountryWarAllMesDB.GetCityCountry(CityId) ~= country then
				--城市国家发生改变
				server_CountryWarAllMesDB.SetCityCountry(CityId, country)
				CountryWarScene.RefreshCityUI(CityId, country)
				CountryWarScene.RefreshCityCountry(CityId, country)
				CountryWarScene.CountEnemyCityByEventManager()
				--雷达刷新
				CountryWarRaderLayer.UpdateCountry( country, CityId )
			end

			if server_CountryWarAllMesDB.GetCityState(CityId) ~= state then
				--城市状态发生改变
				server_CountryWarAllMesDB.SetCityState(CityId, state)
				CountryWarScene.RefreshCityState(CityId,state)
			end	
			--更新圆圈状态
			require "Script/Main/CountryWar/ClickCityLayer"
			ClickCityLayer.UpdateCityUI()
		else
			print("国战场景未开启，不执行ChangState协议")			
		end
	else
		print("team stop list error the status is 0")
	end 
	pNetStream = nil
end


PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_BS_CITY_STATE,Server_Excute)