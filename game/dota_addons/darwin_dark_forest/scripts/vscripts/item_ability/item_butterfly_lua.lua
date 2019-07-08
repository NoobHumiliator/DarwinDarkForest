item_butterfly_lua = class({})
LinkLuaModifier( "modifier_item_butterfly_lua", "item_ability/modifier/modifier_item_butterfly_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_butterfly_lua:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua"
end

--------------------------------------------------------------------------------