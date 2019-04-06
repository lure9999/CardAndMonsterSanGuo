
module("LabelLayer", package.seeall)

-- 创建描边文本
function createStrokeLabel(fontSize, fontName, text, pt, color1, color2, center, ptOff, size)
	--local strokeSize = size
	--[[if strokeSize>2 then
		strokeSize = 2
	end]]--
	--[[if fontSize>=18 and fontSize<22 then
		fontSize = 18
		strokeSize = 2*(18/36)
	elseif fontSize>=22 and fontSize<30 then
		fontSize = 24
		strokeSize = 2*(24/36)
	else
		strokeSize = 2
		fontSize = 36
	end]]--
	fontSize = tonumber(fontSize)
	if center == nil then
		center = false
	end
	if fontSize<25 then
		fontSize = 25
	end
	strokeSize =  2*(fontSize/36)
	if strokeSize<1 then
		strokeSize = 1
	end
	local _Lab_bk = createStrokeLabelNew(fontSize, fontName, text,pt, color1, color2, center, strokeSize)
	--[[local _Lab_bk = Layout:create()
	_Lab_bk:setPosition(pt)
	
	local _Label_1 = Label:create()
	_Label_1:setFontSize(fontSize)
	_Label_1:setColor(color1)
	_Label_1:setFontName(fontName)
	_Label_1:setText(text)
	--_Label_1:setPosition(ptOff)
	_Label_1:setPosition(ccp(size,-size))
	local dd = _Label_1:getVirtualRenderer()
	local temp = tolua.cast(dd, "CCLabelTTF")
	temp:enableStroke(color1,size*2)
	
	
	local _Label_2 = Label:create()
	_Label_2:setFontSize(fontSize)
	_Label_2:setColor(color2)
	_Label_2:setFontName(fontName)
	_Label_2:setText(text)
	_Label_2:setPosition(ccp(0, 0))
	
	
	if center ~= nil and center == false then
		_Label_1:setAnchorPoint(ccp(0,0.5))
		_Label_2:setAnchorPoint(ccp(0,0.5))
		
		_Label_1:setPosition(ccp(size,-size))
		
	end
	
	_Lab_bk:addChild(_Label_1, 0, 1)
	_Lab_bk:addChild(_Label_2, 0, 2)
	
	
	--print(_Lab_bk:getSize().width)
	
	
	
	return _Lab_bk]]--
	return _Lab_bk
end

function setText(pControl, strText)	
	--[[if pControl ~= nil then
		pControl:getChildByTag(1):setText(strText)
		pControl:getChildByTag(2):setText(strText)
	end]]--
	SetStrokeText(pControl,strText)
end

function getText(pControl)
	--[[if pControl ~= nil then
		return pControl:getChildByTag(1):getStringValue()
	end]]--
	local sValue = GetStrokeText(pControl)
	return sValue
end

function setColor( pControl, Color )
	--[[if pControl ~= nil then
		-- pControl:getChildByTag(1):setColor(Color)
		pControl:getChildByTag(2):setColor(Color)
	end]]--
	SetStrokeTextColor( pControl, Color)
end


function SetTextOpacity(pControl,nOpacity)
	SetStrokeOpacity(pControl,nOpacity)
end
--[[function setVisible( pControl, bVisible )
	if pControl ~= nil then
		pControl:setVisible(bVisible)
	end
end]]--
local function DeleteString(strText, strTemp)
	--print("DeleteString")
	--print("DeleteString strText = "..strText)
	--print("DeleteString strTemp = "..strTemp)
	--local Idx1 = string.find(strText, strTemp)
	--print(Idx1)
	return string.gsub(strText, strTemp, "", 1)
end

--判断字符所占宽度
local m_nLastWidth = 0.0
local isHuanHang = false
local function JudgeStringSize( strTemp ,fontSize, LayoutSize)
	--m_nLastWidth = 0.0
	isHuanHang = false
	strTemp = strTemp
	local strList = {}
	local splitStr = ""
    local len = string.len(strTemp)
    -- print("strTemp = "..strTemp)
    local i = 1 
    local width = 0
    while i <= len do
        local c = string.byte(strTemp, i)
        local shift = 1
        if c > 0 and c <= 127 then
        	shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(strTemp, i, i+shift-1)
        i = i + shift
        table.insert(strList,char)

   		if shift == 1 then
   			if c >64 and c < 91 then
        		width = width + fontSize * 0.6 		--大写字母
        	elseif c >96 and c < 123 then
        		width = width + fontSize * 0.45  	--小写字母
        	else
           		width = width + fontSize * 0.5 
       	    end    	
  		else
       	 	width = width + fontSize
      	  	--print(char)
      	  	--print("width == "..width)
   		end  
   		if m_nLastWidth > 0 then
   			--print("上一次字符没换行所以记录宽度 "..width)
   			width = width + m_nLastWidth
   			m_nLastWidth = 0.0
   		end
     	if width >= LayoutSize then
    		--切割字符串
    		isHuanHang = true
    		for key,value in pairs(strList) do
    			splitStr = splitStr..value
    		end
    		--print("split str = "..splitStr)
    		--print("这行字符的宽度为："..width.." 大于了一行的规定宽度："..LayoutSize.."。需要换行")
    		m_nLastWidth = 0.0
    		return splitStr,true
    	else
    		isHuanHang = false
    		--print(m_nLastWidth.."这个宽度没有超过换行宽度，暂时存起来")
   		end   
    end
    if isHuanHang == false then
    	m_nLastWidth = width 	
    end

    --print("当前这段字符串总宽度为 "..width)
    return strTemp,false
end

local function GetTextString(strText, nStart)
	local strTemp = ""
	local Idx1 = string.find(strText, "|", nStart)
	if Idx1 == nil then strTemp = strText return strTemp end
	--print("one :　Idx1 = "..Idx1)
	local Idx2 = string.find(strText, "|", Idx1+1)
	--print("two :　Idx2 = "..Idx2)
	if Idx2 ~= nil and Idx1 ~= nil and tonumber(Idx2) - tonumber(Idx1) >= 2 then
		if Idx1 ~= nil then
			strTemp = string.sub(strText, 0, Idx1-1)
			--print("three : strText = "..strText.." and endIdx = "..Idx1-1)
		end
	else
		--print("four : Idx2+1 = "..Idx2+1)
		return GetTextString(strText, Idx2+1)
	end
	--print("Five : strTemp = "..strTemp)
	return strTemp
end

local function GetKeyString(strText, nStart)
	local strTemp = ""
	local Idx1 = string.find(strText, "|", nStart)
	if Idx1 == nil then return strTemp end

	local Idx2 = string.find(strText, "|", Idx1+1)
	if Idx2 ~= nil and Idx1 ~= nil and tonumber(Idx2) - tonumber(Idx1) <= 1 then
		return GetKeyString(strText, Idx2+1)
	else
		local Idx3 = string.find(strText, "|", Idx2+1)
		if Idx3 ~= nil then
			if nStart ~= 0 then
				strTemp = string.sub(strText, Idx1, Idx3)
			else
				strTemp = string.sub(strText, 0, Idx3)
			end
		end
	end

	return strTemp
end

local RichType = {
	None    = 0,
	Text 	= 1,
	Img		= 2,
	Ani 	= 3,
	Ent 	= 4, -- 换行
}

local m_EntRowNum = 0	--换了几行
local m_EntRowHeight = 0   --每行的高度

local function InitVars()
	m_EntRowNum = 0
	m_EntRowHeight = 0
end

function CreateRichTextLabel(strTextAll,LayoutSize)
	InitVars()
	local colorText = COLOR_White
	local sizeText = 22
	local fontText = "default"
	local nType = RichType.None
	local strImgPath = ""
	local strAniName = ""
	local strText = ""
	local nEntCount = 1
	local nLineSpace = 0
	local tableRich = {}

	local _Lab_bk = Layout:create()

	--ccDrawColor4B(r, g, b, a)
	--ccDrawLine(ccp(), ccp())
	local function DoKeyAnys(strKey)
		local Idx1 = string.find(strKey, "|", 0)
		local Idx2 = string.find(strKey, "|", Idx1+1)
		local strTemp = string.sub(strKey, Idx1+1, Idx2-1)

		local strCon = string.sub(strKey, Idx2+1, string.len(strKey)-1)
		nType = RichType.None

		if strTemp == "color" then
			local nInx1 = string.find(strCon, ",", 0)
			local nR = string.sub(strCon, 0, nInx1-1)
			local nInx2 = string.find(strCon, ",", nInx1+1)
			local nG = string.sub(strCon, nInx1+1, nInx2-1)
			local nB = string.sub(strCon, nInx2+1, string.len(strCon))

			colorText = ccc3(tonumber(nR), tonumber(nG), tonumber(nB))
			nType = RichType.None
		else 
			if strTemp == "size" then
				sizeText = tonumber(strCon)
				nType = RichType.None
			else
				if strTemp == "font" then
					nType = RichType.None
					if strCon == "font1" then
						fontText = CommonData.g_FONT1
					end
					if strCon == "font2" then
						fontText = CommonData.g_FONT2
					end
				else
					if strTemp == "img" then
						nType = RichType.Img
						strImgPath = strCon
					else
						if strTemp == "ani" then
							nType = RichType.Ani
							strAniName = strCon
						else
							if strTemp == "n" then
								nType = RichType.Ent
								nEntCount = tonumber(strCon)
								m_EntRowNum = m_EntRowNum + tonumber(strCon)
							else
								if strTemp == "linespace" then
									nType = RichType.None
									nLineSpace = tonumber(strCon)
								else
									-- add here
								end
							end
						end
					end
				end
			end
		end
	end

	local function getString()
		while true do
			local nS = string.find(strTextAll, "|", 0)
			local isEnt = false
			if nS == 1 then
				local strKey = GetKeyString(strTextAll, 0)
				DoKeyAnys(strKey)
				strTextAll = DeleteString(strTextAll, strKey)
				strText = " "
			else
				local strTemp = GetTextString(strTextAll)
				local strTempSplit,isSplite = JudgeStringSize(strTemp,sizeText,LayoutSize)
				strTextAll = DeleteString(strTextAll, strTempSplit)
				strText = strTempSplit
				nType = RichType.Text
				--[[
				strTextAll = DeleteString(strTextAll, strTemp)
				strText = strTemp	
				nType = RichType.Text
				--]]
				isEnt = isSplite
				if isEnt then m_EntRowNum = m_EntRowNum + 1 end
			end
			strText = string.gsub(strText, "||", "|")


			local tTemp = {}
			tTemp.colorText = colorText
			tTemp.sizeText = sizeText
			tTemp.fontText = fontText
			tTemp.strText = strText
			tTemp.nType = nType
			tTemp.strImgPath = strImgPath
			tTemp.strAniName = strAniName
			tTemp.nLineSpace = nLineSpace
			tTemp.nEntCount = nEntCount
			tTemp.nSplite = isEnt
			table.insert(tableRich, tTemp)
			if string.len(strTextAll) == 0 or strText == strTextAll then
				break
			end
		end
	end

	getString()
	
	local nPosX = 0.0
	local nPosY = 0.0
	local nLineHeight = 0
    for key, value in pairs(tableRich) do
    	if value.nType == RichType.Text then
			local _Label_ = Label:create()
			_Label_:setText(value.strText)
			_Label_:setFontSize(value.sizeText)
			_Label_:setColor(value.colorText)

			if value.fontText ~= "default" then
				_Label_:setFontName(value.fontText)
			end

			_Label_:setPosition(ccp(nPosX, nPosY))
			_Label_:setAnchorPoint(ccp(0,0.5))
			_Lab_bk:addChild(_Label_)

			local nSize = _Label_:getSize()

			if value.nSplite == true then
				nPosX = 0
				nLineHeight = nSize.height
				nPosY = nPosY - nLineHeight
			else
				nPosX = nPosX + nSize.width
				nLineHeight = nSize.height
			end
    	end

    	if value.nType == RichType.Img then
    		local _Img_ = ImageView:create()
        	_Img_:loadTexture(value.strImgPath)
			_Img_:setPosition(ccp(nPosX, nPosY))
			_Img_:setAnchorPoint(ccp(0,0.5))
			_Lab_bk:addChild(_Img_)

			local nSize = _Img_:getSize()

			nPosX = nPosX + nSize.width
			nLineHeight = nSize.height
    	end

    	if value.nType == RichType.Ani then

			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/effect/biaoqing.ExportJson")
			local PayArmature = CCArmature:create("biaoqing")
			PayArmature:getAnimation():play(value.strAniName)
			PayArmature:setPosition(ccp(nPosX, nPosY))
			PayArmature:setAnchorPoint(ccp(0,0.5))
			_Lab_bk:addNode(PayArmature)

			local nSize = PayArmature:getContentSize()
			nPosX = nPosX + nSize.width
			nLineHeight = nSize.height

    	end

    	if value.nType == RichType.Ent then
    		for i = 1, tonumber(value.nEntCount) do
    			nPosY = nPosY - nLineHeight - value.nLineSpace
    		end
    		nPosX = 0
    	end
    end

    m_EntRowHeight = nLineHeight
    m_nLastWidth = 0.0

	return _Lab_bk
end

function getRowsNum()
	return m_EntRowNum
end

function getRowsHeight()
	return m_EntRowHeight
end

