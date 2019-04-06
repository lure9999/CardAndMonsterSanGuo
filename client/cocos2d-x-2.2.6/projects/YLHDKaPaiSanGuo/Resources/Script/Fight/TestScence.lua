
module("TestScence", package.seeall)

--角度转弧度
function degrees_to_radians( angle )
	return angle * 0.01745329252
end

--弧度转角度
function radians_to_degrees( angle )
	return angle * 57.29577951
end
--local SetAnimationRes = BaseSceneLogic.SetAnimationRes

local m_interface = nil

function Test(pinterface)
	m_interface = pinterface
	local bvel = false
	--bvel =	TestAnimation_file()
	--bvel =	TestAnimation()
	--bvel =	Teststl()
	
	--bvel =	Test_Par_file()
	--bvel =	JsonTest()
	--bvel	= Test_UI_file()
	--bvel	= TestSharder()
	return bvel
end



function JsonTest()
	
	local jason_str = "[1,0.009999999776482582,[100,1000,100.220,1.50,1.880,1.50,1.600000023841858]]"
	print(jason_str)
	local pNetStream = NetStream()
	pNetStream:SetPacket(jason_str)
	
	local test1 = pNetStream:Read()
	
	print(test1)
	Pause()
	local test2 = pNetStream:Read()
	print(test2)
	print(tonumber(test2))
	Pause()
	local test3 = pNetStream:Read()
	--printTab(test3)
	Pause()
	return bvel
end

function Teststl()
	
	local stack1 = simulationStl.creatStack_First()	
	--printTab(stack1)
	--Pause()
	stack1:PushStack(100)
	stack1:PushStack(1000)
	stack1:PushStack(1000)
	--printTab(stack1)
	--Pause()
	
	local stack2 = simulationStl.creatStack_Last()	
	stack2:PushStack(111)
	stack2:PushStack(2222)
	stack2:PushStack(33333)
	--printTab(stack2)
	--Pause()
	
	print(stack1:PopStack())
	print(stack1:PopStack())
	print(stack1:PopStack())
	print(stack1:PopStack())
	Pause()
	--printTab(stack1)
	Pause()
	
	stack2:clearStack()
	--printTab(stack2)
	Pause()
	
	return true
end

function Test_Par_file()

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Log/StrengthenEquip_effect_01/StrengthenEquip_effect_01.ExportJson")
	
	local pArmature = CCArmature:create("StrengthenEquip_effect_01")	
	

	pArmature:setPosition(200,250)	
	
	--pArmature:getAnimation():playWithIndex(6)	
	pArmature:getAnimation():play("qianghua05")
	m_interface:Get_Layer_Root():addChild( pArmature )
	return true
end

function Test_UI_file()

	--local pLayer = CCLayerColor:create(ccc4(0,0,0,0) ,1140*4,640)
	local pUI = GUIReader:shareReader():widgetFromJsonFile("Image/NetworkLoading.json") 
	--pLayer:addChild(pUI)
	
	
	local pFadeOut = CCFadeOut:create(5)
	local pFadeIn = CCFadeIn:create(10)
	
	local pFadeTo = CCFadeTo:create(2, 150)
	
	--pUI:runAction(pFadeOut)
	--pUI:runAction(pFadeIn)	
	pUI:runAction(pFadeTo)	

	--WidgetSetOpacity(pUI,100)
	
	m_interface:Get_Layer_Root():addChild( pUI )
		
	--m_interface:Get_Layer_Root():addChild( pLayer )
	
	return true
end

local function SetAnimationRes(iResID)
	
	local iTempResID = iResID	
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationfileName")
	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)
	
	local pAnimationName = AnimationData.getFieldByIdAndIndex(iTempResID,"AnimationName")

	local pArmature = CCArmature:create(pAnimationName)	
			
	pArmature:getAnimation():play(GetAniName_Player(pArmature,Ani_Def_Key.Ani_stand)) 
			
	return pArmature
	
end

function TestAnimation_file()


	local pArmature1 = SetAnimationRes(1)	
	
	--pArmature1:setPosition(568,320)	
	pArmature1:setPosition(200,250)	
	
	local arr = CCArray:create()	
	arr:addObject(CCInteger:create(1))
	arr:addObject(CCInteger:create(4))
	arr:addObject(CCInteger:create(6))
		
	
	pArmature1:getAnimation():playWithIndexArray(arr, -1, true)		
	

	

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Log/xuanzhuan01/xuanzhuan.ExportJson")
	
	local pArmature = CCArmature:create("xuanzhuan")	
	

	pArmature:setAnchorPoint(ccp(0.5, 0.5))
	
	pArmature:getAnimation():playWithIndex(0)	
	
	local  orbit1 = CCOrbitCamera:create(2, 1, 0, -70, 0, 90, 0)   
	--local  orbit = CCOrbitCamera:create(2, 1, 0, 0, -70, 90, 0)   
    pArmature:runAction( orbit1)
		
	
	--pArmature1:addChild( pArmature ,-1)
	
	local cam = pArmature:getCamera()
	
	--local cam = m_interface:Get_Layer_Root():getCamera()
	
	local x = 0
    local y = 0
    local z = 0
	
	x, y, z = cam:getEyeXYZ(x, y, z)
	
	local x1 = 0
    local y1 = 0
    local z1 = 0
	
	x1, y1, z1 = cam:getCenterXYZ(x1, y1, z1)
	
	local r = z 
   
  	
	
	local za = degrees_to_radians(-70)
	local xa = degrees_to_radians(90)

	local i = math.sin(za) * math.cos(xa) * r + x1
	local j = math.sin(za) * math.sin(xa) * r + y1
	local k = math.cos(za) * r + z1

	--cam:setEyeXYZ(i,j,k)
	
	local FlipY3D1 = CCFlipY3D:create(2.0) 
	
	pArmature:runAction( CCRepeatForever:create(FlipY3D1))
	
--	pArmature1:addChild( pArmature ,10)
	pArmature:setPosition(400,320)	
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	
	local sprite = CCSprite:create("Log//white-512x512.png")
  
    --sprite->setPosition(ccp(s.width/4, s.height/2))
    sprite:setColor(COLOR_Blue)
    sprite:setTextureRect(CCRectMake(0, 0, 128, 128))
	
--	local actionRotateBy = CCRotateBy:create(1, 360)
  --  sprite:runAction(CCRepeatForever:create(actionRotateBy))
	
	local  orbit = CCOrbitCamera:create(2, 1, 0, -70, 0, 90, 0) 
	--sprite:runAction( orbit)
	
	local FlipY3D = CCFlipY3D:create(2.0) 
	
	sprite:runAction( CCRepeatForever:create(FlipY3D))
	sprite:setPosition(400,320)
	
	--pArmature1:addChild( sprite ,5)
	m_interface:Get_Layer_Root():addChild( sprite )
	
	
	m_interface:Get_Layer_Root():addChild( pArmature1 )
	return true
end

function TestAnimation()
	
	local function onMovementEvent(armatureBack,movementType,movementID)
		
		if movementType == MovementEventType.start	then				
			--print(movementID)		
		elseif movementType == MovementEventType.complete then				
			--print(movementID)		
		elseif movementType == MovementEventType.loopComplete then			
			--print(movementID)	
		end		
	end
	
	local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
		if evt == FrameEvent_Key.Event_attack then
           
		
		elseif  evt == FrameEvent_Key.Event_Vibration then
					   
			BaseSceneLogic.VibrationSceen(3)
										   
		elseif  evt == FrameEvent_Key.Event_Blur then
			--设置模糊效果
			local pArmature = bone:getArmature()

			if pArmature ~= nil then
							
				CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Blur)			
			end	
			
		elseif  evt == FrameEvent_Key.Event_Normal then
			
			local pArmature = bone:getArmature()

			if pArmature ~= nil then
			
				local ipos = pArmature:getTag()				
				CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Normal)					
						
			end	
		else
		   
        end
	end
	
	--local pArmature = SetAnimationRes(ierror)	
	
	local pArmature = SetAnimationRes(1)		
	
	pArmature:getAnimation():setFrameEventCallFunc( onFrameEvent)
	pArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
	
	pArmature:setPosition(480,320)	
	
	local arr = CCArray:create()	
	arr:addObject(CCInteger:create(1))
	arr:addObject(CCInteger:create(4))
	arr:addObject(CCInteger:create(6))
	--arr:addObject(CCInteger:create(7))
	--arr:addObject(CCInteger:create(8))
	
	--pArmature:getAnimation():playWithIndexArray(arr, -1, false)	
	
	pArmature:getAnimation():playWithIndexArray(arr, -1, true)	
	
	--pArmature:getAnimation():play(Ani_attack,-1,-1,1)
	
	
		
	local  orbit = CCOrbitCamera:create(2, 1, 0, -60, 0, 90, 0)
    local  orbit_back = orbit:reverse()
    local arr1 = CCArray:create()
    arr1:addObject(orbit)
    arr1:addObject(orbit_back)
    pArmature:runAction( CCRepeatForever:create( CCSequence:create(arr1)))
	
	
	
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	return true
	
end

function TestSharder()
	--test
	local pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150,440)	
	--CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Banish)	
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+200,440)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Blur)
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+400,440)	
	--pArmature:setScale(1.5)
	--pArmature:getAnimation():setSpeedScale(pArmature:getAnimation():getSpeedScale()*1.5)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Frozen)
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+600,440)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_GrayScaling)
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	--下行
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150,240)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Ice)	
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+200,240)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Poison)
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+400,240)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_SpriteGray)
	m_interface:Get_Layer_Root():addChild( pArmature )
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+600,240)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Stone)
	m_interface:Get_Layer_Root():addChild( pArmature )	
	
	pArmature = SetAnimationRes(1)	
	pArmature:setPosition(150+800,240)	
	CCArmatureSharder(pArmature,SharderKey.E_SharderKey_Color_R)
	--pArmature:setColor(ccc3(237,49,56))
	m_interface:Get_Layer_Root():addChild( pArmature )	
	
	
	
	return true
	
end