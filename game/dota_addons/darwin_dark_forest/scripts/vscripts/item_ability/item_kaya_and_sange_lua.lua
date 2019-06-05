item_kaya_and_sange_lua = class({})
LinkLuaModifier( "modifier_item_kaya_and_sange_lua", "item_ability/modifier/modifier_item_kaya_and_sange_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_and_sange_lua_debuff", "item_ability/modifier/modifier_item_kaya_and_sange_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_kaya_and_sange_lua:GetIntrinsicModifierName()
	return "modifier_item_kaya_and_sange_lua"
end

--------------------------------------------------------------------------------