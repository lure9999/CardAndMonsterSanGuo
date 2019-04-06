module("SignInLogic",package.seeall)
require "Script/Main/SignIn/SignInData"
require "Script/Main/Item/GetGoodsLayer"

function ShowRewardLayer( nTab1, nTab2, nCallBack )
	GetGoodsLayer.createGetGoods(nTab1, nTab2, nCallBack)
end

function SortSignInFromStatus( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.Sign_Times) > tonumber(b.Sign_Times)
		else
			return tonumber(a.Sign_Times) < tonumber(b.Sign_Times)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

function GetReturnMinthDate( nMonthID )
	local m_Data = {}
	m_Data = SignInData.GetDailyMonthData(nMonthID)
	if #m_Data > 0 then
		for key,value in pairs(m_Data) do
			SortSignInFromStatus(value,false)
		end
	end
	return m_Data
end

function SaveLuxuryIsFirst( is_Luxuey )
	CCUserDefault:sharedUserDefault():setBoolForKey("is_Luxuey", is_Luxuey)
end
function GetLuxuryIsFirst(  )
	CCUserDefault:sharedUserDefault():getBoolForKey("is_Luxuey")
end

function GetMonthNum(  )
	local tab = {}
	local cur_time = os.date("*t")
	local tab_dayNum = SignInLogic.GetReturnMinthDate(cur_time["month"])
	local k_tab = SignInLogic.SortSignInFromStatus(tab_dayNum,false)
	local cur_dayNum = os.date("%d",os.time({year = os.date("%Y"),month = os.date("%m")+1,day = 0}))
	for key,value in pairs(k_tab) do
		table.insert(tab,value)
		if tonumber(key) >= tonumber(cur_dayNum) then
			return tab,cur_dayNum
		end
		
	end
end