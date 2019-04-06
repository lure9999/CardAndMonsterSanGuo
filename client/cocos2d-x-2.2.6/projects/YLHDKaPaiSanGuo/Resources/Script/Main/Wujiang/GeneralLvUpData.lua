require "Script/Common/Common"

module("GeneralLvUpData", package.seeall)

function GetNeedExp( nLv )
	if nLv>MAX_PLAYER_LEVEL then
		nLv = MAX_PLAYER_LEVEL
	end
	return tonumber(expand.getFieldByIdAndIndex(tonumber(nLv),"Exp"))
end

function GetGeneralExpPool(  )
	return tonumber(CommonData.g_MainDataTable.GeneralExpPool)
end

function GetGeneralMaxExpPool(nLv)
	return tonumber(expand.getFieldByIdAndIndex(tonumber(nLv),"Exp_Reserves"))
end

function CalcNeedExpByIncLv( nBaseLv, nIncLv )
	local nNeedExp = 0

	for nLv=nBaseLv, nBaseLv+nIncLv do
		nNeedExp = nNeedExp + GetNeedExp(nLv)
	end
	return nNeedExp
end

function CheckNeed(nCurLv, nUpLevel)
	if nCurLv>= MAX_PLAYER_LEVEL then
		TipLayer.createTimeLayer("武将等级已达到最大值", 2)
		return false
	end
	local nCurExpPool = GetGeneralExpPool()
	local nNeedExp = CalcNeedExpByIncLv(nCurLv, nUpLevel-1)
	-- print("CurLevel = "..nCurLv.."\tIncLv = "..nUpLevel.."\tExpPool = "..nCurExpPool.."\tExpNeed = "..nNeedExp)
	if tonumber(nCurExpPool) < tonumber(nNeedExp) then
        TipLayer.createTimeLayer("当前经验池不够", 2)
        return false
	end
	local upLv = tonumber(nCurLv + nUpLevel)
	if upLv > MAX_PLAYER_LEVEL then
		upLv = MAX_PLAYER_LEVEL
	end	
	if upLv > tonumber(CommonData.g_MainDataTable.level) then
        TipLayer.createTimeLayer("武将等级不能超过主将等级，请提高主将等级", 2)
        return false
	end
	return true
end

--根据公式 属性初值+属性成长*(转生次数+（等级/10）） 得出当前的四个基本属性
--传入初始值，传入当前的等级 ，传入增长值
function GetExpressData(nUpLevel, nGrowValue, nTrunLife)
	local nValue = nGrowValue*(nTrunLife+((tonumber(nUpLevel))/10))
	return nValue
end

function GetAddAttrValue(nUpLevel, nTrunLife)
	local nAddHp 		= GetExpressData(nUpLevel, 100, nTrunLife)
	local nAddAttack 	= GetExpressData(nUpLevel, 20, nTrunLife)
	local nAddWuFang 	= GetExpressData(nUpLevel, 10, nTrunLife)
	local nAddFaFang 	= GetExpressData(nUpLevel, 10, nTrunLife)
	return nAddHp,nAddAttack,nAddWuFang,nAddFaFang
end