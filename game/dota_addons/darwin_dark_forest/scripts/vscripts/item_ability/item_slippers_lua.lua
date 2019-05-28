item_slippers_lua = class({})
LinkLuaModifier( "modifier_item_slippers_lua", "item_ability/modifier/modifier_item_slippers_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_slippers_lua:GetIntrinsicModifierName()
	return "modifier_item_slippers_lua"
end

--------------------------------------------------------------------------------