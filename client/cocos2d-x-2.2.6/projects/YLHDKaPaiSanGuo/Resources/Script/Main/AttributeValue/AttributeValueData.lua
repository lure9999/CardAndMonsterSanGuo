
module("AttributeValueData",package.seeall)

function SortDataFromPriority( pData, SortWay )
	local function sortAsxType( a,b )
		if SortWay == true then
			return tonumber(a.nPriority) > tonumber(b.nPriority)
		else
			return tonumber(a.nPriority) < tonumber(b.nPriority)
		end
	end
	table.sort( pData, sortAsxType )
	return pData
end