modifier_hero_adjustment = class({})

--------------------------------------------------------------------------------

function modifier_hero_adjustment:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	}
	return funcs
end
-----------------------------------------------------------------------------------
function modifier_hero_adjustment:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_hero_adjustment:GetModifierAttackSpeedBaseOverride( params )
	return self:GetParent().flBaseAttackRate
end

-------------------------------------------------------------------------------------------------------------------------------------------------
function modifier_hero_adjustment:GetModifierAttackRangeBonus( params )
	return self:GetParent().flAttackRangeModify
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function modifier_hero_adjustment:GetModifierProjectileSpeedBonus( params )
	return self:GetParent().flProjectileSpeedModify
end

-------------------------------------------------------------------------------------------------------------------------------------------------
