
module("ChatFaceLayer", package.seeall)
require "Script/Common/Common"
local m_pChatFacelayer     = nil
local strEditName    = nil 

local function initVars( )
	m_pChatFacelayer = nil
end

function SetEditName(strNew )
	
	strEditName = strNew	
	return strEditName
end

local function _ChatReturn_Btn_CallBack(sender,eventType)
    if eventType == TouchEventType.ended then        
        m_pChatFacelayer:setVisible(false)  
        m_pChatFacelayer:removeFromParentAndCleanup(true)    
        m_pChatFacelayer = nil                      
    end                 
end
--表情
function createFaceTipLayer( pSender,strText,revicecallbackFun,revicecallbackFun2 )
    initVars()

    if m_pChatFacelayer == nil then
        m_pChatFacelayer = TouchGroup:create()
        m_pChatFacelayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/FaceShowLayer.json"))
        local scenetemp =  CCDirector:sharedDirector():getRunningScene()
        scenetemp:addChild(m_pChatFacelayer, 999, 999)
    end

    local panel_return = tolua.cast(m_pChatFacelayer:getWidgetByName("Panel_FaceShow"),"Layout")
    panel_return:addTouchEventListener(_ChatReturn_Btn_CallBack)

	local arma_ext = nil
    local img_arm  = nil
    local armatureBg = nil
    local PosWidth = CCDirector:sharedDirector():getVisibleSize().width
    
    local editNameType = tolua.cast(pSender,"CCEditBox")      

    local m_ScrollView = tolua.cast(m_pChatFacelayer:getWidgetByName("Image_botm"),"ImageView")
    m_ScrollView:setSize(CCSize(PosWidth,260))
    local scrollViewSize = m_ScrollView:getSize()
    
	local    armature = nil

	local function _ChatFace_Arm_CallBack( sender,eventType )
    	local pSenders = tolua.cast(sender,"ImageView")
	    local pTag = pSenders:getTag()
	    strEditName = editNameType:getText()
	    local pos = nil
    	if eventType == TouchEventType.began then	    	    	    	            	    	    
	        local arma_extSize = arma_ext:getSize()	   	                 
	        CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/chat/biaoqing/biaoqing.ExportJson") 
			armature = CCArmature:create("biaoqing")			
			if pTag >= 15 and pTag <= 17 then
	        	armature:getAnimation():play("biaoqing0" .. pTag)
	        elseif pTag >= 10 and pTag <= 14 then
	        	armature:getAnimation():play("biaoqing0" .. pTag)
	        else
	        	armature:getAnimation():play("biaoqing00" .. pTag)
	    	end
	        armature:setPosition(ccp(arma_extSize.width*0.5,arma_extSize.height*0.5))	   		
		   	armature:setZOrder(6)		   	
		   	arma_ext:addNode(armature)
		   	pos = sender:getTouchStartPos()  
	        arma_ext:setVisible(true)
	        armature:setVisible(true)
	        -- arma_ext:setPosition(ccp(pos.x - 25,pos.y))	 
            arma_ext:setPosition(ccp(sender:getPositionX()-30,pos.y))           	           	        	
		elseif eventType == TouchEventType.ended  then				
			--local newStr = strEditName .. "*" .. pTag
            local newStr = nil	
            if pTag < 10 then
                newStr = strEditName .. "*" .. 0 .. pTag
            else
                newStr = strEditName .. "*" .. pTag
            end
	        revicecallbackFun(newStr) 
			arma_ext:setVisible(false)				
			armature:removeFromParentAndCleanup(true)        
        elseif eventType == TouchEventType.canceled then 
            armature:removeFromParentAndCleanup(true)  
            arma_ext:setVisible(false)     
		end
    end

	local function CirculAnimate(starPos,endPos,ScrollViewSize,ScallSize)
		for i=starPos,endPos do  		      	       	
        	armatureBg = CCArmature:create("biaoqing")
           	if starPos >= 8  and starPos <= 9 then           		
           		armatureBg:getAnimation():play("biaoqing00" .. i)
        		armatureBg:setPosition(ccp(-400   + 120*(i - 8) + CommonData.g_Origin.x/2,ScrollViewSize.height*ScallSize-25))
        	elseif starPos >= 10 and starPos <15 then  	
        		armatureBg:getAnimation():play("biaoqing0" .. i)
        		armatureBg:setPosition(ccp(-400 +240+ 120*(i - 10) + CommonData.g_Origin.x/2,ScrollViewSize.height*ScallSize-25))	        	
        	elseif starPos >= 15 then
        		armatureBg:getAnimation():play("biaoqing0" .. i)
        		armatureBg:setPosition(ccp(-400  + 120*(i - 15) + CommonData.g_Origin.x/2,ScrollViewSize.height*ScallSize-40))
        	else
        		armatureBg:getAnimation():play("biaoqing00" .. i)
        		armatureBg:setPosition(ccp(-400  + 120*(i - 1) + CommonData.g_Origin.x/2,ScrollViewSize.height*ScallSize-30))	
        	end   		
	   		armatureBg:setZOrder(3)	   		
	   		m_ScrollView:addNode(armatureBg)

	   		img_arm = ImageView:create()	    	
	    	local armName = "Image/imgres/common/color/wj_pz1" .. ".png"
	    	img_arm:loadTexture(armName)
	    	img_arm:setPosition(ccp(armatureBg:getPosition()))
	    	img_arm:setTag(i)
	    	img_arm:setScale(0.35)	
	    	img_arm:setColor(ccc3(255,255,255))	    	
		    img_arm:setTouchEnabled(true)
		    img_arm:setOpacity(0)
		    img_arm:setZOrder(5)
		    m_ScrollView:addChild(img_arm)
		    img_arm:addTouchEventListener(_ChatFace_Arm_CallBack)			    
        end
        
	end

    local function initDatas()   
    	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/chat/biaoqing/biaoqing.ExportJson")   	   
    	arma_ext = ImageView:create()
    	arma_ext:loadTexture("Image/imgres/chat/face_ext.png")
    	arma_ext:setAnchorPoint(ccp(0,0))     	  
		--arma_ext:setScale(0.8)
		arma_ext:setZOrder(6)		
		arma_ext:setVisible(false)
		m_pChatFacelayer:addChild(arma_ext,100,100) 
		--调用表情创建函数，创建出17个表情
		CirculAnimate(1,7,scrollViewSize,0.45)
		CirculAnimate(8,9,scrollViewSize,0.2)
		CirculAnimate(10,14,scrollViewSize,0.2)		
		CirculAnimate(15,17,scrollViewSize,0)								        
    end

    if m_pChatFacelayer ~= nil then
  		initDatas()
	end
    local function _ChatGlob_Btn_CallBack( sender,eventType )

    	if  eventType == TouchEventType.ended then    		    		           		 	           	           	  
            editNameType:touchDownAction(nil,2)                     
    	end    	   	
    end

    local m_BtnFace = tolua.cast(m_pChatFacelayer:getWidgetByName("Button_Face"),"Button")
    m_BtnFace:setSize(CCSize(PosWidth / 6,64))
    local img_face = ImageView:create()
    img_face:loadTexture("Image/imgres/chat/Simlface.png")
    m_BtnFace:addChild(img_face)

  
    local m_imgGlob = tolua.cast(m_pChatFacelayer:getWidgetByName("Image_Golb"),"Button")
    m_imgGlob:setTouchEnabled(true)
    m_imgGlob:addTouchEventListener(_ChatGlob_Btn_CallBack)
    local img_golb = ImageView:create()
    img_golb:loadTexture("Image/imgres/chat/globe.png")
    img_golb:setPosition(ccp(0,0))
    m_imgGlob:addChild(img_golb)
    m_imgGlob:setSize(CCSize( m_BtnFace:getPositionX()-m_BtnFace:getContentSize().width/2-CommonData.g_Origin.x/2, 64)) --
    m_imgGlob:setPosition(ccp(( m_BtnFace:getPositionX()-m_BtnFace:getContentSize().width/2)/2+CommonData.g_Origin.x/2,33))
    
    local function _ChatSpace_Btn_CallBack( sender,eventType )
        if eventType == TouchEventType.ended then	
        	strEditName = editNameType:getText()    		    	
	    	local len1 = string.len(strEditName)	    	
	        local newStr = strEditName .. " "
	        local len2 = string.len(newStr)	               	       
	        revicecallbackFun(newStr)	    		     	
    	end
    end


    local m_BtnSpace = tolua.cast(m_pChatFacelayer:getWidgetByName("Button_Space"),"Button") 
    m_BtnSpace:addTouchEventListener(_ChatSpace_Btn_CallBack)
    local label_Space = Label:create()
    label_Space:setFontSize(30)
    label_Space:setColor(ccc3(0,0,0))
    label_Space:setTextHorizontalAlignment(1)
    label_Space:setText("空格")
    m_BtnSpace:addChild(label_Space)
    

    local function _ChatCut_Btn_CallBack( sender,eventType )
    	if eventType == TouchEventType.ended then
    		strEditName = editNameType:getText()
            local strlennnn = string.len(strEditName)                   
			local nCutStr = string.sub(strEditName,1,strlennnn - 1)			
			revicecallbackFun(nCutStr)
	    end        
    end
    local m_BtnCut = tolua.cast(m_pChatFacelayer:getWidgetByName("Button_Cut"),"Button")
    local m_cutWidth = m_BtnCut:getContentSize().width
    local m_cutPosX = m_BtnCut:getPositionX()
       
    m_BtnCut:addTouchEventListener(_ChatCut_Btn_CallBack)
    local img_cut = ImageView:create()
    img_cut:loadTexture("Image/imgres/chat/cancel.png")
    m_BtnCut:addChild(img_cut)

    local function _ChatSend_Btn_CallBack( sender,eventType ) 
        if eventType == TouchEventType.ended then 
        	revicecallbackFun2()          	
        end 	
    end

    local m_imgSender = tolua.cast(m_pChatFacelayer:getWidgetByName("Image_Sender"),"Button")
    m_imgSender:setTouchEnabled(true)

    local cur_senderWidth = m_imgSender:getContentSize().width
    local d_valueWidth = PosWidth - m_cutPosX - m_cutWidth/2

    if d_valueWidth < cur_senderWidth then
        d_valueWidth = cur_senderWidth
    end

    m_imgSender:setSize(CCSize( d_valueWidth, 64)) --
    m_imgSender:setPosition(ccp((PosWidth+m_cutPosX+m_cutWidth/2)/2+CommonData.g_Origin.x/2,m_imgSender:getPositionY()))
     
    m_imgSender:addTouchEventListener(_ChatSend_Btn_CallBack)
    local label_Sender = Label:create()
    label_Sender:setFontSize(30)
    label_Sender:setColor(ccc3(255,255,255))
    label_Sender:setTextHorizontalAlignment(1)
    label_Sender:setText("发送")
    m_imgSender:addChild(label_Sender)

    return m_pChatFacelayer
end
function CreateFaceLayer()	
	initVars()

	m_pChatFacelayer = TouchGroup:create()
	m_pChatFacelayer:addWidget(GUIReader:shareReader():widgetFromJsonFile("Image/FaceShowLayer.json"))

    local panel_return = tolua.cast(m_pChatFacelayer:getWidgetByName("Panel_FaceShow"),"Layout")
    panel_return:addTouchEventListener(_ChatReturn_Btn_CallBack)

	return m_pChatFacelayer	
end

