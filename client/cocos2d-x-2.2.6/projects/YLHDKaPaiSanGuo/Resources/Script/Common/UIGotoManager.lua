--游戏各个界面的跳转管理+

require "Script/serverDB/danyao"

module("UIGotoManager", package.seeall)

local LayerID = {
	UI_NormalFB 				=	1,	--普通副本界面
	UI_Pata 					=	2,	--爬塔界面
	UI_MainJob 					=	3,	--主将职业界面
	UI_Wujiang 					=	4,	--武将界面
	UI_Matrix 					=	5,	--阵容界面
	UI_EliteFB					=	6,	--精英副本界面
	UI_Activity 				=	7,	--活动副本界面
	UI_BiWu 					=	8,	--比武界面
	UI_JiuGuan 					=	9,	--酒馆界面
	UI_Dobk 					=	10,	--夺宝界面
	UI_Shop 					=	11,	--商城界面
	UI_Bag	 					=	12,	--背包界面
	UI_CountryWar 				=	13, --国战界面
	UI_DanYao 					=	14, --丹药界面
	UI_Corps 					=	15, --军团界面
	UI_Mission 					=	16, --任务界面
	UI_Vip 						=	17, --vip界面
}

local switch = {}

local COMEIN_TYPE = {
	COMEIN_MAINSCENE = 1,
	COMEIN_CORPSCENE = 2,
}

local function Release( self )
	--是否释放掉当前界面
	if self.isRelease == true and self.ReleaseFunc ~= nil then
		self.ReleaseFunc()
	end
end

local function GetGuildeAni( self )
	if self.GuildeAni ~= nil then

		self.GuildeAni:removeFromParentAndCleanup(true)
		return self.GuildeAni

	end
end

local function GotoNormalFB( self )
	--判断是否可以攻打此关卡
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if self.Cmd_1 ~= 0 and self.Cmd_1 ~= nil and self.Cmd_2 ~= 0 and self.Cmd_2 ~= nil then
		require "Script/Main/Dungeon/DungeonLogic"
		local nCurErrorCode = DungeonLogic.SceneCanCreate(tonumber(self.Cmd_1), tonumber(self.Cmd_2))
		if tonumber( nCurErrorCode ) == 1 then
			local pErrorText = DungeonLogic.GetErrorCodeText( nCurErrorCode )
			TipLayer.createTimeLayer(pErrorText, 2)
			return
		end
	end

	if tempCur ~= nil  then
	    print("副本界面已经打开")
	else
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		MainScene.DeleteUILayer(DungeonManagerLayer.GetUIControl())
		local pLayerDungeonManager = DungeonManagerLayer.CreateDungeonManagerLayer(DungeonsType.Normal)
		if pLayerDungeonManager==nil then
			print("pLayerDungeonManager is nil...")
			return
		end
		scenetemp:addChild(pLayerDungeonManager,lyaerActivityList_Tag,lyaerActivityList_Tag)
		MainScene.PushUILayer(pLayerDungeonManager)

		if self.Cmd_1 ~= nil and self.Cmd_2 ~= nil then
			DungeonManagerLayer.GotoManagerCallFuncByType(DungeonsType.Normal, tonumber(self.Cmd_1), tonumber(self.Cmd_2))
		end

	end

	--参数执行（Cmd_1 == 战役ID 0 = 任意副本， Cmd_2 == 关卡ID 0 == 任意关卡）
	--执行副本场景的管理方法，传入参数
end

local function GotoPata( self )

	local bPataCheck = PataLayer.CheckPataOpen()

	if PataLayer.CheckPataOpen() == false then
		local bOpen,nNeedLv = PataLayer.CheckPataOpen()
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1643,nil,"通天塔",tonumber(nNeedLv))
		pTips = nil								
		return
	end

	local function  openPata()
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local temp = scenetemp:getChildByTag(layerPataTag)
		if temp == nil then
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			local pata = PataLayer.CreatePataLayer()
			scenetemp:addChild(pata,layerPataTag,layerPataTag)
			MainScene.PushUILayer(pata)
		else
			print("已经是爬塔界面了")
		end
		NetWorkLoadingLayer.loadingHideNow()
	end	
	Packet_GetFuBenInfo.SetSuccessCallBack(openPata, DungeonsType.ClimbingTower)
	network.NetWorkEvent(Packet_GetFuBenInfo.CreatPacket(DungeonsType.ClimbingTower))
	NetWorkLoadingLayer.loadingShow(true)
end

local function GotoMainJob( self )
	require "Script/Main/Wujiang/GeneralOptLayer"
	MainScene.ShowLeftInfo(false)
	MainScene.ClearRootBtn()
	--MainScene.DeleteUILayer(GeneralOptLayer.GetUIControl())

	local pLayerOperate = GeneralOptLayer.CreateGeneralOptLayer(1, 4, 0, nil, 0)
	if pLayerOperate~=nil then
		local pSceneGame =  CCDirector:sharedDirector():getRunningScene()
		pSceneGame:addChild(pLayerOperate, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
		MainScene.PushUILayer(pLayerOperate)
	end
end

local function GotoWujiang( self )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerWujiangList_Tag)
	require "Script/Main/Wujiang/GeneralListLayer"
	if tempCur ~= nil and tempCur == GeneralListLayer:GetUIControl() then
	    print("已经是武将界面了")
	else
		local function OpenWujiang()
			NetWorkLoadingLayer.loadingHideNow()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			--MainScene.DeleteUILayer(GeneralListLayer.GetUIControl())
			local wujiang = GeneralListLayer.CreateGeneralListLayer()
			scenetemp:addChild(wujiang,layerWujiangList_Tag,layerWujiangList_Tag)
			MainScene.PushUILayer(wujiang)
		end

		if NETWORKENABLE > 0 then
			NetWorkLoadingLayer.loadingShow(true)
			Packet_GetGeneralList.SetSuccessCallBack(OpenWujiang)
			network.NetWorkEvent(Packet_GetGeneralList.CreatPacket())
		else
			OpenWujiang()
		end
	end
end

local function GotoMatrix( self )
    local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	require "Script/Main/Matrix/MatrixLayer"
	local tempCur = scenetemp:getChildByTag(layerMatrix_Tag)
	if tempCur ~= nil then
	    print("已经是阵容界面了")
	else

		local function OpenMatrix()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			--MainScene.DeleteUILayer(MatrixLayer.GetUIControl())
			local matrix = MatrixLayer.createMatrixUI()
			scenetemp:addChild(matrix,layerMatrix_Tag,layerMatrix_Tag)
			MainScene.PushUILayer(matrix)
		end

		if NETWORKENABLE > 0 then
			NetWorkLoadingLayer.loadingShow(true)

			Packet_GetMatrix.SetSuccessCallBack(OpenMatrix)
			network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
		else
			OpenMatrix()
		end
	end
end

local function GotoEliteFB( self )
	--先判断当前精英副本是否已经开启
	if DungeonLogic.CheckEliteOpen() == false then
		TipLayer.createTimeLayer("精英副本未开启",2)
		return
	end
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if tempCur ~= nil  then
	    print("已经是副本界面了")
	else
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		MainScene.DeleteUILayer(DungeonManagerLayer.GetUIControl())
		local pLayerDungeonManager = DungeonManagerLayer.CreateDungeonManagerLayer(DungeonsType.Elite)
		if pLayerDungeonManager==nil then
			print("pLayerDungeonManager is nil...")
			return
		end
		scenetemp:addChild(pLayerDungeonManager,lyaerActivityList_Tag,lyaerActivityList_Tag)
		MainScene.PushUILayer(pLayerDungeonManager)
	end

	--参数执行（ Cmd_1 == 关卡ID 0 == 任意关卡 ）
	--执行副本场景的管理方法，传入参数
	if self.Cmd_1 ~= nil then
		DungeonManagerLayer.GotoManagerCallFuncByType(DungeonsType.Elite, tonumber(self.Cmd_1))
	end

end

local function GotoActivity( self )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if tempCur ~= nil  then
	    print("已经是副本界面了")
	else
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		MainScene.DeleteUILayer(DungeonManagerLayer.GetUIControl())
		local pLayerDungeonManager = DungeonManagerLayer.CreateDungeonManagerLayer(DungeonsType.Activity)
		if pLayerDungeonManager==nil then
			print("pLayerDungeonManager is nil...")
			return
		end
		scenetemp:addChild(pLayerDungeonManager,lyaerActivityList_Tag,lyaerActivityList_Tag)
		MainScene.PushUILayer(pLayerDungeonManager)
	end

	if self.Cmd_1 ~= nil and self.Cmd_2 ~= nil then
		DungeonManagerLayer.GotoManagerCallFuncByType(DungeonsType.Activity, tonumber(self.Cmd_1), tonumber(self.Cmd_2))
	end
end

local function GotoBiWu( self )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerCompetition_Tag)
	if tempCur ~= nil  then
	    print("已经是比武界面了")
	else
		local function GetCompetitionData()
			NetWorkLoadingLayer.loadingShow(false)
			local pLayerCompetition = CompetitionLayer.CreateCompetitonLayer(DungeonsType.Normal)
			if pLayerCompetition==nil then
				print("pLayerDungeonManager is nil...")
				return
			end
			scenetemp:addChild(pLayerCompetition,layerCompetition_Tag,layerCompetition_Tag)
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			MainScene.PushUILayer(pLayerCompetition)
		end
		Packet_GetCompetitionData.SetSuccessCallBack(GetCompetitionData)
		network.NetWorkEvent(Packet_GetCompetitionData.CreatPacket())
		NetWorkLoadingLayer.loadingShow(true)
	end
end

local function GotoJiuGuan( self )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local temp = scenetemp:getChildByTag(layerSmithy_Tag)
	if temp == nil then 
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		require "Script/Main/LuckyDraw/LuckyDrawLayer"
		local pLayerLuckyDraw = LuckyDrawLayer.CreateLuckyDrawLayer()
		scenetemp:addChild(pLayerLuckyDraw,layerSmithy_Tag,layerSmithy_Tag)
		MainScene.PushUILayer(pLayerLuckyDraw)
	else
		print("已经是酒馆页面了")
	end	

	if self.Cmd_1 ~= nil then
		LuckyDrawLayer.GotoManagerCallFuncByJiuGuan( self.Cmd_1 )
	end	
end

local function GotoDobk( self )
	if self.Cmd_1 ~= nil and self.Cmd_2 ~= nil then 
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		local tempCur = scenetemp:getChildByTag(layerDobk_Tag)
		if tempCur ~= nil  then
		    print("已经是夺宝界面了")
		else
			local function GetDobkInfo()
				NetWorkLoadingLayer.loadingShow(false)
				if tonumber(self.Cmd_1) == 1 then
					--神武
					self.Cmd_1 = DOBK_TYPE.DOBK_TYPE_SW
				elseif tonumber(self.Cmd_1) == 2 then
					--宝马
					self.Cmd_1 = DOBK_TYPE.DOBK_TYPE_BW
				end
				local pLayerDobk = DobkLayer.CreateDobkLayer(self.Cmd_1, self.Cmd_2)
				if pLayerDobk==nil then
					print("pLayerDobk is nil...")
					return
				end
				scenetemp:addChild(pLayerDobk,layerDobk_Tag,layerDobk_Tag)
				MainScene.ShowLeftInfo(false)
				MainScene.ClearRootBtn()
				MainScene.PushUILayer(pLayerDobk)
			end
			Packet_DobkInfo.SetSuccessCallBack(GetDobkInfo)
			network.NetWorkEvent(Packet_DobkInfo.CreatPacket(DOBK_TYPE.DOBK_TYPE_SW))
			NetWorkLoadingLayer.loadingShow(true)
		end
	end
end

local function GotoShop( self )

	require "Script/Main/Mall/ShopLayer"
	if self.Cmd_1 ~= nil and self.Cmd_2 ~= nil then 
		print("self.Cmd_2 = "..self.Cmd_2)
		ShopLayer.ShowShopLayers(self.Cmd_1, self.Cmd_2)
	end
end

local function GotoBag( self )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerItemList_Tag)
	require "Script/Main/Item/ItemListLayer"
	if tempCur ~= nil  then
	    print("已经是道具界面了")
	    _Button_Change_Btn_CallBack(nil, TouchEventType.ended)
	else
		local function OpenItem()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			--MainScene.DeleteUILayer(ItemListLayer.GetUIControl())
			if self.Cmd_2 == 0 then
				self.Cmd_2 = nil
			end
			if self.Cmd_1 == 0 then
				self.Cmd_1 = nil 
			elseif self.Cmd_1 == 1 then
				self.Cmd_1 = ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH
			elseif self.Cmd_1 == 2 then
				self.Cmd_1 = ENUM_TYPE_BOX.ENUM_TYPE_BOX_SP
			elseif self.Cmd_1 == 3 then
				self.Cmd_1 = ENUM_TYPE_BOX.ENUM_TYPE_BOX_JH
			elseif self.Cmd_1 == 4 then
				self.Cmd_1 = ENUM_TYPE_BOX.ENUM_TYPE_BOX_EQUIP
			elseif self.Cmd_1 == 5 then
				self.Cmd_1 = ENUM_TYPE_BOX.ENUM_TYPE_BOX_TREASURE		
			elseif self.Cmd_1 == 6 then
				self.Cmd_1 = ENUM_TYPE_BOX.ENUM_TYPE_BOX_LINGBAO	
			end	
			--第一个参数代表指引位置，true为按钮指引，false为道具指引
			--如果为道具指引则只穿一个参数=金丹等级		
			local item_item = ItemListLayer.CreateItemListLayer(true, self.Cmd_1, self.Cmd_2, self.Cmd_3)
			scenetemp:addChild(item_item,layerItemList_Tag,layerItemList_Tag)

			MainScene.PushUILayer(item_item)
		end
		if NETWORKENABLE > 0 then
			NetWorkLoadingLayer.loadingShow(true)

			Packet_GetItemList.SetSuccessCallBack(OpenItem)
			network.NetWorkEvent(Packet_GetItemList.CreatPacket())

		else
			OpenItem()
		end
	end
end

local function GotoCountryWar( self )

	if self.Parent == nil then
		return
	end

	if self.Cmd_1 <= 0 then self.Cmd_1 = 145 end

	local function Open_CallBack( nResult )

		if nResult ~= 1 then
			self.isRelease = false
		end

		print(self.isRelease, self.ReleaseFunc)
		
		Release( self )

	end

	if self.ComeInType == COMEIN_TYPE.COMEIN_MAINSCENE then
		MainScene.OpenCountryWarMap(MainScene.GetPScene(), self.Cmd_1, nil, Open_CallBack)
		print("--------------Main In CountryWar----------------")
	elseif self.ComeInType == COMEIN_TYPE.COMEIN_CORPSCENE then
		require "Script/Main/Corps/CorpsScene"
		CorpsScene.OpenCountryWarMap(CorpsScene.GetPScene(), self.Cmd_1, nil, Open_CallBack)
		print("--------------Corp In CountryWar----------------")
	end

end

local function GotoDanYao( self )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerItemList_Tag)
	require "Script/Main/Item/ItemListLayer"
	if tempCur ~= nil  then
	    print("已经是道具界面了,前往丹药需求")
	    _Button_Change_Btn_CallBack(nil, TouchEventType.ended)
	else
		local function OpenItem()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			--MainScene.DeleteUILayer(ItemListLayer.GetUIControl())

			--第一个参数代表指引位置，true为按钮指引，false为道具指引
			--如果为道具指引则只穿一个参数=金丹等级
			local item_item = ItemListLayer.CreateItemListLayer(false, ENUM_TYPE_BOX.ENUM_TYPE_BOX_XH, self.Cmd_1 )
			scenetemp:addChild(item_item,layerItemList_Tag,layerItemList_Tag)

			MainScene.PushUILayer(item_item)
		end
		if NETWORKENABLE > 0 then
			NetWorkLoadingLayer.loadingShow(true)

			Packet_GetItemList.SetSuccessCallBack(OpenItem)
			network.NetWorkEvent(Packet_GetItemList.CreatPacket())

		else
			OpenItem()
		end
	end
end

local function GotoCorps(  )
	MainScene.ShowCorpsScene()
end

local function GotoVip( self )
	MainScene.GoToVIPLayer( 0 )
end

local function GotoMission( self )
	if self.Cmd_1 == nil then
		return
	end

	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(layerMissionNormal_tag)
	require "Script/Main/MissionNormal/MissionNormalLayer"

	local function openMissionLayer()
		NetWorkLoadingLayer.loadingHideNow()
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		--MainScene.DeleteUILayer(MissionNormalLayer.GetUIControl())
		local mission = MissionNormalLayer.CreateMissionNormalLayer( self.Cmd_1, true )
		scenetemp:addChild(mission,layerMissionNormal_tag,layerMissionNormal_tag)

		MainScene.PushUILayer(mission)
	end

	if NETWORKENABLE > 0 then
		NetWorkLoadingLayer.loadingShow(true)

		if tonumber(self.Cmd_1) == 2 then --军团任务
			Packet_GetReceiveMissionCorpsData.SetSuccessCallBack(openMissionLayer)
			network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket( tonumber(self.Cmd_1) )) --0=主线任务。1=日常任务
		elseif tonumber(self.Cmd_1) == 3 then --国战任务
			Packet_GetReceiveMissionCWarData.SetSuccessCallBack(openMissionLayer)
			network.NetWorkEvent(Packet_GetReceiveMissionCWarData.CreatePacket(E_WORLD_MISSION_TASK_TYPE.E_WORLD_TASK_THREE_KINGDOMS))
		else
			Packet_GetNormalMissionData.SetSuccessCallBack(openMissionLayer)
			network.NetWorkEvent(Packet_GetNormalMissionData.CreatePacket( tonumber(self.Cmd_1) )) --0=主线任务。1=日常任务
		end

	else
		openMissionLayer()
	end

end

--nLayerID : 类型ID
--nCmd_..  : 通过表取出的参数按顺序传入
local function ReplaceUI( self, nLayerID, nCmd_1, nCmd_2, nCmd_3 )
	local func = switch[nLayerID]

	if nCmd_1 ~= nil then self.Cmd_1 = tonumber(nCmd_1) end
	
	if nCmd_2 ~= nil then self.Cmd_2 = tonumber(nCmd_2) end
	
	if nCmd_3 ~= nil then self.Cmd_3 = tonumber(nCmd_3) end

	if func ~= nil then 
		
		local function RunFunc(  )
			func(self)
		end

		if self.Parent ~= nil then
			local actArr = CCArray:create()
			actArr:addObject(CCCallFunc:create(RunFunc))
			self.Parent:runAction(CCSequence:create(actArr))
		else
			RunFunc()
		end

	else
		print("goto other UI func error"..nLayerID)
	end

	return true
end
-- nstate = 是否需要释放当前界面
-- func   = 释放的回调
local function SetAttr( self, nState, func )
	self.isRelease = nState

	self.ReleaseFunc = func
end

local function SetParent( self, nParent )
	if nParent ~= nil then
		self.Parent = nParent
	end
end

local function SetComeInType( self, nType )
	if nType ~= nil then
		self.ComeInType = nType
	end
end

local function CreateObj( self )
	switch = {
		[LayerID.UI_NormalFB] 			=  GotoNormalFB,
		[LayerID.UI_Pata]				=  GotoPata,
		[LayerID.UI_MainJob] 			=  GotoMainJob,
		[LayerID.UI_Wujiang] 			=  GotoWujiang,
		[LayerID.UI_Matrix]				=  GotoMatrix,
		[LayerID.UI_EliteFB] 			=  GotoEliteFB,
		[LayerID.UI_Activity] 			=  GotoActivity,
		[LayerID.UI_BiWu] 				=  GotoBiWu,
		[LayerID.UI_JiuGuan] 			=  GotoJiuGuan,
		[LayerID.UI_Dobk] 				=  GotoDobk,
		[LayerID.UI_Shop] 				=  GotoShop,
		[LayerID.UI_Bag] 				=  GotoBag,
		[LayerID.UI_CountryWar]			=  GotoCountryWar,
		[LayerID.UI_DanYao] 			=  GotoDanYao,
		[LayerID.UI_Corps] 				=  GotoCorps,
		[LayerID.UI_Vip] 				=  GotoVip,
		[LayerID.UI_Mission] 			=  GotoMission,
	}

	self.isRelease = false

	self.ReleaseFunc = nil

	self.Parent = nil

	self.ComeInType = COMEIN_TYPE.COMEIN_MAINSCENE

	self.GuildeAni = CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/effectfile/zhiyin01.ExportJson")
	self.GuildeAni = CCArmature:create("zhiyin01")
	self.GuildeAni:getAnimation():play("Animation1")
	self.GuildeAni:retain()

end


function CreateUIGotoManager()
	local tab = {
		CreateObj 				=	CreateObj,
		ReplaceUI 				=	ReplaceUI,
		SetAttr					=	SetAttr,
		SetParent				=	SetParent,
		SetComeInType 			=	SetComeInType,
		GetGuildeAni 			=	GetGuildeAni,
	}

	return tab
end