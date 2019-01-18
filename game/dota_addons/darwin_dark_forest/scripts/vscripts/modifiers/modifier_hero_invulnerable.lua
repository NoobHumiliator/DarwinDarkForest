modifier_hero_invulnerable = class({})


-----------------------------------------------------------------------------------
function modifier_hero_invulnerable:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_hero_invulnerable:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_hero_invulnerable:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_hero_invulnerable:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = ture,
		[MODIFIER_STATE_NO_HEALTH_BAR] = ture,
		[MODIFIER_STATE_INVULNERABLE] = ture,
		[MODIFIER_STATE_OUT_OF_GAME] = ture
	}

	return state
end
