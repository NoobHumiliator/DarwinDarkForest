modifier_elder_green_dragon_passive_lua_passive = modifier_elder_green_dragon_passive_lua_passive or class({})

function modifier_elder_green_dragon_passive_lua_passive:IsHidden()
	return true
end

function modifier_elder_green_dragon_passive_lua_passive:OnCreated()
	 self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_dragon_knight_corrosive_breath", {})
     self:GetParent():SetMaterialGroup("0")
end