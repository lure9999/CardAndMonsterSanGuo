
--������ĸ��ֻ�����ʾ������ celina

module("CoinInfoBarData", package.seeall)

require "Script/serverDB/coinshow"


function GetTabDatByLayerType(nLayerType)
	return coinshow.getDataById(nLayerType)
end

function GetColumNum(sColumnName)
	return coinshow.getIndexByField(sColumnName)
end