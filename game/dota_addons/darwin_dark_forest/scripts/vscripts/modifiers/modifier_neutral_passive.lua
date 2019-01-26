modifier_neutral_passive = class({})


-----------------------------------------------------------------------------------
function modifier_neutral_passive:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_neutral_passive:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_neutral_passive:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_neutral_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end
---------------------------------------------------------------------------------
function modifier_neutral_passive:OnTakeDamage (event)

	if event.unit == self:GetParent() then
        
		local hCaster = self:GetParent()
		local hAttacker = event.attacker
        
        --承受来自其他 队伍的攻击
        if hCaster:GetTeamNumber()~=hAttacker:GetTeamNumber() then         
              hCaster.flLastHitTime = GameRules:GetGameTime()          
        end

	end
end
