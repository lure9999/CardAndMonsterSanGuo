require "Script/serverDB/item"
require "Script/serverDB/levelupguide"
require "Script/serverDB/expand"
require "Script/serverDB/coin"
require "Script/serverDB/resimg"
module("HeroUpGradeData",package.seeall)

function CurLevelData( nLevel )
	local tabLevel = {}
	local tab = levelupguide.getDataById(nLevel)

	tabLevel["Exp_Reserves"] = tab[1]
	tabLevel["TiLi_Max"] = tab[2]
	tabLevel["NaiLi_Max"] = tab[3]
	tabLevel["Open1"] = tab[4]
	tabLevel["OpenText1"] = tab[5]
	tabLevel["Openguide1"] = tab[6]
	tabLevel["Open2"] = tab[7]
	tabLevel["OpenText2"] = tab[8]
	tabLevel["Openguide2"] = tab[9]
	tabLevel["NextOpen1"] = tab[10]
	tabLevel["NextOpenText1"] = tab[11]
	tabLevel["NextOpen2"] = tab[12]
	tabLevel["NextOpenText2"] = tab[13]

	return tabLevel
end

function GetImgpath( nIndex )
	return resimg.getFieldByIdAndIndex(nIndex,"icon_path")
end