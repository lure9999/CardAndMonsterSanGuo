--新手引导的服务器步骤第十大步骤 征战界面
module("NewGuideServerTen_Copy", package.seeall)


local GetGuideIcon = NewGuideLayer.GetGuideIcon
local DeleteGuide = NewGuideLayer.DeleteGuide
local AddGuideIcon = NewGuideLayer.AddGuideIcon

local m_copy_animation  = nil 
local m_copy_callback = nil 
local m_pos_cur  = nil 
local m_type = 0


local function _FightEnd_Back()
	if m_copy_callback~=nil then
		m_copy_callback()
		--m_copy_callback = nil 
	end
end
local function _Click_Fight_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		NewGuideLayer.SetFight(true)
		NewGuideLayer.SetNextCallBack(_FightEnd_Back)
		--[[if m_type == 1 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(9))
		end
		if m_type == 2 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(10))
		end
		if m_type == 3 then
			network.NetWorkEvent(Packet_SetNewGuide.CreatPacket(11))
		end]]--
		EnterPointLayer.BattleBegin()
	end
end
local function ToFight()
	if m_copy_animation~=nil then
		m_copy_animation:setPosition(ccp(850,40))
		m_copy_animation:addTouchEventListener(_Click_Fight_CallBack)
	end
end
local function _Click_One_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--进入战斗，现在先修改为到步骤十一
		--[[if m_copy_animation~=nil then
			DeleteGuide()
		end
		if m_copy_callback~=nil then
			m_copy_callback()
			--m_copy_callback = nil 
		end]]--
		
		DungeonLayer.GetDungeonByNewGuilde(0,1,1,ToFight)
	end
end

local function _Click_Two_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--进入战斗
		DungeonLayer.GetDungeonByNewGuilde(0,1,2,ToFight)
	end
end
local function _Click_Three_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--进入战斗
		DungeonLayer.GetDungeonByNewGuilde(0,1,3,ToFight)
	end
end
local function ShowCopy()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if tempCur ~= nil  then
		print("已经是副本界面了")
	else
		MainScene.ShowLeftInfo(false)
		MainScene.ClearRootBtn()
		MainScene.DeleteUILayer(DungeonManagerLayer.GetUIControl())
		local pLayerDungeonManager = DungeonManagerLayer.CreateDungeonManagerLayer(DungeonsType.Normal)
		if pLayerDungeonManager==nil then
			print("pLayerDungeonManager is nil...")
			return
		end
		scenetemp:addChild(pLayerDungeonManager,lyaerActivityList_Tag,lyaerActivityList_Tag)
		MainScene.PushUILayer(pLayerDungeonManager)
		if m_copy_animation~=nil then
			--m_copy_animation:setPosition(ccp(190,140))
			m_copy_animation:setPosition(m_pos_cur)
			if m_type == 2 then
				m_copy_animation:addTouchEventListener(_Click_Two_CallBack)
			elseif m_type==3 then
				m_copy_animation:addTouchEventListener(_Click_Three_CallBack)
			else
				
				m_copy_animation:addTouchEventListener(_Click_One_CallBack)
			end
			
		end
	end

end




local function _Click_Copy_CallBack(sender, eventType)
	if eventType == TouchEventType.ended then
		--打开副本界面
		ShowCopy()
	end
end
function OpenCopy(fCallBack,nPos,nType)
	--点击打开副本界面
	m_copy_callback = fCallBack
	m_copy_animation = GetGuideIcon()
	m_pos_cur = nPos
	m_type = nType
	--检测是否是副本界面
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	local tempCur = scenetemp:getChildByTag(lyaerActivityList_Tag)
	if tempCur ~= nil  then
		print("已经是副本界面了")
		--print(nType,m_copy_animation,nPos)
		if nType ~= 1 then
			if m_copy_animation == nil then
				AddGuideIcon(nPos)
				m_copy_animation = GetGuideIcon()
			end
			if m_copy_animation~=nil then
				m_copy_animation:setPosition(nPos)
				m_copy_animation:setTouchEnabled(true)
				if nType == 2 then
					m_copy_animation:addTouchEventListener(_Click_Two_CallBack)
				elseif nType==3 then
					m_copy_animation:addTouchEventListener(_Click_Three_CallBack)
				end
			end
		end
	else
		--if nType == 1 then
			if m_copy_animation == nil then
				AddGuideIcon(ccp(570,320))
				m_copy_animation = GetGuideIcon()
			end
			if m_copy_animation~=nil then
				m_copy_animation:setTouchEnabled(true)
				m_copy_animation:addTouchEventListener(_Click_Copy_CallBack)
			end
		--end
	end
	
end