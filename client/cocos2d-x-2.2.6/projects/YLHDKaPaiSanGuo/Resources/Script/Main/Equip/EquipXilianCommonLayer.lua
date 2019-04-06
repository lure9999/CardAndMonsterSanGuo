
module("EquipXilianCommonLayer", package.seeall)



XL_TYPE = {
	XL_TYPE_BEFORE = 1 ,
	XL_TYPE_AFTER  = 2 ,
	XL_TYPE_PLAN   = 3
}

local ToXiLian = EquipXilianLogic.ToXiLian


--showTag 表示显示的是洗炼前还是洗炼后
function ShowXLMidInfo(tableShowInfo,mPanelMid,nType)
	--得到中间的信息
	--清理
	mPanelMid:removeAllChildrenWithCleanup(true)
	local num = #tableShowInfo
	local h_height = 0 
	local pos_h = 236-(50*num+h_height*(num-1))
	local posX = 236-pos_h/2-25
	for key,value in pairs(tableShowInfo) do 
		--名字
		local label_name_xl = Label:create()
		label_name_xl:setFontSize(20)
		label_name_xl:setColor(ccc3(49,31,21))
		label_name_xl:setText(value.Name)
		label_name_xl:setPosition(ccp(60,posX-(h_height+50)*(key-1)+2))
		mPanelMid:addChild(label_name_xl,0,key+100)
		--icon
		local img_type_icon = ImageView:create()
		img_type_icon:loadTexture(GetIconPath(value.Type))
		img_type_icon:setPosition(ccp(60+60,posX-(h_height+50)*(key-1)))
		mPanelMid:addChild(img_type_icon,0,key+101)
		--基础值(只有基础属性才显示基础值)
		if value.Value~=0 then
			local label_value = Label:create()
			label_value:setFontSize(20)
			label_value:setColor(ccc3(49,31,21))
			label_value:setText(value.Value)
			label_value:setPosition(ccp(170,posX-(h_height+50)*(key-1)))
			mPanelMid:addChild(label_value,0,key+102)
		end
		--进度条底
		local img_pro_bg = ImageView:create()
		img_pro_bg:loadTexture("Image/imgres/equip/pro_bg.png")
		img_pro_bg:setPosition(ccp(370,posX-(h_height+50)*(key-1)))
		
		mPanelMid:addChild(img_pro_bg,0,key+103)
		--进度条
		local pro_num = 0
		pro_num = tonumber(value.XLValue)/tonumber(value.LimitValue)*100
		local loadingBar = LoadingBar:create()
		loadingBar:setName("LoadingBar")
		loadingBar:loadTexture("Image/imgres/equip/pro_green.png")
		loadingBar:setPercent(pro_num)
		loadingBar:setPosition(ccp(370,posX-(h_height+50)*(key-1)))
		mPanelMid:addChild(loadingBar,0,key+104)
		--洗炼值
		local label_add_value_x = nil 
		if tonumber(value.XLValue) > 0 then
			label_add_value_x = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,"+"..value.XLValue,ccp(3,0),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(label_add_value_x,key,loadingBar)
		elseif tonumber(value.XLValue) < 0 then
			label_add_value_x = LabelLayer.createStrokeLabel(22,CommonData.g_FONT1,value.XLValue,ccp(3,0),COLOR_Black,COLOR_White,true,ccp(0,-2),2)
			EquipCommon.AddStrokeLabel(label_add_value_x,key,loadingBar)
		end
		--上限
		if value.BLimitMax == true then
			local img_max = ImageView:create()
			img_max:loadTexture("Image/imgres/equip/word_limit.png")
			img_max:setPosition(ccp(580,posX-(h_height+50)*(key-1)))
			mPanelMid:addChild(img_max,0,2000+key)
		else
			if nType == XL_TYPE.XL_TYPE_BEFORE then
				--洗炼前界面显示的最大值
				local label_max_value = Label:create()
				label_max_value:setAnchorPoint(ccp(0,0.5))
				label_max_value:setFontSize(20)
				label_max_value:setColor(ccc3(49,31,21))
				label_max_value:setText("MAX "..value.LimitValue)
				label_max_value:setPosition(ccp(550,posX-(h_height+50)*(key-1)))
				
				mPanelMid:addChild(label_max_value,0,key+106)
			elseif  nType == XL_TYPE.XL_TYPE_AFTER then
				--洗炼后界面显示洗炼值和上升下降符号
				local img_up = ImageView:create()
				img_up:setPosition(ccp(610,posX-(h_height+50)*(key-1)))
				local upValue = value.AddXLValue
				upValue= upValue- upValue%1
				local pos = ccp(570,posX-(h_height+50)*(key-1))
				if tonumber(upValue) > 0 then
					local label_add_value1 = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,"+"..upValue,pos,ccc3(81,113,39),ccc3(0,255,79),true,ccp(0,-2),2)
					EquipCommon.AddStrokeLabel(label_add_value1,key+100+158,mPanelMid)
					img_up:loadTexture("Image/imgres/common/arrow_up.png")
				elseif tonumber(upValue) < 0 then
					local label_add_value2 = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,upValue,pos,ccc3(110,21,0),ccc3(255,66,0),true,ccp(0,-2),2)
					EquipCommon.AddStrokeLabel(label_add_value2,key+100+57,mPanelMid)
					img_up:loadTexture("Image/imgres/common/arrow_down.png")
				end
				if tonumber(upValue) == 0 or upValue==nil  then
					img_up:setVisible(false)
				end
				mPanelMid:addChild(img_up,0,key+100+55)
			end
		end
	end
end

--需要隐藏的按钮
local function CancelBtn(btnObject)
	btnObject:setTouchEnabled(false)
	btnObject:setVisible(false)
end

function ShowXLBtn(nType,mLayer,nGrid,xlCallBack,replaceCallBack,cancelCallBack)
	local m_btn_xl = tolua.cast(mLayer:getWidgetByName("btn_xl"),"Button")
	local m_btn_replace = tolua.cast(mLayer:getWidgetByName("btn_change"),"Button")
	local m_btn_cancel = tolua.cast(mLayer:getWidgetByName("btn_cancel"),"Button")
	
	if nType == XL_TYPE.XL_TYPE_BEFORE then
		CreateBtnCallBack(m_btn_xl,"洗炼",36,xlCallBack,nil,nil,nGrid)
		CancelBtn(m_btn_replace)
		CancelBtn(m_btn_cancel)
	end
	if nType == XL_TYPE.XL_TYPE_AFTER then
		CreateBtnCallBack(m_btn_xl,"继续洗炼",36,xlCallBack,nil,nil,nGrid)
		
		CreateBtnCallBack(m_btn_replace,"替换",36,replaceCallBack,nil,nil,nGrid)
		CreateBtnCallBack(m_btn_cancel,"取消",36,cancelCallBack,nil,nil,nGrid)
		
		m_btn_replace:setVisible(true)
		m_btn_cancel:setVisible(true)
		
		m_btn_replace:setTouchEnabled(true)
		m_btn_cancel:setTouchEnabled(true)
	end
end