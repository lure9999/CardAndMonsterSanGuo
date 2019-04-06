
--require "Script/Login/CreateRoleLayer"

module("LoginCommon", package.seeall)

---变量


LABLE_ACCOUNT_SIZE = 20 
TAG_LAYER_ADD    = 100
----逻辑----
local getLoginData    = LoginLogic.GetLoginData
local checkAccount    = LoginLogic.checkEnterLogin
--检测上次选的服务器有没有在服务器列表
local checkHaveServer = LoginLogic.checkServer
local linkLogin       = LoginLogic.dealLogin



--登陆成功后，根据状态到不同的层

function ShowLoading()
	
	StartScene.changeScene()
	-- 清理网络loading界面
	NetWorkLoadingLayer.ClearLoading()
end
--[[
local function loginSuccessful(nTag)
	
	m_callBack()
	
	if nTag ==0 then
		--创建角色
		StartScene.changeLayer(layer_createRole())
	elseif nTag ==1 then
		local function getSuccessful()
			showLoading()
		end
		getLoginData(getSuccessful)
	end
end
--]]

function handleToMainLayer(callBackSuccess,bCheck)

	local function loginSuccessful(nTag)
		
		if nTag ==0 then
			--创建角色
			StartScene.changeCreateRoleScene()
			--StartScene.changeLayer(CreateRoleLayer.createNewRoleLayer())
		elseif nTag ==1 then
			
			local function getSuccessful()
				--print("getSuccessful")
				--Pause()
				callBackSuccess()
				ShowLoading()
			end
			
			getLoginData(getSuccessful)
		end
	end
	if bCheck == false then
		local bName = checkAccount()
		if bName == false then
			--TipLayer.createTimeLayer("用户名或密码不能小于六位", 2)	
			LoginLayer.SetEnterTouch()
			return 
		end
	end
	local str_server = checkHaveServer()
	--print("str_server"..str_server)
	if str_server~="" then
		TipLayer.createTimeLayer(str_server, 2)	
		LoginLayer.SetEnterTouch()
		return 
	end
	--强制先加载 
	--require "Script/Network/packet/PacketNewRequire"
	linkLogin(loginSuccessful)
end

function HandelRoleLogin()
	local function roleLogin()
		--print(roleLogin)
		--Pause()
		MainScene.SetBRole()
		NetWorkLoadingLayer.loadingHideNow()
		ShowLoading()
	end
	NetWorkLoadingLayer.loadingShow(true)
	getLoginData(roleLogin)
	
end