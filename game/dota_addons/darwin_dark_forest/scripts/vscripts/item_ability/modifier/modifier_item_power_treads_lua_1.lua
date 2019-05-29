
modifier_item_power_treads_lua_1 = class({})

function modifier_item_power_treads_lua_1:IsHidden()
	return true
end
----------------------------------------
function modifier_item_power_treads_lua_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_power_treads_lua_1:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )

end
-------------------------------------------


function modifier_item_power_treads_lua_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

----------------------------------------
function modifier_item_power_treads_lua_1:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
----------------------------------------

function modifier_item_power_treads_lua_1:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
----------------------------------------
function modifier_item_power_treads_lua_1:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_power_treads_lua_1:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end