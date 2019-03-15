modifier_slark_shadow_dance_lua_speed = class({})

--------------------------------------------------------------------------------

function modifier_slark_shadow_dance_lua_speed:IsHidden() return false end
function modifier_slark_shadow_dance_lua_speed:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_slark_shadow_dance_lua_speed:DeclareFunctions()
	local funcs = 
	{
         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
         MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end


function modifier_slark_shadow_dance_lua_speed:GetModifierHealthRegenPercentage()
	if IsServer() then 
        return self:GetAbility():GetSpecialValueFor( "income_damage_percentage" )
	end
end


function modifier_slark_shadow_dance_lua_speed:GetModifierMoveSpeedBonus_Constant()
	if IsServer() then 
        return self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	end
end

function modifier_slark_shadow_dance_lua_speed:GetEffectName()
	return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end
