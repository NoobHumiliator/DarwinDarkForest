
eidolon_duplicate_lua = class({})

LinkLuaModifier( "modifier_eidolon_duplicate_passive", "creature_ability/modifier/modifier_eidolon_duplicate_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function eidolon_duplicate_lua:GetIntrinsicModifierName()
	return "modifier_eidolon_duplicate_passive"
end

--------------------------------------------------------------------------------

