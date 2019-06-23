ultimate_stage_reverse_polarity = ultimate_stage_reverse_polarity or class({})


function ultimate_stage_reverse_polarity:OnAbilityPhaseStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local flParticleRadius = 3000

		EmitGlobalSound("Hero_Magnataur.ReversePolarity.Anim")

		local nParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(nParticleIndex, 0, hCaster, PATTACH_POINT_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(nParticleIndex, 1, Vector(flParticleRadius, 0, 0))
		ParticleManager:SetParticleControl(nParticleIndex, 2, Vector(self:GetCastPoint(), 0, 0))
		ParticleManager:SetParticleControl(nParticleIndex, 3, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(nParticleIndex)
		return true
	end
end

function ultimate_stage_reverse_polarity:OnSpellStart()

	 local hCaster = self:GetCaster()
     local stun_duration = self:GetSpecialValueFor( "stun_duration" )

     EmitGlobalSound("Hero_Magnataur.ReversePolarity.Cast")

     local vCreeps = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetAbsOrigin(), nil, -1, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	 for _,hCreep in ipairs(vCreeps) do
	 	if hCreep:GetTeam()~=DOTA_TEAM_NEUTRALS then
			hCreep:SetAbsOrigin(hCaster:GetAbsOrigin())
			FindClearSpaceForUnit(hCreep, hCaster:GetAbsOrigin(), true)
			hCreep:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration})
			hCreep:EmitSound("Hero_Magnataur.ReversePolarity.Stun")
		end
	 end

end
