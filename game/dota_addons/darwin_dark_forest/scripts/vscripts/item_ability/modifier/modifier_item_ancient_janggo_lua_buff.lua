
modifier_item_ancient_janggo_lua_buff = class({})

function modifier_item_ancient_janggo_lua_buff:IsHidden()
	return false
end
----------------------------------------
function modifier_item_ancient_janggo_lua_buff:IsDebuff()
	return false
end
----------------------------------------
function modifier_item_ancient_janggo_lua_buff:GetStatusEffectName()
	return "particles/items_fx/drum_of_endurance_buff.vpcf"
end

----------------------------------------

function modifier_item_ancient_janggo_lua_buff:OnCreated( kv )
    self.bonus_attack_speed_buff = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_buff" )
    self.bonus_movement_speed_pct_buff = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed_pct_buff" )
end

---------------------------------------------

function modifier_item_ancient_janggo_lua_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

----------------------------------------

function modifier_item_ancient_janggo_lua_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed_buff
end
----------------------------------------
function modifier_item_ancient_janggo_lua_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movement_speed_pct_buff
end
