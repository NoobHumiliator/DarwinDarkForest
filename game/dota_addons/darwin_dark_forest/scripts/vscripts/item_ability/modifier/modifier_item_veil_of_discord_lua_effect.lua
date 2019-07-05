-- ACTIVE DEBUFF MODIFIER
modifier_item_veil_of_discord_lua_effect = modifier_item_veil_of_discord_lua_effect or class({})

-- Modifier properties
function modifier_item_veil_of_discord_lua_effect:IsDebuff() return true end
function modifier_item_veil_of_discord_lua_effect:IsHidden() return false end
function modifier_item_veil_of_discord_lua_effect:IsPurgable() return true end

function modifier_item_veil_of_discord_lua_effect:OnCreated()
	self.resist_debuff    =   self:GetAbility():GetSpecialValueFor("resist_debuff")
end

function modifier_item_veil_of_discord_lua_effect:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_veil_of_discord_lua_effect:GetModifierMagicalResistanceBonus()
	return self.resist_debuff
end

function modifier_item_veil_of_discord_lua_effect:GetEffectName()
	return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_item_veil_of_discord_lua_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
