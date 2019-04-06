module("ArenaManagerLayer", package.seeall)

local m_lyArenaMgrLayer = nil

local m_chbPK = nil
local m_chbRank = nil
local m_chbReward = nil
local m_chbRecorder = nil 
local m_chbCur = nil

local m_btnReturn = nil
local m_btnTip = nil
local m_pListView = nil
local m_pCurLayer = nil

--上面一层的显示 celina
local m_up_info_panel = nil
local m_up_record_panel = nil

local function InitVars(  )
	m_lyArenaMgrLayer = nil
	m_chbPK = nil
	m_chbRank = nil
	m_chbReward = nil
	m_chbRecorder = nil 
	m_chbCur = nil

	m_btnReturn = nil
	m_btnTip = nil
	m_imgTip = nil
	m_pListView = nil
	m_up_info_panel = nil
	m_up_record_panel = nil
end

local function _Button_Return_ArenaMgr_CallBack(sender, eventType)
	if eventType==TouchEventType.ended then
		if m_lyArenaMgrLayer~=nil then
			m_lyArenaMgrLayer:removeFromParentAndCleanup(true)
			InitVars()
		    MainScene.PopUILayer()
		end
	end
end

local function _Button_Tip_ArenaMgr_CallBack(sender, eventType)
	if eventType==TouchEventType.ended then
		if m_imgTip:isVisible()== false then
			m_imgTip:setVisible(true)
		else
			m_imgTip:setVisible(false)
		end
	end
end

local function ChangeArenaByChbTag(tag)

	-- 清除当前界面
	m_pListView:removeAllItems()

	if tag==m_chbRecorder:getTag() then
		m_up_info_panel:setVisible(false)
		m_up_info_panel:setEnabled(false)
		m_up_info_panel:setTouchEnabled(false)
		if m_up_record_panel:isVisible() == false then
			m_up_record_panel:setVisible(true)
			m_up_record_panel:setEnabled(true)
			m_up_record_panel:setTouchEnabled(true)
		end
		m_pListView:setItemsMargin(40)
	else
		m_up_record_panel:setVisible(false)
		m_up_record_panel:setEnabled(false)
		m_up_record_panel:setTouchEnabled(false)
		if m_up_info_panel:isVisible() == false then
			m_up_info_panel:setVisible(true)
			m_up_info_panel:setEnabled(true)
			m_up_info_panel:setTouchEnabled(true)
		end
		m_pListView:setItemsMargin(0)
	end
	-- 根据标签创建新的界面
	if tag==m_chbPK:getTag() then
		-- print("Load PK Layer")
		require "Script/Main/Arena/ArenaPlayerListLayer"
		ArenaPlayerListLayer.createArenaPlayerLayer(m_pListView)
	elseif tag==m_chbRank:getTag() then
		-- print("Load Rank Layer")
		require "Script/Main/Arena/ArenaRankLayer"
		ArenaRankLayer.createArenaRankLayer(m_pListView)
	elseif tag==m_chbReward:getTag() then
		-- print("Load Reward Layer")
		require "Script/Main/Arena/ArenaRewardLayer"
		ArenaRewardLayer.createArenaRewardLayer(m_pListView)
	elseif tag==m_chbRecorder:getTag() then
		-- print("Load Recorder Layer")
		require "Script/Main/Arena/ArenaWarRecordLayer"
		ArenaWarRecordLayer.createArenaRecordLayer(m_pListView)
	end

end

-- CheckBox回调
local function _CheckBox_ArenaMgr__CallBack(sender, eventType)
	-- 获取当前点击的CheckBox
	local curCheckBox = tolua.cast(sender,"CheckBox")
	if eventType == CheckBoxEventType.selected then

		if m_chbCur~=curCheckBox then
			m_chbCur:setSelectedState(false)
			m_chbCur = curCheckBox
			ChangeArenaByChbTag(curCheckBox:getTag())
		end
	else
		if curCheckBox:getSelectedState() == false then
			curCheckBox:setSelectedState(true)
			if m_chbCur==nil then
				m_chbCur = curCheckBox
				ChangeArenaByChbTag(curCheckBox:getTag())
			end
		end
	end

end

-- 初始化所需控件
local function InitWidgets()

	-- 比武
	m_chbPK = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("CheckBox_PK"), "CheckBox")
	if m_chbPK==nil then
		print("m_chbPK is null")
		return false
	else
		m_chbPK:addEventListenerCheckBox(_CheckBox_ArenaMgr__CallBack)
	end

	-- 名将榜
	m_chbRank = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("CheckBox_Rank"), "CheckBox")
	if m_chbRank==nil then
		print("m_chbRank is null")
		return false
	else
		m_chbRank:addEventListenerCheckBox(_CheckBox_ArenaMgr__CallBack)
	end

	-- 奖励查看
	m_chbReward = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("CheckBox_Reward"), "CheckBox")
	if m_chbReward==nil then
		print("m_chbReward is null")
		return false
	else
		m_chbReward:addEventListenerCheckBox(_CheckBox_ArenaMgr__CallBack)
	end

	-- 战斗记录
	m_chbRecorder = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("CheckBox_Recorder"), "CheckBox")
	if m_chbRecorder==nil then
		print("m_chbRecorder is null")
		return false
	else
		m_chbRecorder:addEventListenerCheckBox(_CheckBox_ArenaMgr__CallBack)
	end

	m_btnReturn = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("Button_Return"), "Button")
	if m_btnReturn==nil then
		print("m_btnReturn is null")
		return false
	else
		m_btnReturn:addTouchEventListener(_Button_Return_ArenaMgr_CallBack)
	end

	m_pListView = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("ListView_Info"), "ListView")
	m_pListView:setClippingType(1)
	if m_pListView==nil then
		print("m_pListView is null")
		return false
	end

	m_up_info_panel = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("Panel_Info"),"Layout")
	if m_up_info_panel==nil then
		print("m_up_info_panel is null")
		return false
	end

	m_up_record_panel = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("Panel_record"),"Layout")
	if m_up_record_panel==nil then
		print("m_up_record_panel is null")
		return false
	end

	m_btnTip = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("Button_Tip"), "Button")
	if m_btnTip==nil then 
		print("m_btnReturn is null")
		return false
	else
		m_btnTip:addTouchEventListener(_Button_Tip_ArenaMgr_CallBack)
	end

	m_imgTip = tolua.cast(m_lyArenaMgrLayer:getWidgetByName("Image_Tip"), "ImageView")
	if m_imgTip==nil then
		print("m_imgTip is null")
		return false
	end

	return true
end

function createArenaMgrLayer(  )
	InitVars()
	m_lyArenaMgrLayer = TouchGroup:create()									-- 背景层
    m_lyArenaMgrLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/ArenaManagerLayer.json") )

    local bResult = InitWidgets()

    if bResult==false then
    	print("Init Widgets Failed...")
    	return
    end
    --将主界面按钮重新加载一次
    require "Script/Main/MainBtnLayer"
    local temp = MainBtnLayer.createMainBtnLayer()
    m_lyArenaMgrLayer:addChild(temp, layerMainBtn_Tag, layerMainBtn_Tag)
	_CheckBox_ArenaMgr__CallBack(m_chbPK, CheckBoxEventType.unselected)

	return m_lyArenaMgrLayer
end

function GetUIControl(  )
	return m_lyArenaMgrLayer
end