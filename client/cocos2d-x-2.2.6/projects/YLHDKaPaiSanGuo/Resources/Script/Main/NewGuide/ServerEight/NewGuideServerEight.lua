--新手引导的服务器步骤第八大步骤
module("NewGuideServerEight", package.seeall)

require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_MainSceneBtn"
require "Script/Main/NewGuide/ServerEight/NewGuideServerEight_OpenFlog"


local OpenFlogBtn = NewGuideServerSix_MainSceneBtn.OpenItemBtn

local ShowFlog = NewGuideServerEight_OpenFlog.ShowFlog

local function _EndFlog()
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(7))
	print("第八步跳转到第九步")
	NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_9)

end
local function ToOpenFlog()
	
	ShowFlog(_EndFlog,1,1)
	
end
function CreateServerEight()
	--调用对话8
	HeroTalkLayer.createHeroTalkUI(3032)
	local function FinishTalk()
		
		--点击右下角图标
		OpenFlogBtn(ToOpenFlog,ccp(1020,95))
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end