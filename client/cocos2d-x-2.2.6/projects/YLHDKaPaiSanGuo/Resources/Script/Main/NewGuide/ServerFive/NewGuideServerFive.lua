
--新手引导的服务器步骤第五大步骤
module("NewGuideServerFive", package.seeall)

require "Script/Main/NewGuide/ServerFive/NewGuideServerFive_Matrix"

local OpenMatrix = NewGuideServerFive_Matrix.OpenMatrixFive

local function ToMatrix()
	local function FinishOpenMatrix()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(4))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_6)
	end
	OpenMatrix(FinishOpenMatrix)
end
function CreateServerFive()
	--到阵容界面
	ToMatrix()
	

end