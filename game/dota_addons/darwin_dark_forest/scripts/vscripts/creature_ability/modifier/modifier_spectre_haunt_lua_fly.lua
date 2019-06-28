modifier_spectre_haunt_lua_fly = modifier_spectre_haunt_lua_fly or class({})


function modifier_spectre_haunt_lua_fly:IsHidden()
	return true
end

function modifier_spectre_haunt_lua_fly:CheckState()
	return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true }
end

function modifier_spectre_haunt_lua_fly:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN }
end

function modifier_spectre_haunt_lua_fly:GetModifierMoveSpeed_AbsoluteMin()
	return 400
end