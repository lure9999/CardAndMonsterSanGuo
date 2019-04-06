require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/general"
require "Script/Common/CommonData"


module("MatrixWujiangListData", package.seeall)





function SetGeneralGrid( nGrid, nGridNew )
	server_matrixDB.SetGeneralGrid(nGrid, nGridNew)
end

function GetGeneralGrid( nIndex )
	return server_matrixDB.GetGeneralGrid(nIndex)
end

function GetGeneralTableByGrid( nWjGrid )
	return server_generalDB.GetTableByGrid(nWjGrid)
end

function GetGeneralTempIdByGrid( nWjGrid )
	return server_generalDB.GetTempIdByGrid(nWjGrid)
end

function GetGeneralPosByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "Pos")
end

function GetGeneralResIDByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "ResID")
end

function GetAnimation_ImagefileName_Head_ByResID( ResID )
	return AnimationData.getFieldByIdAndIndex(ResID,"ImagefileName_Head")
end

function GetGeneralcountriesByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "countries")
end

function GetGeneralattributeByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "attribute")
end

function GetGeneralNameByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "Name")
end

function GetGeneralTypeByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "Type")
end

function GetGeneralqualityByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "quality")
end
 
function GetGeneralColourByTempId( nTmpID )
	return general.getFieldByIdAndIndex(nTmpID, "Colour")
end

