bounty_hunter_track_lua = class({})
LinkLuaModifier( "modifier_bounty_hunter_track_lua_debuff", "creature_ability/modifier/modifier_bounty_hunter_track_lua_debuff", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_bounty_hunter_track_lua_speed", "creature_ability/modifier/modifier_bounty_hunter_track_lua_speed", LUA_MODIFIER_MOTION_BOTH )



function bounty_hunter_track_lua:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()


		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local duration = self:GetSpecialValueFor("duration")

		EmitSoundOnLocationForAllies(hCaster:GetAbsOrigin(), "Hero_BountyHunter.Target", hCaster)

		-- Add track particle
		local nParticleIndex = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_CUSTOMORIGIN, hCaster, hCaster:GetTeamNumber())
		ParticleManager:SetParticleControlEnt(nParticleIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nParticleIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(nParticleIndex)

		-- If target has Linken's sphere ready, do nothing
		if hCaster:GetTeamNumber() ~= hTarget:GetTeamNumber() then
			if hTarget:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- Add track debuff to target
		hTarget:AddNewModifier(hCaster, self, "modifier_bounty_hunter_track_lua_debuff", {duration = duration})
	end
end