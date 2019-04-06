module("Packet_UseItem", package.seeall)
--local cjson	= require "json"

local m_funSuccessCallBack = nil

local Send_Cmd = {
	Token 			= 2,
	GlobalID 		= 3,
	BoxID 			= 4,
	KeyID 			= 5,
	number 			= 6,
}
local m_nTempId = nil
local m_nNumber = nil
function CreatPacket(nGrid, number, nTempId)
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_MS)
	pNetStream:Write(C_MS_NET_MSG_ID.C_MS_USEITEM)
	pNetStream:Write(0)
	pNetStream:Write(0)
	--print("CommonData.g_szToken"..CommonData.g_szToken)
	--Pause()
	pNetStream:Write(CommonData.g_szToken)
	pNetStream:Write(CommonData.g_nGlobalID)
	pNetStream:Write(nGrid)
	pNetStream:Write(number)
	m_nTempId = nTempId
	m_nNumber = number
	return pNetStream:GetPacket()
end

function SetSuccessCallBack(funCall)
	m_funSuccessCallBack = funCall
end
function SetTempIDAndNum(nTempId,number)
	m_nTempId = nTempId
	m_nNumber = number
end
--解析包逻辑
function Server_Excute( PacketData )
	local pNetStream = NetStream()
	pNetStream:SetPacket(PacketData)
	local status = pNetStream:Read()
	-- local list   = pNetStream:Read()
	--print("Packet_UseItem")
	--print(PacketData)
	--Pause()
	--ItemData.createItemData()
	
	if status == 1 then
		--[[print("sssss")
		print("m_nTempId = " .. m_nTempId)
		print("m_nNumber = " .. m_nNumber)]]--
		if m_nTempId == nil then
			local list   = pNetStream:Read()
			m_nTempId = list[1][1]
			m_nNumber = list[1][2]
		end
		
		local event_type = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_type"))

		if event_type == 1 then -- 消耗品 --【1=主将经验】【2=武将经验】【3=宝物经验】【4=体力】【5=耐力】【6=银币】【7=金币】【8=星魂】
			--【9=比武声望】【10=军团银币】【11=国战声望】【12=国战声望】【13=国家经验（军团）】【14=国家经验（国家）】
			local event_para_A = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_para_A"))
			local event_para_B = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_para_B"))
			--[[print(event_para_A)
			print(event_para_B)
			Pause()]]--
			local strTip = "恭喜您获得"
			if event_para_A == 1 then
				-- strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "主将经验"
				NetWorkLoadingLayer.loadingHideNow()
				return
			end
			if event_para_A == 2 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "武将经验"
			end
			if event_para_A == 3 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "宝物经验"
			end
			if event_para_A == 4 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "体力"
			end
			if event_para_A == 5 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "耐力"
			end
			if event_para_A == 6 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "银币"
			end
			if event_para_A == 7 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "金币"
			end
			if event_para_A == 8 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "星魂"
			end
			if event_para_A == 9 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "比武声望"
			end
			if event_para_A == 10 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "军团贡献"
			end
			if event_para_A == 11 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "军团银币"
			end
			if event_para_A == 12 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "国战声望"
			end
			if event_para_A == 13 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "国家经验"
			end
			if event_para_A == 14 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "国家经验"
			end
			-- TipLayer.createOkTipLayer(strTip, nil)
			TipLayer.createTimeLayer(strTip, 2)
		end

		if event_type == 2 then -- 箱子类型
			local list = pNetStream:Read()
			--[[print("list----------------------------------")
			printTab(list)]]--
	    	local nTempId = list[1][1]
	    	local nNumber = list[1][2]
			--TipLayer.createOkTipLayer("恭喜您获得" .. tostring(nNumber) .. "个" .. item.getFieldByIdAndIndex(nTempId, "name"), nil)
			GetGoodsLayer.createGetGoods(list)	

		end

		if event_type == 3 then -- 碎片类型
			local strTip = "恭喜您成功合成"
			local event_para_B = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_para_B"))
			--print("event_para_B = " .. event_type)
			local name = item.getFieldByIdAndIndex(event_para_B, "name")
			strTip = strTip .. name
			-- TipLayer.createOkTipLayer(strTip, nil)
			TipLayer.createTimeLayer(strTip, 2)
		end

		if event_type == 8 then
			local event_para_A = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_para_A"))
			local event_para_B = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_para_B"))
			local strTip = "恭喜您获得"
			if event_para_A == 1 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "青龙之魂"
			end
			if event_para_A == 2 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "白虎之魂"
			end
			if event_para_A == 3 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "朱雀之魂"
			end
			if event_para_A == 4 then
				strTip = strTip .. tostring(tonumber(event_para_B)*m_nNumber) .. "玄武之魂"
			end
		end
		-- 更换为别的效果
		-- if event_type == 4 then -- 将魂类型
		-- 	local strTip = "恭喜您成功合成"
		-- 	local event_para_B = tonumber(item.getFieldByIdAndIndex(m_nTempId, "event_para_B"))
		-- 	--print("event_para_B = " .. event_type)
		-- 	local name = item.getFieldByIdAndIndex(event_para_B, "name")
		-- 	strTip = strTip .. name
		-- 	TipLayer.createOkTipLayer(strTip, nil)
		-- end

		if m_funSuccessCallBack ~= nil then
			m_nNumber = nil
			m_nTempId = nil
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end

	else
		--物品栏不足
		--修改
		--TipCommonLayer.CreateTipsLayer(503,TIPS_TYPE.TIPS_TYPE_ITEM,nil,nil,nil)
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(503,nil)
		pTips = nil
		if m_funSuccessCallBack ~= nil then
			--print("m_funSuccessCallBack")
			--Pause()
			m_funSuccessCallBack()
			m_funSuccessCallBack = nil
		end
	end
	pNetStream = nil
		
end

PacketManage.RegistPacketFun(NET_MSG_TYPE_ID.TYPE_MS_C,MS_C_NET_MSG_ID.MS_C_USEITEM_RETURN,Server_Excute)