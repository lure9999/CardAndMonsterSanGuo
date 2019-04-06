
--add by sxin 场景脚本管理器


module("scriptmanage", package.seeall)
require "Script/Fight_New/ScenceScript/script_logic"

local SceneScriptTable = {}

function CreateSceneScript( SceneID)
	local ScriptID = tonumber(SceneData.getFieldByIdAndIndex( SceneID , "ScriptID"))
	
	local pSecen = nil
	
	if SceneScriptTable[ScriptID] == nil then				
		
		local Scriptfile = ScriptData.getFieldByIdAndIndex( ScriptID , "Scriptfile")		
	
		print( Scriptfile )
		
		if Scriptfile == nil then	
			
			pSecen = require "Script/Fight_New/ScenceScript/scene_Base" 	
			
		else		
			--暂时先写死了取1
			--pSecen = require (Scriptfile)		
			pSecen = require "Script/Fight_New/ScenceScript/scene_1" 	
		
		end		
		
		if pSecen ~= nil then
			SceneScriptTable[ScriptID] = pSecen	
			
		else
			print("Script Error SceneID = " .. SceneID )
		end	
		
	else		
		
		pSecen = SceneScriptTable[ScriptID]
	end		
		
	return pSecen
	
end