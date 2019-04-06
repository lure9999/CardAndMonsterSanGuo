--提示框通用接口 celina
--修改为多份
module("TipCommonLayer", package.seeall)

require "Script/Common/TipCommonLayerLogic"

--逻辑
--检测现在的显示类型
local GetTypeByMId = TipCommonLayerLogic.GetTypeByMId
local GetMessageByID = TipCommonLayerLogic.GetMessageByID
local GetDataNum = TipCommonLayerLogic.GetDataNum
local AddStrInfoNoBtn = TipCommonLayerLogic.AddStrInfoNoBtn
local GetActionLayer    = TipCommonLayerLogic.GetActionLayer
local AddStrInfo = TipCommonLayerLogic.AddStrInfo
local GetBtnFirstName = TipCommonLayerLogic.GetBtnFirstName
local GetBtnSecName = TipCommonLayerLogic.GetBtnSecName

local TIPSLAYER_TYPE = {
	TIPSLAYER_TYPE_NONE       = 0,
	TIPSLAYER_TYPE_BUTTON_ONE = 1,
	TIPSLAYER_TYPE_BUTTON_TWO = 2,
}



local function ShowButton(self)
	self.m_layer_tips =  TouchGroup:create()
	self.m_layer_tips:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/TipsCommonLayer.json" ) )
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	scenetemp:addChild(self.m_layer_tips, layerTip_Tag+1, layerTip_Tag+1)
	local img_btn_bg = tolua.cast(self.m_layer_tips:getWidgetByName("img_down"),"ImageView")
	local img_info_bg = tolua.cast(self.m_layer_tips:getWidgetByName("img_tips_bg"),"ImageView")
	AddStrInfo(self.msg,img_info_bg)
	if tonumber( self.nTipType ) == TIPSLAYER_TYPE.TIPSLAYER_TYPE_BUTTON_ONE then
		--一个按钮的时候调用
		local function _Btn_Close_CallBack()
			--一个按钮的情况都要关闭当前界面
			
			if self.fTipCallBack~=nil then
				self.fTipCallBack()
			end	
			self.m_layer_tips:removeFromParentAndCleanup(true)
			self.m_layer_tips = nil 
		end
		local btn_one = Button:create()
		btn_one:loadTextures("Image/imgres/common/btn_bg.png","Image/imgres/common/btn_bg.png","")
		btn_one:setPosition(ccp(0,0))
		img_btn_bg:addChild(btn_one)
		CreateBtnCallBack(btn_one,GetBtnFirstName(self.nTipID),36,_Btn_Close_CallBack)
		
	elseif tonumber( self.nTipType ) == TIPSLAYER_TYPE.TIPSLAYER_TYPE_BUTTON_TWO then
		local function _Btn_Left_CallBack()
			--左边操作
			if self.fTipCallBack~=nil then
				self.fTipCallBack(true)
			end	
			if self.m_layer_tips~=nil then
				self.m_layer_tips:removeFromParentAndCleanup(true)
				self.m_layer_tips = nil 
			end
		end
		local function _Btn_Right_CallBack()
			--右边操作
			if self.fTipCallBack~=nil then
				self.fTipCallBack(false)
			end	
			if self.m_layer_tips~=nil then
				self.m_layer_tips:removeFromParentAndCleanup(true)
				self.m_layer_tips = nil 
			end	
		end
		for i=1,2 do 
			local btn_i = Button:create()
			btn_i:loadTextures("Image/imgres/common/btn_bg.png","Image/imgres/common/btn_bg.png","")
			btn_i:setPosition(ccp(0-btn_i:getContentSize().width/2-20+(i-1)*(btn_i:getContentSize().width+40),0))
			img_btn_bg:addChild(btn_i)
			if i==1 then
				CreateBtnCallBack(btn_i,GetBtnFirstName(self.nTipID),36,_Btn_Left_CallBack)
			else
				CreateBtnCallBack(btn_i,GetBtnSecName(self.nTipID),36,_Btn_Right_CallBack)
			end
		end
	end
end

local function ShowNoButton(self)
	self.m_layer_tips = CCLayer:create()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()

	--scenetemp:addChild(m_layer_tips, layerTip_Tag, layerTip_Tag)
	AddLabelImg(self.m_layer_tips,layerTip_Tag,scenetemp)
	CommonInterface.MakeUIToCenter(self.m_layer_tips)
	--添加tips的背景
	local img_bg = ImageView:create()
	img_bg:setScale9Enabled(true)
	img_bg:loadTexture("Image/imgres/common/tip_bk_01.png")
	img_bg:setPosition(ccp(CommonData.g_sizeVisibleSize.width/2, CommonData.g_sizeVisibleSize.height/2))
	if img_bg~=nil then
		--m_layer_tips:addChild(img_bg,10,10)
		AddLabelImg(img_bg,10,self.m_layer_tips)
		AddStrInfoNoBtn(self.msg,img_bg,1)
	end
	
	local function ActionEnd()
		if self.m_layer_tips~=nil then
			--img_bg:removeFromParentAndCleanup(true)
			img_bg:removeAllChildrenWithCleanup(true)
			self.m_layer_tips:removeFromParentAndCleanup(true)
			self.m_layer_tips = nil
		end
		
	end
	img_bg:stopAllActions()
	img_bg:runAction(GetActionLayer(ActionEnd))
end


--nID,消息ID
--fCallBack 如果有回调需要 回调带参数，true表示是左边的点击，false表示是右边的点击
local function ShowCommonTips(self,nID,fCallBack,...)
	self.nTipID = nID
	self.fTipCallBack = fCallBack
	self.nTipType = GetTypeByMId(self.nTipID)
	self.m_layer_tips = nil
	local message = GetMessageByID(self.nTipID)
	if GetDataNum(self.nTipID)~= 0 then
		self.msg = string.format(message,...)
	else
		self.msg = message
	end
	
	if tonumber( self.nTipType ) == TIPSLAYER_TYPE.TIPSLAYER_TYPE_NONE then
		ShowNoButton( self )
	else
		ShowButton( self )
	
	end
end

function CreateTipLayerManager()
	local pTipManager = {}
	pTipManager.ShowCommonTips = ShowCommonTips
	
	return pTipManager
end