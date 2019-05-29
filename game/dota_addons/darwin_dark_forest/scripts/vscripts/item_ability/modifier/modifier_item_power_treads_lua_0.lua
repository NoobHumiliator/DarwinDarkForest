
modifier_item_power_treads_lua_0 = class({})

function modifier_item_power_treads_lua_0:IsHidden()
	return true
end
----------------------------------------

function modifier_item_power_treads_lua_0:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_power_treads_lua_0:OnCreated( kv )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------
function modifier_item_power_treads_lua_0:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end
------------------------------------------
function modifier_item_power_treads_lua_0:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_power_treads_lua_0:GetModifierPreAttack_BonusDamage(kv)
	return self.bonus_damage
end

-------------------------------------------
function modifier_item_power_treads_lua_0:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_power_treads_lua_0:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end