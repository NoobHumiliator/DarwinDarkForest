durable_shard_split = class({})

--------------------------------------------------------------------------------

function durable_shard_split:OnOwnerDied()
	
	if IsServer() then
		-- 正常死亡 而不是机制移除的单位
        if  true~=self:GetCaster().bKillByMech then
			self.shard_health = self:GetSpecialValueFor( "shard_health" )
			self.shard_damage = self:GetSpecialValueFor( "shard_damage" )
			self.hurl_boulder_level = self:GetSpecialValueFor( "hurl_boulder_level" )
			self.duration = self:GetSpecialValueFor( "duration" )
	        
	        for i=1,2 do
	        	local vSpawnPos = self:GetCaster():GetAbsOrigin() + RandomVector( 75 )
				local hShard = CreateUnitByName( "npc_dota_creature_shard_split", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		        hShard:SetControllableByPlayer(self:GetCaster():GetMainControllingPlayer(), false)
		        hShard:SetOwner( self:GetCaster() )
		        hShard:SetDeathXP( 0 )
				hShard:SetMinimumGoldBounty( 0 )
				hShard:SetMaximumGoldBounty( 0 )
		        
		        local shard_health=self.shard_health

				Timers:CreateTimer({
						    endTime = 0.05,
						    callback = function()
						       	hShard:SetMaxHealth(shard_health)
						        hShard:Heal(shard_health,hShard)
						    end
				})

				hShard:SetBaseDamageMax(self.shard_damage)
		        hShard:SetBaseDamageMin(self.shard_damage)
		        hShard:FindAbilityByName("mud_golem_hurl_boulder_lua"):SetLevel(self.hurl_boulder_level)
		        hShard:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = self.duration } )
	        end
        end
	end
end
---------------------------------------------------------