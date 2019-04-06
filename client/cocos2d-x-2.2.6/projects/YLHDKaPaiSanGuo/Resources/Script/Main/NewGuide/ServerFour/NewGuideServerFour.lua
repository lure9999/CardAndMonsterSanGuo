

--新手引导的服务器步骤第四大步骤
module("NewGuideServerFour", package.seeall)

require "Script/Main/NewGuide/ServerFour/NewGuideServerFour_Matrix"

local OpenMatrix = NewGuideServerFour_Matrix.OpenMatrix

local function ToMatrix()
	local function FinishOpenMatrix()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(3))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_5)
	end
	OpenMatrix(FinishOpenMatrix)
end
function CreateServerFour()
	--调用对话
	HeroTalkLayer.createHeroTalkUI(3030)
	local function FinishTalk()
		--到阵容界面
		ToMatrix()
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)

end