item_dragon_lance_lua = class({})
LinkLuaModifier( "modifier_item_dragon_lance_lua", "item_ability/modifier/modifier_item_dragon_lance_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_dragon_lance_lua:GetIntrinsicModifierName()
	return "modifier_item_dragon_lance_lua"
end

--------------------------------------------------------------------------------