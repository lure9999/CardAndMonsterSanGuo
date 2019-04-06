



--module("FightSceneDlg", package.seeall)

local Widget_win = nil 	--胜利
local Widget_Lose = nil 	--失败 

local function CloseDlg_CallBack(sender, eventType)
		
	--if eventType == TouchEventType.ended then
	if eventType == 2 then
		
		--关闭界面
		Log("exit fightScene")	
		Widget_win:setVisible(false)
		Widget_win:setTouchEnabled(false)
		
		Widget_Lose:setVisible(false)
		Widget_Lose:setTouchEnabled(false)
		
		PopFightScene()
	
	end
end
function ShowResultDly(bResult)	

	if(bResult) then			
		Widget_win:setVisible(true)
		Widget_win:setTouchEnabled(true)
		local close_button = tolua.cast(Widget_win:getChildByTag(3):getChildByTag(6), "Button")	
		close_button:addTouchEventListener(CloseDlg_CallBack)
		
	else 		
		Widget_Lose:setVisible(true)
		Widget_Lose:setTouchEnabled(true)
		
		local close_button = tolua.cast(Widget_Lose:getChildByTag(8):getChildByTag(9), "Button")	
		close_button:addTouchEventListener(CloseDlg_CallBack)
	
	end	
end

-- init战斗结果界面
function InitFightResultDlg(RootLayer)
	
	Widget_Fight_Root = RootLayer
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
	
	
	--胜利
	Widget_win =  tolua.cast(GUIReader:shareReader():widgetFromJsonFile("Image/Fight/UI/FightResult_1.json"),"Widget")
	Widget_win:setVisible(false)
	Widget_win:setAnchorPoint(ccp(0.5, 0.5))
	Widget_win:setPosition(ccp(visibleSize.width/2 + origin.x , visibleSize.height/2 + origin.y ))
	Widget_win:setZOrder(100)
	Widget_win:setScale(0.5)
	
	
	--local close_button = tolua.cast(Widget_win:getChildByTag(3):getChildByTag(6), "Button")
	
	--close_button:addTouchEventListener(CloseDlg_CallBack)

	Widget_win:setTouchEnabled(false)
    RootLayer:addWidget( Widget_win )

	
	--失败
	Widget_Lose =  tolua.cast(GUIReader:shareReader():widgetFromJsonFile("Image/Fight/UI/FightResult_2.json"),"Widget")
	Widget_Lose:setVisible(false)
	Widget_Lose:setAnchorPoint(ccp(0.5, 0.5))
	Widget_Lose:setPosition(ccp(visibleSize.width/2 + origin.x , visibleSize.height/2 + origin.y ))
	Widget_Lose:setZOrder(101)
	Widget_Lose:setScale(0.5)
		
	--local close_button1 = tolua.cast(Widget_Lose:getChildByTag(8):getChildByTag(9), "Button")
	
	--close_button1:addTouchEventListener(CloseDlg_CallBack)

	Widget_Lose:setTouchEnabled(false)
    RootLayer:addWidget( Widget_Lose )
   
 
	
end

--local function main()

--end

--xpcall(main, __G__TRACKBACK__)

