item_reaver_lua = class({})
LinkLuaModifier( "modifier_item_reaver_lua", "item_ability/modifier/modifier_item_reaver_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_reaver_lua:GetIntrinsicModifierName()
	return "modifier_item_reaver_lua"
end

--------------------------------------------------------------------------------