
module("Packet_SDKLogin", package.seeall)
--local cjson	= require "json"

local  GetDynamicID = LoginLogic.GetDynamicID

function CreatPacket(sID,sKey )

	local DynamicID = GetDynamicID()
	print("Packet_SDKLogin")
	print(sID)
	print(sKey)
	print(DynamicID)
	
	local pNetStream = NetStream()
	pNetStream:Write(NET_MSG_TYPE_ID.TYPE_C_GS)
	pNetStream:Write(C_GS_NET_MSG_ID.C_GS_SDKLOGIN)
	pNetStream:Write(0)
	pNetStream:Write(0)
	pNetStream:Write("0")
	pNetStream:Write(0)
	pNetStream:Write(sID)
	pNetStream:Write(sKey)
	pNetStream:Write(GetDynamicID())
	local nowVer = CCUserDefault:sharedUserDefault():getStringForKey("current-version-code")
	if nowVer== nil or nowVer== ""  then
		pNetStream:Write("0")
	else
		pNetStream:Write(nowVer)
	end
	local nType = GetPlatformID()
	pNetStream:Write(nType)
	return pNetStream:GetPacket()
end



