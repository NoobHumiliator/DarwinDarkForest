modifier_item_black_king_bar_lua_buff = class({})

function modifier_item_black_king_bar_lua_buff:IsHidden() return false end
function modifier_item_black_king_bar_lua_buff:IsPurgable() return false end

function modifier_item_black_king_bar_lua_buff:CheckState()
	local state = {
	  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end

function modifier_item_black_king_bar_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
end

function modifier_item_black_king_bar_lua_buff:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("model_scale")
end

function modifier_item_black_king_bar_lua_buff:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_item_black_king_bar_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_black_king_bar_lua_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_item_black_king_bar_lua_buff:StatusEffectPriority()
	return 10
end
