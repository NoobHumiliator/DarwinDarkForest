
modifier_item_ogre_seal_totem = class({})

------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_ogre_seal_totem:OnCreated( kv )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )

	 if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_hp)
    end
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_hp)
    end
end

function modifier_item_ogre_seal_totem:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_item_ogre_seal_totem:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_ogre_seal_totem:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_ogre_seal_totem:GetModifierMagicalResistanceBonus()
	return  self.magic_resistance
end