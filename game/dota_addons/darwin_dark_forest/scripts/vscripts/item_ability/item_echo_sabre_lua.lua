item_echo_sabre_lua = class({})
LinkLuaModifier( "modifier_item_echo_sabre_lua", "item_ability/modifier/modifier_item_echo_sabre_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_echo_sabre_lua_debuff", "item_ability/modifier/modifier_item_echo_sabre_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_echo_sabre_lua:GetIntrinsicModifierName()
	return "modifier_item_echo_sabre_lua"
end

--------------------------------------------------------------------------------