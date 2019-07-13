modifier_item_manta_lua_invulnerable = class({})

--------------------------------------------------------------------------------

function modifier_item_manta_lua_invulnerable:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_manta_lua_invulnerable:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}

	return state
end