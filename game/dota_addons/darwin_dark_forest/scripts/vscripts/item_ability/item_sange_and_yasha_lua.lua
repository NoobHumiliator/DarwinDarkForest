item_sange_and_yasha_lua = class({})
LinkLuaModifier( "modifier_item_sange_and_yasha_lua", "item_ability/modifier/modifier_item_sange_and_yasha_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_sange_and_yasha_lua_debuff", "item_ability/modifier/modifier_item_sange_and_yasha_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_sange_and_yasha_lua:GetIntrinsicModifierName()
	return "modifier_item_sange_and_yasha"
end

--------------------------------------------------------------------------------