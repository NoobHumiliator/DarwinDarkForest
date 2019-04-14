item_vanguard_lua = class({})
LinkLuaModifier( "modifier_item_vanguard_lua", "item_ability/modifier/modifier_item_vanguard_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_vanguard_lua:GetIntrinsicModifierName()
	return "modifier_item_vanguard_lua"
end

--------------------------------------------------------------------------------