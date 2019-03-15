modifier_bounty_hunter_track_lua_speed = modifier_bounty_hunter_track_lua_speed or class({})




function modifier_bounty_hunter_track_lua_speed:DeclareFunctions()
	local funcs = 
	{
         MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
         MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end


function modifier_bounty_hunter_track_lua_speed:OnCreated()
	if IsServer() then
         self.target_crit_multiplier=self:GetAbility():GetSpecialValueFor("target_crit_multiplier")
         self.bonus_move_speed_pct=self:GetAbility():GetSpecialValueFor("bonus_move_speed_pct")
	end
end

function modifier_bounty_hunter_track_lua_speed:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then

		local hTarget = keys.target	
		if hTarget:HasModifier("modifier_bounty_hunter_track_lua_debuff") then
			return self.target_crit_multiplier
		else
            return nil
		end

	end
end

function modifier_bounty_hunter_track_lua_speed:GetModifierMoveSpeedBonus_Percentage()
	if IsServer() then
		return self.bonus_move_speed_pct
	end
end