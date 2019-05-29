item_bracer_lua = class({})
LinkLuaModifier( "modifier_item_bracer_lua", "item_ability/modifier/modifier_item_bracer_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_bracer_lua:GetIntrinsicModifierName()
	return "modifier_item_bracer_lua"
end

--------------------------------------------------------------------------------