shrine_passive = class({})
LinkLuaModifier( "modifier_fountain_aura_lua","modifiers/modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fountain_aura_effect_lua","modifiers/modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function shrine_passive:GetIntrinsicModifierName()
	return "modifier_fountain_aura_lua"
end
--------------------------------------------------------------------------------

