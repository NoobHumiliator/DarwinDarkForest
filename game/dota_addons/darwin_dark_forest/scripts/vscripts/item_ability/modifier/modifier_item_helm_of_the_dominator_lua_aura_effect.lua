
modifier_item_helm_of_the_dominator_lua_aura_effect = class({})

function modifier_item_helm_of_the_dominator_lua_aura_effect:IsHidden()
	return false
end
----------------------------------------
function modifier_item_helm_of_the_dominator_lua_aura_effect:IsDebuff()
	return false
end
----------------------------------------

function modifier_item_helm_of_the_dominator_lua_aura_effect:OnCreated( kv )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed_aura" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "hp_regen_aura" )
end
---------------------------------------------

function modifier_item_helm_of_the_dominator_lua_aura_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

----------------------------------------

function modifier_item_helm_of_the_dominator_lua_aura_effect:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
----------------------------------------

function modifier_item_helm_of_the_dominator_lua_aura_effect:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end
-------------------------------------------