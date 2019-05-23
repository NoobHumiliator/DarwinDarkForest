sand_king_boss_passive = class({})
LinkLuaModifier( "modifier_sand_king_boss_passive", "creature_ability/modifier/modifier_sand_king_boss_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_king_boss_caustic_finale", "creature_ability/modifier/modifier_sand_king_boss_caustic_finale", LUA_MODIFIER_MOTION_NONE )



-----------------------------------------------------------------------------------------

function sand_king_boss_passive:GetIntrinsicModifierName()
	return "modifier_sand_king_boss_passive"
end

-----------------------------------------------------------------------------------------
