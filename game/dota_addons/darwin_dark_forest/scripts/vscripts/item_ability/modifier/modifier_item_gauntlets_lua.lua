
modifier_item_gauntlets_lua = class({})

function modifier_item_gauntlets_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_gauntlets_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_gauntlets_lua:OnCreated( kv )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------
function modifier_item_gauntlets_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end
------------------------------------------
function modifier_item_gauntlets_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_gauntlets_lua:GetModifierPreAttack_BonusDamage(kv)
	return self.bonus_damage
end

-------------------------------------------
function modifier_item_gauntlets_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------