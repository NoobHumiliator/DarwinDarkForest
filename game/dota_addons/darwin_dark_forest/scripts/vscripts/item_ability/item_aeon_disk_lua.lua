item_aeon_disk_lua = class({})
LinkLuaModifier( "modifier_item_aeon_disk_lua", "item_ability/modifier/modifier_item_aeon_disk_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_aeon_disk_lua_buff", "item_ability/modifier/modifier_item_aeon_disk_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_aeon_disk_lua:GetIntrinsicModifierName()
	return "modifier_item_aeon_disk_lua"
end

--------------------------------------------------------------------------------