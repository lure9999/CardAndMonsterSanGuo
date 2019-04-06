--新手引导的服务器步骤第十一大步骤
module("NewGuideServerEleven", package.seeall)

require "Script/Main/NewGuide/ServerTen/NewGuideServerTen_Copy"

local OpenCopyEleven = NewGuideServerTen_Copy.OpenCopy



local function FinishCopyEleven()
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(10))
	NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_12)
end

local function AddGuideElevenFuBen()
	OpenCopyEleven(FinishCopyEleven,ccp(400,290),2)
end

function CreateServerEleven()
	--
	--检测是否是副本界面
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if tempCur ~= nil  then
		--现在是副本界面
		OpenCopyEleven(FinishCopyEleven,ccp(400,290),2)
	else
		MainScene.GuideScroll(AddGuideElevenFuBen)
	end
end