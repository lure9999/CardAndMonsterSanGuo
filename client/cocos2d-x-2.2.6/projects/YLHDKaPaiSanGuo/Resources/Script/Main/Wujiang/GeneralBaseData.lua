-- require "Script/Common/Common"
require "Script/DB/AnimationData"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/talentrate"
module("GeneralBaseData", package.seeall)

MAX_CONSUMETYPE_COUNT=5

local m_nGeneralGrid = 0

local GetGeneralDataTab 			= server_generalDB.GetTableByGrid
local GetTempIdByGrid				= server_generalDB.GetTempIdByGrid


TalentIdx =
{
	attack 		= 1,
	wufang 		= 2,
	fafang 		= 3,
	hp 			= 4,
	duoshan 	= 5,
	crit 		= 6,
	shipo 		= 7,
	mingzhong 	= 8,
}

AttrType =
{
	WuLi 	= 1,
	FaShu	= 2,
}


function SetCurGeneralGrid(	nGrid )
	m_nGeneralGrid = nGrid
end

function GetCurGeneralGrid(  )
	return m_nGeneralGrid
end

function GetGeneralType( nGeneralId )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "Type"))
end

function GetGeneralNameByGeneralID( nGeneralId )
	return tostring(general.getFieldByIdAndIndex(nGeneralId, "Name"))
end

function GetGeneralTypeByGrid( nGrid )
	local nTempId = GetTempIdByGrid(nGrid)
	return GetGeneralType(nTempId)
end

function GetGeneralAttrType( nGeneralId )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "attribute"))
end

function GetGeneralAttrData( nGrid )
	local tabGeneralData = GetGeneralDataTab(nGrid)
	local tabAttrData = {}
	tabAttrData.ZiZhi 		= tabGeneralData["Info02"]["Quality"]
	tabAttrData.TiLi		= tabGeneralData["Info02"]["TiLi"]
	tabAttrData.WuLi		= tabGeneralData["Info02"]["WuLi"]
	tabAttrData.ZhiLi		= tabGeneralData["Info02"]["ZhiLi"]
	tabAttrData.ShengMing	= tabGeneralData["Info02"]["Init_Lift"]
	tabAttrData.GongJi		= tabGeneralData["Info02"]["Init_gongji"]
	tabAttrData.WuFang		= tabGeneralData["Info02"]["Init_wufang"]
	tabAttrData.FaFang		= tabGeneralData["Info02"]["Init_fafang"]
	tabAttrData.ShanBi		= tabGeneralData["Info02"]["Init_duoshan"]
	tabAttrData.BaoJi		= tabGeneralData["Info02"]["Init_crit"]
	tabAttrData.ShiPo		= tabGeneralData["Info02"]["Init_shipo"]
	tabAttrData.ChuanTou	= tabGeneralData["Info02"]["add_gongji"]
	tabAttrData.MianShang	= tabGeneralData["Info02"]["add_fangyu"]

	return tabAttrData
end

function GetGeneralCountryIconByTempId( nTmpId )
	local strIcon = nil
	local nType = GetGeneralType(nTmpId)
	local nCountry = tonumber(general.getFieldByIdAndIndex(nTmpId, "countries"))
	local strIcon = nil
	if nType== GeneralType.General then
		strIcon = string.format("Image/imgres/common/country/country_%d.png",nCountry)
	elseif nType==GeneralType.Main then
		strIcon = string.format("Image/imgres/common/country/zhu.png")
	elseif nType==GeneralType.HuFa then
		strIcon = string.format("Image/imgres/common/country/hu.png")
	end
	return strIcon
end

function GetGeneralCountryIcon( nGrid )
	local nTmpId = GetTempIdByGrid(nGrid)
	return GetGeneralCountryIconByTempId(nTmpId)
end

function GetGeneralTypeIconByTempId( nTempId )
	local nAttr  = tonumber(general.getFieldByIdAndIndex(nTempId, "attribute"))
	local strIcon = nil
	if nAttr == 1 then
		strIcon = string.format("Image/imgres/wujiang/attribute_1.png")
	elseif nAttr==2 then
		strIcon = string.format("Image/imgres/wujiang/attribute_2.png")
	end
	return strIcon
end

function GetGeneralTypeIcon( nGrid )
	local nTmpId = GetTempIdByGrid(nGrid)
	return GetGeneralTypeIconByTempId(nTmpId)
end

function GetGeneralNameByTempId( nTmpId )
	return general.getFieldByIdAndIndex(nTmpId, "Name")
end

function GetGeneralPos( nTempId )
	return tonumber(general.getFieldByIdAndIndex(nTempId, "Pos"))
end

function GetGeneralPosByGrid( nGrid )
	local nTempId = GetTempIdByGrid(nGrid)
	return GetGeneralPos(nTempId)
end

function GetGeneralName( nGrid )
	local nTmpId = GetTempIdByGrid(nGrid)
	local nType = GetGeneralType(nTmpId)
	local strName = nil
	if nType==GeneralType.Main then
		strName = server_mainDB.getMainData("name")
	else
		strName = GetGeneralNameByTempId(nTmpId)
	end
	return strName
end

function GetGeneralLv( nGrid )
	local tabTemp = GetGeneralDataTab(nGrid)
	if tonumber(tabTemp["Info02"]["Lv"])>100 then
		return 100
	end
	return tabTemp["Info02"]["Lv"]
end

function GetMainGeneralLv(  )
	return CommonData.g_MainDataTable.level
end

function GetGeneralTurnLife( nGrid )
	local tabTemp = GetGeneralDataTab(nGrid)
	return tabTemp["Info02"]["Turn"]
end

function GegAnimationId( nGeneralId )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "ResID"))
end

function GetAnimationData(nAniId)
	local pAnimationfileName = AnimationData.getFieldByIdAndIndex(nAniId,"AnimationfileName")
	local pAnimationName = AnimationData.getFieldByIdAndIndex(nAniId,"AnimationName")

	return pAnimationfileName, pAnimationName
end

function GetGeneralStar( nGrid )
	local tabTemp = GetGeneralDataTab(nGrid)
	return tabTemp["Info02"]["Star"]
end

function ConvertNumToCNChar(nLv)
	local str = nil
	if nLv==1 then
		str = "壹"
	elseif nLv==2 then
		str = "贰"
	elseif nLv==3 then
		str = "叁"
	elseif nLv==4 then
		str = "肆"
	elseif nLv==5 then
		str = "伍"
	elseif nLv==6 then
		str = "陆"
	elseif nLv==7 then
		str = "柒"
	elseif nLv==8 then
		str = "捌"
	elseif nLv==9 then
		str = "玖"
	end
	return str
end

function GetDanYaoLvText( nGrid )
	local tabTemp = GetGeneralDataTab(nGrid)
	local nLv =  tabTemp["Info02"]["danyaoLv"]
	local str = nil
	local strNum = nil
	if nLv==0 then
		str="凝神成丹"
	elseif nLv>0 and nLv<10 then
		local strNum = ConvertNumToCNChar(nLv)
		str = "金丹"..strNum.."转"
	else
		str = "鸿蒙待诏"
	end
	return str
end

function GetSkillData( nGeneralId )
	local tabSkillData = {}

	-- 普通技能信息
	local tabNormalSkill = {}
	local nNormalSkillId = tonumber(general.getFieldByIdAndIndex(nGeneralId, "attack_ID"))
	tabNormalSkill.SkillId = nNormalSkillId
	tabNormalSkill.Name = skill.getFieldByIdAndIndex(nNormalSkillId, "Name")
	tabNormalSkill.Desc = skill.getFieldByIdAndIndex(nNormalSkillId, "Des")
	tabSkillData.NormalSkill = tabNormalSkill

	local tabAutoSkill = {}
	local nSAutokillId = tonumber(general.getFieldByIdAndIndex(nGeneralId, "skill_ID"))
	tabAutoSkill.SkillId = nSAutokillId
	tabAutoSkill.Name = skill.getFieldByIdAndIndex(nSAutokillId, "Name")
	tabAutoSkill.Desc = skill.getFieldByIdAndIndex(nSAutokillId, "Des")
	tabSkillData.AutoSkill = tabAutoSkill

	local tabEngineSkill = {}
	local nEngineSkillId = tonumber(general.getFieldByIdAndIndex(nGeneralId, "Engine_ID"))
	tabEngineSkill.SkillId = nEngineSkillId
	tabEngineSkill.Name = skill.getFieldByIdAndIndex(nEngineSkillId, "Name")
	tabEngineSkill.Desc = skill.getFieldByIdAndIndex(nEngineSkillId, "Des")
	tabSkillData.EngineSkill = tabEngineSkill

	return tabSkillData
end

local function GetTalentValue( strDes, tabTalent )
	local strType = string.sub(strDes, 0, 6)
	local strValue = string.sub(strDes,7)
	local atrData = talentrate.getArrDataByField("talentrate",strValue)
	local nValue = tonumber(atrData[1][talentrate.getIndexByField("numerical")])

	if strType == "生命" then
		tabTalent[TalentIdx.hp] = nValue
	elseif strType == "攻击" then
		tabTalent[TalentIdx.attack] = nValue
	elseif strType == "物防" then
		tabTalent[TalentIdx.wufang] = nValue
	elseif strType == "法防" then
		tabTalent[TalentIdx.fafang] = nValue
	elseif strType == "物闪" then
		tabTalent[TalentIdx.duoshan] = nValue
	elseif strType == "法破" then
		tabTalent[TalentIdx.shipo] = nValue
	elseif strType == "命中" then
		tabTalent[TalentIdx.mingzhong] = nValue
	elseif strType == "暴击" then
		tabTalent[TalentIdx.crit] = nValue
	end
	return tabTalent
end

function GetTalentData( nTalentId )
	local tabTalent = {}
	local tabTalentDes = {}
	local strDes = talent.getFieldByIdAndIndex(nTalentId, "talentDes")
	while(string.find(strDes,",")) do
		local nBeginIdx, nEndIdx = string.find(strDes, ",")
		local strTalent = string.sub(strDes, 1, nEndIdx-1)
		table.insert(tabTalentDes, strTalent)
		strDes = string.sub(strDes, nEndIdx+1)
	end
	table.insert(tabTalentDes, strDes)

	for i,v in ipairs(tabTalentDes) do
		GetTalentValue(v, tabTalent)
	end

	return tabTalent
end

function GetAttrPosition( angle, nRatio, unitLen, basePointX, basePointY )
	local nPosX= math.floor(basePointX+math.cos(math.rad(angle))*unitLen*nRatio)
	local nPosY= math.floor(basePointY+math.sin(math.rad(angle))*unitLen*nRatio)
	return nPosX, nPosY
end

function GetTalentId( nGeneralId )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "talent"))
end
function GetTalentName( nTalentId )
	return talent.getFieldByIdAndIndex(nTalentId, "talentName")
end

function GetBlogData( nGeneralId )
	return general.getFieldByIdAndIndex(nGeneralId,"Des")
end

function GetGeneralHeadIcon( nGeneralId )
	local nResId = general.getFieldByIdAndIndex(nGeneralId, "ResID")
    return AnimationData.getFieldByIdAndIndex(nResId,"ImagefileName_Head")
end

function GetGeneralQuality( nGeneralId )
	return tonumber(general.getFieldByIdAndIndex(nGeneralId, "Colour"))
end
function GetGeneralColorIcon( nGeneralId )
	local nPinzhi = GetGeneralQuality(nGeneralId)
    return string.format("Image/imgres/common/color/wj_pz%d.png",nPinzhi)
end

function GetItemType( nItemId )
	return tonumber(item.getFieldByIdAndIndex(nItemId,"item_type"))
end

function GetItemQuality( nItemId )
	return tonumber(item.getFieldByIdAndIndex(nItemId,"pinzhi"))
end

function GetItemColorIcon( nItemId )
	local nQuality = GetItemQuality(nItemId)
	return string.format("Image/imgres/common/color/item_pz%d.png",nQuality)
end

function GetArrowPath( nGeneralId )
	local nPinzhi = GetGeneralQuality(nGeneralId)
    return  string.format("Image/imgres/common/color/arrow_pz%d.png",nPinzhi)
end

function GetAniKeyDef( nGrid )
	local tabAniKeyDef = {}
	local nGeneralId = GetTempIdByGrid(nGrid)
	if GetGeneralType(nGeneralId)~=GeneralType.HuFa then
		tabAniKeyDef = {"Ani_run",
						"Ani_attack",
						"Ani_skill",
						"Ani_manual_skill",
						"Ani_cheers",}
	else
		tabAniKeyDef = {"Ani_attack"}
	end

	return tabAniKeyDef
end

function GetGenerHeadByGrid( nGrid )
	local nTempId = GetTempIdByGrid(nGrid)
	return GetGeneralHeadIcon(nTempId),GetGeneralColorIcon(nTempId)
end

function GetItemIDByGeneralID( nGeneralId )
	local pData = item.getTable()

	local nItemIdStr = nil 

    local fieldNo = 1
    for i=1, #item.keys do
        if item.keys[i] == "event_para_A" then
            fieldNo = i
            break
        end
    end
    for k, v in pairs(pData) do
        if tostring(v[fieldNo-1]) == tostring(nGeneralId) then
            nItemIdStr = k
        end
    end
	if nItemIdStr == nil then
		return 
	end
    local nDataLength 		= string.len(nItemIdStr)

    local nItemId = tonumber(string.sub(nItemIdStr,4,nDataLength))

    return nItemId

end