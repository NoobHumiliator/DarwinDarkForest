
modifier_item_solar_crest_lua_debuff = class({})

---------------------------------------
function modifier_item_solar_crest_lua_debuff:IsDebuff()
	return true
end
----------------------------------------
function modifier_item_solar_crest_lua_debuff:GetEffectName()
	return "particles/items2_fx/medallion_of_courage.vpcf" 
end
----------------------------------------
function modifier_item_solar_crest_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end
----------------------------------------

function modifier_item_solar_crest_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------

function modifier_item_solar_crest_lua_debuff:OnCreated( kv )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "target_attack_speed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "target_movement_speed" )
end
-------------------------------------------
function modifier_item_solar_crest_lua_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

----------------------------------------

function modifier_item_solar_crest_lua_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return -self.bonus_attack_speed
end
----------------------------------------
function modifier_item_solar_crest_lua_debuff:GetModifierPhysicalArmorBonus( params )
	return -self.bonus_armor
end
-------------------------------------------
function modifier_item_solar_crest_lua_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.bonus_move_speed_pct
end