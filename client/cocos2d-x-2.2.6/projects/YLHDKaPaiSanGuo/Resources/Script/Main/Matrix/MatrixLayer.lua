-- for CCLuaEngine traceback


module("MatrixLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

require "Script/serverDB/general"
require "Script/serverDB/equipt"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/server_equipDB"

require "Script/Main/Matrix/MatrixWujiangListLayer"
require "Script/Main/Matrix/MatrixLayerLogic"
require "Script/Main/Matrix/MatrixLayerData"
require "Script/Main/Wujiang/GeneralOptLayer"
require "Script/Main/Equip/EquipListLayer"
require "Script/Main/Equip/EquipLogic"
require "Script/Main/Wujiang/GeneralRelationLayer"
require "Script/Main/Wujiang/GeneralBaseData"
--add by sxin 
require "Script/DB/AnimationData"
require "Script/serverDB/general"



--MatrixLayerLogic 引用
local CheckOpenMatrixWujiangList	                = MatrixLayerLogic.CheckOpenMatrixWujiangList
local CheckOpenMatrixEquipList	                    = MatrixLayerLogic.CheckOpenMatrixEquipList
local Open_Tip_WuJiang								= MatrixLayerLogic.Open_Tip_WuJiang
local Open_Tip_Equipt								= MatrixLayerLogic.Open_Tip_Equipt
local WujiangIsMainStay								= MatrixLayerLogic.WujiangIsMainStay
local GetHufaCurrentLingBaoNums						= MatrixLayerLogic.GetHufaCurrentLingBaoNums
--获得一键装备的数据
local GetOneKeyEquipData                            = MatrixLayerLogic.GetOneKeyEquipData
--一键强化
local  ToKeyStrengthen                              = MatrixLayerLogic.ToKeyStrengthen

local GetGeneralResIDByTempId                       = MatrixWujiangListData.GetGeneralResIDByTempId
local GetAnimation_ImagefileName_Head_ByResID       = MatrixWujiangListData.GetAnimation_ImagefileName_Head_ByResID
local GetGeneralColourByTempId                      = MatrixWujiangListData.GetGeneralColourByTempId
local GetGeneralTempIdByGrid 						= MatrixWujiangListData.GetGeneralTempIdByGrid	
local GetGeneralGrid                                = MatrixWujiangListData.GetGeneralGrid
local GetGeneralTableByGrid                         = MatrixWujiangListData.GetGeneralTableByGrid
local GetGeneralNameByTempId                        = MatrixWujiangListData.GetGeneralNameByTempId
local GetGeneralTypeByTempId                        = MatrixWujiangListData.GetGeneralTypeByTempId
local GetGeneralattributeByTempId                   = MatrixWujiangListData.GetGeneralattributeByTempId
local GetGeneralcountriesByTempId                   = MatrixWujiangListData.GetGeneralcountriesByTempId

local GetGeneralPosByGrid							= GeneralBaseData.GetGeneralPosByGrid
local GetGeneralTypeByGrid							= GeneralBaseData.GetGeneralTypeByGrid

local GetAnimationData_AnimationfileNameByResID     = MatrixLayerData.GetAnimationData_AnimationfileNameByResID
local GetGeneralGridByTempId                        = MatrixLayerData.GetGeneralGridByTempId
local GetEquipIndexByTempId                         = MatrixLayerData.GetEquipIndexByTempId
local GetEquipColorByTempId                         = MatrixLayerData.GetEquipColorByTempId
local GetEquipSuitIDByTempId                        = MatrixLayerData.GetEquipSuitIDByTempId
local GetEquipAnimationIDIDByTempId                 = MatrixLayerData.GetEquipAnimationIDIDByTempId
local GetAnimationData_AnimationNameByResID         = MatrixLayerData.GetAnimationData_AnimationNameByResID
local GetEquipGrid                                  = MatrixLayerData.GetEquipGrid
local GetTempIdByGrid                               = MatrixLayerData.GetTempIdByGrid

local GetRelationData								= GeneralRelationLogic.GetRelationData
local SortRelationStateTab							= GeneralRelationLogic.SortRelationStateTab

local UpDateMatrixBack								= EquipLogic.UpDateMatrixBack
local CheckBEquip									= EquipLogic.CheckBEquip
local m_playerMatrixLayer = nil
local m_isUpdate		  = false

--add by sxin 重构代码2015-3-16

-- MainScene 方法
local MainScene_ShowLeftInfo	= MainScene.ShowLeftInfo
local MainScene_ClearRootBtn	= MainScene.ClearRootBtn
local MainScene_DeleteUILayer	= MainScene.DeleteUILayer
local MainScene_PushUILayer		= MainScene.PushUILayer
local MainScene_PopUILayer		= MainScene.PopUILayer

--MatrixWujiangListLayer 方法
local MatrixWujiangListLayer_GetUIControl	= MatrixWujiangListLayer.GetUIControl
local MatrixWujiangListLayer_createMatrixWujiangList	= MatrixWujiangListLayer.createMatrixWujiangList

--EquipListManager 方法
local EquipListLayer_CreateLayerEquipList = EquipListLayer.CreateLayerEquipList

--UIInterface 方法
local UIInterface_CreatAnimateByResID = UIInterface.CreatAnimateByResID
local UIInterface_MakeHeadIcon = UIInterface.MakeHeadIcon

--EquipPropertyLayer
 require "Script/Main/Equip/EquipPropertyLayer"
local CreateEquipProperty =  EquipPropertyLayer.CreateEquipProperty

--GeneralBaseData
local GetDanYaoLvText 			= GeneralBaseData.GetDanYaoLvText

--LabelLayer
local StrokeLabel_createStrokeLabel 	= LabelLayer.createStrokeLabel
local StrokeLabel_setText 				= LabelLayer.setText

--注册更新 celina
local GetObserver = MainScene.GetObserver
local m_level = nil

--创建动态的描边字体的itag
local StrokeLabel_SeeYuanFen_Tag = 100
local StrokeLabel_ChangeWuJiang_Tag = 200
local StrokeLabel_JinDan_Tag = 300
local StrokeLabel_QiangHua_Tag = 400

function SetIsUpdate( nState )
	m_isUpdate = nState
end


local function OpenMatrixWujiangList(nGrid, nNewGuildeCallBack)

    if CheckOpenMatrixWujiangList(nGrid) == true then
	
		MainScene_ShowLeftInfo(false)
		MainScene_ClearRootBtn()
		MainScene_DeleteUILayer(MatrixWujiangListLayer_GetUIControl())
		
		print("nGridnGridnGridnGrid = " .. nGrid)
		
		local matrixWJ = MatrixWujiangListLayer_createMatrixWujiangList(nGrid)
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(matrixWJ,layerMatrixWuJiangList_Tag,layerMatrixWuJiangList_Tag)

		MainScene_PushUILayer(matrixWJ)

		if nNewGuildeCallBack ~= nil then

			nNewGuildeCallBack()

		end

	end  

end

local function OpenMatrixEquipList(nType)
   
    local nGrid = getCurPos()	
	if CheckOpenMatrixEquipList(nGrid) == true then
	 
		MainScene_ShowLeftInfo(false)
		MainScene_ClearRootBtn()
		local interFace = EquipListLayer_CreateLayerEquipList(ENUM_EQUIP_LAYER_OPRATER_TYPE.ENUM_EQUIP_LAYER_OPRATER_TYPE_MATRIX_EQUIP,nil,nType)
		local matrixEquip = interFace.m_layer
		local scenetemp =  CCDirector:sharedDirector():getRunningScene()
		scenetemp:addChild(matrixEquip,layerMatrixEquipList_Tag,layerMatrixEquipList_Tag)

		MainScene_PushUILayer(matrixEquip)
		return interFace
	end
  
end

local function ShowWJOperateLayer( nIndex )
	local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")

	local General_Type = GeneralType.General
    if nIndex == 6 then
        PageView_Hero:scrollToPage(0)
		General_Type = GeneralType.HuFa
    else
        PageView_Hero:scrollToPage(6 - nIndex)
    end
   
	MainScene_ShowLeftInfo(false)
	MainScene_ClearRootBtn()
	MainScene_DeleteUILayer(GeneralOptLayer.GetUIControl())
	
	--这里直接引用了lua的创建会造成GeneralOptLayer 自身的逻辑错乱！！lua脚本内存只有一份！！！！
	local nWjGrid = GetGeneralGrid(nIndex)
	
	local function pCallBackUpdata()
		if m_playerMatrixLayer~=nil then
			updataCurView()				
		end
	end
	local pLayerOperate = GeneralOptLayer.CreateGeneralOptLayer(nWjGrid, GetGeneralTypeByGrid(nWjGrid), GetGeneralPosByGrid(nWjGrid), pCallBackUpdata, 1)
	if pLayerOperate~=nil then
		local pSceneGame =  CCDirector:sharedDirector():getRunningScene()
		pSceneGame:addChild(pLayerOperate, layerWujiangOperate_Tag, layerWujiangOperate_Tag)
		MainScene_PushUILayer(pLayerOperate)
	end
end


local function _Button_SeeInfo_CallBack_Animate(sender, eventType)
	
    if eventType == TouchEventType.ended then
        local btn_head_temp = tolua.cast(sender,"Button")
        local nIndex = btn_head_temp:getTag()
        
        ShowWJOperateLayer(nIndex)

    end
end
local function AddEffectKeyStrengthen(tabGird)
	--print("AddEffectKeyStrengthen")
	--printTab(tabGird)
	--Pause()
	for i=1,4 do 
		if tonumber(tabGird[i][2])==1 then
			local pos = tonumber(tabGird[i][1]+1)
			local pEquip  = MatrixLayer.GetEquipControl( pos )
			if pEquip~=nil then
				CommonInterface.GetAnimationByName("Image/imgres/effectfile/StrengthenEquip_effect_01.ExportJson", 
				"StrengthenEquip_effect_01", 
				"qianghua02", 
				pEquip, 
				ccp(0, 0),
				nil,
				1000+i)
			end
		end
	end
	
end
--一键强化
local function _Button_QiangHua_CallBack(sender, eventType)
	
    if eventType == TouchEventType.ended then

    	local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")

    	--local nWjGrid = GetGeneralGrid(6 - PageView_Hero:getCurPageIndex())
		
		local nWjPos = 6 - PageView_Hero:getCurPageIndex()

    	local bEquip = false

    	for i = 1, 6 do
        	local nEquipGrid = GetEquipGrid(6 - PageView_Hero:getCurPageIndex(), i)

        	if nEquipGrid > 0 then

        		bEquip = true

        	end

        end
		if bEquip == false then
			--身上没有装备
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1651,nil)
			pTips = nil
		else
			local function StartKeyStrengthen(bSure)
				if bSure == true then
					local function StrengthenOK(tabEquipGird)
						--强化成功更新界面
						-- 去刷新阵容界面
						updataCurView()
						SetIsUpdate(true)
						--添加特效
						AddEffectKeyStrengthen(tabEquipGird)
					end
					ToKeyStrengthen(nWjPos,StrengthenOK)
				end
			end
			--可以一键强化弹出提示框
			local pPoint = TipCommonLayer.CreateTipLayerManager()
			pPoint:ShowCommonTips(1650,StartKeyStrengthen)
			pPoint = nil
		end

    end
end

--武将按钮响应
local function _Button_WuJiang_Click_CallBack(sender, eventType)

    if eventType == TouchEventType.ended then
	    local btn_head_temp = tolua.cast(sender,"Button")
	    local nIndex = btn_head_temp:getTag()
		  
		--更新武将	
		local Button_140 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_140"), "Button")		
		local Image_143 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_143"), "ImageView")			
		if Button_140 == sender and Image_143:isVisible() == false then
			return
		end  	       
      
        local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")

        if nIndex == 6 then
            PageView_Hero:scrollToPage(0)
        else
            PageView_Hero:scrollToPage(6 - nIndex)
        end

        OpenMatrixWujiangList(nIndex)
    end
end

local function _Button_Equip_Click_CallBack(sender, eventType)

    if eventType == TouchEventType.ended then
	
        local i_button_tou = tolua.cast(sender,"Button")
		
        OpenMatrixEquipList(i_button_tou:getTag())
    end
end

--增加一个创建button的接口来实现重复代码

local function CreatAnimation_Button( layout_Size, Texture_N, Texture_S, Texture_Disable, ButonPos ,iScale,iTag , FunTouchEvent)
	
	local layout = Layout:create()
	layout:setSize(layout_Size)		
	local btn_Temp = Button:create()	
	btn_Temp:setTouchEnabled(true)	
	btn_Temp:loadTextures(Texture_N,Texture_S,Texture_Disable)	
	btn_Temp:setPosition(ButonPos)	
	btn_Temp:setScale(iScale)
	btn_Temp:setTag(iTag)	
	btn_Temp:addTouchEventListener(FunTouchEvent)	
	layout:addChild(btn_Temp)
	
	return layout
	
end

local function CreatAnimation_ImageView( layout_Size, Texture, ImagePos ,iTag , FunTouchEvent)
	
	local layout = Layout:create()
	layout:setSize(layout_Size)		
	local img_Temp = ImageView:create()
	img_Temp:loadTexture(Texture)
	img_Temp:setTouchEnabled(true)		
	img_Temp:setPosition(ImagePos)	
	img_Temp:setTag(iTag)	
	img_Temp:addTouchEventListener(FunTouchEvent)	
	layout:addChild(img_Temp)
	
	return layout
	
end

local function AddAnimation(nIndex, TmpID, nWjGrid)
	local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
    if tonumber(nWjGrid) == 0 then
        -- 开启没上阵		
		local layout = CreatAnimation_Button(CCSize(600, 400),"Image/imgres/matrix/open_n.png","Image/imgres/matrix/open_h.png","",ccp(600/2+60, 400/2-20),1,nIndex,_Button_WuJiang_Click_CallBack)
	    PageView_Hero:addPage(layout)
    elseif tonumber(nWjGrid) == -1 then
		-- 未开启		
		local function Open_Tip(sender, eventType)
			if eventType == TouchEventType.ended then				
				local btn_head_temp = tolua.cast(sender,"ImageView")
				local nIndex = btn_head_temp:getTag()		
				Open_Tip_WuJiang(nIndex)
			end
		end
		local layout = CreatAnimation_ImageView(CCSize(600, 400),"Image/imgres/matrix/open_clock.png",ccp(600/2+60, 400/2-20),nIndex,Open_Tip)  		
		PageView_Hero:addPage(layout)
    else       		
		--上阵的
		local ResID = GetGeneralResIDByTempId(TmpID)		
		local pPayArmature = UIInterface_CreatAnimateByResID(ResID)
		
		pPayArmature:setPosition(ccp(600/2, 30))
		if tonumber(TmpID) ~= 7004 and tonumber(TmpID) ~= 7005 and tonumber(TmpID) ~= 7006 and tonumber(TmpID) ~= 7001 and tonumber(TmpID) ~= 7002 then
			pPayArmature:setScaleX(2*pPayArmature:getScaleX())
			pPayArmature:setScaleY(2.0)	
		end
		--add by sxin 修改成上阵的武将点击看缘分	
		--local layout = CreatAnimation_Button(CCSize(600, 400),"Image/common/common_empty.png","Image/common/common_empty.png","",ccp(600/2, 400/2),15,nIndex,_Button_WuJiang_Click_CallBack)
		
		local layout = CreatAnimation_Button(CCSize(600, 400),"Image/imgres/common/common_empty.png","Image/imgres/common/common_empty.png","",ccp(600/2, 400/2),15,nIndex,_Button_SeeInfo_CallBack_Animate)	
		layout:addNode(pPayArmature, 10, 10)
		PageView_Hero:addPage(layout)
    end
end

local function AddHead(nIndex, nTempId, nWjGrid)
    local Image_Head = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Head_0" .. nIndex), "ImageView")
    local Image_Pinzhi = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Pinzhi_0" .. nIndex), "ImageView")
	
    local Image_Pinzhi_new = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Pinzhi_new_0" .. nIndex), "ImageView")

    local Button_Head = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_Head_0" .. nIndex), "Button")
    if nWjGrid > 0 then
        local ResID = GetGeneralResIDByTempId(nTempId)
        local ImagefileName_Head = GetAnimation_ImagefileName_Head_ByResID(ResID)
        local wujiang_colour = GetGeneralColourByTempId(nTempId)
        local string_quality = string.format("Image/imgres/common/color/wj_pz%d.png",wujiang_colour)
      
        if Image_Pinzhi_new ~= nil then 
            Image_Pinzhi_new:loadTexture(string_quality)
			Image_Pinzhi_new:setZOrder(10)
        end
       
        Button_Head:setVisible(false)
		--add by sxin  需要在当前的框里加一个图片 头像要缩小
		if Image_Pinzhi:getChildByTag(109) ~= nil then
			Image_Pinzhi:getChildByTag(109):loadTexture(ImagefileName_Head)
		else
			local img_Temp = ImageView:create()
			img_Temp:loadTexture(ImagefileName_Head)
			img_Temp:setScale(0.68)
			img_Temp:setPosition(ccp(3,10))	
			img_Temp:setZOrder(11)
			img_Temp:setTag(109)
			Image_Pinzhi:addChild(img_Temp)
		end

        local function _Btn_Head_CallBack(sender, eventType)
            if eventType == TouchEventType.ended then

                local nIndex = sender:getTag()    

                local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
                if nIndex == 6 then
                    PageView_Hero:scrollToPage(0)
                else
                    PageView_Hero:scrollToPage(6 - nIndex)
                end
				
            end
        end
        Button_Head:setTag(nIndex)
        Button_Head:addTouchEventListener(_Btn_Head_CallBack)       

    else
        if tonumber(nWjGrid) == 0 then
            -- 开启未上
            Button_Head:loadTextures("Image/imgres/common/add.png", "Image/imgres/common/add.png", "")
            Button_Head:setTag(nIndex)
            Button_Head:addTouchEventListener(_Button_WuJiang_Click_CallBack)
        else
            -- 锁定状态
            Button_Head:loadTextures("Image/imgres/matrix/big_lock.png", "Image/imgres/matrix/big_lock.png", "")
			
            local function TipInfo(sender, eventType)
                if eventType == TouchEventType.ended then				
					local nIndex = sender:getTag() 
					Open_Tip_WuJiang(nIndex)
                end
            end
			Button_Head:setTag(nIndex)
            Button_Head:addTouchEventListener(TipInfo)
        end
    end
end

local function UpdateRelationCount( tabState, pControl )
	local tabSortState = SortRelationStateTab(tabState)
	--print("tabSortState == "..#tabSortState)
	for i=1, GeneralRelationData.MAX_RELATION_COUNT do
		local pImgRelationGreen = tolua.cast(pControl:getChildByName("Image_Activite_"..tostring(i)), "ImageView")
		local pImgRelationBlue = tolua.cast(pControl:getChildByName("Image_Soild_"..tostring(i)), "ImageView") 
		pImgRelationGreen:setVisible(false)
		pImgRelationBlue:setVisible(false)
		if i<=#tabSortState then
			if tabSortState[i]==GeneralRelationData.RelationState.Solidified then 			--已固化
				pImgRelationBlue:setVisible(true)
				pImgRelationGreen:setVisible(false)
			elseif tabSortState[i]==GeneralRelationData.RelationState.Solidifying then 		--固话已激活
				pImgRelationGreen:setVisible(true)
				pImgRelationBlue:setVisible(false)
			--else
			--	pImgRelationGreen:setVisible(false)
			--	pImgRelationBlue:setVisible(false)				
			end
		else
				pImgRelationGreen:setVisible(false)
				pImgRelationBlue:setVisible(false)		
		end
	end
end

local function ChangeCurInfo(nGrid)
    local nWjGrid = GetGeneralGrid(nGrid)
    local nTempId = 0
    local wujiang_colour = 0
    local turn = nil
    local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
    if tableGeneralTemp ~= nil then
        nTempId = tableGeneralTemp["ItemID"]
        m_level = tableGeneralTemp["Info02"]["Lv"]
        turn = tableGeneralTemp["Info02"]["Turn"]
    end
    title_Back = tolua.cast(m_playerMatrixLayer:getWidgetByName("Panel_title_back"), "Layout")
    --local text_Back = tolua.cast(m_playerMatrixLayer:getWidgetByName("Panel_text_back"), "Layout")
	local Image_4 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_4"), "ImageView")	
	local Image_Relation = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Relation"), "ImageView")
	print("ChangeCurInfo nGrid =" .. nWjGrid)
    if nWjGrid > 0 then
    	--缘分显示,设置缘分
		local tabState = {}
		local tabRelationData = GetRelationData(nWjGrid)

		for i=1, #tabRelationData do

			if tabRelationData[i].State~=GeneralRelationData.RelationState.NotActivted then
				table.insert( tabState, tabRelationData[i].State )
			end
		end
		
		UpdateRelationCount(tabState, Image_Relation)

		Image_4:setVisible(true)
        title_Back:setVisible(true)
        --text_Back:setVisible(true)
        local Label_Name = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Name"), "Label")
        local Label_Level = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Level"), "Label")
        local Label_Turn = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Turn"), "Label")
        local imgtype = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Type"), "ImageView")
        local county = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Country"), "ImageView")

        county:setVisible(true)
        imgtype:setVisible(true)

        wujiang_colour = GetGeneralColourByTempId(nTempId)
   		local string_quality = string.format("Image/imgres/matrix/pz_%d.png",wujiang_colour)
        local imgPinzhi = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Role_PinZhi"), "ImageView")
        imgPinzhi:setVisible(true)
        imgPinzhi:loadTexture(string_quality)

        local Name = GetGeneralNameByTempId(nTempId)

        local Type = GetGeneralTypeByTempId(nTempId)
        if tonumber(Type) == GeneralType.Main then

            Label_Name:setText(server_mainDB.getMainData("name"))
        else
            Label_Name:setText(Name)
        end

        local pNameSize = Label_Name:getSize().width
        print("width = "..pNameSize)

        --设置凝神
        if tonumber(Type)==GeneralType.General or tonumber(Type)==GeneralType.Main then
        	--print("显示凝神")
        	Label_Turn:setVisible(true)
        	StrokeLabel_setText(Label_Turn:getChildByTag(StrokeLabel_JinDan_Tag),GetDanYaoLvText(nGrid))  

        else
        	--print("隐藏凝神")
        	Label_Turn:setVisible(false)
        end

        Label_Level:setText("Lv." .. m_level)
		Label_Level:setColor(COLOR_White)

		local pLevelSize = Label_Level:getSize().width

		Label_Level:setPositionX(Label_Name:getPositionX() + pNameSize * 0.5 + 10)
		Label_Turn:setPositionX(Label_Level:getPositionX() + pLevelSize + 5)

		--更新武将
		--是武将叫更换武将 是护法叫更换护法 是主将就没有
		local Button_140 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_140"), "Button")
		local Image_143 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_143"), "ImageView")	
		local Button_139 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_139"), "Button")
		Image_143:setVisible(true)

		local Image_QH = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_QH"), "ImageView")
		
		local Btn_QH   = tolua.cast(Image_QH:getChildByName("Button_139"), "Button")
		Btn_QH:setTouchEnabled(true)

		if nGrid == 6 then 			
			StrokeLabel_setText(Button_140:getChildByTag(StrokeLabel_ChangeWuJiang_Tag),"更换护法") 
			StrokeLabel_setText(Button_139:getChildByTag(StrokeLabel_SeeYuanFen_Tag),"一键装备") 
			StrokeLabel_setText(Btn_QH:getChildByTag(StrokeLabel_QiangHua_Tag),"一键强化") 
			Image_Relation:setVisible(false)  						--如果是护法则隐藏缘分	
			Image_QH:setVisible(false) 		
		else
			StrokeLabel_setText(Button_140:getChildByTag(StrokeLabel_ChangeWuJiang_Tag),"更换武将") 
			StrokeLabel_setText(Button_139:getChildByTag(StrokeLabel_SeeYuanFen_Tag),"一键装备") 
			StrokeLabel_setText(Btn_QH:getChildByTag(StrokeLabel_QiangHua_Tag),"一键强化") 
			Image_Relation:setVisible(true) 
			if WujiangIsMainStay(nGrid) == true then
				Image_143:setVisible(false)			 
			end			
			Image_QH:setVisible(true) 	
		end
		
		--local Button_139 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_139"), "Button")		
		local Image_143_0 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_143_0"), "ImageView")
		Image_143_0:setVisible(true) 


        local attribute = GetGeneralattributeByTempId(nTempId)
        if attribute == "1" then 
            imgtype:loadTexture("Image/imgres/wujiang/attribute_1.png")
        else 
            imgtype:loadTexture("Image/imgres/wujiang/attribute_2.png")
        end

        local county_id = GetGeneralcountriesByTempId(nTempId)
		local type_id = GetGeneralTypeByTempId(nTempId)
        local str_county = nil 
		if  tonumber(type_id) == GeneralType.Main then
			str_county = string.format("Image/imgres/common/country/zhu.png")
		elseif  tonumber(type_id) == GeneralType.General then
			str_county = string.format("Image/imgres/common/country/country_%d.png",county_id)
		elseif  tonumber(type_id) == GeneralType.HuFa then
			str_county = string.format("Image/imgres/common/country/hu.png")
		end
        county:loadTexture(str_county)

    else
        -- 武将
        local Label_Name = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Name"), "Label")
        Label_Name:setText(" ")
        local Label_Level = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Level"), "Label")
        Label_Level:setText(" ")
        local Label_Turn = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Turn"), "Label")
        Label_Turn:setText(" ")
        local county = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Country"), "ImageView")
        county:setVisible(false)
        local imgtype = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Type"), "ImageView")
        imgtype:setVisible(false)
        local imgPinzhi = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Role_PinZhi"), "ImageView")
        imgPinzhi:setVisible(false)
        --imgPinzhi:loadTexture(string_quality)
        
		--更新武将		
		local Image_143 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_143"), "ImageView")	
		Image_143:setVisible(false)
		
		--更新缘分	
		Image_Relation:setVisible(false)			
		local Image_143_0 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_143_0"), "ImageView")				
		Image_143_0:setVisible(false)		
		Image_4:setVisible(false)		
		StrokeLabel_setText(Label_Turn:getChildByTag(StrokeLabel_JinDan_Tag)," ")   

		local Image_QH = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_QH"), "ImageView")
		Image_QH:setVisible(false) 

    end

end

--add by sxin 给装备界面去掉套装特效
local function DelEquipEffect(pEquipControl)		
	if pEquipControl:getChildByTag(10) ~= nil then
		pEquipControl:getChildByTag(10):setVisible(false)
		pEquipControl:getChildByTag(10):removeFromParentAndCleanup(true)		
	end
end

local function ChangeCurEquipInfo(nGrid)
	local tab = {}
    for i = 1, 6 do
        local nEquipGrid = GetEquipGrid(nGrid, i)
        local Button_Equip_add = nil
        local Image_Equip = nil
        local Image_Equip_Pinzhi = nil
        local Image_Equip_Bk = nil
		
		--print("ChangeCurEquipInfo nGrid =" .. nGrid)
			
		--add by sxin 根本不分护法和武将的layer了
		Button_Equip_add = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_Equip_add_0" .. i), "Button")
		Image_Equip = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Equip_0" .. i), "ImageView")
		Image_Equip_Pinzhi = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Equip_Pinzhi_0" .. i), "ImageView")
		Image_Equip_Bk = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_equip_type_0" .. i), "ImageView")
		Image_Equip_Bk:setVisible(true)          
		Image_Equip_Pinzhi:removeAllChildrenWithCleanup(true)
		Image_Equip_Pinzhi:loadTexture("Image/imgres/common/color/wj_pz1.png")
		if nGrid == 6 then 
			Image_Equip_Bk:loadTexture("Image/imgres/equip/treasure.png")
		else
			Image_Equip_Bk:loadTexture("Image/imgres/matrix/equip_type_0"..i..".png")
		end
		print("ChangeCurEquipInfo GetEquipGrid =" ..nEquipGrid)	
        if tonumber(nEquipGrid) == 0 then
            -- 开启可上装备
            local function OpenEquipList(sender, eventType)
                if eventType == TouchEventType.ended then
                    _Button_Equip_Click_CallBack(sender, eventType)
                end
            end
            Button_Equip_add:setVisible(true)
            Button_Equip_add:loadTextures("Image/imgres/common/add.png","Image/imgres/common/add.png","")
            Button_Equip_add:setTag(i)
            Button_Equip_add:addTouchEventListener(OpenEquipList)
            Image_Equip_Pinzhi:setTouchEnabled(true)
			--add celina
			Image_Equip_Pinzhi:setTag(i)
            Image_Equip_Pinzhi:addTouchEventListener(OpenEquipList)
			
			DelEquipEffect(Image_Equip)
			DelEquipEffect(Image_Equip_Pinzhi)
			
            Image_Equip:loadTexture("Image/imgres/matrix/equip_bk.png")
            Image_Equip:setScale(1)
            if nGrid ~= 6 then
                Image_Equip_Pinzhi:loadTexture("Image/imgres/common/color/wj_pz1.png")
            end
        elseif tonumber(nEquipGrid) == -1 then
                -- 未开启
                local function OpenTip(sender, eventType)
                    if eventType == TouchEventType.ended then
	                    if nGrid == 6 then
	                        Open_Tip_Equipt(sender:getTag())
	                    end
                    end
                end
                Button_Equip_add:addTouchEventListener(OpenTip)
                Button_Equip_add:setVisible(true)
                if nGrid == 6 then
                	Button_Equip_add:loadTextures("Image/imgres/matrix/big_lock.png","Image/imgres/matrix/big_lock.png","")
                else
                	Button_Equip_add:setVisible(false)
                end
				Button_Equip_add:setTag(i)
				--add by sxin 去掉套装特效
				DelEquipEffect(Image_Equip)
				DelEquipEffect(Image_Equip_Pinzhi)
				Image_Equip_Pinzhi:setTag(i)
           		Image_Equip_Pinzhi:addTouchEventListener(OpenTip)
				
                Image_Equip:loadTexture("Image/imgres/matrix/equip_bk.png")
                Image_Equip:setScale(1)
                if nGrid ~= 6 then
                    Image_Equip_Pinzhi:loadTexture("Image/imgres/common/color/wj_pz1.png")
                end
        else
            -- 有装备显示
            local nTempId = 0 
            nTempId = GetTempIdByGrid(nEquipGrid)
            local function OpenEquipInfo(sender, eventType)
                if eventType == TouchEventType.ended then
                    local i_button_tou = tolua.cast(sender,"Button")
                    --print("装备信息")                      
                    MainScene_ShowLeftInfo(false)
                    MainScene_ClearRootBtn()
					if EquipPropertyLayer.getEquipLayerControl()~=nil then
						MainScene_DeleteUILayer(EquipPropertyLayer.getEquipLayerControl())
					end
                    local nEquipGrid1 = i_button_tou:getTag()	
					--print(nEquipGrid1)
					local num = sender:getTag()
                    local new_layer = CreateEquipProperty(sender:getTag(), E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG,nil,nil,tab[num])						
                    local scenetemp =  CCDirector:sharedDirector():getRunningScene()
                    scenetemp:addChild(new_layer,layerMatrix_Tag+layerEquipProperty_Tag,layerEquipProperty_Tag)
                    MainScene_PushUILayer(new_layer)
                end
            end
            Button_Equip_add:setTouchEnabled(true)
            Button_Equip_add:setVisible(false)
			print(nEquipGrid)
			tab[nEquipGrid] = i
            Button_Equip_add:setTag(nEquipGrid)
            Button_Equip_add:addTouchEventListener(OpenEquipInfo)


            print("nTempId:=" ..nTempId)
            local i_equip_pinzhi = GetEquipColorByTempId(nTempId)
            local i_suit = GetEquipSuitIDByTempId(nTempId)
            local img_res = nil
            if tonumber(i_suit) == 0 then
                img_res = string.format("Image/imgres/common/pinzhi_icon/icon_pingzhi_%d.png",i_equip_pinzhi)
            else
                img_res = string.format("Image/imgres/common/pinzhi_icon/icon_pingzhi_suit_%d.png",i_equip_pinzhi)
            end

            local i_equip_res = GetEquipAnimationIDIDByTempId(nTempId)

            local pControl = nil

            if nGrid == 6 then
                pControl = UIInterface_MakeHeadIcon(Image_Equip_Pinzhi, ICONTYPE.EQUIP_ICON, nTempId, nEquipGrid)
            else
                pControl = UIInterface_MakeHeadIcon(Image_Equip_Pinzhi, ICONTYPE.EQUIP_ICON, nTempId, nEquipGrid)
            end
            
            pControl:setTag(nEquipGrid)
            pControl:addTouchEventListener(OpenEquipInfo)               

            if Image_Equip_Bk ~= nil then
                Image_Equip_Bk:setVisible(false)
            end

            if nGrid ~= 6 then
                --Image_Equip_Pinzhi:loadTexture(img_res)
            end
        end
    end
   -- end
end

--一键装备响应
local function _Button_SeeInfo_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then 
		sender:setScale(1.0)
		if sender:getTag() <= 0  then 
			return
		end	
		--获取阵容格子
		local nGrid = server_matrixDB.GetMatrixDBByWJ(sender:getTag())
		--获取装备数据
		local Grid = nil
		local nEquipGrid = nil
		local equipData = {}
		--护法有装备限制
		local nCurLBNums = 0
		if nGrid == 6 then
			local tableGeneralTemp = GetGeneralTableByGrid(sender:getTag())
	   		if tableGeneralTemp ~= nil then		 	
		        m_level = tableGeneralTemp["Info02"]["Lv"]
				--判断当前护法可以装备几个装备
				nCurLBNums = GetHufaCurrentLingBaoNums(m_level)
				equipData = GetOneKeyEquipData(sender:getTag(),nCurLBNums)
				print("current hufa can be "..nCurLBNums.." equips")
	   		end
	   	else
	   		equipData = GetOneKeyEquipData(sender:getTag(),6)
	   	end	
	   	local hufaExample = 1
	
		for key,value in pairs(equipData) do
			Grid = value.Grid
			nEquipGrid = value.TempID
			local Name = equipt.getFieldByIdAndIndex(nEquipGrid,"Name")
			local Example = equipt.getFieldByIdAndIndex(nEquipGrid,"Example")
			local nTempId = GetTempIdByGrid(Grid)
			if nGrid == 6 then Example = hufaExample end
            if CheckBEquip(Grid,Example) == true then
            	--pControl = UIInterface_MakeHeadIcon(Image_Equip_Pinzhi, ICONTYPE.EQUIP_ICON, nTempId, Grid)
            else
            	Log(Example.."件装备穿不上")
            end
            if hufaExample <= nCurLBNums then
            	hufaExample = hufaExample + 1
        	end
		end
		UpDateMatrixBack()
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

function getCurPos()
    local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
	
	local iCurIndex = PageView_Hero:getCurPageIndex()
    if iCurIndex == 0 then
        return 6
    else
        return 6 - iCurIndex
    end
end

local function PlayAttack()
    local pageView = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
    local layout = pageView:getPage(pageView:getCurPageIndex())

    local nWjGrid = GetGeneralGrid(6 - pageView:getCurPageIndex())
    print("nWjGrid = " .. nWjGrid)
    local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
    local nTempId = 0

    if tableGeneralTemp ~= nil then
        nTempId = tableGeneralTemp["ItemID"]
        
        local ResID = GetGeneralResIDByTempId(nTempId, "ResID")
        if layout ~= nil then
            local PayArmature = layout:getNodeByTag(10)
            if PayArmature ~= nil then

                PayArmature:getAnimation():play(GetAniName_Res_ID(ResID, Ani_Def_Key.Ani_attack))

                local function onMovementEvent(armatureBack,movementType,movementID)
                    if movementType == 1 then
                        PayArmature:getAnimation():play(GetAniName_Res_ID(ResID, Ani_Def_Key.Ani_stand))
                    end
                end
                PayArmature:getAnimation():setMovementEventCallFunc(onMovementEvent)
            end
        end
    end

end

function updataCurView()
    print("更新界面")
    local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
    PageView_Hero:removeAllPages()

    local nWjGrid = GetGeneralGrid(6)
    local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
    local nTempId = 0

    if tableGeneralTemp ~= nil then
       
        nTempId = tableGeneralTemp["ItemID"]

    else
        print("tableGeneralTemp = nil")
    end
    AddAnimation(6, nTempId, nWjGrid)
    AddHead(6, nTempId, nWjGrid)

    for i=1, 5 do
        local nWjGrid = GetGeneralGrid(i)
        local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
        local nTempId = 0

        if tableGeneralTemp ~= nil then
            
            nTempId = tableGeneralTemp["ItemID"]

        else
            print("tableGeneralTemp = nil")
        end
       
       AddHead(i, nTempId, nWjGrid)
    end

    for i=5, 1, -1 do
        local nWjGrid = GetGeneralGrid(i)
        if nWjGrid > 0 then
        --print("nWjGrid = "..nWjGrid)
        --print("nGrid = "..6-i)
		--print("Name = "..GeneralBaseData.GetGeneralName(nWjGrid)) 
		end     
        local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
        local nTempId = 0
        if tableGeneralTemp ~= nil then
            
            nTempId = tableGeneralTemp["ItemID"]


        else
            print("tableGeneralTemp = nil")
        end
        AddAnimation(i, nTempId, nWjGrid)
	end
	
    if PageView_Hero:getCurPageIndex() == 0 then
        ChangeCurInfo(6)
        ChangeCurEquipInfo(6)
    else
        ChangeCurInfo(6 - PageView_Hero:getCurPageIndex())
        ChangeCurEquipInfo(6 - PageView_Hero:getCurPageIndex())
        PlayAttack()
    end
	
    if MatrixWujiangListLayer.GetUIControl() ~= nil then
    	 local Image_Head_Select = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Head_Select"), "ImageView")
		 local x, y, nGrid = MatrixWujiangListLayer.GetSelectPosition()
		 Image_Head_Select:setPosition(ccp(x, y))
		 
		 
	    --local function scrollCallfunc( )    	
	        if nGrid == 6 then
	          -- PageView_Hero:scrollToPage(0)
	           PageView_Hero:SetCurPageIndex(0)
	        else
	         -- PageView_Hero:scrollToPage(6 - nGrid)
	          PageView_Hero:SetCurPageIndex(6 - nGrid)
	           print("nGrid after = "..6 - nGrid)
	        end	
	    --end

	    --local actionArray1 = CCArray:create()
	    --actionArray1:addObject(CCDelayTime:create(0.5))
		--actionArray1:addObject(CCCallFunc:create(scrollCallfunc))
		--PageView_Hero:runAction(CCSequence:create(actionArray1))
	end
end

local function InitVars()
	m_playerMatrixLayer = nil
	m_level 			= nil
end
function GetUIControl()
    return m_playerMatrixLayer
end

local function Notify()
	--[[
	local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
    local nIndex = nil
    if PageView_Hero:getCurPageIndex() == 0 then
        nIndex = 6
    else
        nIndex = 6 - PageView_Hero:getCurPageIndex()
    end
	local function RefreshData( ... )
		local nWjGrid = GetGeneralGrid(nIndex)
		local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
		local newLevel = nil
		if tableGeneralTemp ~= nil then		 	
			newLevel = tableGeneralTemp["Info02"]["Lv"]
		end
		if newLevel > m_level then
			updataCurView()
		end
	end
	--]]
	local function RefreshData( ... )
		if m_isUpdate == false then
			updataCurView()
		end
		m_isUpdate = false
	end	
	Packet_GetMatrix.SetSuccessCallBack(RefreshData)
	network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
end

function GetEquipControl( nEquipIndex )
	local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
	local pGrid = 6 - PageView_Hero:getCurPageIndex()

    local nEquipGrid = GetEquipGrid(pGrid, nEquipIndex)

	Image_Equip_Pinzhi = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Equip_Pinzhi_0" .. nEquipIndex), "ImageView")

	if Image_Equip_Pinzhi:getChildByTag( nEquipGrid ) ~= nil then

		return Image_Equip_Pinzhi:getChildByTag( nEquipGrid ) 

	end

	return nil

end

function GetMatrixByNewGuilde( nType, nIndex, nCallBack, nPos )

	if m_playerMatrixLayer == nil then 
		print("阵容界面不存在")
		return 
	end

	if tonumber(nType) == 0 then
		--打开武将界面
		OpenMatrixWujiangList( nIndex, nCallBack )
	elseif tonumber(nType) == 1 then
		--退出武将属性界面
	elseif tonumber(nType) == 2 then
		--退出阵容界面
    	GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_MATRIX)
        m_playerMatrixLayer:setVisible(false)
        m_playerMatrixLayer:removeFromParentAndCleanup(true)
        m_playerMatrixLayer = nil
        MainScene_PopUILayer()
		if nCallBack ~= nil then
			nCallBack()
		end
	elseif tonumber(nType) == 3 then
		--选择武将并返回
		MatrixWujiangListLayer.GetMatrixListByNewGuilde( nIndex )
		if nCallBack ~= nil then
			nCallBack()
		end
	elseif tonumber(nType) == 4 then
		--选择武将阵容滚动
        local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")
        if nIndex == 6 then
            PageView_Hero:scrollToPage(0)
        else
            PageView_Hero:scrollToPage(6 - nIndex)
        end
        if nCallBack ~= nil then
        	nCallBack()
        end
	elseif tonumber(nType) == 5 then
		--点击进入武将属性界面
		local nWjGrid = GetGeneralGrid( nIndex )
		local nTempId = GetGeneralTempIdByGrid( nWjGrid )
		local nColor  = GetGeneralColourByTempId( nTempId )
		if tonumber( nColor ) ~= 4 then
			nIndex = 3
		end
		ShowWJOperateLayer( nIndex )
		if nCallBack ~= nil then
			nCallBack()
		end
	elseif tonumber(nType) == 6 then
		--武将升级
	elseif tonumber(nType) == 7 then
		--打开装备列表界面
		local pObj = OpenMatrixEquipList( nIndex )
		if nCallBack ~= nil and pObj ~= nil then
			nCallBack( pObj )
		end		
	elseif tonumber(nType) == 8 then
		--穿上装备
	elseif tonumber(nType) == 9 then
		--进入装备界面	
        --print("装备信息")                      
        MainScene_ShowLeftInfo(false)
        MainScene_ClearRootBtn()
		if EquipPropertyLayer.getEquipLayerControl()~=nil then
			MainScene_DeleteUILayer(EquipPropertyLayer.getEquipLayerControl())
		end

        local new_layer = CreateEquipProperty(nIndex, E_LAYER_TYPE.E_LAYER_TYPE_ZHENRONG,nil,nil, nPos)						
        local scenetemp =  CCDirector:sharedDirector():getRunningScene()
        scenetemp:addChild(new_layer,layerMatrix_Tag+layerEquipProperty_Tag,layerEquipProperty_Tag)
        MainScene_PushUILayer(new_layer)
		if nCallBack ~= nil then
			nCallBack( )
		end	
	elseif tonumber(nType) == 10 then
		--获取阵容数据
		return MatrixWujiangListLayer.GetTab()	
	end

	nType = nil
	nIndex = nil
	nCallBack = nil
	nPos = nil

end

function createMatrixUI( nMoveIndex )
	InitVars()

	if nMoveIndex ~= nil then

		for i=5, 1, -1 do

			local nWjGrid = GetGeneralGrid( i )
			if nWjGrid > 0 then
				local nTempId = GetGeneralTempIdByGrid( nWjGrid )
				local nColor  = GetGeneralColourByTempId( nTempId )

				if tonumber(nColor) == 4 and i ~= 1 then
					nMoveIndex = 6 - i 
				end

			end

		end

	end

	--初始化阵容的更新通知
	GetObserver():RegisterObserver(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_MATRIX,Notify)

	m_playerMatrixLayer = TouchGroup:create()									-- 背景层
    m_playerMatrixLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/MatrixLayer.json") )	
	
    --将主界面按钮重新加载一次 这样主界面的不就不能用了吗脚本控件丢失啊!!!!!!
    require "Script/Main/MainBtnLayer"	
    local temp = MainBtnLayer.createMainBtnLayer()
    m_playerMatrixLayer:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)

    local PageView_Hero = tolua.cast(m_playerMatrixLayer:getWidgetByName("PageView_Hero"), "PageView")

    local function _Button_retrun_CallBack(sender, eventType)
        if eventType == TouchEventType.ended then
        	GetObserver():DeleteObserverByKey(OBSERVER_REGISTER_TYPE.OBSERVER_REGISTER_MATRIX)
            m_playerMatrixLayer:setVisible(false)
            m_playerMatrixLayer:removeFromParentAndCleanup(true)
            m_playerMatrixLayer = nil
            MainScene_PopUILayer()
            sender:setScale(1)
        elseif  eventType == TouchEventType.began then
            sender:setScale(0.9)
        elseif eventType == TouchEventType.canceled then
            sender:setScale(1.0)
        end
    end
	
    local Button_retrun = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_retrun"), "Button")
    Button_retrun:addTouchEventListener(_Button_retrun_CallBack)

    local function _Button_Change_CallBack(sender, eventType)
        if eventType == TouchEventType.ended then
            sender:setScale(1)
            local nIndex = nil
            if PageView_Hero:getCurPageIndex() == 0 then
                nIndex = 6
            else
                nIndex = 6 - PageView_Hero:getCurPageIndex()
            end
            sender:setTag(nIndex)
            _Button_WuJiang_Click_CallBack(sender, eventType)
			
        elseif  eventType == TouchEventType.began then
            sender:setScale(0.9)
        elseif eventType == TouchEventType.canceled then
            sender:setScale(1.0)
        end
    end
	
	--金丹显示
	local Label_Turn = tolua.cast(m_playerMatrixLayer:getWidgetByName("Label_Turn"), "Label")
	Label_Turn:setText("")
    Label_Turn:setVisible(true)
	local plbDanYaoLv =  StrokeLabel_createStrokeLabel(20, CommonData.g_FONT1, "凝神成丹", ccp(0, 0), ccc3(57, 25, 15), ccc3(250, 255, 118), false, ccp(0, -2), 2)
	if plbDanYaoLv~=nil then
		Label_Turn:addChild(plbDanYaoLv,0,StrokeLabel_JinDan_Tag)
	end		
	
    local Button_140 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_140"), "Button")
    Button_140:addTouchEventListener(_Button_Change_CallBack)
	
	--是武将叫更换武将 是护法叫更换护法 是主将就没有
    pText = StrokeLabel_createStrokeLabel(22, CommonData.g_FONT1, "更换武将", ccp(0, -30), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
    Button_140:addChild(pText, 1, StrokeLabel_ChangeWuJiang_Tag)

    	
    local Button_139 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_139"), "Button")
    Button_139:addTouchEventListener(_Button_SeeInfo_CallBack)	

    --一键强化
	local Image_QH = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_QH"), "ImageView")
	local Btn_QH   = tolua.cast(Image_QH:getChildByName("Button_139"), "Button")
	Btn_QH:addTouchEventListener( _Button_QiangHua_CallBack )

	pQHText = StrokeLabel_createStrokeLabel(22, CommonData.g_FONT1, "一键强化", ccp(0, -30), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
	Btn_QH:addChild(pQHText, 1, StrokeLabel_QiangHua_Tag)
	
	--护法不能查看缘分
    pText = StrokeLabel_createStrokeLabel(22, CommonData.g_FONT1, "查看武将", ccp(0, -30), COLOR_Black, COLOR_White, true, ccp(0, -2), 2)
    Button_139:addChild(pText, 1, StrokeLabel_SeeYuanFen_Tag)


    local Image_Head_Select = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Head_Select"), "ImageView")

    local function pageViewEvent(sender, eventType)
        if eventType == PageViewEventType.turning then
		
            local pageView = tolua.cast(sender, "PageView")
            local pageInfo = string.format("page %d " , pageView:getCurPageIndex())
           -- print(pageInfo)
            local nIndex = pageView:getCurPageIndex()
            if nIndex == 0 then 
				nIndex = 6
			else
				nIndex = 6 - nIndex
			end

            local Image_Head = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_Head_0" .. nIndex), "ImageView")
		
			local WorldPosition = ccp(Image_Head:getPositionX(), Image_Head:getPositionY())
            Image_Head_Select:setPosition(ccp(WorldPosition.x  , WorldPosition.y ))

            local nWjGrid = nil
            if pageView:getCurPageIndex() == 0 then
                ChangeCurInfo(6)
                ChangeCurEquipInfo(6)
                nWjGrid = GetGeneralGrid(6)
                local id = server_generalDB.GetTempIdByGrid(nWjGrid)
                local Image_QH = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_QH"), "ImageView")
                Image_QH:setVisible( false )
                local Btn_QH   = tolua.cast(Image_QH:getChildByName("Button_139"), "Button")
                Btn_QH:setTouchEnabled( false )
            else
                ChangeCurInfo(6 - pageView:getCurPageIndex())
                ChangeCurEquipInfo(6 - pageView:getCurPageIndex())
                nWjGrid = GetGeneralGrid(6 - pageView:getCurPageIndex())
                PlayAttack()
            end

            local Button_139 = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_139"), "Button")
            Button_139:setTag(nWjGrid)

        end
    end 

    PageView_Hero:setClippingType(1)
    PageView_Hero:removeAllPages()
    PageView_Hero:addEventListenerPageView(pageViewEvent)   

    local nWjGrid = GetGeneralGrid(6)
    local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
    local nTempId = 0

    if tableGeneralTemp ~= nil then
        --nTempId = tableGeneralTemp["Info02"]["TempID"]
        nTempId = tableGeneralTemp["ItemID"]
    else
        print("tableGeneralTemp = nil")
    end
    AddAnimation(6, nTempId, nWjGrid)
    AddHead(6, nTempId, nWjGrid)
    for i=1, 5 do
        local nWjGrid = GetGeneralGrid(i)
        local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
        local nTempId = 0

        if tableGeneralTemp ~= nil then
            --nTempId = tableGeneralTemp["Info02"]["TempID"]
            nTempId = tableGeneralTemp["ItemID"]
        else
            print("tableGeneralTemp = nil")
        end
        
       AddHead(i, nTempId, nWjGrid)
    end

    for i=5, 1, -1 do
        local nWjGrid = GetGeneralGrid(i)
        local tableGeneralTemp = GetGeneralTableByGrid(nWjGrid)
        local nTempId = 0
        if tableGeneralTemp ~= nil then            
            nTempId = tableGeneralTemp["ItemID"]
        else
            print("tableGeneralTemp = nil")
        end
        AddAnimation(i, nTempId, nWjGrid)
	end    

	local pMoveIndex = 5 

	if nMoveIndex ~= nil then

		pMoveIndex = nMoveIndex

	end

    local function MoveToEnd()
         --PageView_Hero:scrollToPage(5)
         PageView_Hero:SetCurPageIndex(pMoveIndex)
    end
    local array_action = CCArray:create()
    array_action:addObject(CCCallFunc:create(MoveToEnd))
    local actions = CCSequence:create(array_action)
    m_playerMatrixLayer:runAction(actions)



    local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
    local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height

    m_playerMatrixLayer:setPosition(ccp(nOff_W/2, nOff_H/2))	

    local tableFixControl = {
    {
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(m_playerMatrixLayer:getWidgetByName("Image_2"), "ImageView"),			
    },
	{
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(m_playerMatrixLayer:getWidgetByName("Panel_131"), "Layout"),			
    },
    {
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(m_playerMatrixLayer:getWidgetByName("Button_retrun"), "Button"),
    },
    {
        ["off_x"] = 0,
        ["off_y"] = 0,
        ["control"] = tolua.cast(m_playerMatrixLayer:getChildByTag(layerMainBtn_Tag), "TouchGroup"),
    },
}
    for key,value in pairs(tableFixControl) do
        if value["control"] ~= nil then
            local nWidth = value["control"]:getPositionX() - CommonData.g_Origin.x + value["off_x"]
            local nHeight = value["control"]:getPositionY() + CommonData.g_Origin.y + value["off_y"]
            value["control"]:setPosition(ccp(nWidth, nHeight))
        end
    end


	
    return m_playerMatrixLayer
end


