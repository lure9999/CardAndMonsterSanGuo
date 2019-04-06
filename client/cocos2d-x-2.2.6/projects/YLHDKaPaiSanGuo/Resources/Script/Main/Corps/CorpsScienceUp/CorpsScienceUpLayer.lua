require "Script/Main/Corps/CorpsLogic"
require "Script/Main/Dobk/DobkData"
require "Script/Main/Dobk/DobkLogic"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceData"
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceLogic"
require "Script/Main/Corps/CorpsTopLayer"
module("CorpsScienceUpLayer",package.seeall)
require "Script/Main/Corps/CorpsScienceUp/CorpsScienceNode"

ScienceStateType = {
	Zhuzi = 1,
	Yanfa = 2,
	lijiwangcheng = 3,
	bukeyanfa = 4,
}

local CORPSMONEY = "Image/imgres/common/corpsmoney.png"

local m_teachnologyLayer   	= nil
local m_listView 			= nil
local m_img_select			= nil
local m_type                = nil
local l_HightLevel          = nil
local m_org_select_id       = 1
local m_right_count         = 0
local m_left_count          = 0
-- local BtnText               = nil
local bar_count_sp          = nil
local percent               = nil
local nCurCount             = nil
local nNeedCount            = nil
local image_flag = nil
local tableLine = {}
local totalTable = {}
local num = 1
local label_word            = nil
local label_seliver         = nil
local label_silverNum       = nil
local label_gold            = nil
local Label_goldNum         = nil
local label_countdown       = nil
local label_Needtime        = nil
local label_isTeach         = nil
local label_needLevel       = nil
-- local btn_teach             = nil
local m_select_idNum        = nil
local scienceValue          = nil
local m_timeSHand            = nil
local is_ShowScience        = nil
local Panel_limit           = nil
local Panel_money           = nil
local Panel_tech            = nil
local Panel_time            = nil
local senderControl         = nil
local m_CurrentType         = nil
local CurNum                = nil
local m_ScienceType         = nil
local S_UpT                 = nil
local teach_isTeachText     = nil
local pItemWidget           = nil
local l_level               = nil
local l_name                = nil
local n_golbPosition        = 0
local nums                  = 0
local is_firsh              = 0
local cut_time              = 0
local is_selectID           = 0
local listScienceTypeData  = {}
local listScienceShow = {"可研发","研发中","暂时不可研发"}
local tableTreeLevel = {}
local tableMemberLevel = {}
local tableOfficalLevel = {}
local tableMessLevel = {}
local tableDonateLevel = {}
local tableShopLevel = {}
local tableYongLevel = {}
local tableSpiritLevel = {}
local tableTaskLevel = {}
local tablePrisonLevel = {}
local tableBattleLevel = {}
local tableLevelData = {}

local CreateCommonInfoWidget 	= CorpsLogic.CreateCommonInfoWidget
local GetTabSPData = DobkData.GetTabSPData
local GetItemNum = DobkLogic.GetItemNum
local GetItemName  = DobkData.GetItemName
local GetItemCount = DobkData.GetItemCount
local GetItemNeedCount = DobkData.GetItemNeedCount
local CheckBDobk = DobkLogic.CheckBDobk
local GetScienceTabData = CorpsScienceData.GetTabData
local GetScienceName = CorpsScienceData.GetScienceName
local GetSortScienceTypeList = CorpsScienceData.GetSortScienceTypeList
local GetSortList = CorpsScienceData.GetSortList
local GetScienceEffect = CorpsScienceData.GetScienceEffect
local CheckScienceID = CorpsScienceLogic.CheckScienceID
local GetScienceTypeByID = CorpsScienceData.GetScienceTypeByID
local GetScienceCurCount = CorpsScienceData.GetScienceCurCount--得到当前次数
local GetSItemNeedCount = CorpsScienceData.GetSItemNeedCount -- 得到需要的次数
local GetScienceZhuci = CorpsScienceData.GetScienceZhuci
local GetScienceAmountByID = CorpsScienceData.GetScienceAmountByID--得到已经注资次数
local GetScienceTimeByID = CorpsScienceData.GetScienceTimeByID -- 得到当前科技研发的时间
local GetScienceIconImg  = CorpsScienceData.GetScienceIconImg

local tableTreeData 		= {}
local tablePersonNumData 	= {}
local tableOfficalData 		= {}
local tableMessData 		= {}
local tableDonateData 		= {}
local tableShopData 		= {}
local tableYongBingData 	= {}
local tableSpiritData 		= {}
local tableTaskData 		= {}
local tableRandomData 		= {}
local tablePrisonData       = {}
local tabTotal = {}
local function initData(  )
	m_teachnologyLayer 		= nil
	m_listView          	= nil
	m_img_select			= nil
	m_type              	= nil
	l_HightLevel            = nil
	m_org_select_id       	= 1
	m_right_count           = 0
	m_left_count            = 0
	image_flag 				= nil
	l_level                 = nil
	l_name                  = nil
	bar_count_sp            = nil
	percent                 = nil
	nCurCount               = nil
	nNeedCount              = nil
	teach_isTeachText       = nil
	num 					= 1
	label_word            	= nil
	label_seliver        	= nil
	label_silverNum       	= nil
	label_gold            	= nil
	Label_goldNum         	= nil
	label_countdown       	= nil
	label_Needtime        	= nil
	label_isTeach         	= nil
	label_needLevel         = nil
	-- btn_teach               = nil
	m_select_idNum          = nil
	scienceValue            = nil
	m_timeSHand              = nil
	is_ShowScience          = nil
	Panel_time              = nil
	Panel_tech              = nil
	Panel_money             = nil
	Panel_limit             = nil
	m_CurrentType           = nil
	CurNum                  = nil
	m_ScienceType           = nil
	S_UpT                   = nil
	pItemWidget             = nil
	n_golbPosition          = 0
	nums                    = 0
	is_firsh                = 0
	cut_time                = 0
	is_selectID             = 0
	tableTreeLevel = {}
	tableMemberLevel = {}
	tableOfficalLevel = {}
	tableMessLevel = {}
	tableDonateLevel = {}
	tableShopLevel = {}
	tableYongLevel = {}
	tableSpiritLevel = {}
	tableTaskLevel = {}
	tableEventLevel = {}
	tablePrisonLevel = {}
	tableBattleLevel = {}
	tablePrisonData  = {}
	listScienceTypeData = {}
	totalTable = {}
	tableLevelData = {}
	tabTotal = {}


end

local function GetData(  )
	-- local tabTotal = {}
	tabTotal = CorpsScienceData.GetScienceInfo()
	tableTreeData 		= tabTotal[1]
	tablePersonNumData 	= tabTotal[2]
	tableOfficalData 	= tabTotal[3]
	tableMessData 		= tabTotal[4]
	tableDonateData 	= tabTotal[5]
	tableShopData 		= tabTotal[6]
	tableYongBingData 	= tabTotal[7]
	tableSpiritData 	= tabTotal[8]
	tableTaskData 		= tabTotal[9]
	tablePrisonData     = tabTotal[10]


	tableLevelData 		= CorpsData.GetScienceLevel()
	tableTreeLevel 		= tableLevelData[1]
	tableMemberLevel 	= tableLevelData[2]
	tableOfficalLevel 	= tableLevelData[3]
	tableMessLevel 		= tableLevelData[4]
	tableDonateLevel 	= tableLevelData[5]
	tableShopLevel 		= tableLevelData[6]
	tableYongLevel 		= tableLevelData[7]
	tableSpiritLevel 	= tableLevelData[8]
	tableTaskLevel 		= tableLevelData[9]
	tablePrisonLevel 	= tableLevelData[10]

end


local function GetConteobiled(  )
	local function GetSuccessCallback(  )
		local tableMoney = CorpsData.GetCorpsInfo()
		for key,value in pairs(tableMoney) do
			CorpsTopLayer.SetCorpsMoney(value[11])
			-- CorpsTopLayer.SetContribute(value[10])
		end
	end
	Packet_CorpsGetInfo.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsGetInfo.CreateStream())
end

local function _Click_return_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then	
		AudioUtil.PlayBtnClick()
		if m_timeSHand ~= nil then
			m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
			m_timeSHand = nil
		end
		GetConteobiled()
		m_teachnologyLayer:setVisible(false)
		m_teachnologyLayer:removeFromParentAndCleanup(true)
		m_teachnologyLayer = nil
		
	end
end

function DestorySceneLayer(  )
	AudioUtil.PlayBtnClick()
	if m_timeSHand ~= nil then
		m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
		m_timeSHand = nil
	end
	-- GetConteobiled()
	m_teachnologyLayer:setVisible(false)
	m_teachnologyLayer:removeFromParentAndCleanup(true)
	m_teachnologyLayer = nil
end

--通过科技ID获取该科技的信息，及该科技的等级
local function GetScienceTypeDB(  )
	local m_selValue = nil
	if m_org_select_id == 1 then
		m_selValue = tableTreeData[tableTreeLevel.m_nLevel]
		n_level = tableTreeLevel.m_nLevel
	elseif m_org_select_id == 2 then
		m_selValue = tablePersonNumData[tableMemberLevel.m_nLevel]
		n_level = tableMemberLevel.m_nLevel
	elseif m_org_select_id == 3 then
		m_selValue = tableOfficalData[tableOfficalLevel.m_nLevel]
		n_level = tableOfficalLevel.m_nLevel
	elseif m_org_select_id == 4 then
		m_selValue = tableMessData[tableMessLevel.m_nLevel]
		n_level = tableMessLevel.m_nLevel
	elseif m_org_select_id == 5 then
		m_selValue = tableDonateData[tableDonateLevel.m_nLevel]
		n_level = tableDonateLevel.m_nLevel
	elseif m_org_select_id == 6 then
		m_selValue = tableShopData[tableShopLevel.m_nLevel]
		n_level = tableShopLevel.m_nLevel
	elseif m_org_select_id == 7 then
		m_selValue = tableYongBingData[tableYongLevel.m_nLevel]
		n_level = tableYongLevel.m_nLevel
	elseif m_org_select_id == 8 then
		m_selValue = tableSpiritData[tableSpiritLevel.m_nLevel]
		n_level = tableSpiritLevel.m_nLevel
	elseif m_org_select_id == 9 then
		m_selValue = tableTaskData[tableTaskLevel.m_nLevel]
		n_level = tableTaskLevel.m_nLevel
	elseif m_org_select_id == 10 then
		m_selValue = tablePrisonData[tablePrisonLevel.m_nLevel] --tableEventLevel
		n_level = tablePrisonLevel.m_nLevel
	end
	return m_selValue,n_level
end

local function CheckPanelStatus( nIndex )
	
	m_CurrentType = nIndex
	--local m_selValue = CorpsScienceData.GetArrayData(m_org_select_id)
	if m_CurrentType == ScienceStateType.Zhuzi then
		Panel_money:setVisible(true)
		Panel_time:setVisible(false)
		Panel_limit:setVisible(false)
		Panel_tech:setVisible(false)
	elseif m_CurrentType == ScienceStateType.Yanfa then
		Panel_tech:setVisible(true)
		Panel_time:setVisible(false)
		Panel_limit:setVisible(false)
		Panel_money:setVisible(false)
	elseif m_CurrentType == ScienceStateType.lijiwangcheng then
		Panel_tech:setVisible(false)
		Panel_time:setVisible(true)
		Panel_limit:setVisible(false)
		Panel_money:setVisible(false)
	elseif m_CurrentType == ScienceStateType.bukeyanfa then
		Panel_tech:setVisible(false)
		Panel_time:setVisible(false)
		Panel_limit:setVisible(true)
		Panel_money:setVisible(false)
	else
		Panel_tech:setVisible(false)
		Panel_time:setVisible(false)
		Panel_limit:setVisible(false)
		Panel_money:setVisible(false)
	end
end

function CountDownTime( Ss_UpT )
	--local S_UpT = 100
	if m_teachnologyLayer == nil then
		return
	end
	if m_timeSHand ~= nil then
		m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
		m_timeSHand = nil 
	end
	local s_hour = math.floor(Ss_UpT/3600)
	local s_minute = math.floor(Ss_UpT/60) - s_hour*60
	local s_second = Ss_UpT - s_minute*60 - s_hour*3600
	local function ShowTime(  )
		if string.len(s_second) == 1 then
			s_second = "0"..s_second
		end
		if string.len(s_minute) == 1 then
			 s_minute = "0"..s_minute
		end
		if string.len(s_hour) == 1 then
			s_hour = "0"..s_hour
		end
		label_Needtime:setText(s_hour..":"..s_minute..":"..s_second)
	end
	ShowTime()
	if tonumber(Ss_UpT) ~= 0 then
	local function UpTime( dt )
		s_second = s_second - 1
		if s_second == -1 then
			if s_minute ~= -1 or s_hour ~= -1 then
				s_minute = s_minute - 1
				s_second = 59
				if s_minute == -1 then
					if s_hour ~= -1 then
						s_hour = s_hour - 1
						s_minute = 59
						if s_hour == -1 then
							if m_timeSHand ~= nil then
								m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
								m_timeSHand = nil
								LoadSelectedIcon()
								bar_count_sp:setPercent(0)
								local btn_teach = tolua.cast(m_teachnologyLayer:getWidgetByName("Button_btn"),"ImageView")
								local str_btn = btn_teach:getChildByTag(TAG_LABEL_BUTTON)
								-- LabelLayer.setText(str_btn,"注资")
								Panel_tech:setVisible(false)
								Panel_time:setVisible(false)
								Panel_limit:setVisible(false)
								Panel_money:setVisible(true)
								TipLayer.createTimeLayer("科技升级成功!!!")
							end
							s_hour = 0
							s_minute = 0
							s_second = 0
						end
					end
				end
			end
		end
		--s_second = s_second..""
		--s_minute = s_minute..""
		--s_hour = s_hour..""
		if string.len(s_second) == 1 then
			s_second = "0"..s_second
		end
		if string.len(s_minute) == 1 then
			 s_minute = "0"..s_minute
		end
		if string.len(s_hour) == 1 then
			s_hour = "0"..s_hour
		end
		label_Needtime:setText(s_hour..":"..s_minute..":"..s_second)
	end
	m_timeSHand = m_teachnologyLayer:getScheduler():scheduleScriptFunc(UpTime, 1, false)
	else
		if m_timeSHand ~= nil then
		m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
		m_timeSHand = nil 
		end
		bar_count_sp:setPercent(0)
	end
end

function UpdateCutTime( ntime )
	cut_time = ntime
	if m_teachnologyLayer == nil then
		return
	end
	if m_timeSHand ~= nil then
		m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
		m_timeSHand = nil 
	end

	CountDownTime(ntime)
end

function LoadSelectedIcon(  )
	local img_select_teach = tolua.cast(m_teachnologyLayer:getWidgetByName("Image_equip"),"ImageView")

	local img_middle = tolua.cast(m_teachnologyLayer:getWidgetByName("Image_middlebg"),"ImageView")

	local teach_level = tolua.cast(m_teachnologyLayer:getWidgetByName("Label_Level"),"Label")--GetItemName(m_org_select_id)
	local teach_isTeach = tolua.cast(m_teachnologyLayer:getWidgetByName("Label_IsTech"),"Label")
	local teach_explain = tolua.cast(m_teachnologyLayer:getWidgetByName("Label_TechExplain"),"Label")
	local m_selValue = GetScienceTypeDB()
	local ItemPath = CorpsScienceData.GetItemPath(m_selValue[3])
	img_select_teach:loadTexture(ItemPath)
	teach_explain:setText(m_selValue[5])
	teach_level:setText("Lv:"..m_selValue[2])
	--local teach_isTeachText = LabelLayer.createStrokeLabel(24,CommonData.g_FONT1,scienceValue[4],ccp(0,0),COLOR_Black,ccc3(255,87,35),true,ccp(0,0),2)--99,216,53
	
	----需要添加判断是否满足科研的条件,如果不满足则显示不能研发同时研发按钮消失不见
 	-- teach_isTeachText = nil
	teach_isTeachText = LabelLayer.createStrokeLabel(24,CommonData.g_FONT3,"可研发",ccp(5,0),COLOR_Black,ccc3(99,216,53),true,ccp(0,-2),2)

	AddLabelImg(teach_isTeachText,1,teach_isTeach)
	---------------------------------------------------------------------------------------------------------------
	
	local img_barbg = tolua.cast(m_teachnologyLayer:getWidgetByName("Image_bar"),"ImageView")
	bar_count_sp = tolua.cast(m_teachnologyLayer:getWidgetByName("ProgressBar_5"),"LoadingBar")
	local img_barBtom = tolua.cast(m_teachnologyLayer:getWidgetByName("Image_bar"),"ImageView")
	local bar_line = img_barbg:getContentSize()

	local tabTotalLevel = CorpsData.GetScienceLevel()
	local needScienceNum = tonumber(GetSItemNeedCount(m_org_select_id,tabTotalLevel[m_org_select_id]["m_nLevel"]))
	local curNumByID = tonumber(GetScienceAmountByID(m_org_select_id))
	local cur_time = tonumber(GetScienceTimeByID(m_org_select_id))
	--[[if cut_time <= cur_time then
		cur_time = cut_time
	end]]--
	percent = curNumByID / needScienceNum
	
	if percent >= 1 then
		percent = 1
		
	end
	bar_count_sp:setPercent(percent*100)
	local btn_teach = tolua.cast(m_teachnologyLayer:getWidgetByName("Button_btn"),"ImageView")
	local l_most = tolua.cast(m_teachnologyLayer:getWidgetByName("Label_most"),"Label")
	local pSpriteScience = tolua.cast(btn_teach:getVirtualRenderer(), "CCScale9Sprite")
	local t_btnStr = btn_teach:getChildByTag(TAG_LABEL_BUTTON)
	local str_status = nil
	LabelLayer.setText(t_btnStr,"")

	if tonumber(n_golbPosition) == 4 then
		btn_teach:setTag(m_org_select_id) -- 101
		btn_teach:setTouchEnabled(false)
		Scale9SpriteSetGray(pSpriteScience,1)
		-- btn_teach:addTouchEventListener(_Click_TeachBtn_CallBack)
		LabelLayer.setColor(t_btnStr,ccc3(220,220,220))
	else
		btn_teach:setTag(m_org_select_id)
		btn_teach:setTouchEnabled(true)
		btn_teach:setTag(1)
		Scale9SpriteSetGray(pSpriteScience,0)
		LabelLayer.setColor(t_btnStr,ccc3(255,245,126))
		-- btn_teach:addTouchEventListener(_Click_TeachBtn_CallBack)
	end

	if tonumber(needScienceNum) == 0  then
		if tonumber(m_org_select_id) == 1 and tonumber(needScienceNum) == 10 then
			bar_count_sp:setPercent(0)
			img_barBtom:setVisible(false)
			btn_teach:setVisible(false)
			l_most:setVisible(true)
			btn_teach:setTouchEnabled(false)
			l_HightLevel:setVisible(true)
			CheckPanelStatus(6)
			LabelLayer.setText(teach_isTeachText,"科技以达到最高级")
		else
			bar_count_sp:setPercent(0)
			img_barBtom:setVisible(false)
			btn_teach:setVisible(false)
			l_most:setVisible(true)
			btn_teach:setTouchEnabled(false)
			l_HightLevel:setVisible(true)
			CheckPanelStatus(6)
			LabelLayer.setText(teach_isTeachText,"科技以达到最高级")
		end
	elseif tonumber(needScienceNum) == 10 and tonumber(m_org_select_id) == 1 then
		bar_count_sp:setPercent(0)
		img_barBtom:setVisible(false)
		btn_teach:setVisible(false)
		l_most:setVisible(true)
		btn_teach:setTouchEnabled(false)
		l_HightLevel:setVisible(true)
		CheckPanelStatus(6)
		LabelLayer.setText(teach_isTeachText,"科技以达到最高级")
	else
		img_barBtom:setVisible(true)
		l_most:setVisible(false)
		btn_teach:setVisible(true)
		btn_teach:setTouchEnabled(true)
	if percent < 1 then
		if cur_time ~= 0 then
			str_status = ScienceStateType.lijiwangcheng
			CountDownTime(cur_time)
			CheckPanelStatus(ScienceStateType.lijiwangcheng)
			LabelLayer.setText(t_btnStr,"立即完成")
			LabelLayer.setText(teach_isTeachText,"研发中")
			LabelLayer.setColor(t_btnStr,ccc3(255,245,126))
			Scale9SpriteSetGray(pSpriteScience,0)
			btn_teach:setTouchEnabled(true)
			btn_teach:setTag(1)
			btn_teach:addTouchEventListener(_Click_TeachBtn_CallBack)
			bar_count_sp:setPercent(100)
		else
			str_status = ScienceStateType.Zhuzi
			LabelLayer.setText(t_btnStr,"注资")
			LabelLayer.setText(teach_isTeachText,"可注资")
			CheckPanelStatus(ScienceStateType.Zhuzi)
		end
	elseif percent >= 1 and cur_time == 0 then
		str_status = ScienceStateType.Yanfa
		CheckPanelStatus(ScienceStateType.Yanfa)
		-- bar_count_sp:setPercent(0)
		LabelLayer.setText(t_btnStr,"研发")
		LabelLayer.setText(teach_isTeachText,"可研发")
	elseif percent >= 1 and cur_time ~= 0 then
		str_status = ScienceStateType.lijiwangcheng
		CountDownTime(cur_time)
		CheckPanelStatus(ScienceStateType.lijiwangcheng)
		LabelLayer.setText(t_btnStr,"立即完成")
		LabelLayer.setText(teach_isTeachText,"研发中")
		LabelLayer.setColor(t_btnStr,ccc3(255,245,126))
		Scale9SpriteSetGray(pSpriteScience,0)
		btn_teach:setTouchEnabled(true)
		btn_teach:setTag(1)
		btn_teach:addTouchEventListener(_Click_TeachBtn_CallBack)
	end
	end
	-- print(type(str_status),str_status)
	
	local nNeedCount = tonumber(needScienceNum) - 1
	bar_count_sp:removeAllChildrenWithCleanup(true)
	local n_width = 337/needScienceNum
	if tonumber(needScienceNum) > 1 then
		for i=1,nNeedCount do
			--添加小竖线
			local image_flag = ImageView:create()
			image_flag:loadTexture("Image/imgres/corps/flap.png")
			image_flag:setPosition(ccp( -168+n_width*i,bar_count_sp:getPositionY()))
			bar_count_sp:addChild(image_flag,i,i)
		end
	end
end

function UpdateTime(  )
	if m_teachnologyLayer == nil then
		return
	end
	if m_timeSHand ~= nil then
		m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
		m_timeSHand = nil 
	end
	local function GetSuccessCallback(  )
		sssS_UpT = CorpsScienceData.GetScienceUpT()
		CountDownTime(sssS_UpT)
	end
	Packet_CorpsScienceUp.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_CorpsScienceUp.CreatePacket(m_org_select_id))
end

function GetHandTime(  )
	return m_timeSHand
end

function GetSceneLayer(  )
	return m_teachnologyLayer
end

function GetUpDate( TnType )
	if m_teachnologyLayer == nil then
		return 
	end
	if tonumber(TnType) == tonumber(m_org_select_id) then
		local btn_teach = tolua.cast(m_teachnologyLayer:getWidgetByName("Button_btn"),"ImageView")
		local t_btnStr = btn_teach:getChildByTag(TAG_LABEL_BUTTON)
		local m_selValue = GetScienceTypeDB()
		local nNum = tonumber(m_selValue[8])
		local CurNumTab = {}
		CurNumTab = GetScienceZhuci()
		CurNum = CurNumTab[2]
		-- print("当前次数:",CurNum)
		if nNum == 0 or nNum == 1 then
			percent = 1
		else
			percent = CurNum/nNum
		end
		bar_count_sp:setPercent(percent*100)
		if percent == 1 then
			CheckPanelStatus(ScienceStateType.Yanfa)
			LabelLayer.setText(t_btnStr,"研发")
			LabelLayer.setText(teach_isTeachText,"可研发")
			m_CurrentType = ScienceStateType.Yanfa
			num = 1
		end
	end
end

function GetUpdateee( sS_UpTtt )
	if m_teachnologyLayer == nil then
		return
	end
	if m_timeSHand ~= nil then
		m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
		m_timeSHand = nil 
	end
	local btn_teach = tolua.cast(m_teachnologyLayer:getWidgetByName("Button_btn"),"ImageView")
	local s_btnText = btn_teach:getChildByTag(TAG_LABEL_BUTTON)
	local pSpriteScience = tolua.cast(btn_teach:getVirtualRenderer(), "CCScale9Sprite")
	btn_teach:setTag(1)
	Scale9SpriteSetGray(pSpriteScience,0)
	LabelLayer.setColor(s_btnText,ccc3(255,245,126))
	
	CheckPanelStatus(ScienceStateType.lijiwangcheng)
	LabelLayer.setText(s_btnText,"立即完成")
	LabelLayer.setText(teach_isTeachText,"研发中")
	m_CurrentType = ScienceStateType.lijiwangcheng
	CountDownTime(sS_UpTtt)
end

--研发注资点击回调事件
function _Click_TeachBtn_CallBack( sender,eventType )
	if eventType == TouchEventType.ended then
		AudioUtil.PlayBtnClick()
		local btn = tolua.cast(sender,"Button")
		local pSpriteScience = tolua.cast(btn:getVirtualRenderer(), "CCScale9Sprite")
		local n_tag = btn:getTag()
		local s_btnText = btn:getChildByTag(TAG_LABEL_BUTTON)
		local str = LabelLayer.getText(s_btnText)
		local m_selValue = GetScienceTypeDB()
		local nNum = tonumber(m_selValue[8])
		local sS_UpT = 0
		if n_tag < 100 then
		
			if m_CurrentType == ScienceStateType.Zhuzi then
				CheckPanelStatus(ScienceStateType.Zhuzi)
				
				--军团注资协议
				--[[local pTips = TipCommonLayer.CreateTipLayerManager()
					pTips:ShowCommonTips(1218,nil)
					pTips = nil]]--
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					GetConteobiled()
					local CurNumTab = {}
					CurNumTab = GetScienceZhuci()
					CurNum = CurNumTab[2]
					-- print("当前次数:",CurNum)
					if nNum == 0 or nNum == 1 then
						percent = 1
					else
						percent = CurNum/nNum
					end
					bar_count_sp:setPercent(percent*100)
					if percent == 1 then
						CheckPanelStatus(ScienceStateType.Yanfa)
						LabelLayer.setText(s_btnText,"研发")
						LabelLayer.setText(teach_isTeachText,"可研发")
						m_CurrentType = ScienceStateType.Yanfa
						num = 1
					end
				end	
				Packet_CorpsASSET_INJECTION.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsASSET_INJECTION.CreatePacket(m_org_select_id))
				NetWorkLoadingLayer.loadingShow(true)
			elseif m_CurrentType == ScienceStateType.Yanfa then
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					CorpsScene.GetConteobile(1)
					ssS_UpT = CorpsScienceData.GetScienceUpT()
					CheckPanelStatus(ScienceStateType.lijiwangcheng)
					if tonumber(n_golbPosition) == 4 then
						btn:setTag(1)
						Scale9SpriteSetGray(pSpriteScience,1)
						LabelLayer.setColor(s_btnText,ccc3(255,245,126))
					else
						btn:setTag(1)
						Scale9SpriteSetGray(pSpriteScience,0)
						LabelLayer.setColor(s_btnText,ccc3(255,245,126))
					end
					LabelLayer.setText(s_btnText,"立即完成")
					LabelLayer.setText(teach_isTeachText,"研发中")
					m_CurrentType = ScienceStateType.lijiwangcheng
					CountDownTime(ssS_UpT)
					-- GetConteobile()
				end
				Packet_CorpsScienceUp.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_CorpsScienceUp.CreatePacket(m_org_select_id))
				NetWorkLoadingLayer.loadingShow(true)
				
			elseif m_CurrentType == ScienceStateType.lijiwangcheng then
				-- print(str,"研发中......")
				local t_UpT = tonumber(GetScienceTimeByID(m_org_select_id))
				local m_tab,n_level = GetScienceTypeDB()
				
				local function GetSuccessCallback(  )
					NetWorkLoadingLayer.loadingHideNow()
					if m_timeSHand ~= nil then
						m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
						m_timeSHand = nil
					end
					CorpsScienceNode.createSpeedUpLayer(m_org_select_id,t_UpT,n_level)
				end	
				Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
				network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
				NetWorkLoadingLayer.loadingShow(true)
			end	
		else
			local pTips = TipCommonLayer.CreateTipLayerManager()
			pTips:ShowCommonTips(1504,nil)
			pTips = nil		
		end
		
	end
end

local function ShowButton(  )
	Panel_limit = tolua.cast(m_teachnologyLayer:getWidgetByName("Panel_limit"),"Layout")
	Panel_money = tolua.cast(m_teachnologyLayer:getWidgetByName("Panel_money"),"Layout")
	Panel_time  = tolua.cast(m_teachnologyLayer:getWidgetByName("Panel_time"),"Layout")
	Panel_tech  = tolua.cast(m_teachnologyLayer:getWidgetByName("Panel_tech"),"Layout")

	label_needLevel = tolua.cast(Panel_limit:getChildByName("Label_Needlevel"),"Label")
	label_word = tolua.cast(Panel_money:getChildByName("Label_37"),"Label")
	-- label_seliver = tolua.cast(Panel_money:getChildByName("Label_seliver"),"Label")
	label_silverNum = tolua.cast(Panel_money:getChildByName("Label_silverNum"),"Label")
	-- label_gold = tolua.cast(Panel_money:getChildByName("Label_gold"),"Label")
	label_goldNum = tolua.cast(Panel_money:getChildByName("Label_goldNum"),"Label")
	local img_silver = tolua.cast(Panel_money:getChildByName("Image_sliver"),"ImageView")
	local img_gold = tolua.cast(Panel_money:getChildByName("Image_gold"),"ImageView")
	label_countdown = tolua.cast(Panel_time:getChildByName("Label_countdown"),"Label")
	label_Needtime = tolua.cast(Panel_time:getChildByName("Label_Needtime"),"Label")
	label_isTeach = tolua.cast(Panel_tech:getChildByName("Label_canTech"),"Label")


	local m_selTypeDB = GetScienceTypeDB()
	local n_consumDB = ConsumeLogic.GetExpendData(tonumber(m_selTypeDB[7]))
	
	local m_consunDB1 = n_consumDB.TabData[1]
	img_silver:loadTexture(m_consunDB1["IconPath"])
	label_silverNum:setText(m_consunDB1.ItemNeedNum)
	img_gold:setVisible(false)
	label_goldNum:setVisible(false)
	
end

local function _Item_Full( tempID,sender )
	if tonumber(tempID) ~= 1 then
		senderControl = sender
	end
end

local function UpdateControl( pControl,tabItem )
	--if pControl == nil then
		--pControl = tolua.cast(pItemWidget:getChildByName("Image_pcontrol"), "ImageView")
	--end
	local nType_tech = nil
	nType_tech = tabItem["m_nType"]
	local nType_level = nil
	nType_level = tabItem["m_nLevel"]
	local tav = tabTotal[nType_tech]
	local tabLevel = {}
	tabLevel = tav[nType_level]
	
	l_level = tolua.cast(pControl:getChildByName("Label_4"), "Label")
	l_name = tolua.cast(pControl:getChildByName("Label_name"), "Label")

	l_level:setText(string.format("Lv.%d",tabItem["m_nLevel"]))
	l_name:setText(tabLevel[4])
end

local function _Item_CallBack( tempID,sender )
	if tonumber(tempID) ~= m_org_select_id then
		AudioUtil.PlayBtnClick()
		senderControl = sender
		local function GetSuccessCallback(  )
			if m_timeSHand ~= nil then
				m_teachnologyLayer:getScheduler():unscheduleScriptEntry(m_timeSHand)
				m_timeSHand = nil 
			end
			num = 1
			CurNum = 0
			m_org_select_id = tonumber(tempID)
			-- print("tag 值:",m_org_select_id,m_img_select)
			if m_img_select ~= nil then
				m_img_select:removeFromParentAndCleanup(true)
				m_img_select = nil
			end
			local item_sender = m_listView:getItem(m_org_select_id-1)
			local pSender = tolua.cast(item_sender:getChildByName("Image_pcontrol"), "ImageView")
			
			is_selectID = m_org_select_id
			m_img_select = ImageView:create()
			m_img_select:loadTexture("Image/imgres/item/selected_icon.png")
			AddLabelImg(m_img_select,1,pSender)
			LoadSelectedIcon()
			ShowButton()
		end
		Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
		network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
		
	end
end

local function _Btn_Right_CallBack(  )
	AudioUtil.PlayBtnClick()
	local arrayItems = m_listView:getItems()
	if m_right_count < arrayItems:count() then
		m_right_count = m_right_count + 1
		m_listView:scrollToPercentHorizontal(55*m_right_count,0.1,true)
	end
end

local function _Btn_Left_CallBack(  )
	AudioUtil.PlayBtnClick()
	if m_right_count > 0 then
		m_listView:scrollToPercentHorizontal(0,0.1,false)
		m_right_count = m_right_count - 1
		m_left_count = m_left_count + 1
	end
end

local function CreateShopItemWidget( pCorpsItemTemp )
    local pCorpsItem = pCorpsItemTemp:clone()
    local peer = tolua.getpeer(pCorpsItemTemp)
    tolua.setpeer(pCorpsItem, peer)
    return pCorpsItem
end

local function loadUpdateControl( pControl,tabItem )
	if pControl == nil then
		pControl = tolua.cast(pItemWidget:getChildByName("Image_pcontrol"), "ImageView")
	end
	local nType_tech = nil
	nType_tech = tabItem["m_nType"]
	local nType_level = nil
	nType_level = tabItem["m_nLevel"]
	pControl:setTag(TAG_GRID_ADD + tabItem["m_nType"])
	pControl:setTouchEnabled(true)
	local tav = tabTotal[nType_tech]
	local tabLevel = {}
	tabLevel = tav[nType_level]
	
	local pathTech = GetScienceIconImg(tabLevel[3])
	local pImgItemIcon = tolua.cast(pControl:getChildByName("Image_item"), "ImageView")
	local img_kuang = tolua.cast(pControl:getChildByName("Image_3"), "ImageView")
	pImgItemIcon:loadTexture(pathTech)
	CreateItemCallBack(pControl,false,_Item_CallBack,nil)

	-- if l_level == nil then 
		l_level = tolua.cast(pControl:getChildByName("Label_4"), "Label")
		l_name = tolua.cast(pControl:getChildByName("Label_name"), "Label")
	-- end
	_Item_Full(TAG_GRID_ADD + tabItem["m_nType"],pControl)
	

	UpdateControl(pControl,tabItem)
end

--添加科技滑动部分
function ShowTechList(  )
	m_listView = tolua.cast(m_teachnologyLayer:getWidgetByName("ListView_TechType"),"ListView")
	m_listView:setClippingType(1)
	m_listView:setItemsMargin(-10)
	tabTotal = CorpsScienceData.GetScienceInfo()
	tableLevelData 		= CorpsData.GetScienceLevel()
	local pItemTemp = GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTechItem.json")
	for key,value in pairs(tableLevelData) do
		if tonumber(value["m_nType"]) <= 10 then
			pItemWidget =  CreateShopItemWidget(pItemTemp)
			local pControl_1 = tolua.cast(pItemWidget:getChildByName("Image_pcontrol"), "ImageView")
			loadUpdateControl(pControl_1,value)
			if tonumber(m_org_select_id) == 1 then
				senderControl = pControl_1
			end
			m_listView:pushBackCustomItem(pItemWidget)
		end
	end

	m_listView:setItemsMargin(20)
	local item_1 = m_listView:getItem(nums)
	--if item_1 ~= nil then
		if m_img_select == nil then
			--nums = 0		
			local item_11 = tolua.cast(item_1:getChildByName("Image_pcontrol"), "ImageView")
			m_img_select = ImageView:create()
			m_img_select:loadTexture("Image/imgres/item/selected_icon.png")
			-- m_img_select:setPosition(ccp(62,55))
			AddLabelImg(m_img_select,1,item_11)
		end
  	--end
	--左右按键
	local btn_left = tolua.cast(m_teachnologyLayer:getWidgetByName("Image_left"),"ImageView")
	btn_left:setTouchEnabled(true)
	CreateItemCallBack(btn_left,false,_Btn_Left_CallBack,nil)
	local btn_right = tolua.cast(m_teachnologyLayer:getWidgetByName("Image_right"),"ImageView")
	btn_right:setTouchEnabled(true)
	CreateItemCallBack(btn_right,false,_Btn_Right_CallBack,nil)

	m_listView:scrollToPercentHorizontal(20*m_org_select_id,0.1,false)
	LoadSelectedIcon()

end

local function ButttonCall(  )
	local btn_teach = tolua.cast(m_teachnologyLayer:getWidgetByName("Button_btn"),"ImageView")
	l_HightLevel = tolua.cast(m_teachnologyLayer:getWidgetByName("Label_most"),"Label")
	l_HightLevel:setVisible(false)
	local pSpriteScience = tolua.cast(btn_teach:getVirtualRenderer(), "CCScale9Sprite")

	local temp = btn_teach:getChildByTag(TAG_LABEL_BUTTON)

	local BtnText = LabelLayer.createStrokeLabel(26,CommonData.g_FONT3,"注资",ccp(0,0),COLOR_Black,ccc3(255,245,126),true,ccp(0,0),0)
	if temp == nil then
		btn_teach:addChild(BtnText,TAG_LABEL_BUTTON,TAG_LABEL_BUTTON)
	end
	
	if tonumber(n_golbPosition) == 4 then
		btn_teach:setTag(m_org_select_id) -- 101
		btn_teach:setTouchEnabled(false)
		Scale9SpriteSetGray(pSpriteScience,1)
		-- btn_teach:setTouchEnabled(false)
		btn_teach:addTouchEventListener(_Click_TeachBtn_CallBack)
		LabelLayer.setColor(BtnText,ccc3(220,220,220))
	else
		btn_teach:setTag(m_org_select_id)
		btn_teach:setTouchEnabled(true)
		btn_teach:addTouchEventListener(_Click_TeachBtn_CallBack)
	end
end

function cleanListView( pListView )
	if pListView:getItems():count()~=0 then
		pListView:removeAllItems()
	end 
end

function initUI(  )
	m_img_select = nil
	if m_teachnologyLayer == nil then
		return
	else
		local m_listView = tolua.cast(m_teachnologyLayer:getWidgetByName("ListView_TechType"),"ListView")
		cleanListView(m_listView)
		GetData()

		ShowButton()
		ShowTechList()
	end
end

function createTeachLayer( n_selectId )
	initData()
	-- GetData()
	m_teachnologyLayer = TouchGroup:create()
	m_teachnologyLayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/CorpsTechnology.json"))

	----获得成员在军团中的职位权限
	n_golbPosition = CorpsScene.n_GolbPosition
	m_type = DOBK_TYPE.DOBK_TYPE_SW
	nums  = n_selectId
	is_firsh = n_selectId + 1
	m_org_select_id = n_selectId + 1
	is_selectID = m_org_select_id
	-- m_ScienceType = 1
	m_CurrentType = 1
	local btn_return = tolua.cast(m_teachnologyLayer:getWidgetByName("Button_return"),"Button")
	btn_return:addTouchEventListener(_Click_return_CallBack)
	ButttonCall()
	
	initUI()
	-- ButttonCall()

	CheckPanelStatus(m_CurrentType)

	return m_teachnologyLayer
end

function UpdateScienceLevelUI( typeTab )
	local function GetSuccessCallback(  )
		tabTotal = {}
		tableLevelData = {}
		GetData()
		local tabTypeData = {}
		tabTypeData["m_nType"] = typeTab[1]
		tabTypeData["m_nLevel"] = typeTab[2]
		if m_teachnologyLayer == nil then
			return 
		end
		if tonumber(m_org_select_id) == 1 then
			local pItemWidgets = m_listView:getItem(0)
			local pControl_1 = tolua.cast(pItemWidgets:getChildByName("Image_pcontrol"), "ImageView")
			senderControl = pControl_1
		end
		local pControl_1 = tolua.cast(pItemWidget:getChildByName("Image_pcontrol"), "ImageView")
		UpdateControl(senderControl,tabTypeData)
		LoadSelectedIcon()
		-- initUI()
	end
	Packet_ScienceLevel.SetSuccessCallBack(GetSuccessCallback)
	network.NetWorkEvent(Packet_ScienceLevel.CreatePacket())
end