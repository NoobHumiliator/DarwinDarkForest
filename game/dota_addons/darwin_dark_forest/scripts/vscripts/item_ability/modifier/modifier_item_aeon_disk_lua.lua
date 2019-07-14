
modifier_item_aeon_disk_lua = class({})

function modifier_item_aeon_disk_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_aeon_disk_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_aeon_disk_lua:OnCreated( kv )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------


function modifier_item_aeon_disk_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_aeon_disk_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_item_aeon_disk_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end


function modifier_item_aeon_disk_lua:OnTakeDamage (event)

	if IsServer() then
		if event.unit == self:GetParent() then
			local duration = self:GetAbility():GetSpecialValueFor("buff_duration")
			if (self:GetParent():GetHealth()/self:GetParent():GetMaxHealth()) <0.7 and self:GetAbility():IsCooldownReady()  then
	              
	              self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
	              self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_aeon_disk_lua_buff", {duration=duration})
		 	end
		end
    end

end
---------