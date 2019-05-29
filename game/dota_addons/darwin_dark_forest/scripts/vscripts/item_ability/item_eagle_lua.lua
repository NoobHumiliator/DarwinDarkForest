item_eagle_lua = class({})
LinkLuaModifier( "modifier_item_eagle_lua", "item_ability/modifier/modifier_item_eagle_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_eagle_lua:GetIntrinsicModifierName()
	return "modifier_item_eagle_lua"
end

--------------------------------------------------------------------------------