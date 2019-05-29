
modifier_item_mystic_staff_lua = class({})

----------------------------------------
function modifier_item_mystic_staff_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_mystic_staff_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------

function modifier_item_mystic_staff_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
    self.mana_regen_bonus = self:GetAbility():GetSpecialValueFor( "mana_regen_bonus" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )


end

----------------------------------------

function modifier_item_mystic_staff_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

----------------------------------------

function modifier_item_mystic_staff_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_mystic_staff_lua:GetModifierConstantManaRegen( params )
	return self.mana_regen_bonus
end

----------------------------------------

function modifier_item_mystic_staff_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end