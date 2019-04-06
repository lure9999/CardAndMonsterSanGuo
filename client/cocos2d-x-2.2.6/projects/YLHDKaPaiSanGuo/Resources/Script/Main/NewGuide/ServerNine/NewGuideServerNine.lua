--新手引导的服务器步骤第九大步骤
module("NewGuideServerNine", package.seeall)


require "Script/Main/NewGuide/ServerEight/NewGuideServerEight_OpenFlog"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_MainSceneBtn"


local OpenFlogBtn = NewGuideServerSix_MainSceneBtn.OpenItemBtn

local ShowFlog = NewGuideServerEight_OpenFlog.ShowFlog
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide

local function _Click_Misstion_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--关闭日志界面
		--[[local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local tempCur = scenetemp:getChildByTag(layerMissionNormal_tag)
		tempCur:removeFromParentAndCleanup(true)
		MainScene.PopUILayer()]]--
		MissionNormalLayer.GetMissionByNewGuilde( 2 )
		DeleteGuide()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(8))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_10)
	end
end
local function _EndFlog_Nine()
	local pAnimationMisstion = GetGuideIcon()
	if	pAnimationMisstion~=nil then
		--DeleteGuide()
		pAnimationMisstion:setPosition(ccp(110,550))
		pAnimationMisstion:addTouchEventListener(_Click_Misstion_CallBack)
	end
	
end
local function ToOpenFlog()
	print("第九步22========================")
	ShowFlog(_EndFlog_Nine,2,1)
end
function CreateServerNine()
	--检测是否开着日志
	print("第九步1========================")
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerMissionNormal_tag)
	require "Script/Main/MissionNormal/MissionNormalLayer"
	if tempCur ~=nil then
		print("第九步2========================")
		ShowFlog(_EndFlog_Nine,2,1)
	else
		--再走一遍打开日志
		--点击右下角图标
		OpenFlogBtn(ToOpenFlog,ccp(1020,95))
	end
end