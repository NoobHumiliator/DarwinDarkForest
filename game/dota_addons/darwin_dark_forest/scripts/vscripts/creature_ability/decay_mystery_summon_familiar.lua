
decay_mystery_summon_familiar = class({})
--------------------------------------------------------------------------------

function decay_mystery_summon_familiar:OnSpellStart()
	if IsServer() then

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end

        local familiar_number = self:GetSpecialValueFor( "familiar_number" )
        self.familiar_hp = self:GetSpecialValueFor( "familiar_hp" )
	    local familiar_armor = self:GetSpecialValueFor( "familiar_armor" )
        local familiar_attack_damage = self:GetSpecialValueFor( "familiar_attack_damage" )

        for i=1,familiar_number do
        	
            
            local vSpawnPos = self:GetCaster():GetAbsOrigin() + RandomVector( 250 )       


        	local hFamiliar = CreateUnitByName( "npc_dota_creature_summoned_familiar", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			if hFamiliar ~= nil then

	            EmitSoundOn( "Hero_Visage.SummonFamiliars.Cast", hFamiliar )
	            
	            ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeletonMage ) )

	            hFamiliar:SetControllableByPlayer(self:GetCaster():GetMainControllingPlayer(), false)
			    hFamiliar:SetOwner( PlayerResource:GetSelectedHeroEntity(self:GetCaster():GetMainControllingPlayer()) )
				hFamiliar:SetDeathXP( 0 )
				hFamiliar:SetMinimumGoldBounty( 0 )
				hFamiliar:SetMaximumGoldBounty( 0 )
				Timers:CreateTimer({
					    endTime = 0.05,
					    callback = function()
					        hFamiliar:SetBaseMaxHealth(self.familiar_hp)
					       	hFamiliar:SetMaxHealth(self.familiar_hp)
					        hFamiliar:Heal(self.familiar_hp,hFamiliar)
					    end
					})

	            hFamiliar:SetBaseDamageMax(familiar_attack_damage)
	            hFamiliar:SetBaseDamageMin(familiar_attack_damage)
			end
        end
		
	end
end

--------------------------------------------------------------------------------
