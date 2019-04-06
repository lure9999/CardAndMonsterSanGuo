
module("ItemLotSelectLogic", package.seeall)

local function SetSpriteGrayByTab(tabSData,nSelect)
	--处理选中
	if nSelect==1 then
		nSelect =4 
	end
	for i=1,#tabSData do 
		local pControl 	= tolua.cast(tabSData[i][1],"ImageView")
		if pControl~=nil then
			local _Img_Control_Sprite = tolua.cast(pControl:getVirtualRenderer(), "CCSprite")
			SpriteSharder(_Img_Control_Sprite,nSelect)	
				
		end
		
		local pImage_bg 	= tolua.cast(tabSData[i][2],"ImageView")
		if pImage_bg~=nil then
			local _Img_Image_Sprite = tolua.cast(pImage_bg:getVirtualRenderer(), "CCSprite")
			SpriteSharder(_Img_Image_Sprite,nSelect)
			local pImgIcon = pImage_bg:getChildByTag(1000)
			if pImgIcon~=nil then
				local _Img_ImgIcon_Sprite = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")
				SpriteSharder(_Img_ImgIcon_Sprite,nSelect)
			end
			local label_p = pImage_bg:getChildByTag(51)
			if label_p~=nil then
				if nState == 0 then
					LabelLayer.SetTextOpacity(label_p,250)
				else
					LabelLayer.SetTextOpacity(label_p,180)
				end
			end
		end
		
	end
end

local function SetSpriteGrayByImg(pControl,nState)
	if nState == 1 then
		nState = 4
	end
	local _Img_Control_Sprite = tolua.cast(pControl:getVirtualRenderer(), "CCSprite")
	SpriteSharder(_Img_Control_Sprite,nState)	
	--得到父节点，就是背景
	local _Img_Bg = pControl:getParent()
	if _Img_Bg~=nil then
		local pImgIcon = _Img_Bg:getChildByTag(1000)
		if pImgIcon~=nil then
			local _Img_ImgIcon_Sprite = tolua.cast(pImgIcon:getVirtualRenderer(), "CCSprite")
			SpriteSharder(_Img_ImgIcon_Sprite,nState)
		end
		local _Img_Bg_Sprite = tolua.cast(_Img_Bg:getVirtualRenderer(), "CCSprite")
		SpriteSharder(_Img_Bg_Sprite,nState)
		
		local label_p = _Img_Bg:getChildByTag(51)
		if nState == 0 then
			LabelLayer.SetTextOpacity(label_p,250)
		else
			LabelLayer.SetTextOpacity(label_p,180)
		end
	end

end
--nSelect 1，置灰 0 取消置灰
local function DealLotSelect(tabSelectData)
	SetSpriteGrayByTab(tabSelectData,1)
	
end
local function DealCancelSelect(tabSelectData)
	--shader设置为之前的，更新界面数据，tab清空
	SetSpriteGrayByTab(tabSelectData,0)
	DealDelOKImg(tabSelectData,false)
end

function DealLotSelectLogic(bLot,l_tabData,bGoods)
	if bLot== true then
		--处理多选
		if bGoods==nil then
			ItemGoods.SetSelectIconState(false)
		end
		DealLotSelect(l_tabData)
		
	end
	if bLot== false then
		--处理取消多选
		if bGoods==nil then
			ItemGoods.SetSelectIconState(true)
		end
		DealCancelSelect(l_tabData)
	end

end
local function AddImgSelectOK(pParentImg)
	local img_s_ok = ImageView:create()
	img_s_ok:loadTexture("Image/imgres/item/img_lot_select.png")
    img_s_ok:setPosition(CCPoint(44,40))
	AddLabelImg(img_s_ok,1005,pParentImg)
end
--处理多选在上面打对勾
function DealLotGoodsSelect(img_select)
	--亮起来
	local img_ok = img_select:getChildByTag(1005)
	local nGird = img_select:getTag()-TAG_GRID_ADD
	local nPrice = EquipListData.GetSellPriceByGrid(nGird)
	if img_ok==nil then
		AddImgSelectOK(img_select)
		SetSpriteGrayByImg(img_select,0) 
		--更新价格
		ItemListLayer.UpdateLablePrice(nPrice)
	else
		if img_ok:isVisible() == false then
			img_ok:setVisible(true)
			SetSpriteGrayByImg(img_select,0) 
			ItemListLayer.UpdateLablePrice(nPrice)
		else	
			img_ok:setVisible(false)
			SetSpriteGrayByImg(img_select,1)
			ItemListLayer.UpdateLablePrice(-nPrice)
		end
	end
	
end

function DealDelOKImg(tabData,bClear)
	if tabData== nil then
		return 
	end
	for i=1,#tabData do 
		local pControl 	= tolua.cast(tabData[i][1],"ImageView")
		if pControl==nil then
			return 
		end
		local img_ok = pControl:getChildByTag(1005)
		if img_ok~=nil then
			img_ok:removeFromParentAndCleanup(true)
			if bClear ==true then
				tabData[i] = nil
			end
		end
	end
	if bClear== true then
		ItemGoods.ClearTabLot()
	end
end

function DealSellLotEquip(tabEData,fCallback)
	if tabEData == nil then
		return 
	end
	if #tabEData==0 then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1655,nil)
		pTips = nil
		return 
	end
	local tabLotData = {}
	local count = 0
	for i=1,#tabEData do 
		local pControl 	= tolua.cast(tabEData[i][1],"ImageView")
		if pControl==nil then
			return 
		end
		local img_ok = pControl:getChildByTag(1005)
		if img_ok~=nil and img_ok:isVisible()==true  then
			local nGird = pControl:getTag()-TAG_GRID_ADD	
			local tab  = {}
			tab[1] = nGird
			tab[2] = 1
			count = count+1
			tabLotData[count] = tab
		end
	end	
	if count==0 then
		local pTips = TipCommonLayer.CreateTipLayerManager()
		pTips:ShowCommonTips(1655,nil)
		pTips = nil
		return 
	end
	local function sellOver(list)
		NetWorkLoadingLayer.loadingHideNow()
		--TipLayer.createTimeLayer("售出成功，得到银币"..price_now*nNum.."钱", 2)
		--TipCommonLayer.CreateTipsLayer(502,TIPS_TYPE.TIPS_TYPE_EQUIP,nGrid,nil,price_now*nNum)
		local nCoin = #list[1]
		local nItem = #list[2]
		local nTotal = nCoin+nItem
		if nTotal ==0 then
			local pTipLayer = TipCommonLayer.CreateTipLayerManager()
			
			pTipLayer:ShowCommonTips(502,nil,ItemListLayer.GetSelectSellPrice())
			pTipLayer = nil
			ItemListLayer.UpdateLablePrice(-ItemListLayer.GetSelectSellPrice())
		else
			--强化有返还
			StrengthenReturnLayer.CreateStrengthenReturn(list,ItemListLayer.GetSelectSellPrice(),6)
		end
		if fCallback~=nil then
			fCallback()
			fCallback = nil 
		end
	end
	--print("SellNumber="..nNum)
	Packet_SellLotEquip.SetSuccessCallBack(sellOver)
	--printTab(tabLotData)
	--print("==========================")
	network.NetWorkEvent(Packet_SellLotEquip.CreatPacket(tabLotData,count,1))
	NetWorkLoadingLayer.loadingShow(true)

end