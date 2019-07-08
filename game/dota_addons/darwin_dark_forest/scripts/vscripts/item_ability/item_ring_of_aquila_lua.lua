item_ring_of_aquila_lua = class({})
LinkLuaModifier( "modifier_item_ring_of_aquila_lua", "item_ability/modifier/modifier_item_ring_of_aquila_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ring_of_aquila_lua_effect", "item_ability/modifier/modifier_item_ring_of_aquila_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_ring_of_aquila_lua:GetIntrinsicModifierName()
	return "modifier_item_ring_of_aquila_lua"
end

--------------------------------------------------------------------------------