item_branches_lua = class({})
LinkLuaModifier( "modifier_item_branches_lua", "item_ability/modifier/modifier_item_branches_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_branches_lua:GetIntrinsicModifierName()
	return "modifier_item_branches_lua"
end

--------------------------------------------------------------------------------