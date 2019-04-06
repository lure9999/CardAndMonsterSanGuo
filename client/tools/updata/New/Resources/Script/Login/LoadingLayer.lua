-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    Log("----------------------------------------")
    Log("LUA ERROR: " .. tostring(msg) .. "\n")
    Log(debug.traceback())
    Log("----------------------------------------")
end

module("LoadingLayer", package.seeall)

require "Script/Common/Common"
require "Script/Audio/AudioUtil"

local text_username = nil
local text_password = nil

function createLoadingLayerUI()
	local file = io.open("res.txt", "r")
	if file == nil then Log("文件找不到") end
	
	local ourline = nil
	ourline = file:read()
	
	while ourline ~= nil do
		ourline = file:read()
		-- 进行加载
		if ourline ~= nil and ourline ~= "" then
			myAddImageAsync(ourline)
		end
	end
	file:close()
end

--xpcall(main, __G__TRACKBACK__)
