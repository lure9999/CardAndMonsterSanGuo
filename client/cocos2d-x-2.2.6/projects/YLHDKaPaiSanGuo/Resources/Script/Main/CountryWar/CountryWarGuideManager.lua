require "Script/Main/CountryWar/CountryWarScene"
require "Script/Main/CountryWar/CountryWarData"


module("CountryWarGuideManager", package.seeall) 			--给新手指引调用的接口对象

local GetPlayerCountry 					=	CountryWarData.GetPlayerCountry
local GetGeneralResId					= 	CountryWarData.GetGeneralResId

local UIInterface_CreatAnimateByResID 	= 	UIInterface.CreatAnimateByResID
--[[local GetMainCityByCountry				=	CountryWarData.GetMainCityByCountry

local MoveToHeroPt 						=	CountryWarScene.MoveToHeroPt
local GetCountryMapPanel 				=	CountryWarScene.GetCountryMapPanel
local SetUILayerState					=	CountryWarScene.SetUILayerState]]


local function HideUI( self )
	--SetUILayerState( false )
end

local function ShowUI( self )
	--SetUILayerState( true )
end

local function ExitCountryWarScene( self )
	if self.m_RenderData.m_TmpCWarLayer ~= nil then
		self.m_RenderData.m_TmpCWarLayer:removeFromParentAndCleanup(true)
		self.m_RenderData.m_TmpCWarLayer = nil
		print("after remove")
		--print(self.m_RenderData.m_TmpCWarLayer)
		--Pause()		
	end
end

local function GetWorldPosByCityID( self, pCityID )
	--[[if CommonData.g_CountryWarLayer ~= nil then
		return CountryWarScene.GetPosByCityID( pCityID )
	end]]
end

local function CreateTmpCWarLayer( self, nCallBack )

	local function AddCityAni( nCityID, pIndex )
		local pClickPanel = self.m_RenderData.m_WardScene:getChildByTag(12000)
		local pNode = pClickPanel:getChildByTag( nCityID )

		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/countrywar/Animation/Scene_guozhan_leida01/Scene_guozhan_leida01.ExportJson")
		local pBurnArm = CCArmature:create("Scene_guozhan_leida01")
		pBurnArm:getAnimation():play("Animation"..pIndex)
		pBurnArm:setVisible(true)
		pBurnArm:setPosition(ccp( pNode:getPositionX(), pNode:getPositionY() ))
		pClickPanel:addChild(pBurnArm,9999)
	end

	self.m_RenderData.m_TmpCWarLayer = CCLayer:create()
	self.m_RenderData.m_WardScene 	 = SceneReader:sharedSceneReader():createNodeWithSceneFile("publish/Scene_guozhan.json")
	self.m_RenderData.m_TmpCWarLayer:addChild(self.m_RenderData.m_WardScene)
	self.m_RenderData.m_TmpCWarLayer:setZOrder(600)

	local pParent = CCDirector:sharedDirector():getRunningScene()

	AddCityAni(105, 8)

	AddCityAni(107, 6)

	AddCityAni(61, 6)

	AddCityAni(58, 6)

	AddCityAni(228,6)

	AddCityAni(187, 6)

	pParent:addChild(self.m_RenderData.m_TmpCWarLayer)

	nCallBack()
end

local function CameraMoveByMainCity( self, pEndCallBack )

	self.m_Data.m_PlayerCountry = GetPlayerCountry()

	if self.m_Data.m_PlayerCountry ~= nil then

		local tabMoveCountry = {}

		local PosTab = {}
		PosTab[1] = {}
		PosTab[1]["X"] = -3201
		PosTab[1]["Y"] = -3364
		PosTab[2] = {}
		PosTab[2]["X"] = 0
		PosTab[2]["Y"] = -1396
		PosTab[3] = {}
		PosTab[3]["X"] = -3436
		PosTab[3]["Y"] = -76

		if self.m_Data.m_PlayerCountry == COUNTRY_TYPE.COUNTRY_TYPE_WEI then
			--魏国
			tabMoveCountry[1] = 34
			tabMoveCountry[2] = 100
			tabMoveCountry[3] = 190
		elseif self.m_Data.m_PlayerCountry == COUNTRY_TYPE.COUNTRY_TYPE_SHU then
			--蜀国
			tabMoveCountry[1] = 100
			tabMoveCountry[2] = 190
			tabMoveCountry[3] = 34
			PosTab[1]["X"] = -0
			PosTab[1]["Y"] = -1396
			PosTab[2]["X"] = -3436
			PosTab[2]["Y"] = -76
			PosTab[3]["X"] = -3201
			PosTab[3]["Y"] = -3364
		elseif self.m_Data.m_PlayerCountry == COUNTRY_TYPE.COUNTRY_TYPE_WU then
			--吴国
			tabMoveCountry[1] = 190
			tabMoveCountry[2] = 34
			tabMoveCountry[3] = 100
			PosTab[1]["X"] = -3436
			PosTab[1]["Y"] = -76
			PosTab[2]["X"] = -3201
			PosTab[2]["Y"] = -3364
			PosTab[3]["X"] = -0
			PosTab[3]["Y"] = -1396
		end
	
		local function MoveToCamera_1(  )
			--local pCity = tabMoveCountry[1]
			--MoveToHeroPt( pCity, 2.5 )
		end

		local function MoveToCamera_2(  )
			local pCity = tabMoveCountry[2]
			MoveToHeroPt( pCity, 2.5 )
		end

		local function MoveToCamera_3(  )
			local pCity = tabMoveCountry[3]
			MoveToHeroPt( pCity, 2.5 )
		end

		local function GetActionArr(  )
			local pScale = CCArray:create()
			pScale:addObject(CCScaleTo:create(0.15, 1.2))
			pScale:addObject(CCScaleTo:create(0.15, 1))
			pScale:addObject(CCScaleTo:create(0.15, 1.2))
			pScale:addObject(CCScaleTo:create(0.15, 1))

			return pScale
		end

		local function AddRoleAni( nCityID )
			local pClickPanel = self.m_RenderData.m_WardScene:getChildByTag(12000)
			local pNode = pClickPanel:getChildByTag( nCityID )

			local pRoleAni = UIInterface_CreatAnimateByResID(GetGeneralResId(server_mainDB.getMainData("nModeID")))
			pRoleAni:setPosition(ccp( pNode:getPositionX(), pNode:getPositionY() ))
			pRoleAni:setScale(0.7)
			pClickPanel:addChild(pRoleAni,9999)
		end

		local function Run(  )

			if self.m_RenderData.m_WardScene == nil then return end

			AddRoleAni( tabMoveCountry[1] )

			local pClickPanel = self.m_RenderData.m_WardScene:getChildByTag(12000)

			local function CityAni_1(  )
				local pCity = tabMoveCountry[1]
				local pNode = pClickPanel:getChildByTag( pCity )
				local pActionArr = GetActionArr()
				pNode:runAction(CCSequence:create(pActionArr))
			end
			
			local function CityAni_2(  )
				local pCity = tabMoveCountry[2]
				local pNode = pClickPanel:getChildByTag( pCity )
				local pActionArr = GetActionArr()
				pNode:runAction(CCSequence:create(pActionArr))
			end

			local function CityAni_3(  )
				local pCity = tabMoveCountry[3]
				local pNode = pClickPanel:getChildByTag( pCity )
				local pActionArr = GetActionArr()
				pNode:runAction(CCSequence:create(pActionArr))
			end

			--HideUI( self )

			if self.m_RenderData.m_WardScene ~= nil then

				local function SetPos(  )
					self.m_RenderData.m_WardScene:setPosition(ccp(PosTab[1]["X"],PosTab[1]["Y"]))
				end


				local pMoveAction = CCArray:create()
				pMoveAction:addObject(CCCallFunc:create(SetPos))
				pMoveAction:addObject(CCDelayTime:create(2))
				pMoveAction:addObject(CCMoveTo:create(2.5,ccp(PosTab[2]["X"],PosTab[2]["Y"])))
				pMoveAction:addObject(CCCallFunc:create(CityAni_2))
				pMoveAction:addObject(CCDelayTime:create(1))
				pMoveAction:addObject(CCMoveTo:create(2.5,ccp(PosTab[3]["X"],PosTab[3]["Y"])))
				pMoveAction:addObject(CCCallFunc:create(CityAni_3))
				pMoveAction:addObject(CCDelayTime:create(1))
				pMoveAction:addObject(CCMoveTo:create(2.5,ccp(PosTab[1]["X"],PosTab[1]["Y"])))
				pMoveAction:addObject(CCCallFunc:create(CityAni_1))
				pMoveAction:addObject(CCDelayTime:create(1))
				pMoveAction:addObject(CCCallFunc:create(pEndCallBack))

				self.m_RenderData.m_WardScene:runAction(CCSequence:create(pMoveAction))

			end

		end

		--加载临时国战场景

		--MainScene.OpenCountryWarMap(MainScene.GetPScene(), nil, Run)
		CreateTmpCWarLayer( self, Run )
	end

end

local function Release( self )
	self.m_Data.m_PlayerCountry = nil
	self.m_Data = nil
end


function Create(  )
	local tab = {
			Fun_CameraMoveByMainCity 				=	CameraMoveByMainCity,
			Fun_ExitCountryWarScene					=	ExitCountryWarScene,
			Fun_GetWorldPosByCityID 				=	GetWorldPosByCityID,
			Fun_HideUI								=	HideUI,
			Fun_ShowUI 								=	ShowUI,
			Fun_Release 							=	Release,
			m_Data = {
						m_PlayerCountry 			=	nil	
					 },
			m_RenderData = {
								m_Runner 			=   nil,
								m_TmpCWarLayer      =   nil,
								m_WardScene 		=	nil,
						   }						 
	}

	return tab
end

