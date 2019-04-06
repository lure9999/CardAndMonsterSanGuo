
--新手引导的服务器步骤第五大步骤之阵容
module("NewGuideServerFive_Matrix", package.seeall)

local GetGuideIcon = NewGuideLayer.GetGuideIcon
local AddGuideIcon = NewGuideLayer.AddGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide

local m_Matrix_CallBack = nil 
local m_guideAnimation = nil 

local function BackScendMatrix()
	if m_Matrix_CallBack~=nil then
		if m_guideAnimation~=nil then
			DeleteGuide()
		end
		m_Matrix_CallBack()
		m_Matrix_CallBack = nil
	end
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(4))
end
local function _Click_Choose_WJ(sender, eventType)
	if eventType == TouchEventType.ended then
		MatrixLayer.GetMatrixByNewGuilde(3,3,BackScendMatrix)
	end
end
local function OpenWjSecond()
	m_guideAnimation:setPosition(ccp(290,400))
	m_guideAnimation:setVisible(true)
	m_guideAnimation:setTouchEnabled(true)
	m_guideAnimation:addTouchEventListener(_Click_Choose_WJ)
end
local function _Click_SecondGird(sender, eventType)
	if eventType == TouchEventType.ended then
		--调用打开选择武将界面
		--[[if m_Matrix_CallBack~=nil then
			if m_guideAnimation~=nil then
				DeleteGuide()
			end
			m_Matrix_CallBack()
			m_Matrix_CallBack = nil
		end]]--
		
		MatrixLayer.GetMatrixByNewGuilde(0,3,OpenWjSecond)
	end
end
local function AddGuideAnimationMatrix()
	m_guideAnimation = GetGuideIcon()
	
	if m_guideAnimation~=nil then
		--第二个格子的位置 ccp(595,78)
		m_guideAnimation:setPosition(ccp(595,78))
		if m_guideAnimation~=nil then
			m_guideAnimation:setTouchEnabled(true)
			m_guideAnimation:addTouchEventListener(_Click_SecondGird)
		end
	else
		AddGuideIcon(ccp(595,78))
		m_guideAnimation = GetGuideIcon()
		--m_guideAnimation:setVisible(true)
		if m_guideAnimation~=nil then
			m_guideAnimation:setTouchEnabled(true)
			m_guideAnimation:addTouchEventListener(_Click_SecondGird)
		end
	end
	
	
end
function OpenMatrixFive(fCallBack)
	m_Matrix_CallBack = fCallBack
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
			local matrix = MatrixLayer.createMatrixUI()
			scenetemp:addChild(matrix,layerMatrix_Tag,layerMatrix_Tag)
			MainScene.PushUILayer(matrix)
			print("3=========")
			AddGuideAnimationMatrix()
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetMatrix.SetSuccessCallBack(OpenMatrix)
		network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
	else
		print("2==============")
		AddGuideAnimationMatrix()
	end
end