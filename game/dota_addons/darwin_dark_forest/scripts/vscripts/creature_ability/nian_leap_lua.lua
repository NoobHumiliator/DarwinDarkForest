nian_leap_lua = class({})
LinkLuaModifier("modifier_nian_leap_lua", "creature_ability/modifier/modifier_nian_leap_lua", LUA_MODIFIER_MOTION_NONE)

function nian_leap_lua:GetAbilityTextureName()
	return "mirana_leap"
end


function nian_leap_lua:OnAbilityPhaseStart()
	-- Ability properties
	if IsServer() then
	   local caster = self:GetCaster()
	   caster:StartGesture(ACT_DOTA_LEAP_STUN)
    end
	return true
end


function nian_leap_lua:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()

	-- Play cast sound
	EmitSoundOn("Ability.Leap", caster)

	caster:FaceTowards(target_point)
	
	-- Start moving
	local modifier_movement_handler = caster:AddNewModifier(caster, self, "modifier_nian_leap_lua", {duration=80})
	-- Assign the target location in the modifier
	if modifier_movement_handler then
		modifier_movement_handler.target_point = target_point
	end
end