
modifier_item_holy_locket_lua = class({})

function modifier_item_holy_locket_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_holy_locket_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_holy_locket_lua:OnCreated( kv )

    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
  	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
    self.heal_increase = self:GetAbility():GetSpecialValueFor( "heal_increase" )

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------


function modifier_item_holy_locket_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_holy_locket_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end


function modifier_item_holy_locket_lua:GetModifierConstantManaRegen( params )
	return self.mana_regen
end

----------------------------------------
function modifier_item_holy_locket_lua:GetModifierConstantHealthRegen(kv)
	return self.health_regen
end

-------------------------------------------
function modifier_item_holy_locket_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end
-------------------------------------------
function modifier_item_holy_locket_lua:GetModifierHPRegenAmplify_Percentage( params )
	return self.heal_increase
end
