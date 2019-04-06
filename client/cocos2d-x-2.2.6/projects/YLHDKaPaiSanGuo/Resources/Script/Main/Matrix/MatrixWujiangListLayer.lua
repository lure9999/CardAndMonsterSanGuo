
--require "Script/Audio/AudioUtil"
--require "Script/serverDB/general"

require "Script/Main/Matrix/MatrixWujiangListData"
require "Script/Main/Matrix/MatrixWujiangListLogic"
require "Script/Main/Matrix/MatrixLayerLogic"
require "Script/Main/Wujiang/GeneralBaseData"
require "Script/Main/Wujiang/GeneralRelationLogic"

module("MatrixWujiangListLayer", package.seeall)
--add by sxin 重构

local GetWujiangTableByType 		= MatrixWujiangListLogic.GetWujiangTableByType
local CheckSelectWuJiang			= MatrixWujiangListLogic.CheckSelectWuJiang

local Open_Tip_WuJiang				= MatrixLayerLogic.Open_Tip_WuJiang

local SetGeneralGrid 				= MatrixWujiangListData.SetGeneralGrid
local GetGeneralGrid				= MatrixWujiangListData.GetGeneralGrid
local GetGeneralTableByGrid 		= MatrixWujiangListData.GetGeneralTableByGrid
local GetGeneralTempIdByGrid		= MatrixWujiangListData.GetGeneralTempIdByGrid
local GetGeneralPosByTempId			= MatrixWujiangListData.GetGeneralPosByTempId
local GetAnimation_ImagefileName_Head_ByResID = MatrixWujiangListData.GetAnimation_ImagefileName_Head_ByResID
local GetGeneralcountriesByTempId 	= MatrixWujiangListData.GetGeneralcountriesByTempId
local GetGeneralattributeByTempId 	= MatrixWujiangListData.GetGeneralattributeByTempId
local GetGeneralNameByTempId 		= MatrixWujiangListData.GetGeneralNameByTempId
local GetGeneralqualityByTempId 	= MatrixWujiangListData.GetGeneralqualityByTempId
local GetGeneralResIDByTempId 		= MatrixWujiangListData.GetGeneralResIDByTempId
local GetGeneralColourByTempId 		= MatrixWujiangListData.GetGeneralColourByTempId

local GetTempIdByGrid								= server_generalDB.GetTempIdByGrid
local MakeHeadIcon									= UIInterface.MakeHeadIcon
local GetGeneralName								= GeneralBaseData.GetGeneralName
local GetGeneralCountryIcon							= GeneralBaseData.GetGeneralCountryIcon
local GetDanYaoLvText								= GeneralBaseData.GetDanYaoLvText
local GetGeneralTypeByGrid							= GeneralBaseData.GetGeneralTypeByGrid
local GetBlogData									= GeneralBaseData.GetBlogData

local GetRelationData								= GeneralRelationLogic.GetRelationData
local SortRelationStateTab							= GeneralRelationLogic.SortRelationStateTab



local layerMatrixWujiangList = nil
local m_pLastCheckBox = nil
local m_CurPos = nil
local m_CurType = nil

--当前的界面逻辑放在界面内 玩法逻辑在逻辑层
local m_curWuGrid = nil
local m_nCurGrid = nil


local function SetCurGrid(nGrid)
	m_nCurGrid = nGrid
end

local function GetCurGrid()
	return m_nCurGrid
end

local function SetCurWuGrid(nGrid)
	m_curWuGrid = nGrid
end

local function GetCurWuGrid()
	return m_curWuGrid
end

local function _Btn_Head_CallBack(sender,eventType)
	if true then return end

    local i_button_tou = tolua.cast(sender,"Button")
    if eventType == TouchEventType.ended then 
        require "Script/Main/Wujiang/WujiangOperateLayer"
        MainScene.ShowLeftInfo(false)
        MainScene.ClearRootBtn()
        MainScene.DeleteUILayer(WujiangOperateLayer.GetUIControl())
		-- 参数修改为Grid,确保唯一性
		local layer_wjOperate = WujiangOperateLayer.createWujiangOperateLayer(i_button_tou:getTag(), GeneralOptType.Update)
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(layer_wjOperate, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
		MainScene.PushUILayer(layer_wjOperate)
	end
end


local function _Chb_ShangZhen_CallBack(sender,eventType)

    local i_button_tou = tolua.cast(sender,"CheckBox")
    if eventType == TouchEventType.ended then
    	print("上阵GID=" .. i_button_tou:getTag())

		SetGeneralGrid(i_button_tou:getTag(), GetCurGrid())

		SetCurWuGrid(i_button_tou:getTag())	

		returnBack(i_button_tou:getTag())
	end	
end

local function UpdateRelationCount( tabState, pControl )
	local tabSortState = SortRelationStateTab(tabState)
	local pImgRelationBg = tolua.cast(pControl:getChildByName("yf_bg"), "ImageView")
	for i=1, GeneralRelationData.MAX_RELATION_COUNT do
		local  pImgRelation = tolua.cast(pImgRelationBg:getChildByName("img_"..tostring(i)), "ImageView")
		if i<=#tabSortState then
			if tabSortState[i]==GeneralRelationData.RelationState.Solidified then
				pImgRelation:loadTexture("Image/imgres/wujiang/yf_n.png")
			elseif tabSortState[i]==GeneralRelationData.RelationState.Solidifying then
				pImgRelation:loadTexture("Image/imgres/wujiang/yf_l.png")
			end
		else
			pImgRelation:setVisible(false)
		end
	end
end

local function UpdateGeneralWidgetByGrid( nGrid, pControl )
	-- 头像信息
	local pImgHead = tolua.cast(pControl:getChildByName("img_head_item_wj"), "ImageView")
	local nGeneralId = GetTempIdByGrid(nGrid)
	local pHeadControl = MakeHeadIcon(pImgHead, ICONTYPE.GENERAL_ICON, nGeneralId, nGrid)
	pHeadControl:setTouchEnabled(false)
	-- pHeadControl:setTag(nGrid)
	-- pHeadControl:addTouchEventListener(_Btn_Head_CallBack)
	pControl:setTag(nGrid)
	pControl:addTouchEventListener(_Chb_ShangZhen_CallBack)

	-- 名字
	local pLbName = tolua.cast(pControl:getChildByName("label_name"), "Label")
	pLbName:setFontName(CommonData.g_FONT1)
	pLbName:setText(GetGeneralName(nGrid))

	-- 阵营
	local pImgCountry = tolua.cast(pControl:getChildByName("img_country"), "ImageView")
	pImgCountry:loadTexture(GetGeneralCountryIcon(nGrid))

	local pLayer = tolua.cast(pControl:getChildByName("Panel_General"), "Layout")
	local pLbDesc = tolua.cast(pControl:getChildByName("Label_Desc"), "Label")
	local pProgressLayer = tolua.cast(pControl:getChildByName("Panel_Progress"), "Layout")
	pProgressLayer:setVisible(false)
	local nType = GetGeneralTypeByGrid(nGrid)
	if nType~=GeneralType.HuFa then
		pLayer:setVisible(true)
		pLbDesc:setVisible(false)
		-- 丹药
		local pLbDanYaoLv = tolua.cast(pLayer:getChildByName("label_lv"),"Label")
		pLbDanYaoLv:setFontName(CommonData.g_FONT1)
		pLbDanYaoLv:setText(GetDanYaoLvText(nGrid))

		-- 缘分
		local tabState = {}
		local tabRelationData = GetRelationData(nGrid)

		for i=1, #tabRelationData do
			if tabRelationData[i].State~=GeneralRelationData.RelationState.NotActivted then
				table.insert( tabState, tabRelationData[i].State )
			end
		end

		UpdateRelationCount(tabState, pLayer)
	else
		pLayer:setVisible(false)
		pLbDesc:setVisible(true)
		pLbDesc:setText(GetBlogData(nGeneralId))
	end
end

function InitItems( nType, nPos )
	--print(nType, m_CurType, nPos, m_CurPos)
	if nType == GeneralType.General then
		if nPos == m_CurPos and m_CurType == GeneralType.General then
			print("nPos return")
			return
		end
	else
		if nType == m_CurType then
			print("nType return")
			return
		end
	end

	local MatrixWJItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/ItemWujiangList.json")
    local ListView_WuJiangItems = tolua.cast(layerMatrixWujiangList:getWidgetByName("ListView_Wujiang"), "ListView")
	ListView_WuJiangItems:setClippingType(1)
	ListView_WuJiangItems:setItemsMargin(30)
	ListView_WuJiangItems:removeAllItems();
	local TableWujiang = GetWujiangTableByType(nType, nPos)
	--排序的算法
	function comps(a,b)
		if a == GetCurWuGrid() then
			return true
		else
			return false
		end
	end
	table.sort(TableWujiang, comps)

	for key,value in pairs(TableWujiang) do
		-- local nTempID = tonumber(TableWujiang[key]["ItemID"])
		if key==#TableWujiang and (#TableWujiang%2==1) then
			-- 第一行空出30高度
			if key==1 then
				local pLayout = Layout:create()
				pLayout:setSize(CCSize(750, 30))
				ListView_WuJiangItems:pushBackCustomItem(pLayout)
			end
			local ItemTemp = MatrixWJItemTemp:clone()
			local peer = tolua.getpeer(MatrixWJItemTemp)
			tolua.setpeer(ItemTemp, peer)
			-- InitItemData(ItemTemp, TempTable)
			local pControl_1 = tolua.cast(ItemTemp:getChildByName("img_item0_wj"),"ImageView")
			UpdateGeneralWidgetByGrid(TableWujiang[key], pControl_1)
			local pControl_2 = tolua.cast(ItemTemp:getChildByName("img_item1_wj"),"ImageView")
			if pControl_2~=nil then
				pControl_2:setVisible(false)
				pControl_2:setEnabled(false)
			end
			ListView_WuJiangItems:pushBackCustomItem(ItemTemp)
		elseif  key%2==0 then
				-- 第一行空出30高度
				if key==2 then
					local pLayout = Layout:create()
					pLayout:setSize(CCSize(750, 30))
					ListView_WuJiangItems:pushBackCustomItem(pLayout)
				end
				local ItemTemp = MatrixWJItemTemp:clone()
			    local peer = tolua.getpeer(MatrixWJItemTemp)
			    tolua.setpeer(ItemTemp, peer)
			    -- InitItemData(ItemTemp, TempTable)
			    local pControl_1 = tolua.cast(ItemTemp:getChildByName("img_item0_wj"),"ImageView")
				UpdateGeneralWidgetByGrid(TableWujiang[key-1], pControl_1)
				local pControl_2 = tolua.cast(ItemTemp:getChildByName("img_item1_wj"),"ImageView")
				UpdateGeneralWidgetByGrid(TableWujiang[key], pControl_2)
			    ListView_WuJiangItems:pushBackCustomItem(ItemTemp)
		end
	end
    local CheckBox_all = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_all"), "CheckBox")
    local CheckBox_before = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_before"), "CheckBox")
    local CheckBox_mid = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_mid"), "CheckBox")
    local CheckBox_after = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_after"), "CheckBox")
    local CheckBox_hufa = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_hufa"), "CheckBox")

    -- 如果是1表示是护法
    local Panel_hufa_dis = tolua.cast(layerMatrixWujiangList:getWidgetByName("Panel_hufa_dis"), "TouchGroup")
    local Panel_wujiang_dis = tolua.cast(layerMatrixWujiangList:getWidgetByName("Panel_wujiang_dis"), "TouchGroup")

    if GetCurGrid() == 6 then
    	Panel_hufa_dis:setVisible(true)
    	-- 914, 260
    	Panel_hufa_dis:setPosition(ccp(914- CommonData.g_Origin.x, 260- CommonData.g_Origin.y))
    	Panel_wujiang_dis:setVisible(false)
    	-- 916, 161
    	Panel_wujiang_dis:setPosition(ccp(10000, 10000))
    	
    	CheckBox_hufa:setSelectedState(true)
    	CheckBox_before:setSelectedState(false)
		CheckBox_mid:setSelectedState(false)
		CheckBox_after:setSelectedState(false)
		CheckBox_all:setSelectedState(false)
    else
    	Panel_hufa_dis:setVisible(false)
    	Panel_hufa_dis:setPosition(ccp(10000, 10000))
    	Panel_wujiang_dis:setVisible(true)
    	Panel_wujiang_dis:setPosition(ccp(916- CommonData.g_Origin.x, 161- CommonData.g_Origin.y))
	    
    	if nType == GeneralType.General then
    		CheckBox_hufa:setSelectedState(false)
			if nPos==GeneralPos.All then
				CheckBox_all:setSelectedState(true)
    			CheckBox_before:setSelectedState(false)
				CheckBox_mid:setSelectedState(false)
				CheckBox_after:setSelectedState(false)
			else
				CheckBox_all:setSelectedState(false)
				if nPos==GeneralPos.Front then
					CheckBox_before:setSelectedState(true)
					CheckBox_mid:setSelectedState(false)
					CheckBox_after:setSelectedState(false)
				elseif nPos==GeneralPos.Middle then
					CheckBox_before:setSelectedState(false)
					CheckBox_mid:setSelectedState(true)
					CheckBox_after:setSelectedState(false)
				elseif nPos==GeneralPos.Behind then
					CheckBox_before:setSelectedState(false)
					CheckBox_mid:setSelectedState(false)
					CheckBox_after:setSelectedState(true)
				end
			end
		end
    end

    m_CurPos = nPos
    m_CurType = nType
end

function AddHead(nIndex, nTempId, nWjGdi)

	print("nWjGdi  = " .. nWjGdi)

	local Image_Head = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_0" .. nIndex), "ImageView")
	local Button_Head = tolua.cast(layerMatrixWujiangList:getWidgetByName("Button_Head_0" .. nIndex), "Button")
	local Image_Pinzhi_new = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Pinzhi_new_0" .. nIndex), "ImageView")

	print("nIndex = " .. nIndex)
	if tonumber(nWjGdi) > 0 then		
		
		local ResID = GetGeneralResIDByTempId(nTempId)
        local ImagefileName_Head = GetAnimation_ImagefileName_Head_ByResID(ResID)
        local wujiang_colour = GetGeneralColourByTempId(nTempId)
        local string_quality = string.format("Image/imgres/common/color/wj_pz%d.png",wujiang_colour)
		
		
		if Image_Pinzhi_new ~= nil then 
            Image_Pinzhi_new:loadTexture(string_quality)
             Image_Pinzhi_new:setPosition(ccp(0,0))	
            Image_Pinzhi_new:setScale(0.74)
			--Image_Pinzhi_new:setZOrder(10)
        end
		
        Button_Head:setVisible(false)
		--add by sxin  需要在当前的框里加一个图片 头像要缩小
		local img_Temp = ImageView:create()
		img_Temp:loadTexture(ImagefileName_Head)
		img_Temp:setScale(0.68)
		img_Temp:setPosition(ccp(3,10))	
        Image_Head:addChild(img_Temp)  			
		
        local function OpenWujiangInfo(sender, eventType)			
            if eventType == TouchEventType.ended then
                local i_button_tou = tolua.cast(sender,"Button")
                print("武将信息")

				if CheckSelectWuJiang(nWjGdi) == true then
				
					SetCurWuGrid(GetGeneralGrid(i_button_tou:getTag()))

					SetCurGrid(i_button_tou:getTag())

					if GetCurGrid() == 6 then
						InitItems(GeneralType.HuFa, GeneralPos.All)
					else
						InitItems(GeneralType.General, GeneralPos.All)
					end

					local Image_Head = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_0" .. GetCurGrid()), "ImageView")
					local Image_Head_Select = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_Select"), "ImageView")				
					local WorldPosition = ccp(Image_Head:getPositionX(), Image_Head:getPositionY())
					Image_Head_Select:setPosition(ccp(WorldPosition.x , WorldPosition.y ))
				end	
            end
        end
        Button_Head:setTag(nIndex)
        Button_Head:addTouchEventListener(OpenWujiangInfo)
    else
        if tonumber(nWjGdi) == 0 then
            -- 开启未上
            print("开启未上")
            local function AddShangZhen(sender, eventType)
	            if eventType == TouchEventType.ended then

	            	SetCurGrid(nIndex)

	            	SetCurWuGrid(-1)

	    			local Image_Head = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_0" .. GetCurGrid()), "ImageView")
	    			local Image_Head_Select = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_Select"), "ImageView")					
					local WorldPosition = ccp(Image_Head:getPositionX(), Image_Head:getPositionY())
				    Image_Head_Select:setPosition(ccp(WorldPosition.x , WorldPosition.y ))

	                if GetCurGrid() == 6 then
    					InitItems(GeneralType.HuFa, GeneralPos.All)
	                else
    					InitItems(GeneralType.General, GeneralPos.All)
	                end

	            end
            end
            Button_Head:loadTextures("Image/imgres/common/add.png", "Image/imgres/common/add.png", "")
        	Button_Head:setTag(nIndex)
            Button_Head:addTouchEventListener(AddShangZhen)
        else
            -- 锁定状态
            Button_Head:loadTextures("Image/imgres/matrix/big_lock.png", "Image/imgres/matrix/big_lock.png", "")
			
            local function TipInfo(sender, eventType)
                if eventType == TouchEventType.ended then
                    print("提交多少级开启")
					Open_Tip_WuJiang(nIndex)
                end
            end
            Button_Head:addTouchEventListener(TipInfo)
        end
	end          
end

local function InitVars()
	layerMatrixWujiangList = nil
	m_pLastCheckBox = nil
	m_curWuGrid = nil
	m_nCurGrid = nil
	m_CurPos = nil
	m_CurType = nil
end

function GetSelectPosition()
    local Image_Head_Select = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_Select"), "ImageView")
    return Image_Head_Select:getPositionX(), Image_Head_Select:getPositionY(), GetCurGrid()
end

function GetUIControl()
	return layerMatrixWujiangList
end

local function returnOver()

    layerMatrixWujiangList:setVisible(false)
    layerMatrixWujiangList:removeFromParentAndCleanup(true)
    layerMatrixWujiangList = nil
    MainScene.PopUILayer()
end

function returnBack(nNewWJID)
	if NETWORKENABLE > 0 then
	    local function sendOver()
			--print("Name = "..GeneralBaseData.GetGeneralName(nNewWJID))
			SetCurGrid(server_matrixDB.GetMatrixDBByWJ(nNewWJID))
			
			--[[if tonumber(m_nCurGrid) == 2 then
				print("存第3步")
					Pause()
				network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(3))
			end
			if tonumber(m_nCurGrid) == 3 then
				print("存第4步")
					Pause()
				network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(4))
			end]]--
	        NetWorkLoadingLayer.loadingHideNow()
	        -- 去刷新阵容界面
	        MatrixLayer.updataCurView()
	        MatrixLayer.SetIsUpdate(true)
    		returnOver()
	    end

		NetWorkLoadingLayer.loadingShow(true)
        server_matrixDB.SendMatrixToServer(server_matrixDB.GetCopyTable(), sendOver)
        
	else
        MatrixLayer.updataCurView()
    	returnOver()
	end

end

function GetTab(  )
    local function deleteKeyTab(st)
        local tab = {}
        for k, v in pairs(st or {}) do
            if type(v) ~= "table" then
                local nF = string.find(k, "equipgrid")
                if nF ~= nil then
                    for i = 1, 6 do
                        table.insert(tab, i, st["equipgrid" .. i])
                    end
                    return tab
                else
                    table.insert(tab, v)
                end
            else
                table.insert(tab, deleteKeyTab(v))
            end
        end
        return tab
    end

    local sendTable = deleteKeyTab(server_matrixDB.GetCopyTable())

    return sendTable
end

function GetMatrixListByNewGuilde( nIndex ) 

	if layerMatrixWujiangList ~= nil then

		local pType = GeneralType.General
		local pPos  = GeneralPos.All

		if nIndex == 6 then
			pType = GeneralType.HuFa
		else
			pType = GeneralType.General
		end

		local TableWujiangByNG = GetWujiangTableByType(pType, pPos)

		--排序的算法
		function comps(a,b)
			if a == nIndex then
				return true
			else
				return false
			end
		end

		table.sort(TableWujiangByNG, comps)

		local pGrid = TableWujiangByNG[1]

		local nNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_4

		if nIndex == 2 then
			--选取第一个武将
			pGrid = TableWujiangByNG[1]
			nNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_4
		elseif nIndex == 3 then
			--选取第二个武将
			pGrid = TableWujiangByNG[1]
			nNetType = NewGuideManager.Enum_NewGuide_Type.Enum_NewGuide_Type_5
		end

		SetGeneralGrid(pGrid, nIndex)

		SetCurWuGrid(pGrid)	

		--returnBack(pGrid)

	    local function sendOver()
			SetCurGrid(server_matrixDB.GetMatrixDBByWJ(pGrid))
			
	        NetWorkLoadingLayer.loadingHideNow()
	        -- 去刷新阵容界面
	        MatrixLayer.updataCurView()
	        MatrixLayer.SetIsUpdate(true)
    		returnOver()
	    end

	    Packet_ChangeMatrix.SetSuccessCallBack(sendOver)
	    NewGuideManager.PostPacket(nNetType)

	end
end

function createMatrixWujiangList(nGrid)
	InitVars()
	layerMatrixWujiangList = TouchGroup:create()
	layerMatrixWujiangList:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/MatrixWujiangListLayer.json" ) )

    local function _Button_return_CallBack(sender, eventType)
        if eventType == TouchEventType.ended then
        	--returnOver()
		        MatrixLayer.updataCurView()
            	returnOver()
            sender:setScale(1)
        elseif  eventType == TouchEventType.began then
            sender:setScale(0.9)
        elseif eventType == TouchEventType.canceled then
            sender:setScale(1.0)
        end
    end
    local Button_return = tolua.cast(layerMatrixWujiangList:getWidgetByName("Button_return"), "Button")
    Button_return:addTouchEventListener(_Button_return_CallBack)

    local CheckBox_all = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_all"), "CheckBox")
    local CheckBox_before = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_before"), "CheckBox")
    local CheckBox_mid = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_mid"), "CheckBox")
    local CheckBox_after = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_after"), "CheckBox")
    local CheckBox_hufa = tolua.cast(layerMatrixWujiangList:getWidgetByName("CheckBox_hufa"), "CheckBox")

    SetCurGrid(nGrid)

    SetCurWuGrid(GetGeneralGrid(GetCurGrid()))

    local function _CheckBox_all_CallBack(sender, eventType)
		local senderCheckBox = tolua.cast(sender,"CheckBox")

		if eventType == CheckBoxEventType.selected then 
    		local ListView_WuJiangItems = tolua.cast(layerMatrixWujiangList:getWidgetByName("ListView_Wujiang"), "ListView")
            -- ListView_WuJiangItems:removeAllItems();
    		InitItems(GeneralType.General, GeneralPos.All)
    		CheckBox_before:setSelectedState(false)
    		CheckBox_mid:setSelectedState(false)
    		CheckBox_after:setSelectedState(false)
		else
			if eventType == CheckBoxEventType.unselected then
				senderCheckBox:setSelectedState(true)
			end
        end
    end
    CheckBox_all:addEventListenerCheckBox(_CheckBox_all_CallBack)

    local function _CheckBox_before_CallBack(sender, eventType)
		local senderCheckBox = tolua.cast(sender,"CheckBox")

		if eventType == CheckBoxEventType.selected then 
    		local ListView_WuJiangItems = tolua.cast(layerMatrixWujiangList:getWidgetByName("ListView_Wujiang"), "ListView")
            -- ListView_WuJiangItems:removeAllItems()
    		InitItems(GeneralType.General, GeneralPos.Front)
    		CheckBox_all:setSelectedState(false)
    		CheckBox_mid:setSelectedState(false)
    		CheckBox_after:setSelectedState(false)
    		CheckBox_hufa:setSelectedState(false)
		else
			if eventType == CheckBoxEventType.unselected then
				senderCheckBox:setSelectedState(true)
			end
        end
    end
    CheckBox_before:addEventListenerCheckBox(_CheckBox_before_CallBack)

    local function _CheckBox_mid_CallBack(sender, eventType)
		local senderCheckBox = tolua.cast(sender,"CheckBox")

		if eventType == CheckBoxEventType.selected then 
    		local ListView_WuJiangItems = tolua.cast(layerMatrixWujiangList:getWidgetByName("ListView_Wujiang"), "ListView")
            -- ListView_WuJiangItems:removeAllItems()
    		InitItems(GeneralType.General, GeneralPos.Middle)
    		CheckBox_all:setSelectedState(false)
    		CheckBox_before:setSelectedState(false)
    		CheckBox_after:setSelectedState(false)
    		CheckBox_hufa:setSelectedState(false)
		else
			if eventType == CheckBoxEventType.unselected then
				senderCheckBox:setSelectedState(true)
			end
        end
    end
    CheckBox_mid:addEventListenerCheckBox(_CheckBox_mid_CallBack)

    local function _CheckBox_after_CallBack(sender, eventType)
		local senderCheckBox = tolua.cast(sender,"CheckBox")

		if eventType == CheckBoxEventType.selected then 
    		local ListView_WuJiangItems = tolua.cast(layerMatrixWujiangList:getWidgetByName("ListView_Wujiang"), "ListView")
            -- ListView_WuJiangItems:removeAllItems()
    		InitItems(GeneralType.General, GeneralPos.Behind)
    		CheckBox_all:setSelectedState(false)
    		CheckBox_before:setSelectedState(false)
    		CheckBox_mid:setSelectedState(false)
    		CheckBox_hufa:setSelectedState(false)
		else
			if eventType == CheckBoxEventType.unselected then
				senderCheckBox:setSelectedState(true)
			end
        end
    end


    CheckBox_after:addEventListenerCheckBox(_CheckBox_after_CallBack)

    local function _CheckBox_hufa_CallBack(sender, eventType)
		local senderCheckBox = tolua.cast(sender,"CheckBox")

		if eventType == CheckBoxEventType.selected then 
    		local ListView_WuJiangItems = tolua.cast(layerMatrixWujiangList:getWidgetByName("ListView_Wujiang"), "ListView")
            -- ListView_WuJiangItems:removeAllItems()
            -- Pos=-1, Type=2, 为护法
    		InitItems(GeneralType.HuFa, GeneralPos.All)
    		CheckBox_all:setSelectedState(false)
    		CheckBox_before:setSelectedState(false)
    		CheckBox_mid:setSelectedState(false)
    		CheckBox_after:setSelectedState(false)
		else
			if eventType == CheckBoxEventType.unselected then
				senderCheckBox:setSelectedState(true)
			end
        end
    end

    CheckBox_hufa:addEventListenerCheckBox(_CheckBox_hufa_CallBack)

	for i=1, 6 do

        local nWjGrid = GetGeneralGrid(i)
        local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
        local nTempId = 0

        if tableGeneralTemp ~= nil then
            --nTempId = tableGeneralTemp["Info02"]["TempID"]
            nTempId = tableGeneralTemp["ItemID"]
        end
        AddHead(i, nTempId, nWjGrid)
    end
    if GetCurGrid() == 6 then
    	InitItems(GeneralType.HuFa, GeneralPos.All)
    	m_CurType = GeneralType.HuFa
    else
    	InitItems(GeneralType.General, GeneralPos.All)
    	m_CurType = GeneralType.General
    end

    m_CurPos = GeneralPos.All


    local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height

    layerMatrixWujiangList:setPosition(ccp(nOff_W/2, nOff_H/2))

    local tableFixControl = {
    {
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_2"), "ImageView"),
    },
	{
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(layerMatrixWujiangList:getWidgetByName("Panel_37"), "Layout"),			
    },
    {
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(layerMatrixWujiangList:getWidgetByName("Button_return"), "Button"),
    },
    {
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(layerMatrixWujiangList:getChildByTag(layerMainBtn_Tag), "TouchGroup"),
    },
}
    for key,value in pairs(tableFixControl) do
        if value["control"] ~= nil then
            local nWidth = value["control"]:getPositionX() - CommonData.g_Origin.x + value["off_x"]
            local nHeight = value["control"]:getPositionY() + CommonData.g_Origin.y + value["off_y"]
            value["control"]:setPosition(ccp(nWidth, nHeight))
        end
    end
    local Image_Head = nil
    local Image_Head_Select = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_Select"), "ImageView")
    if GetCurGrid() == nil then
    	Image_Head = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_0" .. MatrixLayer.getCurPos()), "ImageView")
    else
	    Image_Head = tolua.cast(layerMatrixWujiangList:getWidgetByName("Image_Head_0" .. GetCurGrid()), "ImageView")
    end
	local WorldPosition = ccp(Image_Head:getPositionX(), Image_Head:getPositionY())
    Image_Head_Select:setPosition(ccp(WorldPosition.x , WorldPosition.y ))

	return layerMatrixWujiangList
end
 
