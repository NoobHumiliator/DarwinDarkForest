
modifier_item_sange_lua_debuff = class({})

function modifier_item_sange_lua_debuff:IsHidden()
	return false
end
----------------------------------------
function modifier_item_sange_lua_debuff:GetTexture()
	return "item_sange"
end

function modifier_item_sange_lua_debuff:GetStatusEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end
----------------------------------------

function modifier_item_sange_lua_debuff:OnCreated( kv )

	self.movement_speed_slow_pct = self:GetAbility():GetSpecialValueFor( "movement_speed_slow_pct" )
    self.attack_speed_slow = self:GetAbility():GetSpecialValueFor( "attack_speed_slow" )


end
--------------------------------------------

function modifier_item_sange_lua_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end


----------------------------------------

function modifier_item_sange_lua_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_speed_slow_pct
end
----------------------------------------
function modifier_item_sange_lua_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_slow
end
-----------------------------------------
