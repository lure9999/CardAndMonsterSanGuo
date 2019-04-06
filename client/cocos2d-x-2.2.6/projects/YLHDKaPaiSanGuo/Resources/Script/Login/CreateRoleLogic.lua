
require "Script/Login/CreateRoleData"
--require "Script/Fight/FightDef"
module("CreateRoleLogic", package.seeall)

require "Script/serverDB/resimg"
--变量

ID_MAN = 80011
ID_GIRL = 81011



TAG_ANIMATION_SMALL = 1 
TAG_ANIMATION_BIG   = 2

ACTION_TIME  = 0.5
SCALE_SMALL_RATIO_X = -1.8
SCALE_SMALL_RATIO_Y = 1.8
SCALE_BIG_RATIO_X   = -2.5
SCALE_BIG_RATIO_Y   = 2.5

STR_HEAD_MAN_PATH = "Image/imgres/hero/head_icon/man"
STR_HEAD_GIRL_PATH = "Image/imgres/hero/head_icon/wm"

local GetAnimationFileName = CreateRoleData.GetRoleAnimationFileName
local GetAnimationName     = CreateRoleData.GetRoleAnimationName
local GetID                = CreateRoleData.GetResID
local HandelRoleLogin      = LoginCommon.HandelRoleLogin
function GetAniName_Res_ID( ResID , Ani_Key)
	
	--print(ResID)
	--print(Ani_Key)
	--Pause()
	--local name = "GetAniName_Res_ID" .. AnimationData.getFieldByIdAndIndex(ResID,Ani_Key) 
	--print(name)
	return AnimationData.getFieldByIdAndIndex(ResID,Ani_Key)	
end
function GetActionByID(m_id_role)
	--print("m_id_role:"..m_id_role)
	--Pause()
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(GetAnimationFileName(m_id_role))
	local PayArmature = CCArmature:create(GetAnimationName(m_id_role))
	
	--print(GetAniName_Res_ID)
	--Pause()
    PayArmature:getAnimation():play(GetAniName_Res_ID(GetID(m_id_role),"Ani_stand"))

	return PayArmature
    

end

function GetRondamName(randCallBack,sixID)
    local function RandOver(strName, NameCode,nCountry)
		NetWorkLoadingLayer.loadingHideNow()
		if randCallBack ~=nil then
			randCallBack(strName,NameCode,nCountry)
		end
	end
	Packet_RandName.SetSuccessCallBack(RandOver)
	network.NetWorkEvent(Packet_RandName.CreatPacket(sixID))
	NetWorkLoadingLayer.loadingShow(true)
end

function ClickPerson(point,object)
	local bRet = false 
	local x = object:boundingBox():getMidX()
	local y = object:boundingBox():getMinY()
	local width = object:boundingBox():getMaxX() - object:boundingBox():getMidX()
	local height = object:boundingBox():getMaxY()-object:boundingBox():getMinY()
	local newRext = CCRectMake(x-60,y,width/3+100,height)
	bRet = newRext:containsPoint(point)
	return bRet
end

local function ChangeAndMove(startPos,endPos,scaleRitio,nObject,callBack,bBig)
	local array_move = CCArray:create()
	
	--local nAddX = 0 
	--local nAddY = 0 
	local nColor = 0
	  --贝塞尔曲线
	if bBig == false then
		--nAddX =  100
		--nAddY =  200
		nColor = 140
	else
		--nAddX =  -100
		--nAddY =  -200
		nColor = 255
	end
	--[[local bezier = ccBezierConfig()
	bezier.controlPoint_1 = ccp(startPos.x, startPos.y)
	bezier.controlPoint_2 = ccp(startPos.x+nAddX, (startPos.y+nAddY))
	bezier.endPosition = ccp(endPos.x, endPos.y)]]--
	
	local array_action_group = CCArray:create()
	--array_action_group:addObject( CCBezierTo:create(ACTION_TIME,bezier ) )
	array_action_group:addObject( CCMoveTo:create(ACTION_TIME,ccp(endPos.x,endPos.y) ) )
	array_action_group:addObject( CCScaleTo:create(ACTION_TIME, -scaleRitio,scaleRitio) )
	array_action_group:addObject( CCTintTo:create(ACTION_TIME, nColor, nColor,nColor) )
	
	array_move:addObject(CCSpawn:create(array_action_group))
	array_move:addObject(CCCallFunc:create(callBack))
	
	nObject:runAction(CCSequence:create(array_move)) 
end
local function runAtkAction(object,nIDTag)
	object:getAnimation():play(GetAniName_Res_ID(GetID(nIDTag), "Ani_attack"))
	local function onMovementEvent(armatureBack,movementType,movementID)
		if movementType == 1 then
			--man_object:getAnimation():play("stand")
			object:getAnimation():play(GetAniName_Res_ID(GetID(nIDTag), "Ani_stand"))
			
		end
	end
	object:getAnimation():setMovementEventCallFunc(onMovementEvent)
end
--获取头像的路径
local function getPathHead(nTag)
	if nTag == ID_GIRL then
		return STR_HEAD_GIRL_PATH
	end
	if nTag == ID_MAN then
		return STR_HEAD_MAN_PATH
	end
end
function MoveAction(mObject,gObject,actionEndCallBack)
	local mx = mObject:getPositionX()
	local my = mObject:getPositionY()
	
	local gx = gObject:getPositionX()
	local gy = gObject:getPositionY()
	
	local nTagID = 0
	local nSexID = 0 
	local nObject = nil 
	local function SmallCallback()
	
	end
	local function BigCallBack()
		runAtkAction(nObject,nTagID)
		
		actionEndCallBack(getPathHead(nTagID),nSexID)
	end
	if mObject:getScaleY()== 2.5 then
		nTagID = ID_GIRL
		nSexID = 2
		nObject = gObject
		mObject:setZOrder(0)
		gObject:setZOrder(1)
		ChangeAndMove(ccp(mx,my),ccp(gx,gy),SCALE_SMALL_RATIO_Y,mObject,SmallCallback,false)
		ChangeAndMove(ccp(gx,gy),ccp(mx,my),SCALE_BIG_RATIO_Y,gObject,BigCallBack,true)
	end
	if gObject:getScaleY()== 2.5 then
		nTagID = ID_MAN
		nSexID = 1
		nObject = mObject
		gObject:setZOrder(0)
		mObject:setZOrder(1)
		ChangeAndMove(ccp(gx,gy),ccp(mx,my),SCALE_SMALL_RATIO_Y,gObject,SmallCallback,false)
		ChangeAndMove(ccp(mx,my),ccp(gx,gy),SCALE_BIG_RATIO_Y,mObject,BigCallBack,true)
	end
end

function checkName(str)
	if str ==nil or str == "" then
		TipLayer.createTimeLayer("请输入名字", 2)
		return false
	end
	--local nWord = 0
	local bSpace = false
	local nEng = 0
	for i=1,#str do 
		local nAscii = string.byte(str,i)
		local byteCount = 1
		if nAscii == 32 then
			bSpace = true
		end
		 if nAscii>0 and nAscii<=127 then
			byteCount = 1
		elseif nAscii>=192 and nAscii<223 then
			byteCount = 2
		elseif nAscii>=224 and nAscii<239 then
			byteCount = 3
		elseif nAscii>=240 and nAscii<=247 then
			byteCount = 4
		end
		--local char = string.sub(str, i, i+byteCount-1)
		i = i + byteCount -1
		if byteCount == 1 then
			nEng = nEng +1
		--else
			--nWord = nWord +1
		end
	end
	local pTips = TipCommonLayer.CreateTipLayerManager()
	
	if bSpace == true then
		pTips:ShowCommonTips(1468,nil)
		pTips = nil
		return false
	end
	if nEng>12  then
		pTips:ShowCommonTips(1469,nil)
		pTips = nil
		return false
	end
	if nEng<2 then
		pTips:ShowCommonTips(1486,nil)
		pTips = nil
		return false
	end
	--if string.len(str)>
	return true
end
function GetImgHeadID(imgStr)
	local tableImg = resimg.getTable()
	local resID = 0
	for key,value in pairs(tableImg) do 
		if value[1] == imgStr then
			resID = string.sub(key,string.find(key,"_")+1,string.len(key))
			return resID
		end
	end
	
	return resID
end
--角色登陆
function createRoleLogin(table_data)
	if checkName(table_data.str_name) == false then
		return 
	end
	local function CreateOver()
		--print(CreateOver)
		--Pause()
		
		NetWorkLoadingLayer.loadingHideNow()
		HandelRoleLogin()
	end
	Packet_CreateCharacter.SetSuccessCallBack(CreateOver)
	network.NetWorkEvent(Packet_CreateCharacter.CreatPacket(table_data.str_sex, table_data.str_resID , table_data.str_name, table_data.str_nameCode,table_data.nCountry))
	NetWorkLoadingLayer.ClearLoading()
	NetWorkLoadingLayer.loadingShow(true)
end
function ChangeBSelf(strGetName,str_rondomName)
	if strGetName == str_rondomName then
		return false
	end	
	return true

end