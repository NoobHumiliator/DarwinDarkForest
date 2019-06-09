
decay_summon_ghost_ogreseal = class({})
--------------------------------------------------------------------------------

function decay_summon_ghost_ogreseal:OnSpellStart()
	if IsServer() then

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local vSpawnPos = self:GetCaster():GetAbsOrigin() + RandomVector( 250 )

		local hGhostSeal = CreateUnitByName( "npc_dota_creature_ghost_seal", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hGhostSeal ~= nil then

			local ghost_seal_duration = self:GetSpecialValueFor( "ghost_seal_duration" )
			self.ghost_seal_health = self:GetSpecialValueFor( "ghost_seal_health" )
            local ghost_seal_damage = self:GetSpecialValueFor( "ghost_seal_damage" )
            local flop_level = self:GetSpecialValueFor( "flop_level" )

            EmitSoundOn( "Undying_Zombie.Spawn", hGhostSeal )
            
            ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeletonMage ) )

			hGhostSeal:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = ghost_seal_duration } )
            hGhostSeal:SetControllableByPlayer(self:GetCaster():GetMainControllingPlayer(), false)
			hGhostSeal:SetOwner( PlayerResource:GetSelectedHeroEntity(self:GetCaster():GetMainControllingPlayer()) )
			hGhostSeal:SetDeathXP( 0 )
			hGhostSeal:SetMinimumGoldBounty( 0 )
			hGhostSeal:SetMaximumGoldBounty( 0 )
			Timers:CreateTimer({
				    endTime = FrameTime(),
				    callback = function()
				       	hGhostSeal:SetMaxHealth(self.ghost_seal_health)
				        hGhostSeal:Heal(self.ghost_seal_health,hGhostSeal)
				    end
				})

            hGhostSeal:SetBaseDamageMax(ghost_seal_damage+10)
            hGhostSeal:SetBaseDamageMin(ghost_seal_damage-10)
            hGhostSeal:FindAbilityByName("creature_ogreseal_flop"):SetLevel(flop_level)

		end
	end
end

--------------------------------------------------------------------------------
