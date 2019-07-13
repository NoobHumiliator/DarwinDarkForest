
modifier_item_shivas_guard_lua_debuff = class({})

function modifier_item_shivas_guard_lua_debuff:IsHidden()
	return false
end
----------------------------------------
function modifier_item_shivas_guard_lua_debuff:IsDebuff()
	return true
end
----------------------------------------
function modifier_item_shivas_guard_lua_debuff:OnCreated( kv )
    self.aura_attack_speed = self:GetAbility():GetSpecialValueFor( "aura_attack_speed" )

end

function modifier_item_shivas_guard_lua_debuff:DeclareFunctions()
	local funcs = 
	{
          MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end


function modifier_item_shivas_guard_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.aura_attack_speed
end
