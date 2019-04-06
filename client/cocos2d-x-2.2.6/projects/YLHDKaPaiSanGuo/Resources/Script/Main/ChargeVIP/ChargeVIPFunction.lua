module("ChargeVIPFunction",package.seeall)

function TipVIPLayer( nIndex,nRoot )
	local tabVIP = MainScene.CheckVIPFunction(nIndex)
	local img_vip = ImageView:create()
	img_vip:loadTexture("Image/imgres/dungeon/vip_bg.png")
	img_vip:setPosition(ccp(-40,10))
	nRoot:addChild(img_vip)

	local label_vip = Label:create()
	label_vip:setText("VIP"..tabVIP["vipLevel"])
	label_vip:setFontSize(18)
	label_vip:setRotation(-45)
	label_vip:setColor(ccc3(255,194,30))
	label_vip:setPosition(ccp(-5,6))
	img_vip:addChild(label_vip)
	
	return img_vip
end