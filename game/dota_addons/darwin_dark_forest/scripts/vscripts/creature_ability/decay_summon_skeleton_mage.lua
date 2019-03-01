
decay_summon_skeleton_mage = class({})
--------------------------------------------------------------------------------

function decay_summon_skeleton_mage:OnSpellStart()
	if IsServer() then

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local vSpawnPos = self:GetCaster():GetAbsOrigin() + RandomVector( 250 )

		local hSkeletonMage = CreateUnitByName( "npc_dota_creature_skeleton_mage", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hSkeletonMage ~= nil then

			local flDuration = self:GetSpecialValueFor( "skeleton_mage_duration" )
			local nNetherBlastLevel = self:GetSpecialValueFor( "nether_blast_level" )

            EmitSoundOn( "Undying_Zombie.Spawn", hSkeletonMage )
            
            ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeletonMage ) )

			hSkeletonMage:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = flDuration } )
            hSkeletonMage:SetControllableByPlayer(self:GetCaster():GetMainControllingPlayer(), false)
			hSkeletonMage:SetOwner( self:GetCaster() )
			hSkeletonMage:SetDeathXP( 0 )
			hSkeletonMage:SetMinimumGoldBounty( 0 )
			hSkeletonMage:SetMaximumGoldBounty( 0 )
            hSkeletonMage:FindAbilityByName("pugna_nether_blast"):SetLevel(nNetherBlastLevel)
            hSkeletonMage:FindAbilityByName("pugna_nether_blast"):StartCooldown(3.0)

		end
	end
end

--------------------------------------------------------------------------------
