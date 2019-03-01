
modifier_decay_tombstone = class({})

---------------------------------------------------------

function modifier_decay_tombstone:IsHidden()
	return true
end

---------------------------------------------------------

function modifier_decay_tombstone:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_decay_tombstone:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

---------------------------------------------------------

function modifier_decay_tombstone:OnCreated()
	if IsServer() then
		self.hSkeletons = {}

		self.radius = 500
		self.zombie_duration = self:GetAbility():GetSpecialValueFor( "zombie_duration" )
		self.zombie_interval = self:GetAbility():GetSpecialValueFor( "zombie_interval" )
		self.max_zombie = self:GetAbility():GetSpecialValueFor( "max_zombie" )
        self.zombie_health = self:GetAbility():GetSpecialValueFor( "zombie_health" )
        self.zombie_damage = self:GetAbility():GetSpecialValueFor( "zombie_damage" )

		EmitSoundOn( "Hero_Tusk.FrozenSigil", self:GetParent() )

		self:StartIntervalThink( self.zombie_interval )
	end
end
---------------------------------------------------------

function modifier_decay_tombstone:OnIntervalThink()
	if IsServer() then

		for k, hSkeleton in pairs( self.hSkeletons ) do
			if hSkeleton == nil or hSkeleton:IsNull() or hSkeleton:IsAlive() == false then
				table.remove( self.hSkeletons, k )
			end
		end


		if #self.hSkeletons < self.max_zombie then
			local vSpawnPos = self:GetParent():GetAbsOrigin() + RandomVector( 150 )
			local hSkeleton = CreateUnitByName( "npc_dota_creature_tombstone_zombie", vSpawnPos, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
			if hSkeleton ~= nil then
				table.insert( self.hSkeletons, hSkeleton )
                hSkeleton:SetControllableByPlayer(self:GetParent().nPlayerId, false)
				hSkeleton:SetOwner( self:GetParent() )
				hSkeleton:SetDeathXP( 0 )
				hSkeleton:SetMinimumGoldBounty( 0 )
				hSkeleton:SetMaximumGoldBounty( 0 )
				local zombie_health=self.zombie_health
                
                Timers:CreateTimer({
				    endTime = 0.05,
				    callback = function()
				       	hSkeleton:SetMaxHealth(zombie_health)
				        hSkeleton:Heal(zombie_health,hSkeleton)
				    end
				})


				hSkeleton:SetBaseDamageMax(self.zombie_damage)
                hSkeleton:SetBaseDamageMin(self.zombie_damage)
                hSkeleton:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_kill", { duration = self.zombie_duration } )

				ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeleton ) )

				EmitSoundOn( "Tombstone.RaiseDead", hSkeleton )
			end
		end

	end
end

--------------------------------------------------------------------------------
