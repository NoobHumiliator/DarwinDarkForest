modifier_elder_green_dragon_passive_lua_passive = modifier_elder_green_dragon_passive_lua_passive or class({})

function modifier_elder_green_dragon_passive_lua_passive:IsHidden()
	return true
end

function modifier_elder_green_dragon_passive_lua_passive:OnCreated()
    
   if IsServer() and self:GetParent() then
   	 --会导致闪退
	 --self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_dragon_knight_corrosive_breath", {duration = 999999})
     self:GetParent():SetMaterialGroup("0")
     self.duration = self:GetAbility():GetSpecialValueFor("duration")
    end
end

function modifier_elder_green_dragon_passive_lua_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	return decFuns
end

function modifier_elder_green_dragon_passive_lua_passive:OnAttackLanded(keys)
    
   if IsServer() then
   	    if self:GetParent() == keys.attacker then
	       keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dragon_knight_corrosive_breath_debuff_lua", {duration = self.duration})
        end
    end

end