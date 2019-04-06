module("City", package.seeall)

--根据表获得每个城池的属性
function CreateCityData( nIndex ,tab)
	local cTab = tab[nIndex]
	if cTab == nil then
		print("error index = "..nIndex)
		Pause()
	end
	local city = {}
	city.Parent 				= {}						--当前城市的父节点索引
	--print(cTab.cityIndex)
	city.SelfIndex				= cTab.cityIndex			--当前城市的索引
	city.InitialAlliance		= cTab.InitialAlliance		--当前城市所属阵营
	city.X						= cTab.PtX
	city.Y						= cTab.PtY
	city.F 						= 0					
	city.G 						= 0
	city.H 						= 0
	city.CanMoveCityTab 		= {}
	for i=1,table.getn(cTab.canMoveIndex) do
		table.insert(city.CanMoveCityTab,cTab.canMoveIndex[i])
	end
	return city
end

