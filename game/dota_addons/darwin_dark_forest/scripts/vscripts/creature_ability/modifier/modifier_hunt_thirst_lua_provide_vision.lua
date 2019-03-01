modifier_hunt_thirst_lua_provide_vision = modifier_hunt_thirst_lua_provide_vision or class({})


function modifier_hunt_thirst_lua_provide_vision:IsDebuff()
   return true
end

function modifier_hunt_thirst_lua_provide_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs

end

function modifier_hunt_thirst_lua_provide_vision:GetModifierProvidesFOWVision()
	return 1
end

function modifier_hunt_thirst_lua_provide_vision:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false,}
	return state
end

function modifier_hunt_thirst_lua_provide_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_hunt_thirst_lua_provide_vision:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end

function modifier_hunt_thirst_lua_provide_vision:GetStatusEffectName()
	return "particles/status_fx/status_effect_thirst_vision.vpcf"
end

function modifier_hunt_thirst_lua_provide_vision:StatusEffectPriority()
	return 8
end
