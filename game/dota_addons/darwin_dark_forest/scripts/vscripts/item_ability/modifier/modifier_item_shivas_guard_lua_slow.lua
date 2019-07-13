
modifier_item_shivas_guard_lua_slow = class({})

function modifier_item_shivas_guard_lua_slow:IsHidden()
	return false
end
----------------------------------------
function modifier_item_shivas_guard_lua_slow:IsDebuff()
	return true
end
----------------------------------------
function modifier_item_shivas_guard_lua_slow:OnCreated( kv )
    self.blast_movement_speed = self:GetAbility():GetSpecialValueFor( "blast_movement_speed" )

end

function modifier_item_shivas_guard_lua_slow:DeclareFunctions()
	local funcs = 
	{
          MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end


function modifier_item_shivas_guard_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.blast_movement_speed
end
