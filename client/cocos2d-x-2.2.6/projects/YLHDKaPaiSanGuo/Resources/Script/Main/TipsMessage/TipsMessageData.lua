--点击按钮的各种提示信息数据  celina

module("TipsMessageData", package.seeall)


require "Script/serverDB/tips"



--nValue1, 对应TipsType
--nValue2,对应 TipsTypePara
--nValue3 对应 TipsPos
local function GetTipsDataByTypeValue(nValue1,nValue2,nValue3)
	local arrayData = tips.getArrDataBy2Field("TipsType",nValue1,"TipsTypePara",nValue2)
	for k,v in pairs(arrayData) do 
		if tonumber(v[tips.getIndexByField("TipsPos")]) == tonumber(nValue3) then
			--message = v[tips.getIndexByField("TipsValue")+1]
			return v
		end	
	end
	return nil
end

function GetMessageByValue(nType,nPara,nPos)
	local tabData = GetTipsDataByTypeValue(nType,nPara,nPos)
	if tabData~=nil then
		return tabData[tips.getIndexByField("TipsValuePara")]
	end
	return ""
end

function GetMessageWidthByValue(nType,nPara,nPos)
	local tabData = GetTipsDataByTypeValue(nType,nPara,nPos)
	
	if tabData~=nil then
		return tabData[tips.getIndexByField("TipsWidth")]
	end
	return 0
end

function ChangeFormat(nSeconds)
	local miu = math.floor(nSeconds/60)
	local sec = nSeconds%60
	return miu,sec
end