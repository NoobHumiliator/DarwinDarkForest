modifier_elder_dragon_passive_lua = modifier_elder_dragon_passive_lua or class({})

function modifier_elder_dragon_passive_lua:IsHidden()
	return false
end

function modifier_elder_dragon_passive_lua:OnCreated()
	self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_dragon_knight_splash_attack", {})
end



