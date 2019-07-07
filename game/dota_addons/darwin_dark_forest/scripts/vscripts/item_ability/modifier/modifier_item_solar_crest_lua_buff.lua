
modifier_item_solar_crest_lua_buff = class({})

function modifier_item_solar_crest_lua_buff:IsDebuff()
	return false
end
----------------------------------------

function modifier_item_solar_crest_lua_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------
function modifier_item_solar_crest_lua_buff:GetEffectName()
	return "particles/items2_fx/medallion_of_courage_friend.vpcf" 
end
----------------------------------------
function modifier_item_solar_crest_lua_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end
----------------------------------------


function modifier_item_solar_crest_lua_buff:OnCreated( kv )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "target_attack_speed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "target_movement_speed" )
end
-------------------------------------------
function modifier_item_solar_crest_lua_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

----------------------------------------

function modifier_item_solar_crest_lua_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
----------------------------------------
function modifier_item_solar_crest_lua_buff:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_solar_crest_lua_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end