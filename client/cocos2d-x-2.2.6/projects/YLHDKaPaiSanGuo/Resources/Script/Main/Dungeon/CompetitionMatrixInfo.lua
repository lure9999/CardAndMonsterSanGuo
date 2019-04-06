
module("CompetitionMatrixInfo", package.seeall)

--变量

local m_MatrixInfoLayer = nil 
--数据
local GetSelfData = CompetitionData.GetSelfData
local GetPlayerDataByIndex = CompetitionData.GetPlayerDataByIndex
--武将类型 
local GetGeneralType      = GeneralBaseData.GetGeneralType


local function InitVars()
	m_MatrixInfoLayer = nil

end

local function InitUI(bSelf,nIndex)
	local playerData = nil 
	if bSelf == true then
		playerData = GetSelfData()
	else
		playerData = GetPlayerDataByIndex(nIndex)
	end
	--名字
	local img_bg_rank = tolua.cast(m_MatrixInfoLayer:getWidgetByName("img_character_info_bg"),"ImageView")
	local lable_PlayerName = LabelLayer.createStrokeLabel(26,CommonData.g_FONT1,playerData.pName,ccp(0,4),COLOR_Black,ccc3(255,192,55),true,ccp(0,-3),3)
	lable_PlayerName:setPosition(ccp(-160,77))
	AddLabelImg(lable_PlayerName,1000,img_bg_rank)
	local lable_level = tolua.cast(m_MatrixInfoLayer:getWidgetByName("Label_rank"),"Label")
	lable_level:setText(playerData.pLevel)
	local lable_fight = tolua.cast(m_MatrixInfoLayer:getWidgetByName("Label_num_zdl"),"Label")
	lable_fight:setText(playerData.pFight)
	--当前排名
	if tonumber(playerData.pRank)>10000 then
		local img_Rank = ImageView:create()
		img_Rank:loadTexture("Image/imgres/compete_bw/jhwr.png")
		img_Rank:setPosition(ccp(180,23))
		AddLabelImg(img_Rank,1000,img_bg_rank)
	else
		local labelRank_player = LabelBMFont:create()
		labelRank_player:setFntFile("Image/imgres/common/num/num_rank.fnt")
		labelRank_player:setText(playerData.pRank)
		labelRank_player:setPosition(ccp(170,23))
		AddLabelImg(labelRank_player,1001,img_bg_rank)
	end
	--阵容
	local count = 0
	local tableInfo = playerData.Info01
	local num = 0
	if bSelf== true then
		for key,value in pairs(tableInfo) do 
			if tonumber(value[1])~=0 then
				local img_wj = ImageView:create()
				
				local pControl = UIInterface.MakeHeadIcon(img_wj, ICONTYPE.GENERAL_COLOR_ICON, value[1], nil,nil,nil,nil)
				img_wj:setPosition(ccp(-240+count*95,-60))
				img_wj:setScale(0.68)
				AddLabelImg(img_wj,2000+count,img_bg_rank)
				--添加护法标识
				if tonumber(GetGeneralType(value[1])) == 5 then
					local _Img_hufa = ImageView:create()
					_Img_hufa:loadTexture("Image/imgres/matrix/hufaside.png")
					_Img_hufa:setPosition(ccp(-242+count*95,-75))
					AddLabelImg(_Img_hufa,3000+count,img_bg_rank)
				end
				count = count +1
			end
		end
	else
		for key,value in pairs(tableInfo) do 
			num = num+1
		end
		for i=1,num do 
			if tonumber(tableInfo["wID"..i][1])~=0 then
				local img_wj = ImageView:create()
				
				local pControl = UIInterface.MakeHeadIcon(img_wj, ICONTYPE.GENERAL_COLOR_ICON, tableInfo["wID"..i][1], nil,nil,nil,nil)
				img_wj:setPosition(ccp(-240+count*95,-60))
				img_wj:setScale(0.68)
				AddLabelImg(img_wj,2000+count,img_bg_rank)
				--添加护法标识
				if tonumber(GetGeneralType(tableInfo["wID"..i][1])) == 5 then
					local _Img_hufa = ImageView:create()
					_Img_hufa:loadTexture("Image/imgres/matrix/hufaside.png")
					_Img_hufa:setPosition(ccp(-242+count*95,-75))
					AddLabelImg(_Img_hufa,3000+count,img_bg_rank)
				end
				count = count +1
			end
		end
	end
end

local function _Btn_Colse_CallBack()
	m_MatrixInfoLayer:removeFromParentAndCleanup(true)
end

function ShowMatrixInfo(bPlayerSelf,nIndex)
	InitVars()
	
	m_MatrixInfoLayer =  TouchGroup:create()
	m_MatrixInfoLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/CompeteLayer_Character.json" ) )
	InitUI(bPlayerSelf,nIndex)
	--关闭按钮
	local btn_close = tolua.cast(m_MatrixInfoLayer:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(btn_close,nil,nil,_Btn_Colse_CallBack,nil,nil,nil,nil)
	return m_MatrixInfoLayer
end
