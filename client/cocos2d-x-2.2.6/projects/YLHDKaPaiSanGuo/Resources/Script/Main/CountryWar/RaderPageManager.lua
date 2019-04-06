--require "Script/Main/CountryWar/CountryWarData"

local GetAnimalBuffInfo					=	CountryWarData.GetAnimalBuffInfo
local GetTeamFace 						=	CountryWarData.GetTeamFace
local GetGeneralHeadPath				=	CountryWarData.GetGeneralHeadPath
local GetPathByImageID					=	CountryWarData.GetPathByImageID
local GetExpeDitionCount				=	CountryWarData.GetExpeDitionCount
local GetExpeDitionDataByIndex			=	CountryWarData.GetExpeDitionDataByIndex
local GetExpeDitionCountryID			=	CountryWarData.GetExpeDitionCountryID
local GetCityNameByIndex				=	CountryWarData.GetCityNameByIndex
local GetExpeDitionCityID				=	CountryWarData.GetExpeDitionCityID
local GetExpeDitionType					=	CountryWarData.GetExpeDitionType
local GetCityCountry					=	CountryWarData.GetCityCountry

local CreateLabel						=	CountryWarLogic.CreateLabel
local GetIndexByCTag					=	CountryWarLogic.GetIndexByCTag
local GetManZuCity						=	CountryWarLogic.GetManZuCity
local JudgeCityManZu					=	CountryWarLogic.JudgeCityManZu
local JudgeCityLock						=	CountryWarLogic.JudgeCityLock
local JudgeCityCenter					=	CountryWarLogic.JudgeCityCenter

module("RaderPageManager", package.seeall)

local Page_Type = {
	Page_CiFu 		=	1, 			--赐福标签页
	Page_YZ 		=	2, 			--远征标签页
	Page_SJ 		=	3,			--事件标签页
}

local PageLayer_Type = {
	Show 			=	1,
	Hide 			=	2, 
}

local Page_YZ_Choose_Type = {
	Show 			=	1,
	Hide 			=	2,
}

local Expe_Type = {
	Expe 		=	1,
	Mons		=	2,
}

local AnimalType = {
	Animal_QINGLONG 		= 1,
	Animal_BAIHU 	 		= 2,
	Animal_ZHUQUE 	 		= 3,
	Animal_XUANWU 	 		= 4,
	Animal_BAHAMUTE 	 	= 5,
}

local SJ_Country_Type = {
	ManZu 				=	1,
	HuangJin 			=	2,
}

local ITEM_HEIGHT = 45

local function EnabledPanel( pPanel, bState )
	if pPanel ~= nil then
		pPanel:setVisible(bState)
		if bState == true then
			pPanel:setZOrder(1)
		else
			pPanel:setZOrder(0)
		end
	end
end

local function GotoTargetCity( sender, eventType )
	if eventType == TouchEventType.ended then

		local pIndex 	 = sender:getTag()
		print("pIndex = "..pIndex)
		local pCityID 	 = GetExpeDitionCityID( pIndex ) 

		if pCityID == nil then
			return
		end

		local pCityName  = GetCityNameByIndex( GetIndexByCTag( pCityID )  )

		if pCityID >= 1 then

			CountryWarScene.MoveToHeroPt( pCityID )

		else

			TipLayer.createTimeLayer("前往城池"..pCityName.."失败",2)

		end

	end

end

local function PageYZ_ChangeTitleText( self, nCountryID )

	if self.Panel_YZ ~= nil then

		local Image_YZChoose  = tolua.cast(self.Panel_YZ:getChildByName("Image_YZChoose"), "ImageView")

		local Image_Btn_Wei    = tolua.cast(Image_YZChoose:getChildByName("Image_Btn_Wei"), "ImageView")

		local Label_Wei        = tolua.cast(Image_Btn_Wei:getChildByName("Label_Wei"), "Label")

		if nCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WEI then

			Label_Wei:setText("魏远征军")

		elseif nCountryID == COUNTRY_TYPE.COUNTRY_TYPE_SHU then

			Label_Wei:setText("蜀远征军")

		elseif nCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WU then

			Label_Wei:setText("吴远征军")

		end

	end
end

local function PageSJ_ChangeTitleText( self, nCountryID )

	if self.Panel_SJ ~= nil then

		local Image_SJChoose  = tolua.cast(self.Panel_SJ:getChildByName("Image_SJChoose"), "ImageView")

		local Image_Btn_ManZu    = tolua.cast(Image_SJChoose:getChildByName("Image_Btn_ManZu"), "ImageView")

		local Label_Manzu        = tolua.cast(Image_Btn_ManZu:getChildByName("Label_ManZu"), "Label")

		if nCountryID == SJ_Country_Type.ManZu then

			Label_Manzu:setText("蛮族入侵")

		elseif nCountryID == SJ_Country_Type.HuangJin then

			Label_Manzu:setText("黄巾入侵")

		end

	end
end

local function PageYZ_ChangeCountry( self, nCountryID )
	if self.Panel_YZ ~= nil then

		local pListView_Yz = tolua.cast(self.Panel_YZ:getChildByName("ListView_YZ"), "ListView")

		if pListView_Yz:getItems():count() > 0 then
			pListView_Yz:removeAllItems()
		end

		for i=1, table.getn( self.pYZItemTab ) do
			local pItem = self.pYZItemTab[i]

			if pItem ~= nil then

				local pExpeTab = GetExpeDitionDataByIndex( pItem:getTag() )

				if pExpeTab ~= nil then

					local pIndex = pExpeTab["Index"]

					local pCountryID = GetExpeDitionCountryID( pIndex )

					--print( " pCountryID = "..pCountryID )

					if tonumber( nCountryID ) == tonumber( pCountryID ) then

						pListView_Yz:pushBackCustomItem( pItem )

					end

				end

			end

		end

		self.PageYZ_CurCountry = nCountryID

		PageYZ_ChangeTitleText( self, nCountryID )

	end	
end

local function PageSJ_ChangeCountry( self, nType )
	if self.Panel_SJ ~= nil then

		local pListView_SJ = tolua.cast(self.Panel_SJ:getChildByName("ListView_SJ"), "ListView")

		if pListView_SJ:getItems():count() > 0 then
			pListView_SJ:removeAllItems()
		end

		self.PageSJ_CurCountry = nType

		local pTab = nil

		if nType == SJ_Country_Type.ManZu then

			pTab = self.pSJItemTab["ManZu"]

		elseif nType == SJ_Country_Type.HuangJin then

			pTab = self.pSJItemTab["HuangJin"]

		end

		if pTab == nil then
			return
		end

		for key, value in pairs( pTab ) do

			local pItem = value

			if pItem ~= nil then

				if JudgeCityManZu( pItem:getTag() ) == true and nType == SJ_Country_Type.ManZu then
					--蛮族事件
					pListView_SJ:pushBackCustomItem( pItem )

					self.PageSJ_CurCountry = SJ_Country_Type.ManZu
				end
				if JudgeCityLock( pItem:getTag() ) == true or JudgeCityCenter( pItem:getTag() ) == true then

					if nType == SJ_Country_Type.HuangJin then
						--黄巾军事件
						pListView_SJ:pushBackCustomItem( pItem )

						self.PageSJ_CurCountry = SJ_Country_Type.HuangJin

					end

				end

			end

		end

		PageSJ_ChangeTitleText( self, self.PageSJ_CurCountry )

	end	
end

local function CreateItem( self, pParent, pExpeTab, _ExIndex )
	
	local pExpeIndex = pExpeTab["Index"]

	local pCountryID = GetExpeDitionCountryID( pExpeIndex )

	local pCityID 	 = GetExpeDitionCityID( _ExIndex ) 

	local pCityName  = GetCityNameByIndex( GetIndexByCTag( pCityID )  )

	local _Img_Bg = ImageView:create()
	_Img_Bg:loadTexture("Image/imgres/countrywar/light_gray.png")
	_Img_Bg:setScale9Enabled(true)
	_Img_Bg:setPosition(ccp(15,0))
	_Img_Bg:setAnchorPoint(ccp(0,0.5))
	_Img_Bg:setTouchEnabled(true)
	_Img_Bg:setTag( _ExIndex )
	_Img_Bg:setSize(CCSizeMake( 220, ITEM_HEIGHT ))
	_Img_Bg:addTouchEventListener( GotoTargetCity )

	local pCutLine_Left = ImageView:create()
	pCutLine_Left:loadTexture("Image/imgres/countrywar/cut_line.png")
	pCutLine_Left:setScaleY(1.5)
	pCutLine_Left:setPosition(ccp(5,0))
	_Img_Bg:addChild( pCutLine_Left, 0 , 1 )

	local pCutLine_Right = ImageView:create()
	pCutLine_Right:loadTexture("Image/imgres/countrywar/cut_line.png")
	pCutLine_Right:setPosition( ccp(_Img_Bg:getSize().width - 5,0) )
	pCutLine_Right:setScaleY(1.5)
	_Img_Bg:addChild( pCutLine_Right, 0 , 2 )

	local pCutLine_Mid = ImageView:create()
	pCutLine_Mid:loadTexture("Image/imgres/countrywar/cut_line.png")
	pCutLine_Mid:setPosition( ccp(_Img_Bg:getSize().width * 0.4,0) )
	pCutLine_Mid:setScaleY(1.5)
	_Img_Bg:addChild( pCutLine_Mid, 0 , 3 )

	--城池国家
	
	local pLabelText = "未知"

	local pLabelCText = "【No】"..pCityName

	if pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WEI then

		pLabelText = "魏远征军"
		pLabelCText = "【魏】"..pCityName

	elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_SHU then

		pLabelText = "蜀远征军"
		pLabelCText = "【蜀】"..pCityName

	elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WU then

		pLabelText = "吴远征军"
		pLabelCText = "【吴】"..pCityName

	end

	local pNameLabel = CreateLabel(pLabelText, 18,ccc3(51,25,13),CommonData.g_FONT1,ccp(10, 0))
	pNameLabel:setAnchorPoint(ccp(0,0.5))
	_Img_Bg:addChild( pNameLabel, 0, 4 )

	local pCityLabel = CreateLabel(pLabelCText, 18,ccc3(29,109,43),CommonData.g_FONT1,ccp(pCutLine_Mid:getPositionX(), 0))
	pCityLabel:setAnchorPoint(ccp(0,0.5))
	_Img_Bg:addChild( pCityLabel, 0, 5 )

	_Img_Bg:retain()

	self.pYZItemTab[_ExIndex] = _Img_Bg

	pParent:pushBackCustomItem( _Img_Bg ) 

end

local function GotoTargetCityBySJ( sender, eventType )
	if eventType == TouchEventType.ended then

		local pCityID = sender:getTag()

		local pCityName  = GetCityNameByIndex( GetIndexByCTag( pCityID )  )

		if pCityID >= 1 then

			CountryWarScene.MoveToHeroPt( pCityID )

		else

			TipLayer.createTimeLayer("前往城池"..pCityName.."失败",2)

		end

	end

end

local function CreateItemBySJ( self, pParent, nCityID, nType, nIndex )

	local pCountryID = GetCityCountry( nCityID ) 

	local pCityID 	 = nCityID

	local pCityName  = GetCityNameByIndex( GetIndexByCTag( pCityID )  )

	local _Img_Bg = ImageView:create()
	_Img_Bg:loadTexture("Image/imgres/countrywar/light_gray.png")
	_Img_Bg:setScale9Enabled(true)
	_Img_Bg:setPosition(ccp(15,0))
	_Img_Bg:setAnchorPoint(ccp(0,0.5))
	_Img_Bg:setTouchEnabled(true)
	_Img_Bg:setTag( pCityID )
	_Img_Bg:setSize(CCSizeMake( 220, ITEM_HEIGHT ))
	_Img_Bg:addTouchEventListener( GotoTargetCityBySJ )

	local pCutLine_Left = ImageView:create()
	pCutLine_Left:loadTexture("Image/imgres/countrywar/cut_line.png")
	pCutLine_Left:setScaleY(1.5)
	pCutLine_Left:setPosition(ccp(5,0))
	_Img_Bg:addChild( pCutLine_Left, 0 , 1 )

	local pCutLine_Right = ImageView:create()
	pCutLine_Right:loadTexture("Image/imgres/countrywar/cut_line.png")
	pCutLine_Right:setPosition( ccp(_Img_Bg:getSize().width - 5,0) )
	pCutLine_Right:setScaleY(1.5)
	_Img_Bg:addChild( pCutLine_Right, 0 , 2 )

	local pCutLine_Mid = ImageView:create()
	pCutLine_Mid:loadTexture("Image/imgres/countrywar/cut_line.png")
	pCutLine_Mid:setPosition( ccp(_Img_Bg:getSize().width * 0.4,0) )
	pCutLine_Mid:setScaleY(1.5)
	_Img_Bg:addChild( pCutLine_Mid, 0 , 3 )

	--城池国家
	
	local pLabelText = "未知"

	local pLabelCText = "【No】"..pCityName

	if nType == SJ_Country_Type.ManZu then

		pLabelText = "蛮族入侵"

	elseif nType == SJ_Country_Type.HuangJin then

		pLabelText = "黄巾入侵"

	end

	if pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WEI then

		pLabelCText = "【魏】"..pCityName

	elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_SHU then

		pLabelCText = "【蜀】"..pCityName

	elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WU then

		pLabelCText = "【吴】"..pCityName

	elseif pCountryID >= COUNTRY_TYPE.COUNTRY_TYPE_BEIDI and pCountryID <= COUNTRY_TYPE.COUNTRY_TYPE_DONGYI then

		pLabelCText = "【蛮】"..pCityName

	elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_HUANG then

		pLabelCText = "【巾】"..pCityName

	end

	local pNameLabel = CreateLabel(pLabelText, 18,ccc3(51,25,13),CommonData.g_FONT1,ccp(10, 0))
	pNameLabel:setAnchorPoint(ccp(0,0.5))
	_Img_Bg:addChild( pNameLabel, 0, 4 )

	local pCityLabel = CreateLabel(pLabelCText, 18,ccc3(29,109,43),CommonData.g_FONT1,ccp(pCutLine_Mid:getPositionX(), 0))
	pCityLabel:setAnchorPoint(ccp(0,0.5))
	_Img_Bg:addChild( pCityLabel, 0, 5 )

	_Img_Bg:retain()

	if nType == SJ_Country_Type.ManZu then

		self.pSJItemTab["ManZu"][nIndex] = _Img_Bg

	elseif nType == SJ_Country_Type.HuangJin then

		self.pSJItemTab["HuangJin"][nIndex] = _Img_Bg

	end

	pParent:pushBackCustomItem( _Img_Bg ) 

end

----------------------------------------赐福相关逻辑begin------------------------------------------------

local function GetBuffStr( nTeamIndex )

	local pBuffDB = GetAnimalBuffInfo()

	local pBuffTeamDb = pBuffDB[nTeamIndex]

	local pStr = ""
	--[[print("nTeamIndex = "..nTeamIndex)
	printTab(pBuffDB)
	print("---------------------------------")
	printTab(pBuffTeamDb)
	Pause()]]
	if pBuffTeamDb ~= nil then

		local pBuff_QL_Num 		= pBuffTeamDb[AnimalType.Animal_QINGLONG]
		local pBuff_BaiHu_Num 	= pBuffTeamDb[AnimalType.Animal_BAIHU]
		local pBuff_ZQ_Num 		= pBuffTeamDb[AnimalType.Animal_ZHUQUE]
		local pBuff_XuanWu_Num  = pBuffTeamDb[AnimalType.Animal_XUANWU]

		if pBuff_QL_Num == 0 or pBuff_QL_Num == nil then
			pBuff_QL_Num = 0
		end
		if pBuff_BaiHu_Num == 0 or pBuff_BaiHu_Num == nil then
			pBuff_BaiHu_Num = 0
		end
		if pBuff_ZQ_Num == 0 or pBuff_ZQ_Num == nil then
			pBuff_ZQ_Num = 0
		end
		if pBuff_XuanWu_Num == 0 or pBuff_XuanWu_Num == nil then
			pBuff_XuanWu_Num = 0
		end
		
		pStr_QL = "|color|233,180,114||size|18|青龙赐福 : 战队穿透属性 + ".."|color|25,254,235|"..pBuff_QL_Num.."|n|1|"
		pStr_BH = "|color|233,180,114||size|18|白虎赐福 : ".."|color|25,254,235|"..pBuff_BaiHu_Num.."|color|233,180,114|次, 青龙赐福攻击力加成效果可持续".."|color|25,254,235|"..pBuff_BaiHu_Num.."|color|233,180,114|次战斗".."|n|1|"
		pStr_ZQ = "|color|233,180,114||size|18|朱雀赐福 : 战队免伤属性 + ".."|color|25,254,235|"..pBuff_ZQ_Num.."|n|1|"
		pStr_XW = "|color|233,180,114||size|18|玄武赐福 : ".."|color|25,254,235|"..pBuff_XuanWu_Num.."|color|233,180,114|次, 朱雀赐福攻击力加成效果可持续".."|color|25,254,235|"..pBuff_XuanWu_Num.."|color|233,180,114|次战斗".."|n|1|"

		pStr = pStr..pStr_QL..pStr_BH..pStr_ZQ..pStr_XW

	else

		pStr_QL = "|color|233,180,114||size|18|青龙赐福 : 战队穿透属性 + ".."|color|25,254,235|0|n|1|"
		pStr_BH = "|color|233,180,114||size|18|白虎赐福 : |color|25,254,235|0|color|233,180,114|次, 青龙赐福攻击力加成效果可持续|color|25,254,235|0|color|233,180,114|次战斗|n|1|"
		pStr_ZQ = "|color|233,180,114||size|18|朱雀赐福 : 战队免伤属性 + ".."|color|25,254,235|0|n|1|"
		pStr_XW = "|color|233,180,114||size|18|玄武赐福 : |color|25,254,235|0|color|233,180,114|次, 朱雀赐福攻击力加成效果可持续|color|25,254,235|0|color|233,180,114|次战斗|n|1|"

		pStr = pStr..pStr_QL..pStr_BH..pStr_ZQ..pStr_XW		

	end

	return tostring(pStr)
end

local function _Button_Buff_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		local pMessage = TipsMessage.CreateTipsMessage()
		pMessage:CreateByStr( GetBuffStr(sender:getTag()), 354, ccp(sender:getPositionX() + 490, sender:getPositionY() + 160) )
	end	
end

local function UpdateCiFu_Buff( self, nTeamIndex, nAnimalIndex, nAnimalNum )
	if self.Root ~= nil then

		local Image_Teamer 	   = tolua.cast(self.Panel_CiFu:getChildByName("Image_Teamer"..nTeamIndex + 1), "ImageView")
		local Label_Buff_1     = tolua.cast(Image_Teamer:getChildByName("Label_Buff_1"), "Label")
		local Label_Buff_2     = tolua.cast(Image_Teamer:getChildByName("Label_Buff_2"), "Label")

		if nAnimalIndex == AnimalType.Animal_BAIHU then
			Label_Buff_1:setText(nAnimalNum)
		end

		if nAnimalIndex == AnimalType.Animal_XUANWU then
			Label_Buff_2:setText(nAnimalNum)
		end	

	end
end

local function DelTeam( self, nIndex )
	if self.Panel_CiFu ~= nil then
		local Image_Teamer = tolua.cast(self.Panel_CiFu:getChildByName("Image_Teamer"..nIndex+1), "ImageView")
		Image_Teamer:setTouchEnabled(false)
		Image_Teamer:setVisible(false)
	end
end

local function UpdatePage_CiFu( self, nTab, nType )
	if self.Panel_CiFu ~= nil then
		local pBuffDB = GetAnimalBuffInfo()

		if nType == 1 then
			--初始化
			for key,value in pairs(nTab) do
				local Image_Teamer = tolua.cast(self.Panel_CiFu:getChildByName("Image_Teamer"..key), "ImageView")
				Image_Teamer:setVisible(true)
				Image_Teamer:setTouchEnabled(true)
				Image_Teamer:setTag(key-1)

				local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 

				if key == 1 then
					local pFaceId = GetTeamFace(key-1)
					local pPath = GetPathByImageID( pFaceId )
					Image_Head:loadTexture( pPath )
				else
					local nTeamerTab = nTab[key]
					local nTempId = nTeamerTab.nTempID
					local nHeadPath = GetGeneralHeadPath(nTempId)
					Image_Head:loadTexture(nHeadPath)	
				end

				Image_Teamer:addTouchEventListener(_Button_Buff_CallBack)

				local Label_Buff_1     = tolua.cast(Image_Teamer:getChildByName("Label_Buff_1"), "Label")
				local Label_Buff_2     = tolua.cast(Image_Teamer:getChildByName("Label_Buff_2"), "Label")

				local pBuff_AnimalDB = pBuffDB[key-1]

				--printTab(pBuffDB)
				--Pause()

				if pBuff_AnimalDB ~= nil then

					local pBuff_BaiHu_Num = pBuff_AnimalDB[AnimalType.Animal_BAIHU]

					local pBuff_XuanWu_Num = pBuff_AnimalDB[AnimalType.Animal_XUANWU]

					Label_Buff_1:setText( pBuff_BaiHu_Num )

					Label_Buff_2:setText( pBuff_XuanWu_Num )

				end

			end
		elseif nType == 2 then
			--新增
			local Image_Teamer = tolua.cast(self.Panel_CiFu:getChildByName("Image_Teamer"..nTab["TeamIndex"]+1), "ImageView")
			Image_Teamer:setVisible(true)
			Image_Teamer:setTouchEnabled(true)
			Image_Teamer:setTag(nTab["TeamIndex"])

			local Image_Head     = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 

			if nTab["TeamIndex"] == 0 then
				local pFaceId = GetTeamFace( nTab["TeamIndex"] )
				local pPath = GetPathByImageID( pFaceId )
				Image_Head:loadTexture( pPath )
			else
				local nTempId = nTab["nTempID"]
				local nHeadPath = GetGeneralHeadPath(nTempId)
				Image_Head:loadTexture(nHeadPath)
			end

			Image_Teamer:addTouchEventListener(_Button_Buff_CallBack)

			local Label_Buff_1     = tolua.cast(Image_Teamer:getChildByName("Label_Buff_1"), "Label")
			local Label_Buff_2     = tolua.cast(Image_Teamer:getChildByName("Label_Buff_2"), "Label")

			local pBuff_AnimalDB = pBuffDB[nTab["TeamIndex"]]

			if pBuff_AnimalDB ~= nil then

				local pBuff_BaiHu_Num = pBuff_AnimalDB[AnimalType.Animal_BAIHU]

				local pBuff_XuanWu_Num = pBuff_AnimalDB[AnimalType.Animal_XUANWU]

				Label_Buff_1:setText( pBuff_BaiHu_Num )

				Label_Buff_2:setText( pBuff_XuanWu_Num )

			end

		elseif nType == 3 then
			--更新
		end

	end
end

----------------------------------------赐福相关逻辑end------------------------------------------------

----------------------------------------远征军相关逻辑begin------------------------------------------------

local function AddItem_YZ( self, nYzData )

	if self.Panel_YZ == nil then
		return 
	end
	-- 添加某条远征军
	local pNewIndex = nYzData["Index"]

	local pListView_Yz = tolua.cast(self.Panel_YZ:getChildByName("ListView_YZ"), "ListView")

	for i=1, GetExpeDitionCount() do
		local pExpeTab = GetExpeDitionDataByIndex(i)
		local pExpeIndex = pExpeTab["Index"]
		if tonumber(pNewIndex) == tonumber(pExpeIndex) then

			if GetExpeDitionType( pExpeIndex ) == Expe_Type.Expe then
				CreateItem( self, pListView_Yz, pExpeTab, i )
				break
			end
		end
	end

	PageYZ_ChangeCountry( self, self.PageYZ_CurCountry )

end

local function DelItem_YZ( self, nDelGrid )
	-- 删除某条远征军

	if self.Panel_YZ ~= nil then

		local pListView_Yz = tolua.cast(self.Panel_YZ:getChildByName("ListView_YZ"), "ListView")

		local pDelIndex = nil

		for i=1, GetExpeDitionCount() do

			local pExpeTab = GetExpeDitionDataByIndex(i)
			local pExpeGrid = pExpeTab["Grid"]
			local pCountryID = GetExpeDitionCountryID( pExpeTab["Index"] )

			if tonumber( pExpeGrid ) == tonumber(nDelGrid) then

				local pExpeItem = self.pYZItemTab[i]

				pDelIndex = i

				if pExpeItem == nil then
					return
				end

				if pCountryID == self.PageYZ_CurCountry then

					--如果当前类型是要删除的类型的列表则删除item

					pExpeItem:removeFromParentAndCleanup(true)

					pListView_Yz:refreshView()

					break

				else

					--如果不是则release这个item 等待从列表中删除

				end

				if pDelIndex ~= nil then

					pExpeItem:release()
					self.pYZItemTab[i] = nil
					--table.remove( self.pYZItemTab, pDelIndex ) 
					print("删除远征军"..pDelIndex)

				end

			end

		end

	end

end

local function UpdateItem_YZ( self, nYzData )
	--更新某条远征军的状态
	local pNewCityID = nYzData["CityID"]
	local pNewIndex  = nYzData["Index"]
	local pCityName  = GetCityNameByIndex( GetIndexByCTag( pNewCityID )  )
	local pCountryID = GetExpeDitionCountryID( pNewIndex )

	--print(pCityName, pCountryID)
	

	--检查当前列表找到此远征军进行数据更新

	if self.Panel_YZ ~= nil then

		local pListView_Yz = tolua.cast(self.Panel_YZ:getChildByName("ListView_YZ"), "ListView")

		local pItemsCount = pListView_Yz:getItems():count()

		if pItemsCount <= 0 then

			return

		end

		for i=1, GetExpeDitionCount() do
			local pExpeTab = GetExpeDitionDataByIndex(i)
			local pExpeIndex = pExpeTab["Index"]
			if tonumber(pExpeIndex) == tonumber(pNewIndex) then

				local pExpeItem = self.pYZItemTab[i]

				if pExpeItem == nil then

					return

				end

				local pCityLabel = tolua.cast(pExpeItem:getChildByTag(5), "Label")

				local pLabelCText = "【No】"..pCityName

				if pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WEI then

					pLabelCText = "【魏】"..pCityName

				elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_SHU then

					pLabelCText = "【蜀】"..pCityName

				elseif pCountryID == COUNTRY_TYPE.COUNTRY_TYPE_WU then

					pLabelCText = "【吴】"..pCityName

				end

				--print(pLabelCText)

				if pCityLabel ~= nil then

					pCityLabel:setText( pLabelCText )

				end

				break

			end

		end

		pListView_Yz:refreshView()

	end

end

local function UpdatePage_YZ( self )
	if self.Panel_YZ ~= nil then

		local pListView_Yz = tolua.cast(self.Panel_YZ:getChildByName("ListView_YZ"), "ListView")

		local Image_YZChoose  = tolua.cast(self.Panel_YZ:getChildByName("Image_YZChoose"), "ImageView")

		local Btn_YZChoose    = tolua.cast(Image_YZChoose:getChildByName("Image_Btn_Show"), "ImageView")

		local Image_Btn_Wei    = tolua.cast(Image_YZChoose:getChildByName("Image_Btn_Wei"), "ImageView")

		local Image_Btn_Shu    = tolua.cast(Image_YZChoose:getChildByName("Image_Btn_Shu"), "ImageView")

		local Image_Btn_Wu     = tolua.cast(Image_YZChoose:getChildByName("Image_Btn_Wu"), "ImageView")

		local function _Btn_ChooseYZ_CallBack( sender, eventType )

			if eventType == TouchEventType.ended then 

				if self.PageYZ_ChooseTpe == Page_YZ_Choose_Type.Hide then
					return
				end

				--关闭状态显示当前选择的远征军

				self.PageYZ_ChooseTpe = Page_YZ_Choose_Type.Hide

				Image_Btn_Wu:setVisible(false)

				Image_Btn_Shu:setVisible(false)

				Image_Btn_Wu:setTouchEnabled(false)

				Image_Btn_Shu:setTouchEnabled(false)	

				Image_YZChoose:setSize(CCSizeMake( 138, 34 ))


				if self.PageYZ_CurCountry == sender:getTag() then
					PageYZ_ChangeTitleText( self, self.PageYZ_CurCountry )
					return
				end

				PageYZ_ChangeCountry( self, sender:getTag() )

			end

		end

		Image_Btn_Wei:setTouchEnabled(true)

		Image_Btn_Wei:addTouchEventListener(_Btn_ChooseYZ_CallBack)

		Image_Btn_Shu:addTouchEventListener(_Btn_ChooseYZ_CallBack)

		Image_Btn_Wu:addTouchEventListener(_Btn_ChooseYZ_CallBack)

		if self.PageYZ_ChooseTpe == Page_YZ_Choose_Type.Hide then

			Image_Btn_Wu:setVisible(false)

			Image_Btn_Shu:setVisible(false)

			Image_Btn_Wu:setTouchEnabled(false)

			Image_Btn_Shu:setTouchEnabled(false)	

		end

		local function _Btn_ShowPageYZ_Choose_CallBack( sender, eventType )
			if eventType == TouchEventType.ended then

				if self.PageYZ_ChooseTpe == Page_YZ_Choose_Type.Hide then

					Image_YZChoose:setSize(CCSizeMake( 138, 92 ))

					self.PageYZ_ChooseTpe = Page_YZ_Choose_Type.Show

					Image_Btn_Wu:setVisible(true)

					Image_Btn_Shu:setVisible(true)

					Image_Btn_Wu:setTouchEnabled(true)

					Image_Btn_Shu:setTouchEnabled(true)

					--打开状态下恢复魏蜀吴桑国家字体显示

					PageYZ_ChangeTitleText( self, COUNTRY_TYPE.COUNTRY_TYPE_WEI )

				else

					Image_YZChoose:setSize(CCSizeMake( 138, 34 ))

					self.PageYZ_ChooseTpe = Page_YZ_Choose_Type.Hide

					Image_Btn_Wu:setVisible(false)

					Image_Btn_Shu:setVisible(false)

					Image_Btn_Wu:setTouchEnabled(false)

					Image_Btn_Shu:setTouchEnabled(false)

					PageYZ_ChangeTitleText( self, self.PageYZ_CurCountry )	

				end

			end
		end

		Btn_YZChoose:setTouchEnabled(true)

		Btn_YZChoose:addTouchEventListener(_Btn_ShowPageYZ_Choose_CallBack)

		local pItemsCount = pListView_Yz:getItems():count()

		pListView_Yz:setItemsMargin(10)

		pListView_Yz:setClippingType(1)

		if pItemsCount <= 0 then

			for i=1, GetExpeDitionCount() do
				local pExpeTab = GetExpeDitionDataByIndex(i)
				local _CountryID = GetExpeDitionCountryID( i )
				local pExpeIndex = pExpeTab["Index"]
				--如果是远征军则创建，是灵兽则不创建
				if GetExpeDitionType( pExpeIndex ) == Expe_Type.Expe then
					CreateItem( self, pListView_Yz, pExpeTab, i )
				end
			end

			PageYZ_ChangeCountry( self, COUNTRY_TYPE.COUNTRY_TYPE_WEI )

		else

			print(" 远征军有数据 ")

		end

	end
end

----------------------------------------远征军相关逻辑end------------------------------------------------

----------------------------------------事件相关逻辑begin------------------------------------------------

local function AddItem_SJ( self, nEventCityID, nType )

	if self.Panel_SJ == nil then
		return
	end

	local pListView_SJ = tolua.cast(self.Panel_SJ:getChildByName("ListView_SJ"), "ListView")

	local pTab = nil

	if nType == SJ_Country_Type.ManZu then

		pTab = self.pSJItemTab["ManZu"]

	else

		pTab = self.pSJItemTab["HuangJin"]

	end

	if pTab == nil then
		return
	end

	if pTab[nEventCityID] ~= nil then
		return
	end

	local pManZuTab = GetManZuCity()

	for key,value in pairs( pManZuTab ) do

		if value["CityID"] == nEventCityID then

			CreateItemBySJ( self, pListView_SJ, value["CityID"], value["Type"], key )

			break

		end

	end

	PageSJ_ChangeCountry( self, nType )

end

local function DelItem_SJ( self, nEventCityID, nType )
	if self.Panel_SJ == nil then
		return
	end

	local pListView_SJ = tolua.cast(self.Panel_SJ:getChildByName("ListView_SJ"), "ListView")

	local pTab = nil

	if nType == SJ_Country_Type.ManZu then

		pTab = self.pSJItemTab["ManZu"]

	else

		pTab = self.pSJItemTab["HuangJin"]

	end

	local pDelItem = pTab[nEventCityID]

	if pDelItem == nil then
		return
	end

	if nType == self.PageSJ_CurCountry then 

		pDelItem:removeFromParentAndCleanup(true)

		pListView_SJ:refreshView()

	end

	pDelItem:release()

	pTab[nEventCityID] = nil

end

local function UpdateItem_SJ( self, nSJData, nType )

end


local function UpdatePage_SJ( self )
	if self.Panel_SJ ~= nil then

		local pListView_SJ = tolua.cast(self.Panel_SJ:getChildByName("ListView_SJ"), "ListView")

		local Image_SJChoose  = tolua.cast(self.Panel_SJ:getChildByName("Image_SJChoose"), "ImageView")

		local Btn_SJChoose    = tolua.cast(Image_SJChoose:getChildByName("Image_Btn_Show"), "ImageView")

		local Image_Btn_ManZu    = tolua.cast(Image_SJChoose:getChildByName("Image_Btn_ManZu"), "ImageView")

		local Image_Btn_HuangJin    = tolua.cast(Image_SJChoose:getChildByName("Image_Btn_HuangJin"), "ImageView")

		local function _Btn_ChooseSJ_CallBack( sender, eventType )

			if eventType == TouchEventType.ended then 

				if self.PageSJ_ChooseTpe == Page_YZ_Choose_Type.Hide then
					return
				end

				--关闭状态显示当前选择的远征军

				self.PageSJ_ChooseTpe = Page_YZ_Choose_Type.Hide

				Image_Btn_HuangJin:setVisible(false)

				Image_Btn_HuangJin:setTouchEnabled(false)	

				Image_SJChoose:setSize(CCSizeMake( 138, 34 ))


				if self.PageSJ_CurCountry == sender:getTag() then
					PageSJ_ChangeTitleText( self, self.PageSJ_CurCountry )
					return
				end

				PageSJ_ChangeCountry( self, sender:getTag() )

			end

		end

		Image_Btn_ManZu:setTouchEnabled(true)

		Image_Btn_ManZu:addTouchEventListener(_Btn_ChooseSJ_CallBack)

		Image_Btn_HuangJin:addTouchEventListener(_Btn_ChooseSJ_CallBack)

		if self.PageSJ_ChooseTpe == Page_YZ_Choose_Type.Hide then

			Image_Btn_HuangJin:setVisible(false)

			Image_Btn_HuangJin:setTouchEnabled(false)

		end

		local function _Btn_ShowPageSJ_Choose_CallBack( sender, eventType )
			if eventType == TouchEventType.ended then

				if self.PageSJ_ChooseTpe == Page_YZ_Choose_Type.Hide then

					Image_SJChoose:setSize(CCSizeMake( 138, 64 ))

					self.PageSJ_ChooseTpe = Page_YZ_Choose_Type.Show

					Image_Btn_HuangJin:setVisible(true)

					Image_Btn_HuangJin:setTouchEnabled(true)

					--打开状态下恢复蛮族字体显示

					PageSJ_ChangeTitleText( self, SJ_Country_Type.ManZu )

				else

					Image_SJChoose:setSize(CCSizeMake( 138, 34 ))

					self.PageSJ_ChooseTpe = Page_YZ_Choose_Type.Hide

					Image_Btn_HuangJin:setVisible(false)

					Image_Btn_HuangJin:setTouchEnabled(false)

					PageSJ_ChangeTitleText( self, self.PageSJ_CurCountry)	

				end

			end
		end

		Btn_SJChoose:setTouchEnabled(true)

		Btn_SJChoose:addTouchEventListener(_Btn_ShowPageSJ_Choose_CallBack)

		local pItemsCount = pListView_SJ:getItems():count()

		pListView_SJ:setItemsMargin(10)

		pListView_SJ:setClippingType(1)

		if pItemsCount <= 0 then
			--1.添加蛮族入侵事件
			local pManZuTab = GetManZuCity()

			for key,value in pairs( pManZuTab ) do
				CreateItemBySJ( self, pListView_SJ, value["CityID"], value["Type"], key )
			end

			PageSJ_ChangeCountry( self, SJ_Country_Type.ManZu )

		else

			print(" 事件page有数据 ")

		end

	end
end

----------------------------------------事件相关逻辑end------------------------------------------------

local function InitPage_CiFu( self )
	EnabledPanel( self.Panel_CiFu, true )
	EnabledPanel( self.Panel_YZ, false )
	EnabledPanel( self.Panel_SJ, false )
end

local function InitPage_YZ( self )
	EnabledPanel( self.Panel_YZ, true )
	EnabledPanel( self.Panel_CiFu, false )
	EnabledPanel( self.Panel_SJ, false )

	UpdatePage_YZ( self )
end

local function InitPage_SJ( self )
	EnabledPanel( self.Panel_SJ, true )
	EnabledPanel( self.Panel_YZ, false )
	EnabledPanel( self.Panel_CiFu, false )

	UpdatePage_SJ( self )
end

local function InitPage( self, nPageIndex, pRootLayer )

	self.PageIndex = nPageIndex

	self.Root 	   = pRootLayer

	self.PageLayerType 	  = PageLayer_Type.Hide
	--远征军
	self.PageYZ_ChooseTpe = Page_YZ_Choose_Type.Hide

	self.PageYZ_CurCountry = COUNTRY_TYPE.COUNTRY_TYPE_WEI

	self.pYZItemTab = {} 			--远征军存储列表

	--事件
	self.PageSJ_ChooseTpe = Page_YZ_Choose_Type.Hide

	self.PageSJ_CurCountry = SJ_Country_Type.ManZu

	self.pSJItemTab = {} 				--事件存储列表

	self.pSJItemTab["ManZu"] = {} 		--蛮族事件存储列表

	self.pSJItemTab["HuangJin"] = {} 	--黄巾事件存储列表

	self.Btn_CiFu = tolua.cast(pRootLayer:getChildByName("Image_Btn_CiFu"), "ImageView")
	self.Btn_YZ   = tolua.cast(pRootLayer:getChildByName("Image_Btn_YZ"), "ImageView")
	self.Btn_SJ   = tolua.cast(pRootLayer:getChildByName("Image_Btn_SJ"), "ImageView")
	self.Btn_Show = tolua.cast(pRootLayer:getChildByName("Button_Show"), "Button")

	self.Panel_CiFu = tolua.cast(pRootLayer:getChildByName("Panel_CiFu"), "ScrollView")
	self.Panel_YZ 	= tolua.cast(pRootLayer:getChildByName("Panel_YZ"), "ScrollView")
	self.Panel_SJ 	= tolua.cast(pRootLayer:getChildByName("Panel_SJ"), "ScrollView")

	local function _Button_CiFu_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			self.PageIndex = Page_Type.Page_CiFu
			self.Btn_CiFu:loadTexture( "Image/imgres/countrywar/light_page.png" )
			self.Btn_YZ:loadTexture( "Image/imgres/countrywar/dark_page.png" )
			self.Btn_SJ:loadTexture( "Image/imgres/countrywar/dark_page.png" )
			InitPage_CiFu( self )
		end	
	end

	local function _Button_YZ_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			self.PageIndex = Page_Type.Page_YZ
			self.Btn_YZ:loadTexture( "Image/imgres/countrywar/light_page.png" )
			self.Btn_CiFu:loadTexture( "Image/imgres/countrywar/dark_page.png" )
			self.Btn_SJ:loadTexture( "Image/imgres/countrywar/dark_page.png" )
			InitPage_YZ( self )
		end		
	end

	local function _Button_SJ_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			self.PageIndex = Page_Type.Page_SJ
			self.Btn_SJ:loadTexture( "Image/imgres/countrywar/light_page.png" )
			self.Btn_CiFu:loadTexture( "Image/imgres/countrywar/dark_page.png" )
			self.Btn_YZ:loadTexture( "Image/imgres/countrywar/dark_page.png" )
			InitPage_SJ( self )
		end	
	end

	local function _Button_Show_CallBack( sender, eventType )
		if eventType == TouchEventType.ended then
			if self.PageLayerType == PageLayer_Type.Hide then
				--show
				if self.Root ~= nil then
					self.Root:setPositionX(self.Root:getPositionX() - 285)
					self.PageLayerType = PageLayer_Type.Show
				end
			else
				--hide
				if self.Root ~= nil then
					self.Root:setPositionX(self.Root:getPositionX() + 285)
					self.PageLayerType = PageLayer_Type.Hide
				end
			end
		end	
	end

	self.Btn_CiFu:addTouchEventListener( _Button_CiFu_CallBack )
	self.Btn_YZ:addTouchEventListener( _Button_YZ_CallBack )
	self.Btn_SJ:addTouchEventListener( _Button_SJ_CallBack )
	self.Btn_Show:addTouchEventListener(_Button_Show_CallBack)

	self.Btn_CiFu:setTouchEnabled(true)
	self.Btn_YZ:setTouchEnabled(true)
	self.Btn_SJ:setTouchEnabled(true)

	if self.PageIndex == Page_Type.Page_CiFu then
		InitPage_CiFu( self )
		self.Btn_CiFu:loadTexture( "Image/imgres/countrywar/light_page.png" )
	elseif self.PageIndex == Page_Type.Page_YZ then
		InitPage_YZ( self )
		self.Btn_YZ:loadTexture( "Image/imgres/countrywar/light_page.png" )
	elseif self.PageIndex == Page_Type.Page_SJ then
		InitPage_SJ( self )
		self.Btn_SJ:loadTexture( "Image/imgres/countrywar/light_page.png" )
	end

end


function Create(  )
	local tab = {
		Fun_InitPage 			=	InitPage,
		Fun_UpdatePage_CiFu 	=	UpdatePage_CiFu,
		Fun_UpdateCiFu_Buff		=	UpdateCiFu_Buff,
		Fun_DelTeam				=	DelTeam,
		Fun_UpdateItem_YZ		=	UpdateItem_YZ,
		Fun_DelItem_YZ 			=	DelItem_YZ,
		Fun_AddItem_YZ			=	AddItem_YZ,
		Fun_UpdateItem_SJ		=	UpdateItem_SJ,
		Fun_AddItem_SJ			=	AddItem_SJ,
		Fun_DelItem_SJ			=	DelItem_SJ,
	}

	return tab
end

