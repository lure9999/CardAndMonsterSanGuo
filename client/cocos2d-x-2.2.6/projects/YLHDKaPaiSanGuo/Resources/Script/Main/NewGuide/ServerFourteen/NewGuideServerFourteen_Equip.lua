
--新手引导的服务器步骤第十四大步骤之 打开装备
module("NewGuideServerFourteen_Equip", package.seeall)


local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon

local m_equip_CallBack = nil 
local m_equip_animation = nil 


local function _Click_Fight_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--点击一下战斗力
		--去对话
		if m_equip_CallBack~=nil then
			m_equip_CallBack()
		end
		if m_equip_animation~=nil then
			DeleteGuide()
		end
	end
end
local function _Strengthen_Over()
	--network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(14))
	if m_equip_animation~=nil then
		m_equip_animation:setPosition(ccp(860,550))
		m_equip_animation:setTouchEnabled(true)
		m_equip_animation:addTouchEventListener(_Click_Fight_CallBack)
	end
end
local function _Start_Strengthen_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		m_equip_animation:setTouchEnabled(false)
		EquipStrengthen.ToStrengthenByNewGuide(_Strengthen_Over)
	end
end
local function OpenStrengthen()
	--到强化界面
	print("OpenStrengthen=========")
	if m_equip_animation~=nil then
		m_equip_animation:setPosition(ccp(460,10))
		m_equip_animation:setTouchEnabled(true)
		m_equip_animation:addTouchEventListener(_Start_Strengthen_CallBack)
	end
end
local function _To_Strengthen_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		print("_To_Strengthen_CallBack=========")
		m_equip_animation:setTouchEnabled(false)
		EquipPropertyLayer.OpenStrengthenGuide(OpenStrengthen)
	end
end
local function OpenEquipSelect()
	m_equip_animation  = GetGuideIcon()
	print("OpenEquipSelect=========")
	if m_equip_animation~=nil then
		m_equip_animation:setPosition(ccp(810,16))
		m_equip_animation:setTouchEnabled(true)
		m_equip_animation:addTouchEventListener(_To_Strengthen_CallBack)
	end
end
function OpenEquip(fCallBack)
	m_equip_CallBack = fCallBack
	local nGird = server_equipDB.GetGridByTempId(1012)
	if nGird~=nil then
		print("OpenEquip")
		MatrixLayer.GetMatrixByNewGuilde(9,nGird,OpenEquipSelect,3)
	end
	
	
end