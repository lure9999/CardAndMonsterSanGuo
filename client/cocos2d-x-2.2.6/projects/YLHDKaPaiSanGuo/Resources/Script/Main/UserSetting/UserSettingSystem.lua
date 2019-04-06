--玩家系统设置界面 celina


module("UserSettingSystem", package.seeall)


--变量

local m_layer_system = nil 
local PATH_SOUND_OPEN = "Image/imgres/usersetting/sound_open.png"
local PATH_SOUND_CLOSE = "Image/imgres/usersetting/sound_close.png"

local PATH_MUSIC_OPEN = "Image/imgres/usersetting/music_open.png"
local PATH_MUSIC_CLOSE = "Image/imgres/usersetting/music_close.png"

local PATH_HMD   = "Image/imgres/usersetting/blacklist.png"
local PATH_DHM   = "Image/imgres/usersetting/exchange.png"

local b_sound_open = false
local b_music_open = false

local function InitVars()
	m_layer_system = nil
	b_sound_open = false
	b_music_open = false
end
local function AddTitleSystem(strName,img_bg,nTag)
	
	local label_title = LabelLayer.createStrokeLabel(36,CommonData.g_FONT1,strName,ccp(0,2),COLOR_Black,ccc3(255,194,30),true,ccp(0,-2),2)
	label_title:setPosition(ccp(0,0))
	AddLabelImg(label_title,nTag,img_bg)
end
local function AddBtnName(strName,img_bg,nTag)
	local label_title = LabelLayer.createStrokeLabel(20,CommonData.g_FONT1,strName,ccp(0,2),ccc3(83,28,2),ccc3(255,245,126),true,ccp(0,-2),2)
	label_title:setPosition(ccp(20,0))
	AddLabelImg(label_title,nTag,img_bg)
end
local function _Sound_CallBack(tag,sender)
	b_sound_open = not b_sound_open
	local img_icon_sound = tolua.cast(sender:getChildByTag(100),"ImageView")
	if b_sound_open==true then
		if img_icon_sound~=nil then
			img_icon_sound:loadTexture(PATH_SOUND_OPEN)
		end
		AudioUtil.openSoundEffect()
		AddBtnName("音效：开",sender,1)
	else
		if img_icon_sound~=nil then 
			img_icon_sound:loadTexture(PATH_SOUND_CLOSE)
		end
		AddBtnName("音效：关",sender,1)
		AudioUtil.muteSoundEffect()
	end
end
local function _Music_CallBack(tag,sender)
	b_music_open = not b_music_open
	local img_icon_music = tolua.cast(sender:getChildByTag(100),"ImageView")
	if b_music_open==true then
		if img_icon_music~=nil then
			img_icon_music:loadTexture(PATH_MUSIC_OPEN)
		end
		AddBtnName("音乐：开",sender,1)
		AudioUtil.openBgm()
	else
		if img_icon_music~=nil then
			img_icon_music:loadTexture(PATH_MUSIC_CLOSE)
		end
		AudioUtil.muteBgm()
		AddBtnName("音乐：关",sender,1)
	end
end
--[[local function AddMenuOnImg(imgPathOn,imgPathClose,img_bg,nTag,fCallBack)
	local spriteBG = tolua.cast(img_bg:getVirtualRenderer(),"CCSprite")
	local img_on = ImageView:create()
	img_on:loadTexture(imgPathOn)
	img_on:setPosition(-54,0)
	AddLabelImg(img_on,1,spriteBG)
	
	local img_open = CCMenuItemImage:create(imgPathOn,imgPathOn)
	local img_close = CCMenuItemImage:create(imgPathClose,imgPathClose)
	local item_menu= CCMenuItemToggle:create(img_open)
	item_menu:registerScriptTapHandler(fCallBack)
    item_menu:addSubItem(img_close)
	
	
	
	local menu = CCMenu:create()
	menu:addChild(item_menu)
	menu:setPosition(ccp(-54,0))
	if img_bg:getNodeByTag(nTag)~=nil then
		img_bg:removeNodeByTag(nTag)
	end
	img_bg:addNode(menu,0,nTag)
end]]--
local function _Btn_HMD_System_CallBack()

end
local function _Btn_DHM_System_CallBack()

end
local function ShowUI()

	--标题
	local img_title_bg1 = tolua.cast(m_layer_system:getWidgetByName("img_wen_s"),"ImageView")
	AddTitleSystem("系统设置",img_title_bg1,10)
	local img_title_bg2 = tolua.cast(m_layer_system:getWidgetByName("img_wen_ts"),"ImageView")
	AddTitleSystem("推送设置",img_title_bg2,10)
	
	--添加按钮
	local img_sound = tolua.cast(m_layer_system:getWidgetByName("img_sound"),"ImageView")
	--AddMenuOnImg(PATH_SOUND_OPEN,PATH_SOUND_CLOSE,img_sound,2,_Sound_CallBack)
	local img_sound_icon = ImageView:create()
	
	img_sound_icon:setPosition(ccp(-54,0))
	AddLabelImg(img_sound_icon,100,img_sound)
	img_sound:setTouchEnabled(true)
	CreateItemCallBack(img_sound,true,_Sound_CallBack,nil)
	
	if CCUserDefault:sharedUserDefault():getBoolForKey("m_isSoundEffectOpen")==false then
		AddBtnName("音效：关",img_sound,1)
		b_sound_open = false
		img_sound_icon:loadTexture(PATH_SOUND_CLOSE)
	else
		AddBtnName("音效：开",img_sound,1)
		b_sound_open = true
		img_sound_icon:loadTexture(PATH_SOUND_OPEN)
	end
	
	local img_music = tolua.cast(m_layer_system:getWidgetByName("img_music"),"ImageView")
	--AddMenuOnImg(PATH_MUSIC_OPEN,PATH_MUSIC_CLOSE,img_music,2,_Music_CallBack)
	
	local img_music_icon = ImageView:create()
	
	img_music_icon:setPosition(ccp(-54,0))
	AddLabelImg(img_music_icon,100,img_music)
	
	img_music:setTouchEnabled(true)
	CreateItemCallBack(img_music,true,_Music_CallBack,nil)
	
	if CCUserDefault:sharedUserDefault():getBoolForKey("m_isBgmOpen")==false then
		AddBtnName("音乐：关",img_music,1)
		img_music_icon:loadTexture(PATH_MUSIC_CLOSE)
		b_music_open = false
	else
		AddBtnName("音乐：开",img_music,1)
		b_music_open = true
		img_music_icon:loadTexture(PATH_MUSIC_OPEN)
	end
	--黑名单
	local img_hmd_btn = tolua.cast(m_layer_system:getWidgetByName("img_hmd"),"ImageView")
	img_hmd_btn:setTouchEnabled(true)
	
	local img_hmd = ImageView:create()
	img_hmd:loadTexture(PATH_HMD)
	img_hmd:setPosition(ccp(-54,0))
	--CreateBtnCallBack(btn_hmd,nil,nil,_Btn_HMD_System_CallBack,nil,nil,nil,nil)
	CreateItemCallBack(img_hmd_btn,true,_Btn_HMD_System_CallBack,nil)
	AddLabelImg(img_hmd,1,img_hmd_btn)
	AddBtnName("黑名单",img_hmd_btn,2)
	
	--兑换码
	local img_dhm_btn = tolua.cast(m_layer_system:getWidgetByName("img_dh"),"ImageView")
	img_dhm_btn:setTouchEnabled(true)
	local img_dhm = ImageView:create()
	img_dhm:loadTexture(PATH_DHM)
	img_dhm:setPosition(ccp(-54,0))
	CreateItemCallBack(img_dhm_btn,true,_Btn_DHM_System_CallBack,nil)
	AddLabelImg(img_dhm,1,img_dhm_btn)
	AddBtnName("兑换码",img_dhm_btn,2)
	
end
local function _Btn_Close_System_CallBack()
	m_layer_system:removeFromParentAndCleanup(true)
end
function ShowSystemLayer()
	InitVars()
	m_layer_system =  TouchGroup:create()
	m_layer_system:addWidget( GUIReader:shareReader():widgetFromJsonFile( "Image/UserSettingSystem.json" ) )
	
	
	ShowUI()
	local btn_close_system = tolua.cast(m_layer_system:getWidgetByName("btn_close"),"Button")
	CreateBtnCallBack(btn_close_system,nil,nil,_Btn_Close_System_CallBack,nil,nil,nil,nil)
	return m_layer_system

end