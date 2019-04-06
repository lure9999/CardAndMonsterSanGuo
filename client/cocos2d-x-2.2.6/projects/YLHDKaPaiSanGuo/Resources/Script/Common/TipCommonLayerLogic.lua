

module("TipCommonLayerLogic", package.seeall)
require "Script/serverDB/message"
require "Script/serverDB/general"
require "Script/serverDB/equipt"
require "Script/serverDB/item"
require "Script/serverDB/server_equipDB"


function GetTypeByMId(nID)
	return message.getFieldByIdAndIndex(nID,"messageType")
end

function GetMessageByID(nID)
	return message.getFieldByIdAndIndex(nID,"messagetext")
end
function GetDataNum(nID)
	return tonumber( message.getFieldByIdAndIndex(nID,"number") )
end
function GetBtnFirstName(nID)
	return message.getFieldByIdAndIndex(nID,"Button_1")
	
end
function GetBtnSecName(nID)
	return message.getFieldByIdAndIndex(nID,"Button_2")
end
function AddStrInfoNoBtn(strInfo,img_bg,nTag)
	local fontName = "default"
	local fontSize = 24
	local labelCreate = RichText:create()
	labelCreate:pushBackElement(RichElementText:create(1,ccc3(233,180,114),255,strInfo,fontName,fontSize))
	labelCreate:setPosition(ccp(0,0))
	local LabelWord = CCLabelTTF:create(strInfo,fontName,fontSize)
	
	local width = LabelWord:getContentSize().width+20
	local height = LabelWord:getContentSize().height+20
	if width<284 then
		width = 284
	end
	if height<45 then
		height = 49
	else
		
	end	
	img_bg:setSize(CCSize(width,height ))
	--img_bg:setSize(CCSizeMake(img_bg:getContentSize().width,labelCreate:getContentSize().height))
	--img_bg:addChild(labelCreate)
	AddLabelImg(labelCreate,nTag,img_bg)
end
function GetActionLayer(fCallBack)
	local actionArray2 = CCArray:create()
	actionArray2:addObject(CCScaleTo:create(0.1, 1.2))
	actionArray2:addObject(CCScaleTo:create(0.1, 1))
	actionArray2:addObject(CCDelayTime:create(1))
	actionArray2:addObject(CCCallFunc:create(fCallBack))
	actionArray2:addObject(CCFadeOut:create(1))
	return CCSequence:create(actionArray2)
end

function AddStrInfo(strInfo,img_bg)
	--拿到的是匹配好的字符串 分行显示
	local labelCreate = RichText:create()
	labelCreate:pushBackElement(RichElementText:create(1,ccc3(49,31,21),255,strInfo,"default",24))
	labelCreate:setPosition(ccp(0,30))
	img_bg:addChild(labelCreate)
end