
--add by sxin 场景脚本管理器


module("scenemanage", package.seeall)

require "Script/Main/Chat/HeroTalkLayer"

local SceneScriptTable = {}

function CreateSceneScript( SceneID)
	local ScriptID = tonumber(SceneData.getFieldByIdAndIndex( SceneID , "ScriptID"))
	
	local pSecen = nil
	
	if SceneScriptTable[ScriptID] == nil then				
		
		local Scriptfile = ScriptData.getFieldByIdAndIndex( ScriptID , "Scriptfile")		
	
		print( Scriptfile )
		if Scriptfile == nil then	
			
			pSecen = require "Script/Scene/scene_Base" 	
			
		else		
			
			pSecen = require (Scriptfile)				
		
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