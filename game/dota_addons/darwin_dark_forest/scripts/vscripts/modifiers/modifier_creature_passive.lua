modifier_creature_passive = class({})


-----------------------------------------------------------------------------------
function modifier_creature_passive:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_creature_passive:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_creature_passive:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_creature_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end

---------------------------------------------------------------------------------

function modifier_creature_passive:OnTakeDamage (event)
    
    --仅限中立生物 反伤类不触发
    if self:GetParent():GetTeam()==DOTA_TEAM_NEUTRALS then
		if event.unit == self:GetParent() then
			--信使无效
			if self:GetParent():GetAttackCapability()~=DOTA_UNIT_CAP_NO_ATTACK then
				local hCaster = self:GetParent()
				local hAttacker = event.attacker
		        --承受来自其他 队伍的攻击
		        if hAttacker and  hCaster:GetTeamNumber()~=hAttacker:GetTeamNumber() then
		              --立即进行反击      
		              hCaster.flLastHitTime = GameRules:GetGameTime()      
		              hCaster.hLastAttacker= hAttacker
		              hCaster.hChasingTarget = hAttacker
		              hCaster:SetBaseMoveSpeed( hCaster.nOriginalMovementSpeed )
		              hCaster:MoveToTargetToAttack(hAttacker)
		        end
			end
		end
    end
end
-----------------------------------------------------------------------------------


function modifier_creature_passive:GetModifierProvidesFOWVision()
       
     if self:GetParent():GetLevel()>=10 then
        return 1
     else
     	return 0
     end

end
-----------------------------------------------------------------------------------