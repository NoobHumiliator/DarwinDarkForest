modifier_elder_red_dragon_passive_lua_passive = modifier_elder_red_dragon_passive_lua_passive or class({})

function modifier_elder_red_dragon_passive_lua_passive:IsHidden()
	return true
end

function modifier_elder_red_dragon_passive_lua_passive:OnCreated()
	 self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_dragon_knight_splash_attack", {})
     self:GetParent():SetMaterialGroup("1")
end