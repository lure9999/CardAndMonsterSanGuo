
--新手引导的服务器步骤第四大步骤之阵容
module("NewGuideServerFour_Matrix", package.seeall)

local GetGuideIcon = NewGuideLayer.GetGuideIcon
local AddGuideIcon = NewGuideLayer.AddGuideIcon
local DeleteGuide  = NewGuideLayer.DeleteGuide

local m_Matrix_CallBack = nil 
local m_guideAnimation = nil 

--回到阵容界面
local function BackMatrix()
	m_guideAnimation:setVisible(false)
	m_guideAnimation:setTouchEnabled(false)
	DeleteGuide()
	if m_Matrix_CallBack~=nil then
		m_Matrix_CallBack()
	end
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(3))
end

local function _Click_Choose_WJ(sender,eventType)
	if eventType == TouchEventType.ended then
		MatrixLayer.GetMatrixByNewGuilde(3,2,BackMatrix)
	end
end
--打开武将界面
local function OPenWJLayer()
	--
	print("OPenWJLayer")
	m_guideAnimation:setPosition(ccp(290,400))
	m_guideAnimation:setVisible(true)
	m_guideAnimation:setTouchEnabled(true)
	m_guideAnimation:addTouchEventListener(_Click_Choose_WJ)
end

local function _Click_FirstGird(sender, eventType)
	if eventType == TouchEventType.ended then
		--调用打开选择武将界面
		MatrixLayer.GetMatrixByNewGuilde(0,2,OPenWJLayer)
		--[[m_guideAnimation:setVisible(false)
		m_guideAnimation:setTouchEnabled(false)]]--
	end
end

function OpenMatrix(fCallBack)
	m_Matrix_CallBack = fCallBack
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	require "Script/Main/Matrix/MatrixLayer"
	local tempCur = scenetemp:getChildByTag(layerMatrix_Tag)
	if tempCur == nil then
		local function OpenMatrix()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			MainScene.DeleteUILayer(MatrixLayer.GetUIControl())
			local matrix = MatrixLayer.createMatrixUI()
			scenetemp:addChild(matrix,layerMatrix_Tag,layerMatrix_Tag)
			MainScene.PushUILayer(matrix)
			m_guideAnimation = GetGuideIcon()
			if m_guideAnimation~=nil then
				--第二个格子的位置 ccp(595,78)
				m_guideAnimation:setPosition(ccp(720,75))
				m_guideAnimation:setVisible(true)
			else
				AddGuideIcon(ccp(720,75))
				m_guideAnimation = GetGuideIcon()
			end
			if m_guideAnimation~=nil then
				m_guideAnimation:setTouchEnabled(true)
				m_guideAnimation:addTouchEventListener(_Click_FirstGird)
			end
		end

		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetMatrix.SetSuccessCallBack(OpenMatrix)
		network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
	end
end