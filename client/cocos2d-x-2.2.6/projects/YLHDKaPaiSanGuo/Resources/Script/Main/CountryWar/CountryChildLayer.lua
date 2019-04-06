-- for CCLuaEngine traceback
require "Script/Common/Common"
require "Script/Fight/simulationStl"
require "Script/Main/CountryWar/CountryWarData"
require "Script/Main/CountryWar/CountryWarLogic"
require "Script/Main/CountryWar/CountryWarRaderLayer"
require "Script/Main/CountryWar/ClickCityLayer"
require "Script/Main/CountryWar/CountryWarDef"
require "Script/Main/CountryWar/PathFinding"
require "Script/Main/CountryWar/CityNode"
require "Script/Main/Chat/ChatShowLayer"
require "Script/Main/Mission/MissionLayer"


module("CountryChildLayer", package.seeall)

local m_ChildLayer		= nil
local m_SelectImg       = nil
local m_Type 			= nil
local m_Str  			= nil
local m_nCityID 		= nil
local m_State 			= nil
local m_Tab 			= nil
local m_nHanderTime 	= nil
local m_nDelayTime 		= nil
local m_BloodConsNum    = nil
local m_BloodConsType   = nil
local m_BloodEnough		= nil


local StrokeLabel_createStrokeLabel 		= 	LabelLayer.createStrokeLabel 

local CopyItemWidget						= 	CountryWarLogic.CopyItemWidget
local numIsIntab							=	CountryWarLogic.numIsIntab
local JudgeBloodWarByTeam					=	CountryWarLogic.JudgeBloodWarByTeam

local GetGeneralResId 						=	CountryWarData.GetGeneralResId
local GetGeneralHeadPath					=	CountryWarData.GetGeneralHeadPath
local GetTeamTab 							=	CountryWarData.GetTeamTab
local GetTeamCount 							=	CountryWarData.GetTeamCount
local GetTeamLevel 							=	CountryWarData.GetTeamLevel
local GetTeamFace 							=	CountryWarData.GetTeamFace
local GetTeamName 							=	CountryWarData.GetTeamName
local GetTeamBlood 							=	CountryWarData.GetTeamBlood
local GetTeamRes							=	CountryWarData.GetTeamRes
local GetTeamBloodCityTime 					= 	CountryWarData.GetTeamBloodCityTime
local GetPlayerCountry 						=	CountryWarData.GetPlayerCountry
local GetBloodOrDefenseTime 				=	CountryWarData.GetBloodOrDefenseTime
local GetCityCountry						=	CountryWarData.GetCityCountry
local GetTeamID								=	CountryWarData.GetTeamID
local GetBloodConsID						=	CountryWarData.GetBloodConsID
local GetExpendData							=	ConsumeLogic.GetExpendData
local GetConsNeedNum						=	CountryWarData.GetConsNeedNum
local GetConsName							=	CountryWarData.GetConsName
local GetTeamCell							=	CountryWarData.GetTeamCell
local GetTeamLife							=	CountryWarData.GetTeamLife
local GetPathByImageID						=	CountryWarData.GetPathByImageID

local function InitVars()
	if m_nHanderTime ~= nil then
		m_ChildLayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end
	m_ChildLayer		= nil
	m_SelectImg         = nil
	m_Type 				= nil
	m_Str  				= nil
	m_nCityID 			= nil
	m_State 			= nil
	m_Tab 				= nil
	m_nHanderTime 		= nil
	m_nDelayTime 		= nil
	m_BloodConsNum    	= nil
	m_BloodConsType   	= nil
	m_BloodEnough		= nil
end

local E_BeginBtn = {
	E_BeginBtn_BeginWar = 1,
	E_BeginBtn_StopWar  = 2,
	E_BeginBtn_Over     = 3,
}

local function _Click_Close_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if sender:getTag() == 1 then
			m_ChildLayer:removeFromParentAndCleanup(true)
			InitVars()
		end
		if sender:getTag() == 2 then
			m_ChildLayer:setVisible(false)
			m_ChildLayer:setTouchEnabled(false)
			m_ChildLayer:setPositionX(m_ChildLayer:getPositionX() - 10000)
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function SetFightDelayTime( nSecend )
	if nSecend < 0 then return end
	m_nDelayTime = nSecend
	local strM = math.floor(nSecend/60)
	local strS = math.floor(nSecend%60)
	local strTemp = ""
	if tonumber(strM) < 10 then strM = "0" .. strM end
	if tonumber(strS) < 10 then strS = "0" .. strS end

	local Image_Bg 	  = tolua.cast(m_ChildLayer:getWidgetByName("Image_Bg"), "ImageView")
	LabelLayer.setText(Image_Bg:getChildByTag(1100),strM.."分")
	LabelLayer.setText(Image_Bg:getChildByTag(1101),strS.."秒")
	local function tick(dt)
		if m_nDelayTime == 0 then
		-- 时间到了。战斗结束
			--print("时间到了。战斗结束")
			m_ChildLayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
			m_nHanderTime = nil
		end
		m_nDelayTime = m_nDelayTime - 1
		SetFightDelayTime(m_nDelayTime)
	end
	if m_nHanderTime ~= nil then
		m_ChildLayer:getScheduler():unscheduleScriptEntry(m_nHanderTime)
		m_nHanderTime = nil
	end

	m_nHanderTime = m_ChildLayer:getScheduler():scheduleScriptFunc(tick, 1, false)
end

local function SetClickState( nState )
	for key,value in pairs(GetTeamTab()) do
		local Image_Teamer = tolua.cast(m_ChildLayer:getWidgetByName("Image_Team"..key + 1), "ImageView")
		Image_Teamer:setTouchEnabled(nState)
	end
end

local function _Click_Begin_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		local Image_Bg 	  = tolua.cast(m_ChildLayer:getWidgetByName("Image_Bg"), "ImageView")
		local pBtnBegin   = tolua.cast(m_ChildLayer:getWidgetByName("Button_1"), "Button")

		if m_State == E_BeginBtn.E_BeginBtn_BeginWar then
			--判断是否能开始血战
			if m_BloodEnough == false then
				TipLayer.createTimeLayer(GetConsName(m_BloodConsType, m_BloodConsNum).."不足",2)
				return
			end
			m_Tab = {}
			for i=1,4 do
				local Image_SelectFrame = tolua.cast(m_ChildLayer:getWidgetByName("Image_SelectFrame_"..i), "ImageView")
				if Image_SelectFrame:isVisible() == true then
					table.insert(m_Tab, i-1)
				end 
			end
			if table.getn(m_Tab) > 0 then
				--开始血战/坚守
				local function Start( isSuccess )
					if tonumber(isSuccess) == 1 then
						--开始成功
						SetClickState(false)
						--CountryWarScene.StartBloodWar(m_Tab, m_nCityID)
						CountryWarScene.SetUIBtnBloodOrDefense(true, m_Str.."中")
						local pBtnClose = tolua.cast(m_ChildLayer:getWidgetByName("Image_BtnClose"), "ImageView")
						pBtnClose:loadTexture("Image/imgres/countrywar/btn_small.png")
						pBtnClose:setTag(2)

						if pBtnBegin:getChildByTag(99) ~= nil then
							LabelLayer.setText(pBtnBegin:getChildByTag(99), "停止"..m_Str)
						end
						--设置label显示
						if Image_Bg:getChildByTag(2000) ~= nil then
							Image_Bg:getChildByTag(2000):setText("以下队伍正在"..m_Str)
						end
						if Image_Bg:getChildByTag(2001) ~= nil then
							Image_Bg:getChildByTag(2001):setVisible(false)
						end
						if Image_Bg:getChildByTag(1100) ~= nil then
							Image_Bg:getChildByTag(1100):setVisible(true)
						end
						if Image_Bg:getChildByTag(1101) ~= nil then
							Image_Bg:getChildByTag(1101):setVisible(true)
						end
						--修改按钮状态
						m_State = E_BeginBtn.E_BeginBtn_StopWar
						sender:setTag(E_BeginBtn.E_BeginBtn_StopWar)

						--开启计时
						SetFightDelayTime(30 * 60)
					else
						print("开始失败啦")
					end
					pBtnBegin:setTouchEnabled(true)
				end
				--pBtnBegin:setTouchEnabled(false)
				--开始血战和坚守多发几个参数
				--判断当前到目标成的路线是否可以血战
				local pBloodTab = {}
				for key,value in pairs(m_Tab) do

					if JudgeBloodWarByTeam(value, m_nCityID) == true then
						table.insert(pBloodTab, value)
					end

				end
				if table.getn(pBloodTab) > 0 then
					Packet_CountryWarStopHighOrder.SetSuccessCallBack(Start)
					network.NetWorkEvent(Packet_CountryWarStopHighOrder.CreatPacket(1, m_nCityID, table.getn(pBloodTab), pBloodTab))
				end
			else
				print("沒有可"..m_Str.."的队伍")
				TipLayer.createTimeLayer("沒有可"..m_Str.."的队伍",2)
			end    
		elseif m_State == E_BeginBtn.E_BeginBtn_StopWar then
			--停止血战协议
			SetClickState(false)
			local function Stop( isSuccess )
				if tonumber(isSuccess) == 1 then
					--停止血战/坚守成功
					if Image_Bg:getChildByTag(2000) ~= nil then
						Image_Bg:getChildByTag(2000):setVisible(true)
						Image_Bg:getChildByTag(2000):setText(m_Str.."已经结束")
						Image_Bg:getChildByTag(2000):setPositionX(Image_Bg:getChildByTag(2000):getPositionX() + 50)
					end
					if Image_Bg:getChildByTag(201) ~= nil then
						Image_Bg:getChildByTag(201):setPositionX(Image_Bg:getChildByTag(201):getPositionX() - 200)
					end
					if pBtnBegin:getChildByTag(99) ~= nil then
						LabelLayer.setText(pBtnBegin:getChildByTag(99), "知道了")	
					end
					if Image_Bg:getChildByTag(1100) ~= nil then
						Image_Bg:getChildByTag(1100):setVisible(false)
					end
					if Image_Bg:getChildByTag(1101) ~= nil then
						Image_Bg:getChildByTag(1101):setVisible(false)
					end
					local pBtnClose = tolua.cast(m_ChildLayer:getWidgetByName("Image_BtnClose"), "ImageView")
    				pBtnClose:setTouchEnabled(false)
    				pBtnClose:setVisible(false)

					m_State = E_BeginBtn.E_BeginBtn_Over
					sender:setTag(E_BeginBtn.E_BeginBtn_Over)
				else
					--停止血战/坚守 失败
					print("结束失败啦")
				end
				pBtnBegin:setTouchEnabled(true)
			end
			--pBtnBegin:setTouchEnabled(false)
			Packet_CountryWarStopHighOrder.SetSuccessCallBack(Stop)
			network.NetWorkEvent(Packet_CountryWarStopHighOrder.CreatPacket(0))
		elseif m_State == E_BeginBtn.E_BeginBtn_Over then
			CountryWarScene.SetUIBtnBloodOrDefense(false)
			m_ChildLayer:removeFromParentAndCleanup(true)
			InitVars()
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Select_CallBack( sender, eventType )
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		if m_SelectImg:isVisible() == false then
			m_SelectImg:setVisible(true)
		else 
			m_SelectImg:setVisible(false)
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
	end
end

local function _Click_Head_CallBack( sender, eventType )
	local Image_Bg 	  = tolua.cast(m_ChildLayer:getWidgetByName("Image_Bg"), "ImageView")
	local Image_SelectFrame = tolua.cast(m_ChildLayer:getWidgetByName("Image_SelectFrame_"..sender:getTag()), "ImageView")
	if eventType == TouchEventType.ended then
		sender:setScale(1.0)
		Image_SelectFrame:setScale(1.0)
		--判断当前队伍是否可选择

		if GetTeamLife(sender:getTag() - 1) == true then

			TipLayer.createTimeLayer("已过期,无法出战",2)
			return 
  
		end

		if GetTeamCell(sender:getTag() - 1) ~= -1 then
			TipLayer.createTimeLayer("牢狱中,无法出战",2)
			return 
		end

		if Image_SelectFrame:isVisible() == false then
			Image_SelectFrame:setVisible(true)
		else
			Image_SelectFrame:setVisible(false)
		end 
		--判断当前选择了哪些队伍
		m_BloodConsNum = 0
		for key,value in pairs(GetTeamTab()) do
			local pTeamID = GetTeamID(key)
			local Image_SelectFrame = tolua.cast(m_ChildLayer:getWidgetByName("Image_SelectFrame_"..key+1), "ImageView")
			if pTeamID > 0 and Image_SelectFrame:isVisible() == true then
				local pConsID = GetBloodConsID(pTeamID)
				local pConsTab = GetExpendData(pConsID)

				m_BloodConsNum = m_BloodConsNum + pConsTab.TabData[1].ItemNeedNum
				m_BloodEnough   = pConsTab.TabData[1].Enough
			end
		end
		if m_BloodConsNum == 0 then
			m_BloodEnough = true
		end
		if Image_Bg:getChildByTag(2001) ~= nil then 
			Image_Bg:getChildByTag(2001):setText("消耗:     "..m_BloodConsNum)
		end
	elseif  eventType == TouchEventType.began then
		sender:setScale(0.9)
		Image_SelectFrame:setScale(0.9)
	elseif eventType == TouchEventType.canceled then
		sender:setScale(1.0)
		Image_SelectFrame:setScale(1.0)
	end
end

local function CreateLabel( text, size, color, fontName, pos )
	local label	  = Label:create()
	label:setFontSize(size)
	label:setColor(color)
	label:setFontName(fontName)
	label:setPosition(pos)
	label:setText(text)
	return label
end

local function InitHead( nState, nWJTab )
	--printTab(GetTeamTab())
	--Pause()
	for key,value in pairs(GetTeamTab()) do
		local Image_Teamer = tolua.cast(m_ChildLayer:getWidgetByName("Image_Team"..key + 1), "ImageView")
		local Image_SelectFrame = tolua.cast(m_ChildLayer:getWidgetByName("Image_SelectFrame_"..key + 1), "ImageView")
		Image_Teamer:setVisible(true)

		if nState == true and nWJTab ~= nil then
			Image_SelectFrame:setVisible(false)
		else
			if GetTeamLife(key) == false and GetTeamCell(key) == -1 then 		--未过期的佣兵和不在牢狱中的佣兵在可以默认选上
				Image_SelectFrame:setVisible(true)
			end
		end

		if m_State == E_BeginBtn.E_BeginBtn_BeginWar then
			Image_Teamer:setTouchEnabled(true)
		else
			Image_Teamer:setTouchEnabled(false)
		end
		Image_Teamer:setTag(key+1)
		Image_Teamer:addTouchEventListener(_Click_Head_CallBack)
		local Image_Head   = tolua.cast(Image_Teamer:getChildByName("Image_Head"), "ImageView") 

		if key == 0 then
			local pFaceId = GetTeamFace(key)
			local pPath = GetPathByImageID( pFaceId )
			Image_Head:loadTexture( pPath )
		else
			local nHeadPath    = GetGeneralHeadPath(value["TeamRes"])
			Image_Head:loadTexture(nHeadPath)	
		end

		--是否过期
		if GetTeamLife(key) == true then
			if Image_Head:getChildByTag(99) == nil then
				local lifeImg = ImageView:create()
				lifeImg:setPosition(ccp(-8,-20))
				lifeImg:loadTexture("Image/imgres/corps/LifeEnd.png")
				Image_Head:addChild(lifeImg,1,99)
			end
		else
			if Image_Head:getChildByTag(99) ~= nil then
				Image_Head:getChildByTag(99):removeFromParentAndCleanup(true)
			end
		end
		--是否牢狱中
		if GetTeamCell(key) ~= -1 then
			local pCellBg = ImageView:create()
			pCellBg:setScale9Enabled(true)
			pCellBg:loadTexture("Image/imgres/countrywar/war_numName_bg.png")
			pCellBg:setSize(CCSize(105,34))
			pCellBg:setPosition(ccp(0,0))
			local pCellLabel = CreateLabel("牢狱中", 24, ccc3(226,55,9), CommonData.g_FONT1, ccp(0,0))
			pCellBg:addChild(pCellLabel)
			Image_Teamer:addChild(pCellBg, 2, 100)
			SpriteSetGray(pSpriteHeadImg,1)
		else
			if Image_Teamer:getChildByTag(100) ~= nil then
				Image_Teamer:getChildByTag(100):removeFromParentAndCleanup(true)
			end
			SpriteSetGray(pSpriteHeadImg,0)
		end
	end
	if nState == true and nWJTab ~= nil then
    	--有血战/坚守武将
    	for key,value in pairs(nWJTab) do
    		local Image_SelectFrame = tolua.cast(m_ChildLayer:getWidgetByName("Image_SelectFrame_"..value), "ImageView")
    		Image_SelectFrame:setVisible(true)
    	end
   	end
end

function RefreshOverUI(  )
	if m_ChildLayer ~= nil then
		if m_ChildLayer:isVisible() == false then
			m_ChildLayer:setVisible(true)
			m_ChildLayer:setTouchEnabled(true)
			m_ChildLayer:setPositionX(m_ChildLayer:getPositionX() + 10000)
		end
		local Image_Bg 	  = tolua.cast(m_ChildLayer:getWidgetByName("Image_Bg"), "ImageView")
		local pBtnBegin   = tolua.cast(m_ChildLayer:getWidgetByName("Button_1"), "Button")

		m_State = E_BeginBtn.E_BeginBtn_Over
		pBtnBegin:setTag(E_BeginBtn.E_BeginBtn_Over)

		if Image_Bg:getChildByTag(2000) ~= nil then
			Image_Bg:getChildByTag(2000):setText(m_Str.."已经结束")
			Image_Bg:getChildByTag(2000):setPositionX(Image_Bg:getChildByTag(2000):getPositionX() + 50)
		end
		if Image_Bg:getChildByTag(201) ~= nil then
			Image_Bg:getChildByTag(201):setPositionX(Image_Bg:getChildByTag(201):getPositionX() - 200)
		end
		if pBtnBegin:getChildByTag(99) ~= nil then
			LabelLayer.setText(pBtnBegin:getChildByTag(99), "知道了")	
		end
		if Image_Bg:getChildByTag(1100) ~= nil then
			Image_Bg:getChildByTag(1100):setVisible(false)
		end
		if Image_Bg:getChildByTag(1101) ~= nil then
			Image_Bg:getChildByTag(1101):setVisible(false)
		end

		local pBtnClose = tolua.cast(m_ChildLayer:getWidgetByName("Image_BtnClose"), "ImageView")
		pBtnClose:setTouchEnabled(false)
		pBtnClose:setVisible(false)
	end
end

local function InitUI( nCityName, nStep )
	local Image_Bg 	  = tolua.cast(m_ChildLayer:getWidgetByName("Image_Bg"), "ImageView")
	local pBtnBegin = tolua.cast(m_ChildLayer:getWidgetByName("Button_1"), "Button")
	local pBtnClose = tolua.cast(m_ChildLayer:getWidgetByName("Image_BtnClose"), "ImageView")

	local pConsRes = nil
	m_BloodConsNum = 0

	--计算血战的消耗
	for key,value in pairs(GetTeamTab()) do
		local pTeamID = GetTeamID(key)
		if pTeamID == nil then
			print("坚守错误")
			return
		end
		if pTeamID > 0 then
			local pConsID = GetBloodConsID(pTeamID)
			local pConsTab = GetExpendData(pConsID)

			pConsRes = pConsTab.TabData[1].IconPath
			m_BloodConsType = pConsTab.TabData[1].ConsumeType
			m_BloodConsNum  = m_BloodConsNum + pConsTab.TabData[1].ItemNeedNum
			m_BloodEnough   = pConsTab.TabData[1].Enough
		end
	end

	if m_BloodConsNum == 0 then
		m_BloodEnough = true
	end

	local label_Title = CreateLabel("请选择队伍"..m_Str, 24, ccc3(51,25,13), CommonData.g_FONT3, ccp(-60,140))
	Image_Bg:addChild(label_Title,1,2000)
	local label_Cons  = CreateLabel("消耗:     "..m_BloodConsNum, 18, ccc3(51,25,13), CommonData.g_FONT3, ccp(130,138))
	label_Cons:setAnchorPoint(ccp(0, 0.5))
	Image_Bg:addChild(label_Cons,1,2001)

	if pConsRes ~= nil then
		local Image_Cons = ImageView:create()
		Image_Cons:loadTexture(pConsRes)
		Image_Cons:setPosition(ccp(65,5))
		Image_Cons:setScale(0.4)
		label_Cons:addChild(Image_Cons)
	end

	local label_City  = LabelLayer.createStrokeLabel(24,CommonData.g_FONT3,nCityName,ccp(80,140),COLOR_Black,ccc3(0,217,12),true,ccp(0,0),2)
	Image_Bg:addChild(label_City,1,201)
	--[[local label_Exp  = LabelLayer.createStrokeLabel(18,CommonData.g_FONT3,"EXP:".."999999",ccp(190,138),COLOR_Black,ccc3(0,217,12),true,ccp(0,0),2)
	label_Exp:setVisible(false)
	Image_Bg:addChild(label_Exp,1,202)]]

    local label_Min = LabelLayer.createStrokeLabel(20,CommonData.g_FONT3,"30分",ccp(pBtnBegin:getPositionX() + 120, pBtnBegin:getPositionY()),COLOR_Black,ccc3(255,87,35),true,ccp(0,0),2)
	label_Min:setVisible(false)
	Image_Bg:addChild(label_Min,1,1100)

    local label_Sec = LabelLayer.createStrokeLabel(20,CommonData.g_FONT3,"30秒",ccp(pBtnBegin:getPositionX() + 172, pBtnBegin:getPositionY()),COLOR_Black,ccc3(255,87,35),true,ccp(0,0),2)
	label_Sec:setVisible(false)
	Image_Bg:addChild(label_Sec,1,1101)


	if nStep == true then
		--正在血战/坚守状态 改变text和pos
		pBtnClose:loadTexture("Image/imgres/countrywar/btn_small.png")
		pBtnClose:setTag(2)

		if pBtnBegin:getChildByTag(99) ~= nil then
			LabelLayer.setText(pBtnBegin:getChildByTag(99), "停止"..m_Str)	
		end
		--设置label显示
		if label_Title ~= nil then
			label_Title:setText("以下队伍正在"..m_Str)
		end
		if label_City ~= nil then
			label_City:setPositionX(label_City:getPositionX())
		end
		if label_Min ~= nil then
			label_Min:setVisible(true)
		end
		if label_Sec ~= nil then
			label_Sec:setVisible(true)
		end
		if label_Cons ~= nil then
			label_Cons:setVisible(false)
		end
		if label_Exp ~= nil then
			label_Exp:setVisible(true)
		end
		pBtnBegin:setTag(E_BeginBtn.E_BeginBtn_StopWar)

		--创建血战/坚守计时器
		if CommonData.g_BloodOrDefenseTime ~= -1 then
			SetFightDelayTime(CommonData.g_BloodOrDefenseTime)
		end
	end

end

function CreateCountryChildLayer(nType, nCityName, nCityID, nState, nWJTab)
	InitVars() 
	
	m_ChildLayer = TouchGroup:create()								
    m_ChildLayer:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/CountryWarEventLayer.json"))

    m_Type = nType

    m_nCityID = nCityID

    if m_Type == PlayerState.E_PlayerState_BloodWar then
    	m_Str = "血战"
	elseif m_Type == PlayerState.E_PlayerState_Defense then
		m_Str = "坚守"
	end

	if nState == true and nWJTab ~= nil then
    	--有血战/坚守武将
    	m_State = E_BeginBtn.E_BeginBtn_StopWar
    else
   		m_State = E_BeginBtn.E_BeginBtn_BeginWar
   	end

    InitHead(nState, nWJTab) 

    --关闭/最小化按钮
    local pBtnClose = tolua.cast(m_ChildLayer:getWidgetByName("Image_BtnClose"), "ImageView")
    pBtnClose:setTouchEnabled(true)
    pBtnClose:setTag(1)
    pBtnClose:addTouchEventListener(_Click_Close_CallBack)
    --是否募兵按钮
    local pBtnSelect = tolua.cast(m_ChildLayer:getWidgetByName("Image_Select"), "ImageView")
    pBtnSelect:setEnabled(false)
    pBtnSelect:addTouchEventListener(_Click_Select_CallBack) 
    local Label_Info = tolua.cast(m_ChildLayer:getWidgetByName("Label_Info"), "Label")
    Label_Info:setVisible(false)
    --开战等功能按钮
    local pBtnBegin = tolua.cast(m_ChildLayer:getWidgetByName("Button_1"), "Button")
    pBtnBegin:addTouchEventListener(_Click_Begin_CallBack) 
    pBtnBegin:setTag(m_State)
    local label_Info  = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,"开战",ccp(0,0),COLOR_Black,COLOR_White,true,ccp(0,0),0)
	pBtnBegin:addChild(label_Info,1,99)

    InitUI( nCityName, nState )

    m_SelectImg = tolua.cast(pBtnSelect:getChildByName("Image_Selected"), "ImageView")

    return m_ChildLayer
end

