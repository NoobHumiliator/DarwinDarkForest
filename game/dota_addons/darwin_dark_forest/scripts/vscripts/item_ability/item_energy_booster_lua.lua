item_energy_booster_lua = class({})
LinkLuaModifier( "modifier_item_energy_booster_lua", "item_ability/modifier/modifier_item_energy_booster_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_energy_booster_lua:GetIntrinsicModifierName()
	return "modifier_item_energy_booster_lua"
end

--------------------------------------------------------------------------------