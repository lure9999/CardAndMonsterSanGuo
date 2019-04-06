--玩家叛离国家界面 celina


module("UserDesertCountry", package.seeall)


--变量
local m_pDesertCountryLayer = nil 
local m_cur_tag_flag = nil 
local m_mid_tag_flag = nil --值永远为中间的国家
local img_bg = nil 
local table_flag = nil 
local img_tuijian = nil 
local tabFight = nil --三个国家的战斗力
local m_cur_country = nil --现在选中的国家
local tabCountry = nil --记录现在三个国家

--逻辑
local Action_MidSide = UserSettingLogic.Action_MidSide 
local Action_SideToSide = UserSettingLogic.Action_SideToSide
local ActionBG = UserSettingLogic.ActionBG
local GetFlagInfo = UserSettingLogic.GetFlagInfo
local DealDesertCountry = UserSettingLogic.DealDesertCountry
local GetCountryByImg = UserSettingLogic.GetCountryByImg
local GetFightCountry = UserSettingLogic.GetFightCountry
local DealCountryTag  = UserSettingLogic.DealCountryTag

--数据
local GetExpendData = UserSettingData.GetExpendData
local GetTJCountry  = UserSettingData.GetTJCountry
local GetPriceRatio = UserSettingData.GetPriceRatio
local GetCountryLv = UserSettingData.GetCountryLv


local function InitVars()
	m_pDesertCountryLayer = nil 
	m_cur_tag_flag = nil --记录现在选中的旗子
	m_mid_tag_flag = nil
	table_flag = nil --存放旗子的对象
	img_tuijian = nil 
	tabFight = nil
	m_cur_country = nil
	tabCountry = nil
end
local function InitCountryInfo()
	local panel_country = tolua.cast(m_pDesertCountryLayer:getWidgetByName("Panel_dCountry"),"Layout")
	for i=1,3 do 
		--国家等级
		local img = tolua.cast(table_flag[i].img,"ImageView")
		local tag = img:getTag()-TAG_GRID_ADD
		local label_country_lv = tolua.cast(m_pDesertCountryLayer:getWidgetByName("Label_"..tag.."1"),"Label")
		label_country_lv:setText(GetCountryLv(tabCountry[i]))
		if table_flag[i].country  == GetTJCountry() then
			img_tuijian = ImageView:create()
			img_tuijian:loadTexture("Image/imgres/corps/recommend.png")
			img_tuijian:setPosition(ccp(label_country_lv:getPositionX()-150,label_country_lv:getPositionY()))
			AddLabelImg(img_tuijian,999,panel_country)
		end
		--总战力
		local label_country_zl = tolua.cast(m_pDesertCountryLayer:getWidgetByName("Label_"..i.."2"),"Label")
		local pZl = LabelBMFont:create()
		pZl:setFntFile("Image/imgres/main/fight.fnt")
		pZl:setPosition(ccp(label_country_zl:getPositionX()+40,label_country_zl:getPositionY()-22))
		pZl:setAnchorPoint(ccp(0,0.5))
		pZl:setText(GetFightCountry(tabCountry[i],tabFight))
		if panel_country:getChildByTag(10000+i)~=nil then
			panel_country:getChildByTag(10000+i):removeFromParentAndCleanup(true)
		end
		panel_country:addChild(pZl,0,10000+i)
	end
end
local function OtherFlagMove(selectTag)
	local img_mide_side = nil
	local img_side_side = nil
	local bShu = false
	local function MidActionEnd()
		img_mide_side:setTouchEnabled(true)
		if selectTag>102 then
			img_mide_side:setTag(TAG_GRID_ADD+1)
		else
			img_mide_side:setTag(TAG_GRID_ADD+3)
		end
			--print("3======")
		InitCountryInfo()
	end
	local function SideToSide()
		img_side_side:setTouchEnabled(true)
		if selectTag>102 then
			img_side_side:setTag(TAG_GRID_ADD+3)
		else
			img_side_side:setTag(TAG_GRID_ADD+1)
		end
		--print("2======")
	end
	if selectTag == 103 then
		--说明顺时针旋转
		bShu = true 
	end
	tabCountry = DealCountryTag(bShu,tabCountry)
	for i=1,3 do
		local img_i = tolua.cast(table_flag[i].img,"ImageView")
		local iTag = img_i:getTag()
		if iTag>selectTag  and iTag~= m_mid_tag_flag then
			--说明是右边的
			img_side_side = img_i
			
			img_i:runAction(Action_SideToSide(SideToSide,ccp(254,409)))
			img_i:setTouchEnabled(false)
		end
		if iTag<selectTag  and iTag~= m_mid_tag_flag then
			--说明是左边的
			img_side_side = img_i
			img_i:runAction(Action_SideToSide(SideToSide,ccp(877,408)))
			img_i:setTouchEnabled(false)
		end
		if iTag== m_mid_tag_flag then
			img_mide_side = img_i
			img_i:setZOrder(2)
			if selectTag>m_mid_tag_flag then
				img_i:runAction(Action_MidSide(MidActionEnd,ccp(254,409),150,0.72))
				img_i:setTouchEnabled(false)
			else
				img_i:runAction(Action_MidSide(MidActionEnd,ccp(877,408),150,0.72))
				img_i:setTouchEnabled(false)
			end
		end
	end
end
--叛离国家的消耗
local function ShowExpendDesertCountry( mTagCountry )
	--消耗的Icon
	local tabExpendData = GetExpendData(mTagCountry,1)
	local img_expend_icon = tolua.cast(m_pDesertCountryLayer:getWidgetByName("img_consume"),"ImageView")
	img_expend_icon:loadTexture(tabExpendData[1].IconPath)
	
	
	local label_red = tolua.cast(m_pDesertCountryLayer:getWidgetByName("Label_red"),"Label")--折扣前的价格
	local label_price = tolua.cast(m_pDesertCountryLayer:getWidgetByName("Label_green"),"Label")
	if  mTagCountry  ~= GetTJCountry() then
		--如果不是推荐的就没有折扣
		label_red:setVisible(false)
		label_price:setText(tabExpendData[1].ItemNeedNum)
	else
		label_red:setVisible(true)
		label_red:setText(tabExpendData[1].ItemNeedNum)
		local line = AddLine(ccp(-label_red:getContentSize().width/2,-2),ccp(label_red:getContentSize().width/2,-2),ccc3(179,31,2),2,255)
		label_red:addNode(line)
		label_price:setText(tonumber(tabExpendData[1].ItemNeedNum)*GetPriceRatio())
	end
	
	
end


local function _Img_Flag_CallBack(sender, eventType)
	local curTag = sender:getTag()
	if eventType == TouchEventType.ended then
		if curTag~= m_mid_tag_flag then
			--选中的要移到中间
			local img_select = tolua.cast(sender,"ImageView")
			img_select:setZOrder(3)
			--SetOtherZorder(curTag)
			local function ActionEnd()
				--动作完毕后，tag重新设置一遍
				img_select:setTouchEnabled(true)
				img_select:setTag(TAG_GRID_ADD+2)
				table_flag[curTag-TAG_GRID_ADD].img:setTag(TAG_GRID_ADD+2)
				--print(curTag-TAG_GRID_ADD)
				--print("1======")
			end
			img_bg:runAction(ActionBG())
			img_select:setTouchEnabled(false)
			img_select:runAction(Action_MidSide(ActionEnd,ccp(566,402),255,0.9))
			OtherFlagMove(curTag)
			ShowExpendDesertCountry(GetCountryByImg(img_select,table_flag))
		end
	end
end
--旗的按键和动作处理
local function DealFlag()
	table_flag = {}
	m_cur_tag_flag = GetTJCountry()
	tabCountry = {}
	for i=1,3 do 
		local img_flag = tolua.cast(m_pDesertCountryLayer:getWidgetByName("img_"..i),"ImageView")
		img_flag:setTouchEnabled(true)
		img_flag:setTag(TAG_GRID_ADD+i)
		img_flag:loadTexture(GetFlagInfo()[i].imgPath)
		if i==2 then
			m_mid_tag_flag = TAG_GRID_ADD+i
			
			img_flag:setZOrder(1)
			
		end
		img_flag:addTouchEventListener(_Img_Flag_CallBack)
		local tab = {}
		tab.img = img_flag
		tab.country = GetFlagInfo()[i].nCountry
		table.insert(table_flag,tab)
		
		table.insert(tabCountry,GetFlagInfo()[i].nCountry)
	end
	
end
local function _Btn_DesetCountry_CallBack()
	DealDesertCountry(tabCountry[2],m_pDesertCountryLayer)
end


local function InitUI()
	img_bg = tolua.cast(m_pDesertCountryLayer:getWidgetByName("img_bg"),"ImageView")
	DealFlag()
	InitCountryInfo()
	--确定叛国的按钮
	local _btn_desert_country = tolua.cast(m_pDesertCountryLayer:getWidgetByName("btn_dCountry"),"Button")
	CreateBtnCallBack( _btn_desert_country,"确定叛国",36,_Btn_DesetCountry_CallBack )
	--叛国的消耗
	ShowExpendDesertCountry(m_cur_tag_flag)
end

local function _Btn_Back_Setting()
	m_pDesertCountryLayer:removeFromParentAndCleanup(true)
end
function CreateUserDesertCountry(tabCountryFight)
	InitVars()
	m_pDesertCountryLayer = TouchGroup:create()
	m_pDesertCountryLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/UserDesertCountry.json" ) )
	tabFight = tabCountryFight
	InitUI()
	--返回
	local _btn_back = tolua.cast(m_pDesertCountryLayer:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack( _btn_back,nil,nil,_Btn_Back_Setting )
	return m_pDesertCountryLayer
end