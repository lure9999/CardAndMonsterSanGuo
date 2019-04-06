
--最上面的各种货币提示条数据 celina

module("CoinInfoBarData", package.seeall)

require "Script/serverDB/coinshow"


function GetTabDatByLayerType(nLayerType)
	return coinshow.getDataById(nLayerType)
end

function GetColumNum(sColumnName)
	return coinshow.getIndexByField(sColumnName)
end