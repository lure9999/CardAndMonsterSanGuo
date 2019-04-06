
--新手引导的服务器步骤第七大步骤-检测阵容界面是否开启 celina
module("NewGuideServerSeven_Matrix", package.seeall)


local AddGuideIcon = NewGuideLayer.AddGuideIcon
local GetGuideIcon = NewGuideLayer.GetGuideIcon

local m_seven_CallBack_Matrix = nil 
local m_seven_animation = nil 


local function CloseOK()
	if m_seven_CallBack_Matrix~=nil then
		m_seven_CallBack_Matrix()
		m_seven_CallBack_Matrix= nil 
	end
end

local function _Click_CloseWJ_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		GeneralOptLayer.ExitOptLayer( CloseOK )
	end
end
local function LevelUpEnd()
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(6))
	m_seven_animation:setPosition(ccp(110,550))
	m_seven_animation:addTouchEventListener(_Click_CloseWJ_CallBack)
end
local function _Click_LevelUP_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		GeneralLvUpLayer._BtnLvUp_CallBack( LevelUpEnd )
	end
end
local function OpenWjLevel()
	print("升级")
	if m_seven_animation~=nil then
		m_seven_animation:setPosition(ccp(690,80))
		m_seven_animation:addTouchEventListener(_Click_LevelUP_CallBack)
	end
end
local function _Click_WJ_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		MatrixLayer.GetMatrixByNewGuilde(5,2,OpenWjLevel)
	end

end
local function MoveToSelect()
	--print("MoveToSelect")
	m_seven_animation = GetGuideIcon()
	--[[print(m_seven_animation)
	Pause()]]--
	if m_seven_animation==nil then
		AddGuideIcon(ccp(570,320))
		m_seven_animation= GetGuideIcon()
	else
		m_seven_animation:setPosition(ccp(570,320))
	end
	if m_seven_animation~=nil then
		
		m_seven_animation:setTouchEnabled(true)
		m_seven_animation:addTouchEventListener(_Click_WJ_CallBack)
	end
end
function CheckOpenMatrix(fCallBack)
	m_seven_CallBack_Matrix = fCallBack
	require "Script/Main/Matrix/MatrixLayer"
	local pMatrix = MatrixLayer.GetUIControl()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	if pMatrix == nil then
		local function OpenMatrix()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			MainScene.DeleteUILayer(MatrixLayer.GetUIControl())
			local matrix = MatrixLayer.createMatrixUI(4)
			scenetemp:addChild(matrix,layerMatrix_Tag,layerMatrix_Tag)
			MainScene.PushUILayer(matrix)
			MoveToSelect()
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetMatrix.SetSuccessCallBack(OpenMatrix)
		network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
	else
		MoveToSelect()
	end
end