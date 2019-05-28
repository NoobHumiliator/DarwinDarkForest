item_circlet_lua = class({})
LinkLuaModifier( "modifier_item_circlet_lua", "item_ability/modifier/modifier_item_circlet_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_circlet_lua:GetIntrinsicModifierName()
	return "modifier_item_circlet_lua"
end

--------------------------------------------------------------------------------