
modifier_item_heavens_halberd_lua = class({})

function modifier_item_heavens_halberd_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_heavens_halberd_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_heavens_halberd_lua:OnCreated( kv )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
    self.status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------
function modifier_item_heavens_halberd_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end
------------------------------------------
function modifier_item_heavens_halberd_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_heavens_halberd_lua:GetModifierPreAttack_BonusDamage(kv)
	return self.bonus_damage
end

-------------------------------------------
function modifier_item_heavens_halberd_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_heavens_halberd_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end

----------------------------------------------

function modifier_item_heavens_halberd_lua:GetModifierStatusResistanceStacking(params)
	return self.status_resistance
end

----------------------------------------------

function modifier_item_heavens_halberd_lua::GetModifierEvasion_Constant(params)
	return self.bonus_evasion
end