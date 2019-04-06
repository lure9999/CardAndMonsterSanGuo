--新手引导的服务器步骤第十大步骤
module("NewGuideServerTen", package.seeall)

require "Script/Main/NewGuide/ServerTen/NewGuideServerTen_Copy"

local OpenCopy = NewGuideServerTen_Copy.OpenCopy

local function FinishCopy()
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(9))
	NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_11)

end
local function AddGuideFuBen()
	OpenCopy(FinishCopy,ccp(190,140),1)

end

function CreateServerTen()
	--对话
	HeroTalkLayer.createHeroTalkUI(3033)
	local function FinishTalk()
		MainScene.GuideScroll(AddGuideFuBen)
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end