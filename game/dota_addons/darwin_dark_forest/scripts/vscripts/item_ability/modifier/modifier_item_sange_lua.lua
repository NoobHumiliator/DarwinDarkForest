
modifier_item_sange_lua = class({})

function modifier_item_sange_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_sange_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_sange_lua:OnCreated( kv )

	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end

end
--------------------------------------------
function modifier_item_sange_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end-
--------------------------------------------

function modifier_item_sange_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end


----------------------------------------

function modifier_item_sange_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
----------------------------------------
function modifier_item_sange_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist
end
-----------------------------------------
function modifier_item_sange_lua:GetModifierConstantHealthRegen( params )
	return self.bonus_health_regen
end
-----------------------------------------