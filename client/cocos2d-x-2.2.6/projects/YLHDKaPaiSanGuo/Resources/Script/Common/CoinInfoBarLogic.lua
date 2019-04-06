
--提示条的逻辑 celina
module("CoinInfoBarLogic", package.seeall)

require "Script/serverDB/coin"
require "Script/serverDB/resimg"

function GetCoinPathByID(nCoinID)
	if tonumber(nCoinID )<=0 then
		return nil
	end
	local resID = coin.getFieldByIdAndIndex(nCoinID,"ResID")
	return resimg.getFieldByIdAndIndex(resID,"icon_path")

end

function GetCoinNum(sNum)
	return server_mainDB.getMainData(sNum)
end