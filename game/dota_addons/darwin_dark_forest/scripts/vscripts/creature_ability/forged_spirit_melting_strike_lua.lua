forged_spirit_melting_strike_lua = class({})
LinkLuaModifier( "modifier_forged_spirit_melting_strike","creature_ability/modifier/modifier_forged_spirit_melting_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_forged_spirit_melting_strike_effect","creature_ability/modifier/modifier_forged_spirit_melting_strike_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function forged_spirit_melting_strike_lua:GetIntrinsicModifierName()
	return "modifier_forged_spirit_melting_strike"
end

--------------------------------------------------------------------------------

function forged_spirit_melting_strike_lua:OnSpellStart()
	self:ToggleAutoCast()
end

--------------------------------------------------------------------------------
