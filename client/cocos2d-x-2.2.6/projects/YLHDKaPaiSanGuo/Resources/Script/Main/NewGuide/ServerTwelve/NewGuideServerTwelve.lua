--新手引导的服务器步骤第十二大步骤
module("NewGuideServerTwelve", package.seeall)

require "Script/Main/NewGuide/ServerTen/NewGuideServerTen_Copy"

local OpenCopyTwelve = NewGuideServerTen_Copy.OpenCopy
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon

local function _Click_CopyClose_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--关闭副本界面回到主界面
		DungeonManagerLayer.ReturnDungeon()
		local m_pAnimation = GetGuideIcon()
		if m_pAnimation~=nil then
			MainScene.BackScrollView()
			DeleteGuide()
			--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(11))
			NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_13)
		end
	end
end
local function FinishCopyTwelve()
	--点击返回回到主界面
	local m_pAnimation = GetGuideIcon()
	if m_pAnimation~=nil then
		m_pAnimation:setPosition(ccp(110,550))
		m_pAnimation:addTouchEventListener(_Click_CopyClose_CallBack)
	end
end
local function AddGuideTwelveFuBen()
	OpenCopyTwelve(FinishCopyTwelve,ccp(663,326),3)
end
function CreateServerTwelve()
	--检测是否是副本界面
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if tempCur ~= nil  then
		--现在是副本界面
		OpenCopyTwelve(FinishCopyTwelve,ccp(663,326),3)
	else
		MainScene.GuideScroll(AddGuideTwelveFuBen)
	end
end