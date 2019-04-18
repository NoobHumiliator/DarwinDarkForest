item_heart_lua = class({})
LinkLuaModifier( "modifier_item_heart_lua", "item_ability/modifier/modifier_item_heart_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_heart_lua:GetIntrinsicModifierName()
	return "modifier_item_heart_lua"
end

--------------------------------------------------------------------------------