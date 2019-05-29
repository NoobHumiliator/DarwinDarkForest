item_null_talisman_lua = class({})
LinkLuaModifier( "modifier_item_null_talisman_lua", "item_ability/modifier/modifier_item_null_talisman_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_null_talisman_lua:GetIntrinsicModifierName()
	return "modifier_item_null_talisman_lua"
end

--------------------------------------------------------------------------------