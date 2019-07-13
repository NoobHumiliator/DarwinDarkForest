
modifier_item_silver_edge_lua_debuff = class({})

function modifier_item_silver_edge_lua_debuff:IsHidden()
	return false
end
----------------------------------------

function modifier_item_silver_edge_lua_debuff:IsDebuff()
	return true
end
----------------------------------------

function modifier_item_silver_edge_lua_debuff:CheckState()
	local state ={
		[MODIFIER_STATE_PASSIVES_DISABLED]= true
	}
	return state
end