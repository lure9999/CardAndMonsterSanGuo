--新手引导的服务器步骤第十四大步骤
module("NewGuideServerFourteen", package.seeall)

require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_MainSceneBtn"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_Marix"
require "Script/Main/NewGuide/ServerFourteen/NewGuideServerFourteen_Marix"

local OpenMainBtn = NewGuideServerSix_MainSceneBtn.OpenItemBtn

local ShowMarix = NewGuideServerSix_Marix.ShowMarix
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon
local ToFourteenMarix = NewGuideServerFourteen_Marix.CreateFourteenMarix
local DeleteNewGuideTouchGroup = NewGuideLayer.DeleteNewGuideTouchGroup

local pMarixAnimation = nil 

--将14步骤 拆成了14和15 14到选择装备，15到强化了装备
local function FinishMarix()
	--全部完成，删掉新手引导
	--[[HeroTalkLayer.createHeroTalkUI(3036)
	local function FinishTalk()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(13))
		DeleteNewGuideTouchGroup()
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)]]--
	--到第十五步
	NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_15)
	
end
local function EndMarix()
	ToFourteenMarix(FinishMarix,1)
end
local function ToOpenMatrix()
	ShowMarix(EndMarix)
end
function CreateServerFourteen()
	--对话
	HeroTalkLayer.createHeroTalkUI(3035)
	local function FinishTalk()
		--点击右下角图标
		OpenMainBtn(ToOpenMatrix,ccp(1020,400))
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end