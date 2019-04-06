module("CorpsMemberSortLogic",package.seeall)

function SortTimeFromStatus( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.lastTime) > tonumber(b.lastTime)
		else
			return tonumber(a.lastTime) < tonumber(b.lastTime)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

function SortContributeFromStatus( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.seven) > tonumber(b.seven)
		else
			return tonumber(a.seven) < tonumber(b.seven)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end

function SortTotalFromStatus( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.totalContibute) > tonumber(b.totalContibute)
		else
			return tonumber(a.totalContibute) < tonumber(b.totalContibute)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end