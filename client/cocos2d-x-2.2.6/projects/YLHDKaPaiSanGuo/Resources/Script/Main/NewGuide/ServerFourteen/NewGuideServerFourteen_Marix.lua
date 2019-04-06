
--新手引导的服务器步骤第十四大步骤之 打开阵容
module("NewGuideServerFourteen_Marix", package.seeall)

require "Script/Main/NewGuide/ServerFourteen/NewGuideServerFourteen_Equip"


local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon

local OpenEquip = NewGuideServerFourteen_Equip.OpenEquip

local m_fourteen_CallBack = nil 
local pAnimationFourteen = nil 

local m_pEquipList = nil 
local function EndOpenEquip()
	if m_fourteen_CallBack~=nil then
		m_fourteen_CallBack()
	end
end	
local function OpenEquip_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--去打开装备
		OpenEquip(EndOpenEquip)
	end
end

local function BackMarix()
	--[[if pAnimationFourteen~=nil then
		pAnimationFourteen:setPosition(ccp(190,290))
		pAnimationFourteen:addTouchEventListener(OpenEquip_CallBack)
	end]]--
	--第十四步完成
	if pAnimationFourteen~=nil then
		DeleteGuide()
	end	
	if m_fourteen_CallBack~=nil then
		m_fourteen_CallBack()
	end
end
local function _SelectEquip_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--点击回到了阵容界面
		--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(13))
		print("_SelectEquip_CallBack")
		pAnimationFourteen:setTouchEnabled(false)
		m_pEquipList:Exit_MatriEquip_CallBack(1012,3,BackMarix)
	end
end	
local function OpenEquipSelect(pEquipList)
	m_pEquipList = pEquipList
	if pAnimationFourteen~=nil then
		pAnimationFourteen:setPosition(ccp(300,400))
		pAnimationFourteen:setTouchEnabled(true)
		pAnimationFourteen:addTouchEventListener(_SelectEquip_CallBack)
	end
end
local function _OpenEquipSelect_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--打开阵容选择等家溯接口，暂时先打开装备去强化
		MatrixLayer.GetMatrixByNewGuilde(7,3,OpenEquipSelect)
		--OpenEquip(EndOpenEquip)
	end
end
function CreateFourteenMarix(fCallBack,nType)
	pAnimationFourteen = GetGuideIcon()
	m_fourteen_CallBack = fCallBack
	if pAnimationFourteen~=nil then
		pAnimationFourteen:setPosition(ccp(190,290))
	else
		AddGuideIcon(ccp(190,290))
		pAnimationFourteen = GetGuideIcon()
	end
	
	pAnimationFourteen:setTouchEnabled(true)
	if tonumber(nType) == 1 then
		--去选择装备
		pAnimationFourteen:addTouchEventListener(_OpenEquipSelect_CallBack)
	end
	if tonumber(nType) == 2 then
		--去点击装备
		pAnimationFourteen:setPosition(ccp(190,300))
		pAnimationFourteen:addTouchEventListener(OpenEquip_CallBack)
	end
end