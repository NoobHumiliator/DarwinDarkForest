item_robe_lua = class({})
LinkLuaModifier( "modifier_item_robe_lua", "item_ability/modifier/modifier_item_robe_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_robe_lua:GetIntrinsicModifierName()
	return "modifier_item_robe_lua"
end

--------------------------------------------------------------------------------