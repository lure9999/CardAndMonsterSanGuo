
module("RichLabel", package.seeall)

local nRichDataType = {
	nText		=	1,			--纯文本
	nImg		=	2,			--图片
	nAni		=	3,			--动画
	nLink		=	4,			--超链接
}

local nRichKeys = {
	nKey 			= "|",					--分割符
	nColorKey  		= "color",				--颜色属性
	nSizeKey		= "size",				--字体大小属性
	nImgKey	    	= "img",				--图片属性
	nAniKey	    	= "ani",				--动画属性
	nLineSpaceKey   = "linespace",			--文本间距
	nFontKey 		= "font",				--字体库编号
	nEnt 			= "n",					--换行属性
	--nCoustom		= "customAttr"			--自定义属性
}

local m_imgPath = ""

local nTag = 0
local m_RichType = 0

local m_Parent	= nil
local m_IsScale = 1

--click callback
local function _Image_Click_CallBack( sender,eventType )
	if eventType == 2 then
		print(sender:getTag())
	end
end

--add Animation
local function InsertRichLabelAnimationItem( nAniTag ,nAniName ,nParent )	
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/imgres/chat/biaoqing/biaoqing.ExportJson")
	local PayArmature = CCArmature:create("biaoqing")
	if m_IsScale ~= 1 then
		local size = PayArmature:getContentSize()
		local width = size.width * m_IsScale
		local height = size.height * m_IsScale
		PayArmature:setScale(m_IsScale)
		PayArmature:setContentSize(CCSize(width,height))
	end
	PayArmature:getAnimation():play(nAniName)
	local recustom = RichElementCustomNode:create(1, COLOR_White, 255, PayArmature)
	nParent:pushBackElement(recustom)
	nTag = nTag + 1
end

--add Image
local function InsertRichLabelImageItem( nImgTag, nImgPath ,nParent )
	local reimg = RichElementImage:create(100 + nImgTag,COLOR_White,255,nImgPath)
	if m_RichType == 0 then
		nParent:pushBackElement(reimg)
	elseif m_RichType == 1 then
		--nParent:pushTouchElement(reimg)
		nParent:pushBackElement(reimg)
	end
	nTag = nTag + 1
end

--add Text
function InsertRichLabelTextItem( nTextTag, nStrText , nFontSize, nColorText, nFontType, nParent)
	local re1 = RichElementText:create(200 + nTextTag,nColorText,255,nStrText,nFontType,nFontSize)
	if nParent == nil then 
		m_Parent:pushBackElement(re1)
	else
		nParent:pushBackElement(re1)
	end
	nTag = nTag + 1
end

--add CustomNode
local function InsertRichLabelCoustomItem( nNodeTag,nParent )
	local cus1 = RichElementCustomNode:create(nNodeTag,ccc3(0,0,0),255,img)
	nParent:pushBackElement(cus1)
	nTag = nTag + 1
end

function AddCustomItem( nNode ,nScale)
	local pNode = CCNode:create()
	pNode:setContentSize(nNode:getContentSize())
	nNode:setPosition(ccp(nNode:getContentSize().width * 0.5 , nNode:getContentSize().height * 0.5))
	pNode:addChild(nNode)
	pNode:setScale(nScale)
	local cus1 = RichElementCustomNode:create(nTag,ccc3(0,0,0),255,pNode)
	m_Parent:pushBackElement(cus1)
end

local function CreateLabelItem( nStrText , nFontSize, nColorText, nFontType, nParent, nRichDimensions )
	--创建label前先判断自己还有多少空间可以添加字符
	local nSurplusWidth = nRichDimensions - nCurrWidth
	--取得所有单个字符
	local nCharList,strLen = ComminuteText(nStrText)

	local _Label_ = Label:create()
	_Label_:setFontSize(nFontSize)
	_Label_:setColor(nColorText)

	if nFontType ~= "default" then
		_Label_:setFontName(nFontType)
	end
	local nLabelRender = tolua.cast(_Label_:getVirtualRenderer(),"CCLabelTTF")

	local Size = _Label_:getContentSize()
	nCurrWidth = nCurrWidth + Size.width

	_Label_:setText(nStrText)
	_Label_:setPosition(ccp(nPosX, nPosY))
	_Label_:setAnchorPoint(ccp(0,0.5))
	nParent:addChild(_Label_)
	nPosX = nPosX + Size.width
	print("after add Label width ---------------> "..nCurrWidth)
end

function Create( nData , nDimensions ,nType, nAnchorPt, nScaleNum )
	m_RichType = nType
	local nRichData 			= nData 					--用户输入的字符
	local nRichText 			= ""						--用户输入的纯文字
	local nRichDimensions		= nDimensions				--富文本的边界尺寸
	local nFontSize 			= 20						--文本要求字体尺寸
	local nFontType 			= "default"					--字体类型
	local nColorText 			= COLOR_White				--当前字体颜色
	local nImgPath				= ""						--插入的图片路径
	local nAniName				= ""						--插入的动画路径
	local nLineSpace 			= 0							--文件间隙（空格）
	local nEnt 					= 0							--文本换行数

	if nScaleNum ~= nil then
		m_IsScale = nScaleNum
	end

	--判断是否有转义字符
	local function JudgeEscapeStr()
		local ntmpStr = nRichData
		local nEscapeStrIdx = string.find(ntmpStr,"*",2)
		if nEscapeStrIdx ~= nil then 
			local nfaceStr = string.sub(ntmpStr,nEscapeStrIdx + 1,nEscapeStrIdx + 2)
			local nfaceId = tonumber(nfaceStr)
			--print("nfaceStr = "..nfaceStr)
			--print("nfaceId = "..nfaceId)
			if nfaceId and nfaceId < 18 then
				local nfacePath = string.format("|ani|biaoqing%03d|",nfaceId)
				--print("nfacePath = "..nfacePath)
				nRichData = string.gsub(nRichData,"*"..nfaceStr,nfacePath)
				JudgeEscapeStr()
			else
				Log("id no find")
			end
		else
			Log("no Face!")
		end
	end
	JudgeEscapeStr()
	
	local _richLabel = RichText:create()
	_richLabel:ignoreContentAdaptWithSize(false)
	_richLabel:setSize(CCSizeMake(nDimensions,0))
	_richLabel:setTouchEnabled(true)
	_richLabel:setTag(10000)
	_richLabel:addTouchEventListener(_Image_Click_CallBack)
	if nAnchorPt ~= nil then 
		_richLabel:setAnchorPoint(nAnchorPt)
	else
		_richLabel:setAnchorPoint(ccp(0,1))
	end
	--_richLabel:setColor(ccc3(255,0,0))

	local nAttrIdx	   				= string.find(nRichData,nRichKeys.nKey,1)
	if nAttrIdx~=nil and nAttrIdx > 1 then												--说明数据开头没有属性标识
		local str = string.sub(nRichData,1,nAttrIdx - 1)
		InsertRichLabelTextItem( nTag, str , nFontSize, nColorText, nFontType, _richLabel)
	end	

	local function FindAttrKeys( nRichData )
		local nAttrIdx	   			= string.find(nRichData,nRichKeys.nKey,1)							--找到属性的起始 "|" 
		if nAttrIdx ~= nil then			
			local nAttrEndIdx 		= string.find(nRichData,nRichKeys.nKey,nAttrIdx + 1)		  		--找到属性的结束 "|"
			local nAttrType    		= string.sub(nRichData,nAttrIdx + 1,nAttrEndIdx - 1) 				--找到属性类型
			local nNumEndIdx 		= string.find(nRichData,nRichKeys.nKey,nAttrEndIdx + 1)
			if nAttrType == nRichKeys.nColorKey then
				local nDivInx1 		= string.find(nRichData, ",", nAttrEndIdx + 1)
				local nR 			= string.sub(nRichData, nAttrEndIdx + 1, nDivInx1 - 1)
				local nDivInx2 		= string.find(nRichData, ",", nDivInx1 + 1)
				local nG 			= string.sub(nRichData, nDivInx1 + 1, nDivInx2 - 1)
				local nDivEndInx    = string.find(nRichData, "|", nDivInx2 + 1)
				local nB 			= string.sub(nRichData, nDivInx2 + 1, nDivEndInx - 1)
				nColorText       	= ccc3(tonumber(nR), tonumber(nG), tonumber(nB))
			elseif nAttrType == "size" then
				local sizeStr		= string.sub(nRichData, nAttrEndIdx + 1, nNumEndIdx - 1) 
				nFontSize 			= tonumber(sizeStr)
			elseif nAttrType == nRichKeys.nImgKey then
				if nNumEndIdx ~= nil then
					nImgPath 			= string.sub(nRichData, nAttrEndIdx + 1, nNumEndIdx - 1)
					InsertRichLabelImageItem(nTag ,nImgPath , _richLabel)
				end
			elseif nAttrType == nRichKeys.nAniKey then
				if nNumEndIdx ~= nil then
					nAniName 			= string.sub(nRichData, nAttrEndIdx + 1, nNumEndIdx - 1)
					InsertRichLabelAnimationItem(nTag ,nAniName , _richLabel)
				end
			elseif nAttrType == nRichKeys.nLineSpaceKey then
				local lineSpaceStr	= string.sub(nRichData, nAttrEndIdx + 1, nNumEndIdx - 1) 
				nLineSpace 			= tonumber(lineSpaceStr)
				local str = ""
				for i = 1,nLineSpace do
					str = str.."  "
				end
				InsertRichLabelTextItem( nTag, str , nFontSize, nColorText, nFontType, _richLabel)
			elseif nAttrType == nRichKeys.nFontKey then
				local fontStr		= string.sub(nRichData, nAttrEndIdx + 1, nNumEndIdx - 1) 
				if fontStr == "font1" then
					nFontType = CommonData.g_FONT1
				elseif fontStr == "font2" then
					nFontType = CommonData.g_FONT2
				else
					print("font error !")
				end
			elseif nAttrType == nRichKeys.nEnt then
				local entSpaceStr	= string.sub(nRichData, nAttrEndIdx + 1, nNumEndIdx - 1) 
				nEnt 				= tonumber(entSpaceStr)
				local function addNewLine( nNewLineNum )
					for i=1,nNewLineNum do
						_richLabel:pushNewLineElement()
					end
				end
				addNewLine(nEnt)
			--elseif nAttrType == nRichKeys.nCoustom then
			--	InsertRichLabelCoustomItem(nTag, _richLabel)
			else
				print("key error !")
			end 
			local nDataLength 		= string.len(nRichData)
			local DivData 			= string.sub(nRichData,nNumEndIdx + 1,nDataLength)
			return DivData
		else
			return nRichData
		end
	end

	--1.解析nData数据
	nRichData = FindAttrKeys(nRichData)
	local function AnalyzeData( nRichData )
		local nKeyIndex = string.find(nRichData,"|",1)
		local nEndIndex = nil
		if nKeyIndex ~= nil then nEndIndex = string.find(nRichData,"|",nKeyIndex + 1) end
		if nKeyIndex == 1 then
			--此时有属性
			if nEndIndex ~= nil then
				nRichData   = FindAttrKeys(nRichData)
				AnalyzeData(nRichData)
			end
		elseif nKeyIndex == nil then
			--此时无属性并且之后也不再有属性
			nRichText   = nRichData
			InsertRichLabelTextItem( nTag, nRichText , nFontSize, nColorText, nFontType, _richLabel)
		else
			--此时Data里有"|"
			if nEndIndex ~= nil then
				--此时在文本之后有属性改变
				nRichText   = string.sub(nRichData,1,nKeyIndex - 1)
				InsertRichLabelTextItem( nTag, nRichText , nFontSize, nColorText, nFontType, _richLabel)
				nRichData   = FindAttrKeys(nRichData)
				AnalyzeData(nRichData)
			else
				nRichText   = nRichData
				InsertRichLabelTextItem( nTag, nRichText , nFontSize, nColorText, nFontType, _richLabel)
			end

		end
	end
	AnalyzeData(nRichData)

	nTag = 0
	_richLabel:formatText()
	m_Parent = _richLabel
	return _richLabel
end