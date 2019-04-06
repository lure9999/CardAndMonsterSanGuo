--新手引导的服务器步骤第十三大步骤
module("NewGuideServerThirteen", package.seeall)

require "Script/Main/NewGuide/ServerEight/NewGuideServerEight_OpenFlog"
require "Script/Main/NewGuide/ServerSix/NewGuideServerSix_MainSceneBtn"


local OpenFlogBtn = NewGuideServerSix_MainSceneBtn.OpenItemBtn
local ShowFlog = NewGuideServerEight_OpenFlog.ShowFlog
local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide


local function _Click_Misstion_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--关闭日志界面
		MissionNormalLayer.GetMissionByNewGuilde( 2 )
		DeleteGuide()
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(12))
		NewGuideManager.UpdateNewGuideProcess(NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_14)
	end
end
local function _EndFlogThree()
	local pAnimationMisstion = GetGuideIcon()
	if	pAnimationMisstion~=nil then
		--DeleteGuide()
		pAnimationMisstion:setPosition(ccp(110,550))
		pAnimationMisstion:addTouchEventListener(_Click_Misstion_CallBack)
	end
end
local function ToOpenFlog_Three()
	ShowFlog(_EndFlogThree,3,0)
end
--第十三步骤
function CreateServerThirteen()
	--点击右下角图标
	OpenFlogBtn(ToOpenFlog_Three,ccp(1020,95))
end