
--新手引导第一大部 之添加NPC celina
module("NewGuideServerOne_AddNPC", package.seeall)



--local DeleteGuide = NewGuideLayer.DeleteGuide
--local SetColorOpacity = NewGuideLayer.SetColorOpacity

local pNPC = nil
local m_fCallBack = nil 
--添加指引人物
local function AddNewGuidePerson()
	
	--添加孙尚香
	local resID = general.getFieldByIdAndIndex(7004, "ResID")
	local animationFileName = AnimationData.getFieldByIdAndIndex(resID,"AnimationfileName")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(animationFileName)
	local animationName = AnimationData.getFieldByIdAndIndex(resID,"AnimationName")
	pNPC = CCArmature:create(animationName)
    pNPC:getAnimation():play(GetAniName_Res_ID(resID, Ani_Def_Key.Ani_manual_skill))
	pNPC:setPosition(ccp(570+CommonData.g_Origin.x,320+CommonData.g_Origin.y))
	 local pLayout= tolua.cast(MainScene.GetControlUI():getWidgetByName("Panel_Main_Root"),"Layout")
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			--pNPC:getAnimation():play(GetAniName_Res_ID(resID, Ani_Def_Key.Ani_manual_skill))
			--增加50经验
			pNPC:removeFromParentAndCleanup(true)
			pLayout:setBackGroundColorOpacity(0)
			if m_fCallBack~=nil then
				--print("============")
				m_fCallBack()
				m_fCallBack = nil 
			end
		end
		
	end
	 pNPC:getAnimation():setMovementEventCallFunc(onMovementEvent)
	
	pLayout:setBackGroundColorOpacity(120)
	MainScene.GetControlUI():addChild(pNPC)
	
	
end

--[[function PlayAtk()
	if pNPC~=nil then
		local resID = general.getFieldByIdAndIndex(6038, "ResID")
		pNPC:getAnimation():play(GetAniName_Res_ID(resID, Ani_Def_Key.Ani_attack))
		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				--pNPC:getAnimation():play(GetAniName_Res_ID(resID, Ani_Def_Key.Ani_manual_skill))
				--增加50经验
			end
			
		end
		pNPC:getAnimation():play(GetAniName_Res_ID(resID, Ani_Def_Key.Ani_manual_skill))
	end
end]]--

function CreateAddNPC(fCallBack)
	
	m_fCallBack = fCallBack
	
	AddNewGuidePerson()
end