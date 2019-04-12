
modifier_item_crown_lua = class({})

----------------------------------------

function modifier_item_crown_lua:GetTexture()
	return "item_crown"
end
----------------------------------------

function modifier_item_crown_lua:IsHidden()
	return true
end


----------------------------------------

function modifier_item_crown_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
end

----------------------------------------

function modifier_item_crown_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}

	return funcs
end

----------------------------------------

function modifier_item_crown_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_crown_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_crown_lua:GetModifierExtraHealthBonus( params )
	return self.bonus_health
end

----------------------------------------