module("CorpsContentData",package.seeall)
require "Script/serverDB/legioicon"
require "Script/serverDB/resimg"--
require "Script/serverDB/globedefine"
require "Script/serverDB/consume"
require "Script/serverDB/item"
require "Script/serverDB/technolog"
require "Script/serverDB/effect"
require "Script/serverDB/pointreward"
require "Script/serverDB/coin"
require "Script/serverDB/vipfunction"
require "Script/serverDB/server_CorpsGetInfoDB"

--返回月份的天数
function GetDayNumByMon( nMonth,nYears )
	local nDayNum = 0
	if tonumber(nMonth) == 1 then
		nDayNum = 31
	elseif tonumber(nMonth) == 2 then
		if (tonumber(nYears)%4 == 0 or tonumber(nYears)%100 ~= 0 ) and (tonumber(nYears)%400 == 0) then
			nDayNum = 29
		else
			nDayNum = 28
		end
	elseif tonumber(nMonth) == 3 then
		nDayNum = 31
	elseif tonumber(nMonth) == 4 then
		nDayNum = 30
	elseif tonumber(nMonth) == 5 then
		nDayNum = 31
	elseif tonumber(nMonth) == 6 then
		nDayNum = 30
	elseif tonumber(nMonth) == 7 then
		nDayNum = 31
	elseif tonumber(nMonth) == 8 then
		nDayNum = 31
	elseif tonumber(nMonth) == 9 then
		nDayNum = 30
	elseif tonumber(nMonth) == 10 then
		nDayNum = 31
	elseif tonumber(nMonth) == 11 then
		nDayNum = 30
	elseif tonumber(nMonth) == 12 then
		nDayNum = 31
	end
	return nDayNum
end

--得到成员科技的信息
function GetMemTechData( nLevel )
	local tablePersonNumData = {}
	for i=11,14 do
		local ArrayMemData = CorpsScienceData.GetArrayData(i)
		table.insert(tablePersonNumData,ArrayMemData)
	end
	return tablePersonNumData[nLevel]
end

--得到官员科技的信息
function GetOffTechData( nLevel )
	local tablePersonNumData = {}
	for i=15,18 do
		local ArrayMemData = CorpsScienceData.GetArrayData(i)
		table.insert(tablePersonNumData,ArrayMemData)
	end
	return tablePersonNumData[nLevel]
end

--得到当前科技的官员数量
function GetOfficalLimitNum( nLevel )
	local tab = GetOffTechData(nLevel)
	if tonumber(tab[10]) == 0 or tonumber(tab[11]) == 0 then
		return 0,0
	end
	return effect.getFieldByIdAndIndex(tonumber(tab[10]),"EffectPara1"),effect.getFieldByIdAndIndex(tonumber(tab[11]),"EffectPara1")
end

--得到当前科技的总人数
function GetTotalLimitNum( nLevel )
	local tab = GetMemTechData(nLevel)
	return effect.getFieldByIdAndIndex(tonumber(tab[10]),"EffectPara1")
end

function GetSetIconPath( nID )
	-- local nIndex = legioicon.getFieldByIdAndIndex(nID,"iconid")
	return resimg.getFieldByIdAndIndex(nID,"icon_path")
end

function GetCountry( nID )
	local path = nil
	if tonumber(nID) == 1 then
		path = "Image/imgres/common/country/country_1.png"
	elseif tonumber(nID) == 2 then
		path = "Image/imgres/common/country/country_2.png"
	elseif tonumber(nID) == 3 then
		path = "Image/imgres/common/country/country_3.png"
	end
	return path
end

function GetSetInfoByserver(  )
	return server_CorpsSettingDB.GetCopyTable()
end

function GetOfficalControl( nTag )
	local tab = {}
	if tonumber(nTag) == 1 then
		tab = {"修改军团图标","修改准入条件","修改军团公告","修改军团说明","处理申请列表","踢出军团成员","研发军团科技","注资军团科技","转交军团长","任命副将","任命圣女","任命护法","解散军团"}
	elseif tonumber(nTag) == 2 then
		tab = {"修改军团图标","修改准入条件","修改军团公告","修改军团说明","处理申请列表","踢出军团成员","研发军团科技","注资军团科技","任命圣女","任命护法","离开军团"}
	elseif tonumber(nTag) == 3 then
		tab = {"修改军团图标","修改军团公告","修改军团说明","处理申请列表","踢出军团成员","研发军团科技","注资军团科技","离开军团"}
	elseif tonumber(nTag) == 4 then
		tab = {"修改军团图标","修改军团公告","修改军团说明","处理申请列表","踢出军团成员","研发军团科技","注资军团科技","离开军团"}
	elseif tonumber(nTag) == 5 then
		tab = {"离开军团"}
	end
	return tab
end

function SortPartByTime( TabItem )

	local totalTab = {}
	local tab1 = {}
	local tab2 = {}
	local tab3 = {}
	local tab4 = {}
	local tab5 = {}
	local tab6 = {}
	local tab7 = {}
	local tab8 = {}
	local tab9 = {}
	local tab10 = {}
	local tab11 = {}
	local tab12 = {}
	local tab13 = {}
	local tab14 = {}
	local tab15 = {}
	local tab16 = {}
	local tab17 = {}
	local tab18 = {}
	local tab19 = {}
	local tab20 = {}
	local tab21 = {}
	local tab22 = {}
	local tab23 = {}
	local tab24 = {}
	local tab25 = {}
	local tab26 = {}
	local tab27 = {}
	local tab28 = {}
	local tab29 = {}
	local tab30 = {}
	local tab31 = {}
	
	for key,value in pairs(TabItem) do

		local nTimeDB = os.date("*t", value["time"])
		printTab(nTimeDB)
		
		if tonumber(nTimeDB["day"]) == 1 then
			
			table.insert(tab1,value)
		elseif tonumber(nTimeDB["day"]) == 2 then
			
			table.insert(tab2,value)
		elseif tonumber(nTimeDB["day"]) == 3 then
			
			table.insert(tab3,value)
		elseif tonumber(nTimeDB["day"]) == 4 then
			
			table.insert(tab4,value)
		elseif tonumber(nTimeDB["day"]) == 5 then
			
			table.insert(tab5,value)
		elseif tonumber(nTimeDB["day"]) == 6 then
			
			table.insert(tab6,value)
		elseif tonumber(nTimeDB["day"]) == 7 then
			
			table.insert(tab7,value)
		elseif tonumber(nTimeDB["day"]) == 8 then
			
			table.insert(tab8,value)
		elseif tonumber(nTimeDB["day"]) == 9 then
			
			table.insert(tab9,value)
		elseif tonumber(nTimeDB["day"]) == 10 then
			
			table.insert(tab10,value)
		elseif tonumber(nTimeDB["day"]) == 11 then
			
			table.insert(tab11,value)
		elseif tonumber(nTimeDB["day"]) == 12 then
			
			table.insert(tab12,value)
		elseif tonumber(nTimeDB["day"]) == 13 then
			
			table.insert(tab13,value)
		elseif tonumber(nTimeDB["day"]) == 14 then
			
			table.insert(tab14,value)
		elseif tonumber(nTimeDB["day"]) == 15 then
			
			table.insert(tab15,value)
		elseif tonumber(nTimeDB["day"]) == 16 then
			
			table.insert(tab16,value)
		elseif tonumber(nTimeDB["day"]) == 17 then
			
			table.insert(tab17,value)
		elseif tonumber(nTimeDB["day"]) == 18 then
			
			table.insert(tab18,value)
		elseif tonumber(nTimeDB["day"]) == 19 then
			
			table.insert(tab19,value)
		elseif tonumber(nTimeDB["day"]) == 20 then

			table.insert(tab20,value)
		elseif tonumber(nTimeDB["day"]) == 21 then

			table.insert(tab21,value)
		elseif tonumber(nTimeDB["day"]) == 22 then

			table.insert(tab22,value)
		elseif tonumber(nTimeDB["day"]) == 23 then

			table.insert(tab23,value)
		elseif tonumber(nTimeDB["day"]) == 24 then

			table.insert(tab24,value)
		elseif tonumber(nTimeDB["day"]) == 25 then

			table.insert(tab25,value)
		elseif tonumber(nTimeDB["day"]) == 26 then

			table.insert(tab26,value)
		elseif tonumber(nTimeDB["day"]) == 27 then

			table.insert(tab27,value)
		elseif tonumber(nTimeDB["day"]) == 28 then

			table.insert(tab28,value)
		elseif tonumber(nTimeDB["day"]) == 29 then

			table.insert(tab29,value)
		elseif tonumber(nTimeDB["day"]) == 30 then

			table.insert(tab30,value)
		elseif tonumber(nTimeDB["day"]) == 31 then

			table.insert(tab31,value)
		end
	end

	if next(tab1) ~= nil then
		table.insert(totalTab,tab1)
	end
	if next(tab2) ~= nil then
		table.insert(totalTab,tab2)
	end
	if next(tab3) ~= nil then
		table.insert(totalTab,tab3)
	end
	if next(tab4) ~= nil then
		table.insert(totalTab,tab4)
	end
	if next(tab5) ~= nil then
		table.insert(totalTab,tab5)
	end
	if next(tab6) ~= nil then
		table.insert(totalTab,tab6)
	end
	if next(tab7) ~= nil then
		table.insert(totalTab,tab7)
	end
	if next(tab8) ~= nil then
		table.insert(totalTab,tab8)
	end
	if next(tab9) ~= nil then
		table.insert(totalTab,tab9)
	end
	if next(tab10) ~= nil then
		table.insert(totalTab,tab10)
	end
	if next(tab11) ~= nil then
		table.insert(totalTab,tab11)
	end
	if next(tab12) ~= nil then
		table.insert(totalTab,tab12)
	end
	if next(tab13) ~= nil then
		table.insert(totalTab,tab13)
	end
	if next(tab14) ~= nil then
		table.insert(totalTab,tab14)
	end
	if next(tab15) ~= nil then
		table.insert(totalTab,tab15)
	end
	if next(tab16) ~= nil then
		table.insert(totalTab,tab16)
	end
	if next(tab17) ~= nil then
		table.insert(totalTab,tab17)
	end
	if next(tab18) ~= nil then
		table.insert(totalTab,tab18)
	end
	if next(tab19) ~= nil then
		table.insert(totalTab,tab19)
	end
	if next(tab20) ~= nil then
		table.insert(totalTab,tab20)
	end
	if next(tab21) ~= nil then
		table.insert(totalTab,tab21)
	end
	if next(tab22) ~= nil then
		table.insert(totalTab,tab22)
	end
	if next(tab23) ~= nil then
		table.insert(totalTab,tab23)
	end
	if next(tab24) ~= nil then
		table.insert(totalTab,tab24)
	end
	if next(tab25) ~= nil then
		table.insert(totalTab,tab25)
	end
	if next(tab26) ~= nil then
		table.insert(totalTab,tab26)
	end
	if next(tab27) ~= nil then
		table.insert(totalTab,tab27)
	end
	if next(tab28) ~= nil then
		table.insert(totalTab,tab28)
	end
	if next(tab29) ~= nil then
		table.insert(totalTab,tab29)
	end
	if next(tab30) ~= nil then
		table.insert(totalTab,tab30)
	end
	if next(tab31) ~= nil then
		table.insert(totalTab,tab31)
	end
	
	return totalTab
end