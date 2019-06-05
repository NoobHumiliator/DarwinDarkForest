
modifier_item_yasha_and_kaya_lua = class({})

function modifier_item_yasha_and_kaya_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_yasha_and_kaya_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_yasha_and_kaya_lua:OnCreated( kv )

	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )
    self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )

    self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
    self.mana_regen_bonus = self:GetAbility():GetSpecialValueFor( "mana_regen_bonus" )
    self.manacost_reduction = self:GetAbility():GetSpecialValueFor( "manacost_reduction" )


end
---------------------------------------------

function modifier_item_yasha_and_kaya_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
	}

	return funcs
end


----------------------------------------

function modifier_item_yasha_and_kaya_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
----------------------------------------

function modifier_item_yasha_and_kaya_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
-------------------------------------------
function modifier_item_yasha_and_kaya_lua:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_yasha_and_kaya_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end
-------------------------------------------
function modifier_item_yasha_and_kaya_lua:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end
--------------------------------------------
function modifier_item_yasha_and_kaya_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end
----------------------------------------
function modifier_item_yasha_and_kaya_lua:GetModifierConstantManaRegen( params )
	return self.mana_regen_bonus
end
----------------------------------------
function modifier_item_yasha_and_kaya_lua:GetModifierPercentageManacost( params )
	return self.manacost_reduction
end

----------------------------------------

