
modifier_item_bottle_lua_effect = class({})

function modifier_item_bottle_lua_effect:IsHidden()
	return false
end
function modifier_item_bottle_lua_effect:IsDebuff()
	return false
end
function modifier_item_bottle_lua_effect:GetTexture()
	return "item_bottle"
end


----------------------------------------

function modifier_item_bottle_lua_effect:OnCreated( kv )

    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
  	

end
---------------------------------------------

function modifier_item_bottle_lua_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

----------------------------------------

function modifier_item_bottle_lua_effect:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

----------------------------------------
function modifier_item_bottle_lua_effect:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------