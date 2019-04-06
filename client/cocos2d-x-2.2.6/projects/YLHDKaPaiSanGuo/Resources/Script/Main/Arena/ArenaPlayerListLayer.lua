module("ArenaPlayerListLayer", package.seeall)

local m_lvTempPlayer = nil

local function CreatePlayerListWidget(  )
	local PlayerWidget = m_lvTempPlayer:clone()    
    local peer = tolua.getpeer(m_lvTempPlayer)   
    tolua.setpeer(PlayerWidget, peer)
    return PlayerWidget
end
local function _Button_Challenge_MallLayer_CallBack( sender, eventType )
	local btnTemp = tolua.cast(sender, "Button")
	if eventType == TouchEventType.ended then
		print("BtnTag=="..btnTemp:getTag())
	end
end
local function UpdateDataToWidget( nIdx, wgPlayerInfo )
	if wgPlayerInfo==nil then
		print("widget is null")
		return
	else
		local Panel_PlayerInfo = tolua.cast(wgPlayerInfo:getChildByName("Panel_PlayerInfo_"..nIdx),"Layout")
		local Button_Challenge = tolua.cast(Panel_PlayerInfo:getChildByName("Button_Challenge_"..nIdx),"Button")
		if Button_Challenge~=nil then
			Button_Challenge:addTouchEventListener(_Button_Challenge_MallLayer_CallBack)
		end
	end
end

local function CreataPlayerList(pListView)
	for i=1,10 do
		if i%2==0 then
			local PlayerInfoWidget = CreatePlayerListWidget()
			local PlayerInfoWidget_1 = tolua.cast(PlayerInfoWidget:getChildByName("Image_PlayerInfo_"..tostring((i-1)%2)),"ImageView")
			UpdateDataToWidget((i-1)%2, PlayerInfoWidget_1)
			local PlayerInfoWidget_2 = tolua.cast(PlayerInfoWidget:getChildByName("Image_PlayerInfo_"..tostring((i-1)%2+1)),"ImageView")
			UpdateDataToWidget((i-1)%2+1, PlayerInfoWidget_2)
			pListView:pushBackCustomItem(PlayerInfoWidget)
		end
	end
end

function createArenaPlayerLayer( pListView)

    m_lvTempPlayer = GUIReader:shareReader():widgetFromJsonFile("Image/ArenaPlayerTemp.json")

    CreataPlayerList(pListView)
end