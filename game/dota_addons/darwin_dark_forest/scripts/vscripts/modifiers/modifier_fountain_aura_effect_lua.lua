modifier_fountain_aura_effect_lua = class({})
-------------------------------------------------------------------------------


function modifier_fountain_aura_effect_lua:IsDebuff()
    return false
end

-------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
	return funcs
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage( params )
	return self:GetAbility():GetSpecialValueFor( "heal_percent" )
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen( params )
	return self:GetAbility():GetSpecialValueFor( "mana_percent" )
end


