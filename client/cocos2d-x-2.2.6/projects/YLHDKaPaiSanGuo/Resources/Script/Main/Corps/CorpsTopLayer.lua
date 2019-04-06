module("CorpsTopLayer", package.seeall)
local GetCorpsInfo 			= CorpsData.GetCorpsInfo

local m_topLayer = nil
local m_topType = 0

local nOff_W = CommonData.g_nDeginSize_Width - CommonData.g_sizeVisibleSize.width
local nOff_H = CommonData.g_nDeginSize_Height - CommonData.g_sizeVisibleSize.height
local nOff_X = CommonData.g_Origin.x
local nOff_Y = CommonData.g_Origin.y 
local IMAGE_TILI = "Image/imgres/common/tili.png"

local function init(  )
	m_topLayer  = nil
	m_topType   = 0
end

function SetContribute( Num )
	if m_topLayer == nil then
		return
	end
	local image_Contribute = tolua.cast(m_topLayer:getWidgetByName("Label_cNum"),"Label")
	if image_Contribute:getChildByTag(1001) ~= nil then
		LabelLayer.setText(image_Contribute:getChildByTag(1001),Num)
	else
		local text = LabelLayer.createStrokeLabel(23,"微软雅黑",Num,ccp(0,0),COLOR_Black, ccc3(206,147,91),true,ccp(0,-2),2)
		image_Contribute:addChild(text,1001,1001)
	end
end

--添加银币的特效
local function AddSliverTX(img_bg)
	
	local pAnimature = CommonInterface.GetAnimationByName("Image/imgres/effectfile/yuanbaoyinbi_texiao/yuanbaoyinbi_texiao.ExportJson", 
		"yuanbaoyinbi_texiao", 
		"Animation2", 
		img_bg, 
		ccp(0, 0),
		nil,
		100)
end
--添加金币的特效
local function AddGoldTX(img_bg)
	local pAnimature = CommonInterface.GetAnimationByName("Image/imgres/effectfile/yuanbaoyinbi_texiao/yuanbaoyinbi_texiao.ExportJson", 
		"yuanbaoyinbi_texiao", 
		"Animation1", 
		img_bg, 
		ccp(0, 0),
		nil,
		100)
end

function SetCorpsMoney( Num )
	if m_topLayer == nil then
		return
	end
	local image_Contribute = tolua.cast(m_topLayer:getWidgetByName("Label_MNum"),"Label")
	if image_Contribute:getChildByTag(1000) ~= nil then
		LabelLayer.setText(image_Contribute:getChildByTag(1000),Num)
	else
		local text = LabelLayer.createStrokeLabel(23,"微软雅黑",Num,ccp(0,0),COLOR_Black, ccc3(206,147,91),true,ccp(0,-2),2)
		image_Contribute:addChild(text,0,1000)
	end
end

function SetSliverMoney( Num )
	if m_topLayer == nil then
		return
	end
	local image_Sliver = tolua.cast(m_topLayer:getWidgetByName("Label_SNum"),"Label")
	if image_Sliver:getChildByTag(1000) ~= nil then
		LabelLayer.setText(image_Sliver:getChildByTag(1000),Num)
	else
		local text = LabelLayer.createStrokeLabel(23,"微软雅黑",Num,ccp(0,0),COLOR_Black, ccc3(206,147,91),true,ccp(0,-2),2) --ccc3(83,28,2), ccc3(161,85,20)
		image_Sliver:addChild(text,0,1000)
	end
end

function SetGodMoney( Num )
	if m_topLayer == nil then
		return
	end
	local img_btom = tolua.cast(m_topLayer:getWidgetByName("Image_4_3"),"ImageView")
	if img_btom == nil then
		return
	end
	local image_Gold = tolua.cast(img_btom:getChildByName("Label_gNum"),"Label")
	if image_Gold:getChildByTag(1000) ~= nil then
		LabelLayer.setText(image_Gold:getChildByTag(1000),Num)
	else
		local text = LabelLayer.createStrokeLabel(23,"微软雅黑",Num,ccp(0,0),COLOR_Black, ccc3(206,147,91),true,ccp(0,-2),2)
		image_Gold:addChild(text,0,1000)
	end
end

local function SetCorpsPower( nNumber )
	if m_topLayer == nil then
		return
	end
	local image_CorpsPower = tolua.cast(m_topLayer:getWidgetByName("Image_80"),"ImageView")
	local label_CorpsPower = tolua.cast(m_topLayer:getWidgetByName("Label_power"),"Label")
	image_CorpsPower:loadTexture("Image/imgres/corps/corpsPower.png")
	if label_CorpsPower:getChildByTag(1000) ~= nil then
		local ntemp = tolua.cast(label_CorpsPower:getChildByTag(1000),"LabelBMFont")
		ntemp:setText(nNumber)
	else
		local pText = LabelBMFont:create()		
		pText:setFntFile("Image/imgres/main/fight.fnt")
		pText:setPosition(ccp(-50,-20))
		pText:setAnchorPoint(ccp(0,0.5))
		pText:setText(nNumber)
		label_CorpsPower:addChild(pText,0,1000)
	end 
end

local function _Click_coin_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local n_tag = sender:getTag()
		if tonumber(n_tag) == 1 then
			local pMessage = TipsMessage.CreateTipsMessage()
			pMessage:Create(1,0,2,ccp(sender:getPositionX()+150,600))
		elseif tonumber(n_tag) == 2 then
			local pMessage = TipsMessage.CreateTipsMessage()
			pMessage:Create(1,0,1,ccp(sender:getPositionX()+150,600))
		elseif tonumber(n_tag) == 3 then
			local pMessage = TipsMessage.CreateTipsMessage()
			pMessage:Create(1,0,10,ccp(sender:getPositionX()+150,600))
		elseif tonumber(n_tag) == 4 then
			local pMessage = TipsMessage.CreateTipsMessage()
			pMessage:Create(1,0,13,ccp(sender:getPositionX()+150,600))
		elseif tonumber(n_tag) == 5 then
			local pMessage = TipsMessage.CreateTipsMessage()
			pMessage:Create(1,1,2,ccp(840,600))
		elseif tonumber(n_tag) == 6 then
			local pMessage = TipsMessage.CreateTipsMessage()
			pMessage:Create(1,1,1,ccp(sender:getPositionX()+100,600))
		end
		
	end
end

local function loadCoinMoney( nPerstige,nCorpsMoney,power )
	if m_topLayer == nil then
		return
	end
	local img_tili = tolua.cast(m_topLayer:getWidgetByName("Image_money"),"ImageView")
	local img_Goldbg = tolua.cast(m_topLayer:getWidgetByName("Image_4_2"),"ImageView")
	local img_sliverbg = tolua.cast(m_topLayer:getWidgetByName("Image_4_3"),"ImageView")
	local img_contribg = tolua.cast(m_topLayer:getWidgetByName("Image_4"),"ImageView")
	local img_corpsbg = tolua.cast(m_topLayer:getWidgetByName("Image_4_0"),"ImageView")
	local img_powerbg = tolua.cast(m_topLayer:getWidgetByName("Image_4_1"),"ImageView")
	local img_tesliver = tolua.cast(img_sliverbg:getChildByName("Image_contibute"),"ImageView")
	local img_tegold = tolua.cast(img_Goldbg:getChildByName("Image_contibute"),"ImageView")

	AddSliverTX(img_tesliver)
	AddGoldTX(img_tegold)

	img_Goldbg:setTouchEnabled(true)
	img_sliverbg:setTouchEnabled(true)
	img_contribg:setTouchEnabled(true)
	img_corpsbg:setTouchEnabled(true)
	img_powerbg:setTouchEnabled(true)
	img_Goldbg:setTag(1)
	img_sliverbg:setTag(2)
	img_contribg:setTag(3)
	img_corpsbg:setTag(4)
	img_powerbg:setTag(5)

	local n_Gold = server_mainDB.getMainData("gold")
	local n_Sliver = server_mainDB.getMainData("silver")
	local n_Tili = server_mainDB.getMainData("tili")
	local n_Contribute = server_mainDB.getMainData("Family_Prestige")

	SetGodMoney(n_Sliver)
	SetSliverMoney(n_Gold)
	SetCorpsPower(power)
	SetContribute(n_Contribute)
	if m_topType == 0 then
		img_tili:loadTexture(IMAGE_TILI)
		img_tili:setScale(0.5)
		SetCorpsMoney(n_Tili)
	else
		
		SetCorpsMoney(nCorpsMoney)
	end
	img_Goldbg:addTouchEventListener(_Click_coin_CallBack)
	img_sliverbg:addTouchEventListener(_Click_coin_CallBack)
	img_contribg:addTouchEventListener(_Click_coin_CallBack)
	img_corpsbg:addTouchEventListener(_Click_coin_CallBack)
	img_powerbg:addTouchEventListener(_Click_coin_CallBack)
end

local function SetPanelPosition(  )
	local PanelTop = tolua.cast(m_topLayer:getWidgetByName("Panel_top"),"Layout")
	local posTopX = PanelTop:getPositionX()
	local posTopY = PanelTop:getPositionY()
	PanelTop:setPosition(ccp(posTopX - nOff_X,posTopY))
end


function ShowTopLayer( nRoot,v_data,is_bool )
	init()
	m_topLayer = TouchGroup:create()									-- 背景层
    m_topLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTopLayer.json") )
    m_topLayer:setTouchPriority(0)
    m_topLayer:setPosition(ccp(0,nRoot:getContentSize().height-50-nOff_Y)) --nRoot:getContentSize().width/2
    SetPanelPosition()
    m_topType = is_bool
   	if is_bool == 1 then
	    local function GetSuccessCallback(  )
	    	local tableData = GetCorpsInfo()
	    	loadCoinMoney(tableData[1][10],tableData[1][11],tableData[1][13])
	    end
	    Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())

	elseif is_bool == 2 then
	    loadCoinMoney(v_data[1][10],v_data[1][11],v_data[1][13])
	else
		m_topType = is_bool
		local function GetSuccessCallback(  )
	    	local tableData = GetCorpsInfo()
	    	loadCoinMoney(tableData[1][10],tableData[1][11],tableData[1][13])
	    end
	    Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
	end
	-- nRoot:addChild(m_topLayer,10000,10000)
    return m_topLayer
end