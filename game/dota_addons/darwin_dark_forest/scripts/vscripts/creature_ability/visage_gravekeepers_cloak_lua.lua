visage_gravekeepers_cloak_lua = class({})
LinkLuaModifier( "modifier_visage_gravekeepers_cloak_lua_passive","creature_ability/modifier/modifier_visage_gravekeepers_cloak_lua_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_visage_gravekeepers_cloak_lua_effect","creature_ability/modifier/modifier_visage_gravekeepers_cloak_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function visage_gravekeepers_cloak_lua:GetIntrinsicModifierName()
	return "modifier_visage_gravekeepers_cloak_lua_passive"
end
--------------------------------------------------------------------------------

