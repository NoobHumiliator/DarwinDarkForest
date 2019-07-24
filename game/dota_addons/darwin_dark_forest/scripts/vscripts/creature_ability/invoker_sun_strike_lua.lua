invoker_sun_strike_lua = class({})
LinkLuaModifier( "modifier_invoker_sun_strike_lua_thinker", "creature_ability/modifier/modifier_invoker_sun_strike_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function invoker_sun_strike_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function invoker_sun_strike_lua:GetBehavior()
	 local nDefaultBehavior = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING 
     if self:GetCaster():HasModifier("modifier_item_aeon_disk_lua") then
        return nDefaultBehavior+DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
     else
        return nDefaultBehavior
     end
end

 function invoker_sun_strike_lua:CastFilterResultTarget( hTarget )
	if not self:GetCaster():HasModifier("modifier_item_aeon_disk_lua") then
 		return UF_FAIL_CUSTOM
 	end
 	if self:GetCaster() ~= hTarget then
 		return UF_FAIL_CUSTOM
 	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Ability Start
function invoker_sun_strike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- get values
	local delay = self:GetSpecialValueFor("delay")
	local vision_distance = self:GetSpecialValueFor("vision_distance")
	local vision_duration = self:GetSpecialValueFor("vision_duration")

	-- create modifier thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_invoker_sun_strike_lua_thinker",
		{ duration = delay },
		point,
		caster:GetTeamNumber(),
		false
	)

	-- create vision
	AddFOWViewer( caster:GetTeamNumber(), point, vision_distance, vision_duration, false )
end