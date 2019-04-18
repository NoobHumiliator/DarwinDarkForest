item_gauntlets_lua = class({})
LinkLuaModifier( "modifier_item_gauntlets_lua", "item_ability/modifier/modifier_item_gauntlets_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_gauntlets_lua:GetIntrinsicModifierName()
	return "modifier_item_gauntlets_lua"
end

--------------------------------------------------------------------------------