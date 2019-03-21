
decay_summon_wraith_warrior = class({})
--------------------------------------------------------------------------------

function decay_summon_wraith_warrior:OnSpellStart()
	if IsServer() then

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local vSpawnPos = self:GetCaster():GetAbsOrigin() + RandomVector( 250 )

		local hWraithWarrior = CreateUnitByName( "npc_dota_creature_wraith_warrior", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hWraithWarrior ~= nil then

			local wraith_warrior_duration = self:GetSpecialValueFor( "wraith_warrior_duration" )
			self.wraith_warrior_health = self:GetSpecialValueFor( "wraith_warrior_health" )
            local wraith_warrior_damage = self:GetSpecialValueFor( "wraith_warrior_damage" )

            EmitSoundOn( "Undying_Zombie.Spawn", hWraithWarrior )
            
            ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeletonMage ) )

			hWraithWarrior:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = wraith_warrior_duration } )
            hWraithWarrior:SetControllableByPlayer(self:GetCaster():GetMainControllingPlayer(), false)
			hWraithWarrior:SetOwner( self:GetCaster() )
			hWraithWarrior:SetDeathXP( 0 )
			hWraithWarrior:SetMinimumGoldBounty( 0 )
			hWraithWarrior:SetMaximumGoldBounty( 0 )
			Timers:CreateTimer({
				    endTime = 0.05,
				    callback = function()
				       	hWraithWarrior:SetMaxHealth(self.wraith_warrior_health)
				        hWraithWarrior:Heal(self.wraith_warrior_health,hWraithWarrior)
				    end
				})

            hWraithWarrior:SetBaseDamageMax(wraith_warrior_damage+10)
            hWraithWarrior:SetBaseDamageMin(wraith_warrior_damage-10)

		end
	end
end

--------------------------------------------------------------------------------
