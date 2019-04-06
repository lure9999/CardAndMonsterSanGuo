
module("Scene_FightUIObj", package.seeall)

require "Script/Fight_New/Scene_SkillUIObj"
require "Script/Fight_New/Scene_FightPool"

local MAX_SKILLNUM 				=	8
local MAX_CLEARUPNUM 			=	3

local Click_Pos = {
	Pos_Tail 	=	1,
	Pos_Mid		=	2,
	Pos_Head	=	3,
}

local SkillType = {
	Skill_Auto		=	1,
	Skill_Normal	=	2,	
	Skill_Arround	=	3,
}

--副本类型的UI
local function CreateFightUIByFuBen( self, nType )
	self.m_Type = SceneDB_Type.Type_FuBen
end

local function PlaySkillAni( nType, nSObj )
	if nSObj ~= nil then

		nSObj:Fun_PlaySkillAni( nType )
		--nSObj:Fun_SetSkillTouchEnabled( true )

	end
end

local function PlayMissAni( self, _Index )
	if self.m_SkillMissAni[_Index] ~= nil then

		local function onMovementEvent(armatureBack,movementType,movementID)
			if movementType == 1 then
				self.m_SkillMissAni[_Index]:setVisible(false)
			end
		end

		self.m_SkillMissAni[_Index]:setVisible(true)
		self.m_SkillMissAni[_Index]:getAnimation():play("Animation3")
		self.m_SkillMissAni[_Index]:getAnimation():setMovementEventCallFunc(onMovementEvent)
	end

end

local function PlayHitAni( nType, nSObj )
	if nSObj ~= nil then

		nSObj:Fun_PlayHitAni( nType )

		--[[if nType == FightClear_Type.Type_SingleClear then

			nSObj:Fun_SetSkillTouchEnabled( true )

		end]]

	end
end

local function CheckNodeByNext( self, pNode, pVel, pSkillID, nTestType )
	if pVel:Fun_GetSkillType() == SkillType.Skill_Arround then

		--print(pVel:Fun_GetSkillIndex().."技能是圆圈技能不检测")

	end
	--从当前节点向后检查
	if pNode.Next ~= "ListEnd" then

		local pNextNode = pNode.Next

		local pPrevNode = pNode.Prev

		local pNodeVel  = self.m_FightPool:Fun_VisitNode(pNode)

		local pNextVel = self.m_FightPool:Fun_VisitNode(pNextNode)

		local pPrevVel = self.m_FightPool:Fun_VisitNode(pPrevNode)

		local pNextSkillID = pNextVel:Fun_GetSkillID()

		if pSkillID == pNextSkillID then

			if pNodeVel:Fun_GetClearUpTag() == FightClear_Type.Type_SingleClear then

				--print("只检测当前技能是单消的情况下,向后检查")
				if pNextVel:Fun_GetClearUpTag() == FightClear_Type.Type_SingleClear then
					--print("当前技能的下一个技能也是单消可以组成双消")
					pVel:Fun_SetClearUpTag( FightClear_Type.Type_DoubelClear )
					pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_DoubelClear )
					PlaySkillAni( FightClear_Type.Type_DoubelClear, pNodeVel )
				elseif pNextVel:Fun_GetClearUpTag() == FightClear_Type.Type_DoubelClear then
					--print("当前技能的下一个技是双消可以组成三消")
					if pNextNode.Next ~= "ListEnd" then

						local pDoubelNextNode = pNextNode.Next
						local pDoubelNextVel  = self.m_FightPool:Fun_VisitNode(pDoubelNextNode)
						--设置消除属性
						pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						pDoubelNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						--删除双消动画
						pNextVel:Fun_DelSkillAni()
						--添加三消动画
						PlaySkillAni( FightClear_Type.Type_TripleClear, pNodeVel )
					end
				elseif pNextVel:Fun_GetClearUpTag() == FightClear_Type.Type_TripleClear then
					--print("当前技能是单消，下一个技能是三消则重组三消并继续向下check")
					if pNextNode.Next ~= "ListEnd" then
						local pDoubelNextNode = pNextNode.Next
						local pDoubelNextVel  = self.m_FightPool:Fun_VisitNode(pDoubelNextNode)
						pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear)
						pDoubelNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						--删除旧三消动画
						pNextVel:Fun_DelSkillAni()
						--添加新三消动画
						PlaySkillAni( FightClear_Type.Type_TripleClear, pVel )
						local pTripleNextNode = pDoubelNextNode.Next
						if pTripleNextNode ~= "ListEnd" then

							local pTripleNextVel = self.m_FightPool:Fun_VisitNode(pTripleNextNode)
							pTripleNextVel:Fun_SetClearUpTag(FightClear_Type.Type_SingleClear)
							CheckNodeByNext( self, pTripleNextNode, pTripleNextVel, pTripleNextVel:Fun_GetSkillID(), 1 ) 

						end
					end
				end

			elseif pNodeVel:Fun_GetClearUpTag() == FightClear_Type.Type_DoubelClear then
				if pNextVel:Fun_GetClearUpTag() == FightClear_Type.Type_SingleClear then
					--print("当前技能是双消，下个技能是单消的话组成三消")
					local pDoubelNextNode = pNextNode.Next
					local pDoubelNextVel  = self.m_FightPool:Fun_VisitNode(pDoubelNextNode)
					pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear)
					pDoubelNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )	
					--添加新三消动画
					PlaySkillAni( FightClear_Type.Type_TripleClear, pVel )								
				elseif pNextVel:Fun_GetClearUpTag() == FightClear_Type.Type_DoubelClear then
					--print("当前技能是双消，下个技能是双消，组成三消")
					pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear)
					--删除旧的三消动画
					pNextVel:Fun_DelSkillAni()
					--添加新三消动画
					PlaySkillAni( FightClear_Type.Type_TripleClear, pPrevVel )	
				elseif pNextVel:Fun_GetClearUpTag() == FightClear_Type.Type_TripleClear then
					--print("当前技能是双消，下个技能是三消，技能上限为8个不应该出现")
					Pause()
				end
			elseif pNodeVel:Fun_GetClearUpTag() == FightClear_Type.Type_TripleClear then
				--print("未知错误")
				Pause()
			end 


		end

	else

		--print("当前检查的是最后一个技能")

	end
	
end

local function CheckNode( self, pNode, pVel, pSkillID, nTestType )

	if pVel:Fun_GetSkillType() == SkillType.Skill_Arround then

		--print(pVel:Fun_GetSkillIndex().."技能是圆圈技能不检测")
		return

	end


	local nIndex = pVel:Fun_GetSkillIndex()

	if pNode.Prev ~= "Empty" then

		local pPrveNode = pNode.Prev

		local pNextNode = pNode.Next

		local pPrevVel = self.m_FightPool:Fun_VisitNode(pPrveNode)

		local pNextVel = self.m_FightPool:Fun_VisitNode(pNextNode)

		local pPrevSkillID = pPrevVel:Fun_GetSkillID()


		if pSkillID == pPrevSkillID then

			--ID相同判断技能的ClearTag
			if pPrevVel:Fun_GetClearUpTag() == FightClear_Type.Type_SingleClear then
				--当前技能的上一个技能为单消，则这个技能可能与其上个技能凑成双消或者三消
				if pVel:Fun_GetClearUpTag() == FightClear_Type.Type_SingleClear then
					--如果当前技能也为单消则可以与上个技能形成双消
					--print("当前检测的技能是单消技能Index = "..pVel:Fun_GetSkillIndex().."，他的前一个技能是单消技能的index是"..pPrevVel:Fun_GetSkillIndex().."，可以组成双消")
					--Pause()
					pVel:Fun_SetClearUpTag( FightClear_Type.Type_DoubelClear )
					pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_DoubelClear )
					--播动画
					PlaySkillAni( FightClear_Type.Type_DoubelClear, pPrevVel )
				elseif pVel:Fun_GetClearUpTag() == FightClear_Type.Type_DoubelClear then
					--如果当前技能为双消则可以与上个技能形成三消（取出当前技能的后一个技能设为三消属性）
					print("当前检测的技能是双消技能，他的前一个技能是单消技能，可以组成三消"..nIndex)
					pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					--删除旧的三消动画
					pVel:Fun_DelSkillAni()
					--播放新的双消动画
					PlaySkillAni( FightClear_Type.Type_TripleClear, pPrevVel )
				elseif pVel:Fun_GetClearUpTag() == FightClear_Type.Type_TripleClear then
					--print("当前检测的技能是三消技能，他的前一个技能是单消技能,重新定义三消"..nIndex)
					pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					--删除旧三消动画
					pVel:Fun_DelSkillAni()
					--播新三消动画
					PlaySkillAni( FightClear_Type.Type_TripleClear, pPrevVel )
					if pNextNode ~= "ListEnd" then
						local pTripleNextNode = pNextNode.Next
						local pTripleNextVel  = self.m_FightPool:Fun_VisitNode(pTripleNextNode)
						pTripleNextVel:Fun_SetClearUpTag( FightClear_Type.Type_SingleClear )
						local pTripleNextVelSkillID = pTripleNextVel:Fun_GetSkillID()
						--从重设属性的这个技能重新开始检测
						CheckNodeByNext( self, pTripleNextNode, pTripleNextVel, pTripleNextVelSkillID, 1 ) 
					end
				end
				return 
			elseif pPrevVel:Fun_GetClearUpTag() == FightClear_Type.Type_DoubelClear then
				--print("之前的技能是双消--------------------"..pVel:Fun_GetClearUpTag())
				if pVel:Fun_GetClearUpTag() == FightClear_Type.Type_SingleClear then
					--print("当前技能是单消，之前的技能是双消，可以组成三消"..nIndex)
					local pTripleNode = pPrveNode.Prev
					local pTripleVel  = self.m_FightPool:Fun_VisitNode(pTripleNode)

					pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )				
					pTripleVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					--删除旧的双消动画
					pTripleVel:Fun_DelSkillAni()
					--播动画
					PlaySkillAni( FightClear_Type.Type_TripleClear, pTripleVel )
				elseif pVel:Fun_GetClearUpTag() == FightClear_Type.Type_DoubelClear then
					local pTripleNode = pPrveNode.Prev
					if pTripleNode ~= "Empty" then
						print("当前技能是双消，之前技能是双消，可以组成三消"..nIndex)
						local pTripleVel  = self.m_FightPool:Fun_VisitNode(pTripleNode)

						pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )				
						pTripleVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
						pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_SingleClear )
						--删除旧的双消动画
						pVel:Fun_DelSkillAni()
						pTripleVel:Fun_DelSkillAni()
						--播动画
						PlaySkillAni( FightClear_Type.Type_TripleClear, pTripleVel )
					end

				elseif pVel:Fun_GetClearUpTag() == FightClear_Type.Type_TripleClear then
					--print("当前检测技能为三消技能，之前的技能为双消，重定义三消"..nIndex)
					local pTripleNode = pPrveNode.Prev
					local pTripleVel  = self.m_FightPool:Fun_VisitNode(pTripleNode)

					pVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					pPrevVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )				
					pTripleVel:Fun_SetClearUpTag( FightClear_Type.Type_TripleClear )
					--删除旧的三消动画和前面技能的双消动画
					pVel:Fun_DelSkillAni()
					pTripleVel:Fun_DelSkillAni()
					--播新三消动画
					PlaySkillAni( FightClear_Type.Type_TripleClear, pTripleVel )
					--将旧的三消和动画清除
					if pNextNode ~= "ListEnd" then
						if pNextNode.Next ~= "ListEnd" then
							local pTripleNextNode = pNextNode.Next
							local pTripleNextVel  = self.m_FightPool:Fun_VisitNode(pTripleNextNode)
							pTripleNextVel:Fun_SetClearUpTag( FightClear_Type.Type_DoubelClear )
							pNextVel:Fun_SetClearUpTag( FightClear_Type.Type_DoubelClear )
						--从重设属性的这个技能重新开始检测
						CheckNodeByNext( self, pTripleNextNode, pTripleNextVel, pTripleNextVel:Fun_GetSkillID(), 1 ) 
						end
					end
				end
				return
			elseif pPrevVel:Fun_GetClearUpTag() == FightClear_Type.Type_TripleClear then
				--当前技能的上一个技能为三消
				--print("当前检测的技能是单消技能，他的前一个技能是三消技能,向后看"..nIndex)
				--Pause()
				--CheckNodeByNext( self, pNode, pVel, pSkillID, nTestType ) 
				--[[if nTestType == 1 then
					print("技能添加检测结束triple")
				else
					print("技能点击检测结束triple")
				end]]
			end
		end

	else
		--print("第一个技能"..nIndex)
		--[[if nTestType == 1 then
			print("技能添加检测结束first skill")
		else
			print("技能点击检测结束first skill")
		end]]

	end
end

local function DelNode( self, _Node )
	--删除链表节点
	self.m_FightPool:Fun_DelNode( _Node )
	--删除UI
	local pNodeVel  = self.m_FightPool:Fun_VisitNode( _Node )
	--print("Index = "..pNodeVel:Fun_GetSkillIndex())
	--print("SkillID = "..pNodeVel:Fun_GetSkillID())

	PlayMissAni( self, pNodeVel:Fun_GetSkillIndex() )

	pNodeVel:Fun_DelFromParent()
	pNodeVel = nil

end

local function ResetSkillIndex( self )
	
	local pNode  =  self.m_FightPool:Fun_GetListTail() 				--从链表尾端开始重新设置

	local pSize  = self.m_FightPool:Fun_GetListSize()				--链表末端的索引为链表长度

	--print("pSize =================== "..pSize)

	while (pNode.Prev ~= nil )
	do

		--print(pNode.Prev)
		--Pause()
		--print("pSize =================== "..pSize)
		local pNodeVel  = self.m_FightPool:Fun_VisitNode( pNode )

		pNodeVel:Fun_SetSkillIndex( pSize )

		pNode = pNode.Prev

		pSize = pSize - 1

	end

end

local function MoveSkillUI( self )

	local pNode  =  self.m_FightPool:Fun_GetListTail() 				--从链表尾端开始移动

	while (pNode.Prev ~= nil )
	do
		local pNodeVel  = self.m_FightPool:Fun_VisitNode( pNode )

		pNodeVel:Fun_MovePos()

		pNode = pNode.Prev

	end
end

local function GetNodeSkillID( self, _CmdNode )
	local _CmdVel      =  self.m_FightPool:Fun_VisitNode( _CmdNode )
	return _CmdVel:Fun_GetSkillID()
end

local function GetNodeClearTag( self, _CmdNode )
	local _CmdVel      =  self.m_FightPool:Fun_VisitNode( _CmdNode )
	return _CmdVel:Fun_GetClearUpTag() 
end

local function IsClearUpTagEqual( self, _CmdNode_1, _CmdNode_2 )
	if GetNodeClearTag( self, _CmdNode_1) == GetNodeClearTag( self, _CmdNode_2) then

		return true

	end

	return false
end

local function IsSkillIDEqual( self, _CmdNode_1, _CmdNode_2 )
	if GetNodeSkillID( self, _CmdNode_1) == GetNodeSkillID( self, _CmdNode_2) then

		return true

	end

	return false
end

local function ContrastNode( self, _CmdNode, _CmdNextNode )
	-- 对比两个技能
	if IsClearUpTagEqual( self, _CmdNode, _CmdNextNode ) == true and 
	   IsSkillIDEqual( self, _CmdNode, _CmdNextNode ) == true
	then

		return true

	end

	return false
	
end

local function FindDoubelClearNode( self, _NextNode, _Node, _PrevNode )

	local _NodeVel      =  self.m_FightPool:Fun_VisitNode( _Node )
	local _NextVel      =  self.m_FightPool:Fun_VisitNode( _NextNode )
	local _PrevVel      =  self.m_FightPool:Fun_VisitNode( _PrevNode )

	local _NodeSkillID, _NextSkillID, _PrevSkillID

	local _NodeClearTag, _NextNodeClearTag, _PrevNodeClearTag

	_NodeSkillID  =  _NodeVel:Fun_GetSkillID()

	_NodeClearTag =  _NodeVel:Fun_GetClearUpTag()

	if _NextNode ~= "ListEnd" then
		_NextSkillID  	  =  _NextVel:Fun_GetSkillID()
		_NextNodeClearTag =  _NextVel:Fun_GetClearUpTag()
	end

	if _PrevNode ~= "Empty" then
		_PrevSkillID  	  =  _PrevVel:Fun_GetSkillID()
		_PrevNodeClearTag =  _PrevVel:Fun_GetClearUpTag() 
	end

	if _PrevNode ~= "Empty" then

		if _PrevSkillID == _NodeSkillID then
			--print("和前一个节点产生双消")
			--和前一个节点产生双消
			if _PrevNodeClearTag == _NodeClearTag then
				--print("11111111111111111111111111111111111111111111111111")
				return _PrevNode,false,true
			else
				--print("33333333333333333333333333333333333333333333333333")
				return _NextNode,false
			end
		end

	end

	if _NextNode ~= "ListEnd" then

		if _NodeSkillID == _NextSkillID then
			--print("和下一个节点产生双消")
			--和下一个节点产生双消
			--print("22222222222222222222222222222222222222222222222222")
			return _NextNode,true
			
		end

	end

end

local function FindTripleClearNode( self, _NextNode, _Node, _PrevNode )

	if _PrevNode ~= "Empty" then
		--print("上一个不是空")
		if ContrastNode( self, _Node, _PrevNode ) == true then
			--当前技能与下一个技能消除类型相同，并且技能ID也相同，则属于三消中的一部分
			--继续看下一个
			local _PrevNode_2 = self.m_FightPool:Fun_GetPrevNode( _PrevNode )
			--print("-----_PrevNode_2-----------")
			--print(_PrevNode_2)
			if _PrevNode_2 ~= "Empty" then

				if ContrastNode( self, _PrevNode, _PrevNode_2 ) == true then
					--找到了三消
					--print("3")
					return _PrevNode, _PrevNode_2, Click_Pos.Pos_Tail

				else
					--没找到三消，代表_node为三消中间技能，另一个三消技能为_PrevNode
					--print("4")
					return _NextNode, _PrevNode, Click_Pos.Pos_Mid

				end

			else

				return _NextNode, _PrevNode, Click_Pos.Pos_Mid

			end

		else
			--[[local _p1 = GetNodeClearTag(self, _Node)
			local _p2 = GetNodeClearTag(self, _PrevNode)
			local _s1 = GetNodeSkillID(self, _Node)
			local _s2 = GetNodeSkillID(self, _PrevNode)
			print("当前技能与其前一个技能技能和消除类型都不同..Empty")
			print(_p1,_p2)
			print(_s1,_s2)
			Pause()]]
		end

	end

	if _NextNode ~= "ListEnd" then
		--print("下一个不是End")
		if ContrastNode( self, _Node, _NextNode ) == true then
			--当前技能与下一个技能消除类型相同，并且技能ID也相同，则属于三消中的一部分
			--继续看下一个
			local _NextNode_2 = self.m_FightPool:Fun_GetNextNode( _NextNode )

			--print("-----_NextNode_2-----------")
			--print(_NextNode_2)

			if _NextNode_2 ~= "ListEnd" then

				if ContrastNode( self, _NextNode, _NextNode_2 ) == true then
					--找到了三消
					--print("1")
					return _NextNode, _NextNode_2, Click_Pos.Pos_Head

				else
					--没找到三消，代表_node为三消中间技能，另一个三消技能为_PrevNode
					--print("2")
					return _NextNode, _PrevNode, Click_Pos.Pos_Mid

				end

			else

				return _NextNode, _PrevNode, Click_Pos.Pos_Mid

			end

		else
			--[[local p1 = GetNodeClearTag(self, _Node)
			local p2 = GetNodeClearTag(self, _NextNode)
			local s1 = GetNodeSkillID(self, _Node)
			local s2 = GetNodeSkillID(self, _NextNode)
			print("当前技能与其后一个技能技能和消除类型都不同..ListEnd")
			print(p1,p2)
			print(s1,s2)
			Pause()]]
		end

	end

end

local function CheckClickSkill( self, pNode )
	--取得当前节点的前后节点
	local pNextNode = pNode.Next 
	local pPrevNode = pNode.Prev
	--local pNextVel  = self.m_FightPool:Fun_VisitNode( pNextNode )
	--local pPrevVel  = self.m_FightPool:Fun_VisitNode( pPrevNode )
	local pNodeVel  = self.m_FightPool:Fun_VisitNode( pNode )
	local pClearUp  = pNodeVel:Fun_GetClearUpTag()
	local pCheckNode = pNextNode

	DelNode( self, pNode )

	if pClearUp == FightClear_Type.Type_SingleClear then
		--print("技能索引"..pNodeVel:Fun_GetSkillIndex().."单消了,链表最大长度为 = "..self.m_FightPool:Fun_GetListSize())
		--Pause()
	elseif pClearUp == FightClear_Type.Type_DoubelClear then
		--取出节点前后与之技能ID相同的节点一起删除，重置Index
		--print("技能索引"..pNodeVel:Fun_GetSkillIndex().."双消了------------------------------")
		local _DoubelClearNode,isNext,isPrev =  FindDoubelClearNode( self, pNextNode, pNode, pPrevNode )
		DelNode( self, _DoubelClearNode )
		if isNext == true then
			--当前连消的技能是点击技能的下一个
			pCheckNode = pNextNode.Next
			--print("当前连消的技能是点击技能的下一个 = "..pNodeVel:Fun_GetSkillIndex())
		else
			--当前连消的技能是点击技能的上一个,如果上一个为空则证明上一个是第一个技能，则从当前点击的技能下一个开始
			if isPrev == true then
				--print("Prev")
				--返回的当前点击的上一个技能,要检查当前点击的下一个技能
				pCheckNode = pNextNode
			else
				pCheckNode = pNextNode.Next
				--print("bibibibibibibibi = "..pNodeVel:Fun_GetSkillIndex())
				local pNVel = self.m_FightPool:Fun_VisitNode( pNextNode )
				--print("bibibibibibibibi Next= "..pNVel:Fun_GetSkillIndex())
			end
		end
		--print("娃娃哇哇哇哇哇哇哇哇")

	elseif pClearUp == FightClear_Type.Type_TripleClear then

		--print("技能索引"..pNodeVel:Fun_GetSkillIndex().."三消了")
		local _Node_1, _Node_2, Pos_Type = FindTripleClearNode( self, pNextNode, pNode, pPrevNode )
		if _Node_1 == nil or _Node_2 == nil then
			print(_Node_1, _Node_2)
			Pause()
		end
		DelNode( self, _Node_1 )
		DelNode( self, _Node_2 )

		if Pos_Type == Click_Pos.Pos_Head then
			pCheckNode = _Node_2.Next
		elseif Pos_Type == Click_Pos.Pos_Mid then
			pCheckNode = _Node_1.Next
		elseif Pos_Type == Click_Pos.Pos_Tail then
			pCheckNode = pNode.Next
		end

	end

	--每次删除后都要对技能的索引重新定义
	ResetSkillIndex( self )

	--技能UI根据索引进行移动
	MoveSkillUI( self )

	--检测删除技能的前后技能是否可以形成连消
	if pCheckNode ~= "ListEnd" then
		local pCheckVel 		= self.m_FightPool:Fun_VisitNode(pCheckNode)
		local pCheckSkillID  = pCheckVel:Fun_GetSkillID( ) 
		--print("CheckVel!!!Index = "..pCheckVel:Fun_GetSkillIndex())
		--print("CheckVel!!!_ClearTag = "..pCheckVel:Fun_GetClearUpTag())
		--print("Click!!!____当前需要检测的技能索引是"..pCheckVel:Fun_GetSkillIndex())
		--Pause()

		CheckNode( self, pCheckNode, pCheckVel, pCheckSkillID, 2 )
	end
end

local function GetListSize( self )
	local pSize = self.m_FightPool:Fun_GetListSize()
	return pSize
end

local function FindSkillNodeContrast( self, nGeneralID, nState )
	local pNode  =  self.m_FightPool:Fun_GetListHead() 				--从链表顶端开始检测

	while ( pNode ~= "ListEnd" and pNode ~= "Empty" )
	do

		local pNodeVel  = self.m_FightPool:Fun_VisitNode( pNode )

		local pNodeGeneralId = pNodeVel:Fun_GetSKillGeneralID()

		if tonumber(pNodeGeneralId) == tonumber(nGeneralID) then

			pNodeVel:Fun_SetLifeUI(nState)

		end

		pNode = pNode.Next

	end
end

local function CheckListLife( self, nGeneralID )
	if self.m_DeathList ~= nil then
		self.m_DeathList[nGeneralID] = {}
		self.m_DeathList[nGeneralID]["Life"] = false
		--遍历技能链表找出所有generalID相同的技能
		FindSkillNodeContrast(self, nGeneralID, false)
		--print(nGeneralID.."------------------------------>Death")
	end
end

local function AddSkill( self, nGeneralID, nSkillID, nSkillType, nColorID, nSkillTab )
	--printTab(self.m_DeathList)

	local function _Click_Skill_CallBack( _SkillTab, _SkillIndex, _ClearTag )
		local pNode = self.m_FightPool:Fun_Find_SkillListVel( _SkillIndex )
		CheckClickSkill( self, pNode ) 				--UI使用的消除逻辑
		self.m_BaseScene:Fun_UI_UseSkill( _SkillTab, _ClearTag )
	end


	local function MoveBeginCheck(  )
		local pListSize = self.m_FightPool:Fun_GetListSize()
		local pNode  =  self.m_FightPool:Fun_GetListTail() 				--从链表尾端开始检测
		local pVel 		= self.m_FightPool:Fun_VisitNode(pNode)
		local pSkillID  = pVel:Fun_GetSkillID( ) 

		CheckNode( self, pNode, pVel, pSkillID, 1 )
	end


	local function MoveEndCheck(  )
		--检测FightPool中的数据，播放三消双消有关动画

		--[[local pListSize = self.m_FightPool:Fun_GetListSize()
		local pNode  =  self.m_FightPool:Fun_GetListTail() 				--从链表尾端开始检测
		local pVel 		= self.m_FightPool:Fun_VisitNode(pNode)
		local pSkillID  = pVel:Fun_GetSkillID( )]]
		local pNode  =  self.m_FightPool:Fun_GetListTail() 
		local pVel 		= self.m_FightPool:Fun_VisitNode(pNode)
		local pSkillID  = pVel:Fun_GetSkillID( )
		--播放碰撞动画
		PlayHitAni( FightClear_Type.Type_SingleClear, pVel )
 
		--CheckNode( self, pNode, pVel, pSkillID, 1 )

	end

	local pSize = self.m_FightPool:Fun_GetListSize()

	if pSize < 8 then
		--printTab(self.m_DeathList)
		--创建技能
		local pSkillObj = Scene_SkillUIObj.CreateBaseObj()

		--设置当前英雄的生存状态
		if self.m_DeathList[nGeneralID] == nil then
			self.m_DeathList[nGeneralID] = {}
			self.m_DeathList[nGeneralID]["Life"] = true
		end

		pSkillObj:Fun_InitAttr( self.m_RenderData.m_RootPanel, nGeneralID, nSkillID, nSkillType, nColorID, nSkillTab, pSize + 1, self.Pos_Skill, self.m_DeathList[nGeneralID]["Life"] )

		self.m_FightPool:Fun_MakeNode( pSkillObj )

		MoveBeginCheck()

		pSkillObj:Fun_CreateSkill( MoveEndCheck, _Click_Skill_CallBack)
	
	else
		--print("技能池已满停止接受技能")
	end

end

local function SetSceneInterface( self, _BaseScene )
	self.m_BaseScene = _BaseScene
end

local function CreateTestUI( self, _Layer )

	self.m_RenderData.m_BaseUI = _Layer
	self.m_RenderData.m_BaseUI:addWidget( GUIReader:shareReader():widgetFromJsonFile("Image/FightUILayer_New.json") )

	self.m_RenderData.m_RootPanel = tolua.cast(self.m_RenderData.m_BaseUI:getWidgetByName("Image_Root"), "ImageView")

	--创建技能栈
 	self.m_FightPool = Scene_FightPool.CreateBaseObj()
 	self.m_FightPool:Fun_CreateFightPool(MAX_SKILLNUM)

 	self.Pos_Skill = {}
 	for i=1,8 do
		local Image_Skill = tolua.cast(self.m_RenderData.m_RootPanel:getChildByName("Image_SkillBg_"..i), "ImageView")
		self.Pos_Skill[i] = ccp(Image_Skill:getPositionX(), Image_Skill:getPositionY())
		--创建技能消失动画
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("Image/Fight/animation/zhandoutiao_texiao/zhandoutiao_texiao.ExportJson")
		self.m_SkillMissAni[i] = CCArmature:create("zhandoutiao_texiao")
		self.m_SkillMissAni[i]:setPosition(self.Pos_Skill[i])
		self.m_SkillMissAni[i]:setVisible(false)
		self.m_RenderData.m_RootPanel:addNode(self.m_SkillMissAni[i],9999)
	end

    local function _Button_Retrun_CallBack(sender,eventType)
        if eventType == CheckBoxEventType.selected then
        	Scene_Manger.LeaveBaseScene()
        elseif eventType == CheckBoxEventType.unselected then
		
        end
    end

	local Button_Return = tolua.cast(self.m_RenderData.m_BaseUI:getWidgetByName("Button_Return"), "Button")
	Button_Return:addTouchEventListener(_Button_Retrun_CallBack)

	self.m_DeathList = {}
	local pActionArr = CCArray:create()
	pActionArr:addObject(CCDelayTime:create(0.5))
	pActionArr:addObject(CCMoveBy:create(0.5, ccp(0, 120)))
	self.m_RenderData.m_RootPanel:runAction(CCSequence:create(pActionArr))	
	
	--return self.m_RenderData.m_BaseUI
	--_BaseNode:addChild(self.m_RenderData.m_BaseUI, UILayer_Z)	
	
end

local function ShowUI( self, nState )
	self.m_RenderData.m_BaseUI:setVisible(nState)
end

local function Release( self )
	self.m_Type = nil
	self.m_DeathList = nil
end

function CreateBaseObj()

	local Obj = {
				--funciton
				Fun_CreateFightUIByFuBen 			=	CreateFightUIByFuBen,
				Fun_CreateTestUI 					=	CreateTestUI,
				Fun_ShowUI							= 	ShowUI,
				Fun_AddSkill 						=	AddSkill,
				Fun_SetSceneInterface 				=	SetSceneInterface,
				Fun_GetListSize						=	GetListSize,
				Fun_CheckListLife					=	CheckListLife,


				Fun_Release 						=	Release,

				--member
				m_RenderData = {
					m_BaseUI 						= 	nil,
					m_RootPanel 					=	nil,
				},

				m_SkillMissAni = {
																	--技能消失动画
				},
				m_DeathList    = {

				},													--死亡列表
				m_SkillArrayIndex 					=	nil, 		--技能分组索引]]
				m_FightPool 						= 	nil,		--技能池
				m_SkillHead 						=	nil, 		--技能池顶端技能
				m_ContinueVel 						=	0,			--技能的连续相同数
			}
	return Obj
end










