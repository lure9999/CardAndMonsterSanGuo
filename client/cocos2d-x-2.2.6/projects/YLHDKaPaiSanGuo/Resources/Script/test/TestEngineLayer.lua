--测试脚本 针对引擎内存测试资源用

module("TestEngineLayer", package.seeall)
--require "Script/Login/res_test"
local m_UIScene = nil
local m_pSprite = nil
local m_UILayer = nil


local off_y = 50
local off_X = 50

local MaxLine = 0	

local function CreatMenItem( LabelText, fontSize , pregisterScriptHandler ,index)
	
	-- add a popup menu
	local labelPopupItem = CCLabelTTF:create(LabelText, "Arial", fontSize)
	local menuPopupItem = CCMenuItemLabel:create(labelPopupItem)
	menuPopupItem:setPosition(0, 0)	
	menuPopupItem:registerScriptTapHandler(pregisterScriptHandler)
	local menuPopup = CCMenu:createWithItem(menuPopupItem)
	local itemWidth = menuPopupItem:getContentSize().width
	local itemHeight = menuPopupItem:getContentSize().height
	
		
	if ( 640 - itemHeight/2 -off_y*(index -MaxLine)) > 0 then
		menuPopup:setPosition(off_X + itemWidth/2 , 640 - itemHeight/2 -off_y*(index -MaxLine))
	else
		MaxLine = index-1
		menuPopup:setPosition( (off_X +itemWidth)*(index -MaxLine+1) ,  640 - itemHeight/2 -off_y*(index -MaxLine))
	end
	
	return menuPopup
	
end 
 
--测试 对话
local function createLayerMenuTalk()

	local layerMenu = CCLayer:create()	
	
	local	m_strText_username = CCEditBox:create (CCSizeMake(300,53), CCScale9Sprite:create("Image/imgres/common/text_bk.png"))
	m_strText_username:setPosition(ccp(320,580))
	m_strText_username:setPlaceHolder("input TalkID")
	m_strText_username:setPlaceholderFontColor(ccc3(177, 177, 177))	
	m_strText_username:setFontColor(ccc3( 0x78, 0x25, 0x00))
	m_strText_username:setMaxLength(24)
	m_strText_username:setReturnType(kKeyboardReturnTypeDone)
	m_strText_username:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	--m_strText_username:setText("请输入账号")
	m_strText_username:setTouchPriority(-129)
		
	m_UIScene:addChild(m_strText_username, 1, 100)

	
	
	local function menuCallback_Talk() 	   
	 
		  local id = tonumber(m_strText_username:getText() )
		  if id > 0 then 
		  	  HeroTalkLayer.createHeroTalkUI(id) 
		  else
			  print("输入错误")
		  end
	end
	

	layerMenu:addChild(CreatMenItem("TalkTest", 24,menuCallback_Talk,1))
	
		
	return layerMenu
end

function createTestTalk()

	require "Script/Main/Chat/HeroTalkLayer"
	
	
	m_UIScene = CCScene:create()
	
	m_pSprite = ImageView:create()
	m_pSprite:setPosition(ccp(960 *3/ 4, 640 *4 / 8))
	m_UIScene:addChild(m_pSprite,100)
	
	
	m_UIScene:addChild(createLayerMenuTalk())		
	
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true
end

function DelArmature( Armature )
	local pArmature = tolua.cast(Armature, "CCArmature")
	if pArmature ~= nil then 
	
		local pbone = pArmature:getParentBone() 
	
		if pbone ~= nil then
				
			local parArmature = pbone:getArmature()
			if parArmature ~= nil then 				
				pbone:autorelease()
				pbone:retain()
				parArmature:removeBone(pbone,true)	
				
			else
				print("*******DelArmature***********")			
				
			end				
		
		else
			Armature:removeFromParentAndCleanup(true)			
		end
	else
		print("DelArmature error")	
	end
	
	print("DelArmature ")
	
end




--//技能特效回调 播放完自动删除 
function onEffectMovementEvent(Armature, MovementType, movementID)

	if MovementType == 0	then
	
	elseif MovementType == 1 then					
		
	--	Armature:getAnimation():playWithIndex(1)
		DelArmature(Armature)
	
	elseif MovementType == 2 then		
		
		DelArmature(Armature)
	end
end

local g_EffectID = 1000
function CreatBoneName()
	
	g_EffectID = g_EffectID + 1
	
	return "BoneEffect" .. g_EffectID
	
end

--测试 骨骼动画
local function createboneLayerMenuTalk()

	local layerMenu = CCLayer:create()	
	

	local pArmaturenv = nil
	local index = 0
	local function menuCallback_1() 	   
	 
		  
		local pAnimationfileName = "Image/Fight/player/nvzhu/nvzhu.ExportJson"		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		local pAnimationName = "nvzhu"
		pArmaturenv = CCArmature:create(pAnimationName)					
		pArmaturenv:setPosition(480,320)	
		
		--增加多皮肤
		local skin = nil
	   -- skin = CCSkin:createWithSpriteFrameName("Log/tietu/attack_weapons01_nvzhu_zs_01.png")
       -- pArmaturenv:getBone("layer7"):addDisplay(skin, 1)
		
		skin = CCSkin:create("Log/tietu/bar_nvzhu_01.png")
		
		if skin == nil then 
			print("skin == nil ")
			Pause()
		end
		
		local index = 1
        pArmaturenv:getBone("bra"):addDisplay(skin, index)		  
		
		skin = CCSkin:create("Log/tietu/body_nvzhu_01.png")
        pArmaturenv:getBone("body"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/head_nvzhu_01.png")
        pArmaturenv:getBone("head"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress01_nvzhu_01.png")
        pArmaturenv:getBone("headdress01"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress02_nvzhu_01.png")
        pArmaturenv:getBone("headdress02"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress03_nvzhu_01.png")
        pArmaturenv:getBone("headdress03"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress04_nvzhu_01.png")
        pArmaturenv:getBone("headdress04"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress05_nvzhu_01.png")
        pArmaturenv:getBone("headdress05"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress06_nvzhu_01.png")
        pArmaturenv:getBone("headdress06"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress07_nvzhu_01.png")
        pArmaturenv:getBone("headdress07"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress08_nvzhu_01.png")
        pArmaturenv:getBone("headdress08"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress09_nvzhu_01.png")
        pArmaturenv:getBone("headdress09"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress10_nvzhu_01.png")
        pArmaturenv:getBone("headdress10"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/headdress11_nvzhu_01.png")
        pArmaturenv:getBone("headdress11"):addDisplay(skin, index)
		
		skin = CCSkin:create("Log/tietu/l_cloak01_nvzhu_01.png")
        pArmaturenv:getBone("l_cloak"):addDisplay(skin, index)
		
		
	
		local arr = CCArray:create()			
		arr:addObject(CCInteger:create(0))
		arr:addObject(CCInteger:create(1))
		arr:addObject(CCInteger:create(2))
			arr:addObject(CCInteger:create(3))
			arr:addObject(CCInteger:create(4))
			arr:addObject(CCInteger:create(5))
			arr:addObject(CCInteger:create(6))
			arr:addObject(CCInteger:create(7))
			arr:addObject(CCInteger:create(8))
			arr:addObject(CCInteger:create(9))
		pArmaturenv:getAnimation():playWithIndexArray(arr, -1, true)			
		layerMenu:addChild( pArmaturenv )			
		  
	end
	
	local function menuCallback_2() 	   
	 
		-- index = ((index+1)%2)*10
		   index = 1
		  --pArmaturenv:getBone("layer7"):changeDisplayWithIndex(index, true)
		   pArmaturenv:getBone("bra"):changeDisplayWithIndex(1, true)
		   --pArmaturenv:getBone("bra"):changeDisplayWithName( "Log/tietu/bar_nvzhu_01.png", true)
		   
		   
		    pArmaturenv:getBone("body"):changeDisplayWithIndex(index, true)
			 pArmaturenv:getBone("head"):changeDisplayWithIndex(index, true)
			  pArmaturenv:getBone("headdress01"):changeDisplayWithIndex(index, true)
			   pArmaturenv:getBone("headdress02"):changeDisplayWithIndex(index, true)
			    pArmaturenv:getBone("headdress03"):changeDisplayWithIndex(index, true)
				 pArmaturenv:getBone("headdress04"):changeDisplayWithIndex(index, true)
				  pArmaturenv:getBone("headdress05"):changeDisplayWithIndex(index, true)
				   pArmaturenv:getBone("headdress06"):changeDisplayWithIndex(index, true)
				    pArmaturenv:getBone("headdress07"):changeDisplayWithIndex(index, true)
					 pArmaturenv:getBone("headdress08"):changeDisplayWithIndex(index, true)
					  pArmaturenv:getBone("headdress09"):changeDisplayWithIndex(index, true)
					   pArmaturenv:getBone("headdress10"):changeDisplayWithIndex(index, true)
					    pArmaturenv:getBone("headdress11"):changeDisplayWithIndex(index, true)
						 pArmaturenv:getBone("l_cloak"):changeDisplayWithIndex(index, true)
		  
	end
	
	local pArmatureMC = nil

	
	local function menuCallback_5()
	
		local pAnimationfileName = "Log/player/machao/machao.ExportJson"		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		local pAnimationName = "machao"
		pArmatureMC = CCArmature:create(pAnimationName)					
		pArmatureMC:setPosition(680,320)	
	
		local arr = CCArray:create()			
		arr:addObject(CCInteger:create(0))
		arr:addObject(CCInteger:create(1))
		arr:addObject(CCInteger:create(2))
			arr:addObject(CCInteger:create(3))
			arr:addObject(CCInteger:create(4))
			arr:addObject(CCInteger:create(5))
			arr:addObject(CCInteger:create(6))
			arr:addObject(CCInteger:create(7))
			arr:addObject(CCInteger:create(8))
		pArmatureMC:getAnimation():playWithIndexArray(arr, -1, true)
		--pArmatureMC:getAnimation():playWithIndex(0)
		layerMenu:addChild( pArmatureMC )
		
	end
	
	local function menuCallback_3() 	   
	 		
	
		local pAnimationfileName = "Image/Fight/skill/dianwei_hitted03/dianwei_hitted03.ExportJson"	
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		
		local pAnimationName = "dianwei_hitted03"
		
		
		local pArmatureEffect = CCArmature:create(pAnimationName)				
	
		pArmatureEffect:getAnimation():playWithIndex(0)	
		
		pArmatureEffect:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
		local bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(pArmatureEffect, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)			
		bone:setZOrder(100)	

		pArmatureMC:addBone(bone, "bone_renhou")
		--pArmatureMC:addBone(bone, "bone_renqian")
			  
	end
	
	local function menuCallback_6() 	   
	 			
		local pbone_rq = pArmatureMC:getBone("bone_renqian")
		--print(pbone_rq:getZOrder())
		
		
	--	local pbone_rh = pArmatureMC:getBone("bone_renhou")		
		
		local pAnimationfileName = "Image/Fight/skill/huatuo_skill02_01/huatuo_skill02_01.ExportJson"	
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		local pAnimationName = "huatuo_skill02_01"	
		
		local pArmatureEffect = CCArmature:create(pAnimationName)			
		pArmatureEffect:getAnimation():playWithIndex(0)	
		
		pArmatureEffect:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
		
		local bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(pArmatureEffect, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)
		bone:setZOrder(100)
		pArmatureMC:addBone(bone, "bone_renqian")
			
			
	end
	
	local function menuCallback_4()
		
		local index = math.random(0, 9)
		pArmatureMC:getAnimation():playWithIndex(index)
	end
	
	
	local function menuCallback_7()

		if pArmatureMC ~= nil then
			
			DelArmature(pArmatureMC)
			pArmatureMC = nil
		end
		
	end
	
	local function menuCallback_8() 	   
	 		
	
		local pAnimationfileName = "Log/test_pushanbing_skill001/pushanbing_skill001.ExportJson"	
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		
		local pAnimationName = "pushanbing_skill001"
		
		
		local pArmatureEffect = CCArmature:create(pAnimationName)				
	
		pArmatureEffect:getAnimation():playWithIndex(0)	
		
		pArmatureEffect:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
		local bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(pArmatureEffect, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)			
		bone:setZOrder(100)	
		
		pArmatureMC:addBone(bone, "bone_renhou")
		--pArmatureMC:addBone(bone, "bone_renqian")
		
		local pbone_skill001 = pArmatureEffect:getBone("skill001")	
		
		print(pbone_skill001:getZOrder())
		
		local pbone_skill002 = pArmatureEffect:getBone("skill002")	
		print(pbone_skill002:getZOrder())
		--pbone_skill001:setZOrder(100)		  
	end
	
	

	layerMenu:addChild(CreatMenItem("add animation", 24,menuCallback_1,1))
	layerMenu:addChild(CreatMenItem("change tou", 24,menuCallback_2,2))
	layerMenu:addChild(CreatMenItem("add noloopeffect", 24,menuCallback_3,3))
	layerMenu:addChild(CreatMenItem("play 1", 24,menuCallback_4,4))
	layerMenu:addChild(CreatMenItem("add machao", 24,menuCallback_5,5))
	layerMenu:addChild(CreatMenItem("add loopeffect", 24,menuCallback_6,6))
	layerMenu:addChild(CreatMenItem("del machao", 24,menuCallback_7,7))
	layerMenu:addChild(CreatMenItem("testeffectorder", 24,menuCallback_8,8))
	
	local pArmaturecaocao = nil
	local aniIndex = 0
	local function menuCallback_9()
	
		local pAnimationfileName = "Log/player/caocao/caocao.ExportJson"		
		--local pAnimationfileName = "Image/Fight/player/nvzhu/nvzhu.ExportJson"		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		--local pAnimationName = "nvzhu"
		local pAnimationName = "caocao"
		pArmaturecaocao = CCArmature:create(pAnimationName)					
		pArmaturecaocao:setPosition(680,320)	
	
		local arr = CCArray:create()			
		arr:addObject(CCInteger:create(0))
		arr:addObject(CCInteger:create(1))
		arr:addObject(CCInteger:create(2))
			arr:addObject(CCInteger:create(3))
			arr:addObject(CCInteger:create(4))
			arr:addObject(CCInteger:create(5))
			arr:addObject(CCInteger:create(6))
			arr:addObject(CCInteger:create(7))
			arr:addObject(CCInteger:create(8))
		--pArmaturecaocao:getAnimation():playWithIndexArray(arr, -1, true)
		pArmaturecaocao:getAnimation():playWithIndex(aniIndex)
		--pArmaturecaocao:setScaleX(-pArmaturecaocao:getScaleX())
		layerMenu:addChild( pArmaturecaocao )
		
	end
	
	local function menuCallback_10() 	   

		local bone_xuetiao = "xuetiao"
		local bone_shenshang = "shenshang"
		local bone_jiaoxia = "jiaoxia"			
			
		
		local pAnimationfileName = "Image/Fight/skill/huatuo_skill02_01/huatuo_skill02_01.ExportJson"	
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		local pAnimationName = "huatuo_skill02_01"	
		
		local pArmatureEffect = CCArmature:create(pAnimationName)			
		pArmatureEffect:getAnimation():playWithIndex(0)			
		--pArmatureEffect:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
		
		local bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(pArmatureEffect, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)
		bone:setZOrder(100)
		pArmaturecaocao:addBone(bone, "shenshang")
		
		--底下的特效
		
		pAnimationfileName = "Image/Fight/skill/huatuo_skill02_02/huatuo_skill02_02.ExportJson"	
		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		pAnimationName = "huatuo_skill02_02"	
		
		pArmatureEffect = CCArmature:create(pAnimationName)			
		pArmatureEffect:getAnimation():playWithIndex(0)			
		--pArmatureEffect:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
			
		
		bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(pArmatureEffect, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)
		--bone:setZOrder(100)
		pArmaturecaocao:addBone(bone, "jiaoxia")
		
		
		--头顶
		local loadingBarBack = LoadingBar:create()
		loadingBarBack:setName("HP_LoadingBarBack")
		loadingBarBack:loadTexture("Image/Fight/UI/hpline_bg.png")
		loadingBarBack:setDirection(0)
		
		loadingBarBack:setTag(20000)
		loadingBarBack:setPercent(100)		

		local loadingBarHp = LoadingBar:create()
		loadingBarHp:setName("HP_Loading")
		loadingBarHp:loadTexture("Image/Fight/UI/hpline.png")
		loadingBarHp:setDirection(0)

		loadingBarHp:setTag(19999)
		loadingBarHp:setPercent(100)
		
				
		bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(loadingBarBack, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)
		bone:setZOrder(100)
		pArmaturecaocao:addBone(bone, "xuetiao")
		
		
		bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(loadingBarHp, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)
		bone:setZOrder(111)
		pArmaturecaocao:addBone(bone, "xuetiao")			
			
	end
	
	local function menuCallback_11()

		if pArmaturecaocao ~= nil then
			
			aniIndex = aniIndex +1
			
			pArmaturecaocao:getAnimation():playWithIndex(aniIndex%10,-1,-1,1)
			
		end
		
	end
	
	function OnDamageNumEnd(pNode)	
	
		local pUILabelBMFont = tolua.cast(pNode, "LabelBMFont")

		pUILabelBMFont:removeFromParentAndCleanup(true)	
	end
	
	local function menuCallback_12()

		if pArmaturecaocao ~= nil then			
			
			--pArmaturecaocao:getAnimation():playWithIndex(aniIndex%10)
			
								
			local pDelayStar = CCDelayTime:create(0.1)	
			local pScaleTo = CCScaleTo:create(0.1,2.0,2.0)
			local pScaleTo1 = CCScaleTo:create(0.1,1.0,1.0)
			local pDelay = CCDelayTime:create(0.4)
			local pScaleTo2 = CCScaleTo:create(0.1,0.1,0.1)		
			local pcallFunc = CCCallFuncN:create(OnDamageNumEnd)
			local pDelay1 = CCDelayTime:create(0.1)	
				
			local pScaleTo3 = CCScaleTo:create(0.1,2.0,2.0)
			local pScaleTo4 = CCScaleTo:create(0.2,1.0,1.0)
			
			local arr = CCArray:create()
			arr:addObject(pDelayStar)
			--arr:addObject(pScaleTo)
			arr:addObject(pScaleTo3)
			
			--arr:addObject(pDelay1)
		--	arr:addObject(pScaleTo1)
			arr:addObject(pScaleTo4)
			--arr:addObject(pDelay)
			--arr:addObject(pScaleTo2)
			arr:addObject(CCFadeOut:create(0.5))
			arr:addObject(pcallFunc)		
			
			local pScaleToseq  = CCSequence:create(arr)
			
			local pMoveUp = CCMoveBy:create(0.8,ccp(0,100))
			
			local spawn = CCSpawn:createWithTwoActions(pMoveUp, pScaleToseq)
			
			
			--// Create the LabelBMFont
			local labelBMFont = LabelBMFont:create()						
			labelBMFont:setFntFile("Image/Fight/UI/blood/greenblood.fnt")	

			local pBone = pArmaturecaocao:getBone("xuetiao")	
			
			if pArmaturecaocao:getScaleX() > 0 then
				
				labelBMFont:setPosition(ccp( pArmaturecaocao:getPositionX()+ pBone:nodeToArmatureTransform().tx, pArmaturecaocao:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
									
			else
			
				labelBMFont:setPosition(ccp( pArmaturecaocao:getPositionX() - pBone:nodeToArmatureTransform().tx, pArmaturecaocao:getPositionY() + pBone:nodeToArmatureTransform().ty ))	
		
			end 					
			
			labelBMFont:setText("+" .. 500)
			labelBMFont:setZOrder(100)
			labelBMFont:runAction(spawn)
			
		
			layerMenu:addChild(labelBMFont)
			
		end
		
	end
	
	local function menuCallback_13() 	   
	 		
	
		--local pAnimationfileName = "Image/Fight/skill/dianwei_hitted03/dianwei_hitted03.ExportJson"	
		local pAnimationfileName = "Image/Fight/skill/nvzhu_zs_skill01/nvzhu_zs_skill01.ExportJson"
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		
		local pAnimationName = "nvzhu_zs_skill01"
		
		
		local pArmatureEffect = CCArmature:create(pAnimationName)				
	
		pArmatureEffect:getAnimation():playWithIndex(0)	
		
		pArmatureEffect:getAnimation():setMovementEventCallFunc(onEffectMovementEvent)
		
		--pArmatureEffect:setScaleX(-(pArmatureEffect:getScaleX()))
			
		local bone  = CCBone:create(CreatBoneName())		
		bone:addDisplay(pArmatureEffect, 0)
		bone:changeDisplayWithIndex(0, true)
		bone:setIgnoreMovementBoneData(true)			
		bone:setZOrder(100)	
		--bone:setScaleX(-(bone:getScaleX()))
		

		pArmaturecaocao:addBone(bone, "shenshang")
		--pArmaturecaocao:addBone(bone, "bone_renqian")
			  
	end
	
	local function menuCallback_14()
	
		local pAnimationfileName = "Image/Fight/cg/piantou03/piantou03.ExportJson"		
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pAnimationfileName)		
		local pAnimationName = "piantou03"
		
		local pArmatureMC = CCArmature:create(pAnimationName)					
		pArmatureMC:setPosition(570,320)	
	
		--Pause()
		pArmatureMC:getAnimation():playWithIndex(0)
		layerMenu:addChild( pArmatureMC )
		
	end

	
	layerMenu:addChild(CreatMenItem("add caocao  ", 24,menuCallback_9,9))
	layerMenu:addChild(CreatMenItem("add effect ", 24,menuCallback_10,10))
	layerMenu:addChild(CreatMenItem("playani ", 24,menuCallback_11,11))
	layerMenu:addChild(CreatMenItem("playani again", 24,menuCallback_12,12))
	
	layerMenu:addChild(CreatMenItem("playani piantou03", 24,menuCallback_14,14))
		
	return layerMenu
end


function createTestBone()

		
	m_UIScene = CCScene:create()
		
	
	m_UIScene:addChild(createboneLayerMenuTalk())		
	
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true
end


function createSceneLayerMenu()

	local layerMenu = CCLayer:create()	
	
	local	m_strText_username = CCEditBox:create (CCSizeMake(300,53), CCScale9Sprite:create("Image/imgres/common/text_bk.png"))
	m_strText_username:setPosition(ccp(330,580))
	m_strText_username:setPlaceHolder("Scence FIle")
	m_strText_username:setPlaceholderFontColor(ccc3(177, 177, 177))	
	m_strText_username:setFontColor(ccc3( 0x78, 0x25, 0x00))
	m_strText_username:setMaxLength(24)
	m_strText_username:setReturnType(kKeyboardReturnTypeDone)
	m_strText_username:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	--m_strText_username:setText("请输入账号")
	m_strText_username:setTouchPriority(-129)
		
	m_UIScene:addChild(m_strText_username, 1, 100)
	
	G_FightScene_Root_TagID 		=		10000
	G_FightScene_Layer_Back_TagID 	=	13000
	G_FightScene_Layer_Middle_TagID =	12000
	G_FightScene_Layer_Front_TagID 	=	11000
	
	MaxMoveDistance = 960
	MaxPlayMoveSpeed = 180
	SceneEnterTime = MaxMoveDistance/MaxPlayMoveSpeed

	local m_pGameScene = nil
	local m_pGameNode_Back = nil
	local m_pGameNode_Middle = nil
	local m_pGameNode_Front = nil
	
	local m_itimes = 1
	
	local function menuCallback_Scence() 	   
	 
		  local FileName = tostring(m_strText_username:getText())
		  if FileName ~= nil then 
		  	 
			if  m_pGameScene ~= nil then 
				
				m_pGameScene:removeFromParentAndCleanup(true)
				m_itimes = 1
			end
			
			m_pGameScene = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/" .. FileName)

			m_UIScene:addChild(m_pGameScene)

			m_pGameNode_Back = m_pGameScene:getChildByTag(G_FightScene_Layer_Back_TagID)

			m_pGameNode_Middle = m_pGameScene:getChildByTag(G_FightScene_Layer_Middle_TagID)

			m_pGameNode_Front = m_pGameScene:getChildByTag(G_FightScene_Layer_Front_TagID)
			
			 
		  else
			  print("输入错误")
		  end
	end
	
	function PlaySceneEnter()
		
		if m_pGameScene == nil then 
			
			print("没有加载场景")
			return
		end 
		
		if m_itimes < 3 then 
			m_itimes = m_itimes +1
		else
			print("场景到头了")
			return
		end
		
		
					
		local pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance*0.5,0))
		m_pGameNode_Back:runAction(pMoveBy)	
		
		pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance,0))	
		m_pGameNode_Middle:runAction(pMoveBy)	

		pMoveBy = CCMoveBy:create(SceneEnterTime,ccp(-MaxMoveDistance*1.5,0))	
		m_pGameNode_Front:runAction(pMoveBy)	
		
		
	end
	
	
	local function menuCallback_Run() 	   
	 
		PlaySceneEnter()
		print("Run")
		
		
	end
	

	layerMenu:addChild(CreatMenItem("ScenceTest", 24,menuCallback_Scence,1))
	
	layerMenu:addChild(CreatMenItem("Run", 24,menuCallback_Run,2))
	
		
	return layerMenu
	
end

function createTestScence()

		
	m_UIScene = CCScene:create()
		
	
	m_UIScene:addChild(createSceneLayerMenu(),100)		
	
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true
end

--测试lua写法 支持多分的问题
function createTestLua()
		
	m_UIScene = CCScene:create()
	
	local TouchGrouplayer = TouchGroup:create()
	m_UIScene:addChild(TouchGrouplayer)	
			
	require "Script/test/TestLua"
	
	local bt1 = TestLua.CreatTestLua_1(100,200,300)
	bt1:setPosition(ccp(100,300))
	
	TouchGrouplayer:addWidget(bt1)	
	
	local bt2 = TestLua.CreatTestLua_1(1000,2000,3000)
	bt2:setPosition(ccp(300,300))
	
	TouchGrouplayer:addWidget(bt2)	
	
	
	--存储表
	local btInterface1 = TestLua.CreatTestLua_2(1,2,3)
	local bt3 = btInterface1:GetUiPtr()
	bt3:setPosition(ccp(100,100))	
	TouchGrouplayer:addWidget(bt3)	
	
	btInterface1:PrintData()
	
	
	local btInterface2 = TestLua.CreatTestLua_2(999,888,777)
	local bt4 = btInterface2:GetUiPtr()
	bt4:setPosition(ccp(300,100))	
	TouchGrouplayer:addWidget(bt4)	
	btInterface2:PrintData()
	
	local btInterface3 = TestLua.CreatTestLua_3()
	
	for i=1,4 do 
		btInterface3:RegisterObserver(i,TestLua.CreateTestLuaCallBack(i))
	end
	
	btInterface3:Notify()
	
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true
end

--测试新场景
local function createNewFightTestLua()

	local function SceneEvent(tag)
	
		if tag == "enter" then				
			CCDirector:sharedDirector():purgeCachedData()	
		end
		
		if tag == "enterTransitionFinish" then	
		
		end	
		
		if tag == "exit" then				
				
		end	
		
		if tag == "exitTransitionStart" then		
			
		end	
		
		if tag == "cleanup" then			
						
		end	
		
	end			
		
	m_UIScene = CCScene:create()	
	m_UIScene:registerScriptHandler(SceneEvent)	


	--战斗UI
	require "Script/Fight_New/Scene_FightUIObj"
	m_UILayer = Scene_FightUIObj.CreateBaseObj()
	
	local layerMenu = CCLayer:create()		
	local function menuCallback_FightTest() 	   
	 
		require "Script/Fight_New/Scene_Manger"
		Scene_Manger.CreateScene(Scene_Type.Type_Base, m_UILayer) 
		Scene_Manger.InitScenceData(nil)
		Scene_Manger.EnterBaseScene()
	end
	
	layerMenu:addChild(CreatMenItem("FightTest", 24,menuCallback_FightTest,1))		
	m_UIScene:addChild(layerMenu,100)			
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true
end


--测试新场景
local function createAnySDKTestLua()

	local function SceneEvent(tag)
	
		if tag == "enter" then				
			CCDirector:sharedDirector():purgeCachedData()	
		end
		
		if tag == "enterTransitionFinish" then	
		
		end	
		
		if tag == "exit" then				
				
		end	
		
		if tag == "exitTransitionStart" then		
			
		end	
		
		if tag == "cleanup" then			
						
		end	
		
	end			
		
	m_UIScene = CCScene:create()	
	m_UIScene:registerScriptHandler(SceneEvent)	

	local layerMenu = CCLayer:create()		
	local function menuCallback_LoginTest() 	   
	 
		print("AnySDKLogin")
		AnySDKLogin()
		
	end
	
	local function menuCallback_payTest() 	   
	 
		print("AnySDKLogin")
		AnySDKLogin()
		
	end
	
	
	layerMenu:addChild(CreatMenItem("LoginTest", 24,menuCallback_LoginTest,1))		
	m_UIScene:addChild(layerMenu,100)			
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true
end

function Initcityroad_editData()
	
	local function SceneEvent(tag)
	
		if tag == "enter" then				
			CCDirector:sharedDirector():purgeCachedData()	
		end
		
		if tag == "enterTransitionFinish" then	
		
		end	
		
		if tag == "exit" then				
				
		end	
		
		if tag == "exitTransitionStart" then		
			
		end	
		
		if tag == "cleanup" then			
						
		end	
		
	end			
		
	m_UIScene = CCScene:create()	
	m_UIScene:registerScriptHandler(SceneEvent)	

	local layerMenu = CCLayer:create()		
	local function menuCallback_Initcityroad_editData() 
		require "Script/Common/Common"
		require "Script/Network/packet/NetStream"
		require "Script/serverDB/cityroad_edit"
		require "Script/Main/Wujiang/GeneralBaseData"
		require "Script/Main/CountryWar/CountryWarDef"
		require "Script/Main/CountryWar/CountryWarData"				
		CountryWarData.Initcityroad_editData()
		print("Initcityroad_editData ok")	
	end
	
	layerMenu:addChild(CreatMenItem("Initcityroad_editData", 24,menuCallback_Initcityroad_editData,1))		
	m_UIScene:addChild(layerMenu,100)			
    CCDirector:sharedDirector():runWithScene(m_UIScene)		
	
	return true

end

function TestEngine(  )

  	local bvel = false
	
	-- bvel =  createTestNetLayer()
	 --bvel =  createTestTalk()
	 
	--bvel =  createTestBone()
	--bvel =  createTestScence()
	
	--bvel = createTestLua()
	
	--bvel = createNewFightTestLua()
	
	--bvel = createAnySDKTestLua()
	--bvel = Initcityroad_editData()
	return bvel
end
	





