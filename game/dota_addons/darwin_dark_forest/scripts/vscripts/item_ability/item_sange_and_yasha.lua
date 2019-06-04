item_sange_and_yasha = class({})
LinkLuaModifier( "modifier_item_sange_and_yasha", "item_ability/modifier/modifier_item_sange_and_yasha", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_sange_and_yasha_debuff", "item_ability/modifier/modifier_item_sange_and_yasha_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_sange_and_yasha:GetIntrinsicModifierName()
	return "modifier_item_sange_and_yasha"
end

--------------------------------------------------------------------------------