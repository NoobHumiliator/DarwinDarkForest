modifier_visage_gravekeepers_cloak_lua_passive = modifier_visage_gravekeepers_cloak_lua_passive or class({})


function modifier_visage_gravekeepers_cloak_lua_passive:OnCreated()
	if IsServer() then
		self.recovery_time = self:GetAbility():GetSpecialValueFor("recovery_time")
		self.max_layers = self:GetAbility():GetSpecialValueFor("max_layers")
		self.minimum_damage = self:GetAbility():GetSpecialValueFor("minimum_damage")
		self:StartIntervalThink(self.recovery_time)
    end
end

function modifier_visage_gravekeepers_cloak_lua_passive:OnRefresh()
	if IsServer() then
		self.recovery_time = self:GetAbility():GetSpecialValueFor("recovery_time")
		self.max_layers = self:GetAbility():GetSpecialValueFor("max_layers")
		self.minimum_damage = self:GetAbility():GetSpecialValueFor("minimum_damage")
    end
end

function modifier_visage_gravekeepers_cloak_lua_passive:OnIntervalThink()
	if IsServer() then
		local nStacksNumber= 0
		if self:GetParent():HasModifier("modifier_visage_gravekeepers_cloak_lua_effect") then
			nStacksNumber=self:GetParent():GetModifierStackCount("modifier_visage_gravekeepers_cloak_lua_effect", self:GetParent())
		    if nStacksNumber<self.max_layers then
			  self:GetParent():FindModifierByName("modifier_visage_gravekeepers_cloak_lua_effect"):SetStackCount(nStacksNumber+1)
		    end
		else
			local hModifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_visage_gravekeepers_cloak_lua_effect", {})
		    hModifier:SetStackCount(1)
		end
	end
end

function modifier_visage_gravekeepers_cloak_lua_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_visage_gravekeepers_cloak_lua_passive:OnTakeDamage(event)
   if event.unit == self:GetParent() then
     	local original_damage = event.original_damage      
        if original_damage>self.minimum_damage then             
            if self:GetParent():HasModifier("modifier_visage_gravekeepers_cloak_lua_effect") then
			    local nStacksNumber=self:GetParent():GetModifierStackCount("modifier_visage_gravekeepers_cloak_lua_effect", self:GetParent())
			    if nStacksNumber==1 then
                    self:GetParent():RemoveModifierByName("modifier_visage_gravekeepers_cloak_lua_effect")
			    else
			    	self:GetParent():FindModifierByName("modifier_visage_gravekeepers_cloak_lua_effect"):SetStackCount(nStacksNumber-1)
			    end
		    end
        end
	end
end

