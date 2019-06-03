item_yasha_lua = class({})
LinkLuaModifier( "modifier_item_yasha_lua", "item_ability/modifier/modifier_item_yasha_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_yasha_lua:GetIntrinsicModifierName()
	return "modifier_item_yasha_lua"
end

--------------------------------------------------------------------------------