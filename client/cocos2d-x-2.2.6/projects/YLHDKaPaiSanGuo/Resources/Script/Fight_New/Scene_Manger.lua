


module("Scene_Manger", package.seeall)
require "Script/Fight_New/Fight_NewDef"
require "Script/Fight_New/Scene_BaseScene"
require "Script/Fight_New/simulationStl"

local g_ScenceData = nil

function CreateScene( eScene_Type ,pUIInterface)

	if eScene_Type == Scene_Type.Type_Base then
		g_ScenceData = Scene_BaseScene.CreatBaseSceneData()		
	elseif eScene_Type == Scene_Type.Type_Other then
		
	else
	
	end	
	
	if pUIInterface ~= nil then	
		g_ScenceData:Fun_SetUIInterface(pUIInterface)		
		pUIInterface:Fun_SetSceneInterface(g_ScenceData)	
		--Fun_AddSkill()
	end

end

function InitScenceData( pNetStream )

	if g_ScenceData ~= nil then 
		g_ScenceData:Fun_InitServerData(pNetStream)
	else
		print("InitScenceData:没有创建场景！！！")
	end
	

end

function EnterBaseScene( )

	if g_ScenceData ~= nil then 
		g_ScenceData:Fun_EnterScene()
	else
		print("EnterBaseScene:没有创建场景！！！")
	end

end

function LeaveBaseScene( )

	if g_ScenceData ~= nil then 
		g_ScenceData:Fun_LeaveScene()
		--g_ScenceData = nil
	else
		--print("LeaveBaseScene:没有创建场景！！！")
	end

end

function ReleaseScence( )

	if g_ScenceData ~= nil then 
		g_ScenceData:Fun_Release()
		g_ScenceData = nil
	else
		--print("LeaveBaseScene:没有创建场景！！！")
	end

end

function GetCurpScence( )

	return g_ScenceData 

end








