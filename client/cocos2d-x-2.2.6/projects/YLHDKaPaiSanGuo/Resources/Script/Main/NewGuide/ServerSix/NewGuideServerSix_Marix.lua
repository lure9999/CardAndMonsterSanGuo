--新手引导的服务器步骤第六大步骤-第一步是否在阵容界面
module("NewGuideServerSix_Marix", package.seeall)





function ShowMarix(fCallBack)
	--如果阵容界面没打开那么打开阵容界面
	require "Script/Main/Matrix/MatrixLayer"
	local pMatrix = MatrixLayer.GetUIControl()
	local scenetemp =  CCDirector:sharedDirector():getRunningScene()
	if pMatrix == nil then
		local function OpenMatrix()
			NetWorkLoadingLayer.loadingHideNow()
			--ClearUI()
			MainScene.ShowLeftInfo(false)
			MainScene.ClearRootBtn()
			MainScene.DeleteUILayer(MatrixLayer.GetUIControl())
			local matrix = MatrixLayer.createMatrixUI()
			scenetemp:addChild(matrix,layerMatrix_Tag,layerMatrix_Tag)
			MainScene.PushUILayer(matrix)
			if fCallBack~=nil then
				fCallBack()
			end
		end
		NetWorkLoadingLayer.loadingShow(true)
		Packet_GetMatrix.SetSuccessCallBack(OpenMatrix)
		network.NetWorkEvent(Packet_GetMatrix.CreatPacket())
	else
		if fCallBack~=nil then
			fCallBack()
		end
	end

end