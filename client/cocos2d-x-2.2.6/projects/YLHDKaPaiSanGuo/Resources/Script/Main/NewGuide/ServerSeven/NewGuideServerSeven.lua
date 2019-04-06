
--新手引导的服务器步骤第七大步骤
module("NewGuideServerSeven", package.seeall)

require "Script/Main/NewGuide/ServerSeven/NewGuideServerSeven_Matrix"

local CheckOpenMatrix = NewGuideServerSeven_Matrix.CheckOpenMatrix
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide

local function _Click_CloseMatrix(sender, eventType)
	if eventType == TouchEventType.ended then
		local pSevenAnimation = GetGuideIcon()
		if pSevenAnimation~=nil then
			DeleteGuide()
		end
		local function CloseOK()
			--[[print("CloseOK")
			Pause()]]--
			--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(6))
			NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_8)
		end
		MatrixLayer.GetMatrixByNewGuilde(2,0,CloseOK)
		
	end
end
local function StartClickDZ()
	local pSevenAnimation = GetGuideIcon()
	if pSevenAnimation~=nil then
		pSevenAnimation:addTouchEventListener(_Click_CloseMatrix)
	
	end

end

function CreateServerSeven()
	--[[print("CreateServerSeven")
	Pause()]]--
	CheckOpenMatrix(StartClickDZ)

end