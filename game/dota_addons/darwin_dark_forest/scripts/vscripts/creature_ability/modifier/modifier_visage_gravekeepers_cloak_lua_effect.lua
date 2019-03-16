modifier_visage_gravekeepers_cloak_lua_effect = modifier_visage_gravekeepers_cloak_lua_effect or class({})


function modifier_visage_gravekeepers_cloak_lua_effect:OnCreated()
	if IsServer() then
		self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
    end
end


function modifier_visage_gravekeepers_cloak_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_visage_gravekeepers_cloak_lua_effect:GetModifierIncomingDamage_Percentage(event)
     
     local flPercentage = -1 * self:GetStackCount()*self.damage_reduction
     if flPercentage <-100 then 
        flPercentage=-100 
     end

     return flPercentage
     
end

