
modifier_item_rod_of_atos_lua_debuff = class({})

function modifier_item_rod_of_atos_lua_debuff:IsDebuff()
	return true
end


function modifier_item_rod_of_atos_lua_debuff:GetEffectName()
	return "particles/items2_fx/rod_of_atos.vpcf"
end

function modifier_item_rod_of_atos_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_item_rod_of_atos_lua_debuff:CheckState(keys)
	local state = {
	    [MODIFIER_STATE_ROOTED] = true
	}
	return state
end