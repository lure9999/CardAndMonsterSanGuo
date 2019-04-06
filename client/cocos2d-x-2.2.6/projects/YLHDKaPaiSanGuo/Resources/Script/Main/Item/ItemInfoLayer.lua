-- for CCLuaEngine traceback

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

require "Script/serverDB/item"
require "Script/Common/CommonData"

module("ItemInfoLayer", package.seeall)


local layerIteminfo = nil





function createItemInfo(item_id)
	layerIteminfo = TouchGroup:create()
	layerIteminfo:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/ItemInfoLayer.json"))
	
	local img_pop_bg = tolua.cast(layerIteminfo:getWidgetByName("img_bg_popInfo"),"ImageView")
	local name_info = tolua.cast(layerIteminfo:getWidgetByName("label_name_pop"),"Label")
	local number_info = tolua.cast(layerIteminfo:getWidgetByName("label_number_pop"),"Label")
	local img_icon_info = tolua.cast(layerIteminfo:getWidgetByName("img_iconbg_pop"),"ImageView")
	local info_iteminfo = tolua.cast(layerIteminfo:getWidgetByName("label_info_pop"),"Label")
	--print("item_id"..item_id)
	--得到的是返回的ID
	local table_id_info = CommonData.g_ItemTable[item_id]["TempID"]

	--img_icon_info:setVisible(false)
	local tag_info = img_icon_info:getTag()
	img_pop_bg:removeChildByTag(tag_info,true)
	
	local img_n_icon = ImageView:create()
	img_n_icon:setPosition(ccp(-185,38))
	local num_info = CommonData.g_ItemTable[item_id]["Number"]
	local str_num = string.format("持有： %d",1)
	number_info:setText(str_num)
	
	local img_icon_item = tolua.cast(layerIteminfo:getWidgetByName("img_icon_pop"),"ImageView")
	local tag_icon_item = img_icon_item:getTag()
	img_pop_bg:removeChild(img_icon_item,true)
	
	local img_n_icon_item = ImageView:create()
	img_n_icon_item:setPosition(ccp(-183,35))
	local res_id_ll = item.getFieldByIdAndIndex(table_id_info,"res_id")
	if tonumber(res_id_ll)==2 then 
		img_n_icon_item:loadTexture("Image/daoju/icon_daoju_hao.png")
		
	elseif tonumber(res_id_ll)==3 then
		img_n_icon_item:loadTexture("Image/daoju/icon_daoju_zhu.png")
	elseif tonumber(res_id_ll)==4 then
		img_n_icon_item:loadTexture("Image/daoju/icon_daoju_baoshi.png")
	elseif tonumber(res_id_ll)==5 then
		img_n_icon_item:loadTexture("Image/daoju/icon_daoju_gift.png")
	elseif tonumber(res_id_ll)==6 then
		img_n_icon_item:loadTexture("Image/daoju/icon_daoju_juanzhou.png")
	else
		img_n_icon_item:loadTexture("Image/daoju/icon_daoju_shu.png")
	end
	img_n_icon_item:setTag(tag_icon_item)
	img_pop_bg:addChild(img_n_icon_item)
	
	local info1 = item.getFieldByIdAndIndex(table_id_info,"des")
	--print(info1)
	info_iteminfo:setText(info1)
	local str_info1 = item.getFieldByIdAndIndex(table_id_info,"name")
	name_info:setText(str_info1)
	local pinzhi_info = item.getFieldByIdAndIndex(table_id_info,"pinzhi")
	if tonumber(pinzhi_info) == 2 then
		name_info:setColor(ccc3(29,255,50))
		
	elseif tonumber(pinzhi_info) == 3 then
		name_info:setColor(ccc3(29,167,255))
	elseif tonumber(pinzhi_info) == 4 then 
		name_info:setColor(ccc3(255,115,228))
	elseif tonumber(pinzhi_info) == 5 then 
		name_info:setColor(ccc3(255,231,70))
	end
	local str_path_icon = string.format("Image/common/pinzhi_icon/icon_pingzhi_%d.png",pinzhi_info)
	img_n_icon:loadTexture(str_path_icon)
	img_pop_bg:addChild(img_n_icon)
	local function _Btn_Back_ItemInfoLayer_CallBack(sender,eventType)
	    if eventType == TouchEventType.ended then
			--print("关闭")
			local scene_now = CCDirector:sharedDirector():getRunningScene()
			local layer_now = scene_now:getChildByTag(layerItemList_Tag)
			if layer_now ~=nil then
				layer_now:removeChildByTag(layerItemInfo_Tag,true)
		    end
		end
	end
	--返回按钮
	local btn_close_iteminfo = tolua.cast(layerIteminfo:getWidgetByName("btn_closed_pop"),"Button")
	btn_close_iteminfo:addTouchEventListener(_Btn_Back_ItemInfoLayer_CallBack)
	
	return layerIteminfo
end