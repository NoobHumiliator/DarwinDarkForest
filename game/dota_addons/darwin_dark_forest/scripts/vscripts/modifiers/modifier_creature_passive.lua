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

	if event.unit == self:GetParent() then
        
		local hCaster = self:GetParent()
		local hAttacker = event.attacker
        
        --承受来自其他 队伍的攻击
        if hAttacker and  hCaster:GetTeamNumber()~=hAttacker:GetTeamNumber() then
              --小本本记下来         
              hCaster.flLastHitTime = GameRules:GetGameTime()      
              hCaster.flLastAttacker= hAttacker
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