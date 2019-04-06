-- for CCLuaEngine traceback

require "Script/Common/Common"
require "Script/Audio/AudioUtil"
require "Script/serverDB/general"
require "Script/serverDB/equipt"
require "Script/serverDB/server_matrixDB"
require "Script/serverDB/server_generalDB"
require "Script/serverDB/server_equipDB"


module("MatrixLayerData", package.seeall)


function GetAnimationData_AnimationfileNameByResID( ResID )
    return AnimationData.getFieldByIdAndIndex(ResID,"AnimationfileName")
end

function GetGeneralGridByTempId( TempId )
    return server_generalDB.GetGridByTempId(TempId)
end

function GetEquipIndexByTempId( TempId )
    return server_equipDB.GetIndexByTempId(TempId)
end

function GetEquipColorByTempId( TempId )
    return equipt.getFieldByIdAndIndex(TempId,"Color")
end

function GetEquipSuitIDByTempId( TempId )
    return equipt.getFieldByIdAndIndex(TempId,"SuitID")
end

function GetEquipAnimationIDIDByTempId( TempId )
    return equipt.getFieldByIdAndIndex(TempId,"AnimationID")
end

function GetAnimationData_AnimationNameByResID( ResID )
    return AnimationData.getFieldByIdAndIndex(ResID,"AnimationName")
end

function GetEquipGrid( nGrid, nIndex )
    return server_matrixDB.GetEquipGrid(nGrid, nIndex)
end

function GetTempIdByGrid( nGrid )
    return tonumber(server_equipDB.GetTempIdByGrid(nGrid))
end