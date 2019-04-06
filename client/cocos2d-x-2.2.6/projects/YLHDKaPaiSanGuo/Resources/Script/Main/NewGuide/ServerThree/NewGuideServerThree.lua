--新手引导第三大步骤 celina
module("NewGuideServerThree", package.seeall)


require "Script/Main/NewGuide/ServerThree/NewGuideServerThree_LuckDraw"

local DealGuideLuckDraw = NewGuideServerThree_LuckDraw.DealGuideLuckDraw

local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide =NewGuideLayer.DeleteGuide

local function _Close_LuckyDraw_CallBack(sender,eventType)
	if eventType == TouchEventType.ended then
		LuckyDrawLayer.GetLuckyDrawByNewGuilde(2)
		local pAnimation = GetGuideIcon()
		if pAnimation~=nil then
			DeleteGuide()
		end
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(2))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_4)
	end
end
local function ToLuckyDraw()
	local function EndLuckDraw()
		--NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_3)
		local pAnimation = GetGuideIcon()
		if pAnimation~=nil then
			pAnimation:setPosition(ccp(125,560))
			pAnimation:setVisible(true)
			pAnimation:setTouchEnabled(true)
			pAnimation:addTouchEventListener(_Close_LuckyDraw_CallBack)
		end
	end
	DealGuideLuckDraw(EndLuckDraw)
	
end


function CreateServerThree()
	--第三步如果酒馆界面没打开那么显示打开
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local temp = scenetemp:getChildByTag(layerSmithy_Tag)
	if temp == nil then 
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		require "Script/Main/LuckyDraw/LuckyDrawLayer"
		local pLayerLuckyDraw = LuckyDrawLayer.CreateLuckyDrawLayer()
		scenetemp:addChild(pLayerLuckyDraw,layerSmithy_Tag,layerSmithy_Tag)
		MainScene.PushUILayer(pLayerLuckyDraw)
	end
	--开始对话
	HeroTalkLayer.createHeroTalkUI(3029)
	local function FinishTalk()
		ToLuckyDraw()
	end
	HeroTalkLayer.SetGuideBackFun(FinishTalk)
end