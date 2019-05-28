
modifier_item_mantle_lua = class({})

function modifier_item_mantle_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_mantle_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_mantle_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end
-------------------------------------------


function modifier_item_mantle_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

----------------------------------------

function modifier_item_mantle_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------

function modifier_item_mantle_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end
----------------------------------------

function modifier_item_mantle_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
