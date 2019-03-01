hunt_thirst_lua = class({})
LinkLuaModifier( "modifier_hunt_thirst_lua_passive","creature_ability/modifier/modifier_hunt_thirst_lua_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hunt_thirst_lua_provide_vision","creature_ability/modifier/modifier_hunt_thirst_lua_provide_vision", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hunt_thirst_lua:GetIntrinsicModifierName()
	return "modifier_hunt_thirst_lua_passive"
end
--------------------------------------------------------------------------------

