
modifier_item_heart_lua = class({})

function modifier_item_heart_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_heart_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_heart_lua:OnCreated( kv )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_regen_rate = self:GetAbility():GetSpecialValueFor( "health_regen_rate" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------
function modifier_item_heart_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end
------------------------------------------

function modifier_item_heart_lua:OnTakeDamage(event)
     
     if IsServer() then
     	if event.unit == self:GetParent() then
     	   self:GetAbility():StartCooldown(7.0)
     	end
     end
end


------------------------------------------
function modifier_item_heart_lua:GetModifierHealthRegenPercentage(kv)

	if self:GetAbility():IsCooldownReady() then
	   return self.health_regen_rate 
    else
       return 0
    end
end

-------------------------------------------


function modifier_item_heart_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------


function modifier_item_heart_lua:GetModifierPreAttack_BonusDamage( params )
    return self.bonus_damage
end
---------------------------------------------
function modifier_item_heart_lua:GetModifierMagicalResistanceBonus( params )
    return self.magic_resistance
end