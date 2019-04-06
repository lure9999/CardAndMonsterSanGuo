--分身界面 celina

module("AtkCityAvatarLayer", package.seeall)




--变量 
local m_avatar_layer = nil 
local tabAvatarWJ = nil 
local n_cur_type = 0
local img_select = nil 
local Label_num = nil --消耗数量
local nCityID = nil
local tabExpend = nil --消耗数据

--数据
local GetConsumeFenShenID = AtkCityData.GetConsumeFenShenID
local GetWJNameByID  = AtkCityData.GetWJNameByID
--逻辑
local ToServerAvatar = AtkCitySceneLogic.ToServerAvatar
local CheckBEnoughExpend = AtkCitySceneLogic.CheckBEnoughExpend
local GetEnoughMaxNum = AtkCitySceneLogic.GetEnoughMaxNum

local function InitVars()
	m_avatar_layer = nil 
	tabAvatarWJ = nil
	n_cur_type = 0
	img_select = nil 
	Label_num = nil
	nCityID = nil
	tabExpend = nil
end
local function AvatarWJ_CallBack(tag,sender)
	if tag~=n_cur_type then
		n_cur_type = tag
		img_select:setPosition(ccp(sender:getParent():getPositionX(),sender:getParent():getPositionY()))
	end

end
local function _Btn_Avatar_CallBack()
	--释放分身
	--关闭页面
	if tonumber(Label_num:getStringValue()) == 0 then
		return
	end
	ToServerAvatar(Label_num:getStringValue(),n_cur_type-1,nCityID)
	m_avatar_layer:removeFromParentAndCleanup(true)
	InitVars()
end
local function DealAddAndSubBtn(num)
	local nowNum = tonumber(Label_num:getStringValue())
	if CheckBEnoughExpend(tabExpend,num) == false then
		--如果不够，直接设置为最大能买的
		Label_num:setText(GetEnoughMaxNum(tabExpend,num))
		return 
	end
	
	
	Label_num:setText(num)
end
local function _Btn_Add_CallBack()
	--增加一次
	local nowNum = tonumber(Label_num:getStringValue())
	DealAddAndSubBtn(nowNum+1)
end
local function _Btn_Add_Ten_CallBack()
	local nowNum = tonumber(Label_num:getStringValue())
	DealAddAndSubBtn(nowNum+10)
end
local function _Btn_Sub_CallBack()
	local nowNum = tonumber(Label_num:getStringValue())
	if nowNum==0 then
		return 
	end
	if nowNum-1<0 then
		DealAddAndSubBtn(0)
	else
		DealAddAndSubBtn(nowNum-1)
	end
	
end
local function _Btn_Sub_Ten_CallBack()
	local nowNum = tonumber(Label_num:getStringValue())
	if nowNum==0 then
		return 
	end
	if nowNum-10<0 then
		DealAddAndSubBtn(0)
	else
		DealAddAndSubBtn(nowNum-10)
	end
	
end
local function InitUI()
	--武将的头像
	for i=1,4 do 
		local img_wj = tolua.cast(m_avatar_layer:getWidgetByName("img_"..i),"ImageView")
		local label_name = tolua.cast(m_avatar_layer:getWidgetByName("lable_name_"..i),"Label")
		label_name:setVisible(false) --策划修改为分身界面不显示名字
		if i<= #tabAvatarWJ then
			local pControl = UIInterface.MakeHeadIcon(img_wj,ICONTYPE.HEAD_ICON,tabAvatarWJ[i].itemID,nil,nil,nil,nil,nil)
			pControl:setTag(TAG_GRID_ADD+tabAvatarWJ[i].Type)
			CreateItemCallBack(pControl,false,AvatarWJ_CallBack,nil)
			--label_name:setText(CountryWarData.GetTeamName(tonumber(tabAvatarWJ[i].Type)-1))
		else
			img_wj:setVisible(false)
			--label_name:setVisible(false)
		end
	end
	local img_wj = tolua.cast(m_avatar_layer:getWidgetByName("img_1"),"ImageView")
	local img_bg = tolua.cast(m_avatar_layer:getWidgetByName("img_avatar_bg"),"ImageView")
	img_select = ImageView:create()
	n_cur_type = tonumber(tabAvatarWJ[1].Type)
	img_select:loadTexture("Image/imgres/item/selected_icon.png")
	img_select:setPosition(ccp(img_wj:getPositionX(),img_wj:getPositionY()))
	AddLabelImg(img_select,100,img_bg)
	
	local pExpend = ConsumeLogic.GetExpendData(GetConsumeFenShenID())
	tabExpend = pExpend.TabData
	--local 
	if #tabExpend<2 then
		local panel_gold = tolua.cast(m_avatar_layer:getWidgetByName("Panel_gold"),"Layout")
		panel_gold:setVisible(false)
	end
	Label_num = tolua.cast(m_avatar_layer:getWidgetByName("Label_32"),"Label")
	for i=1,#tabExpend do 
		local img_expend = tolua.cast(m_avatar_layer:getWidgetByName("img_fs_icon1"),"ImageView")
		
		img_expend:loadTexture(tabExpend[i].IconPath)
		local label_num = tolua.cast(m_avatar_layer:getWidgetByName("lable_fs_num"),"Label")
		if tabExpend[i].Enough == false then
			Label_num:setText("0")
			label_num:setText("0")
		else
			Label_num:setText("1")
			label_num:setText(tonumber(tabExpend[i].ItemNeedNum))
		end
		
		local img_btn_expend = tolua.cast(m_avatar_layer:getWidgetByName("img_fs_icon"),"ImageView")
		img_btn_expend:loadTexture(tabExpend[i].IconPath)
		local label_OwnNum = tolua.cast(m_avatar_layer:getWidgetByName("lable_stay_num"),"Label")
		label_OwnNum:setText(tabExpend[i].ItemNum)
	end
	
	--释放分身
	local btn_fs = tolua.cast(m_avatar_layer:getWidgetByName("btn_fs"),"Button")
	CreateBtnCallBack( btn_fs,"释放分身",36,_Btn_Avatar_CallBack )
	--增加
	local btn_add = tolua.cast(m_avatar_layer:getWidgetByName("btn_add"),"Button")
	CreateBtnCallBack( btn_add,nil,nil,_Btn_Add_CallBack )
	local btn_add_ten = tolua.cast(m_avatar_layer:getWidgetByName("btn_add_ten"),"Button")
	CreateBtnCallBack( btn_add_ten,nil,nil,_Btn_Add_Ten_CallBack )
	--减少
	local btn_sub = tolua.cast(m_avatar_layer:getWidgetByName("btn_sub"),"Button")
	CreateBtnCallBack( btn_sub,nil,nil,_Btn_Sub_CallBack )
	local btn_sub_ten = tolua.cast(m_avatar_layer:getWidgetByName("btn_sub_ten"),"Button")
	CreateBtnCallBack( btn_sub_ten,nil,nil,_Btn_Sub_Ten_CallBack )
	
end
local function _Btn_Close_CallBack()
	m_avatar_layer:removeFromParentAndCleanup(true)
	InitVars()
end

function CreateAvatarLayer(tabAWJ,nCityTag)
	InitVars()
	m_avatar_layer = TouchGroup:create()
	m_avatar_layer:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/AvatarSelectLayer.json" ) )
	tabAvatarWJ = tabAWJ
	nCityID = nCityTag
	InitUI()
	local btn_close = tolua.cast(m_avatar_layer:getWidgetByName("btn_back"),"Button")
	CreateBtnCallBack( btn_close,nil,nil,_Btn_Close_CallBack,nil,nil,nil,nil,nil )
	return m_avatar_layer
end