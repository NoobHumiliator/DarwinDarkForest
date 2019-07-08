
modifier_item_force_staff_lua = class({})

function modifier_item_force_staff_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_force_staff_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_force_staff_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end
---------------------------------------------

function modifier_item_force_staff_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

----------------------------------------

function modifier_item_force_staff_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_force_staff_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end


function modifier_item_force_staff_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

----------------------------------------
function modifier_item_force_staff_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------