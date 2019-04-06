
--新手引导第二大步骤 celina
module("NewGuideServerTwo", package.seeall)


require "Script/Main/NewGuide/ServerTwo/NewGuideServerTwo_Shop"


local DealGuideGropShop = NewGuideServerTwo_Shop.DealGuideGropShop

local function ToGrogshop()
	local function EndGrogShop()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(1))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_3)
	end
	DealGuideGropShop(EndGrogShop)
end
function CreateServerTwo()
	--调用对话
	HeroTalkLayer.createHeroTalkUI(3027)
	local function FinishTalk()
		--播放孙尚香的攻击动画
		ToGrogshop()
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)

end