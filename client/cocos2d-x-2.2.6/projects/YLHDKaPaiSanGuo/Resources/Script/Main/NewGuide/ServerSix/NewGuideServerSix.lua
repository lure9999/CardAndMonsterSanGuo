
--新手引导的服务器步骤第六大步骤
module("NewGuideServerSix", package.seeall)

require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_Item"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_Marix"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_MainSceneBtn"

local OpenItemLayer = NewGuideServerSix_Item.OpenItemLayer
local OpenItemBtn = NewGuideServerSix_MainSceneBtn.OpenItemBtn
local ShowMarix = NewGuideServerSix_Marix.ShowMarix

local function ToItem()
	local function FinishOpenItem()
		--[[print("FinishOpenItem")
		Pause()]]--
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(5))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_7)
	end
	OpenItemLayer(FinishOpenItem)
end

local function ShowMainSceneBtn()
	local function OpenBtnEnd()
		--到背包界面
		ToItem()
	end
	OpenItemBtn(OpenBtnEnd,ccp(1020,220))
end
local function ToTalk()
	--调用对话
	HeroTalkLayer.createHeroTalkUI(3031)
	local function FinishTalk()
		
		--点击右下角图标
		ShowMainSceneBtn()
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end
function CreateServerSix()
	ShowMarix(ToTalk)
end