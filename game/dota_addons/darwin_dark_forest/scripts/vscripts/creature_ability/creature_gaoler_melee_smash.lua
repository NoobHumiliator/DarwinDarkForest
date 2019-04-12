creature_gaoler_melee_smash = class({})
LinkLuaModifier( "modifier_command_restricted", "creature_ability/modifier/modifier_command_restricted", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function creature_gaoler_melee_smash:ProcsMagicStick()
	return false
end
-----------------------------------------------------------------------------

function creature_gaoler_melee_smash:GetPlaybackRateOverride()
	return 0.5
end

-----------------------------------------------------------------------------

function creature_gaoler_melee_smash:OnSpellStart()

	if IsServer() then
		--EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
        local impact_radius = self:GetSpecialValueFor( "impact_radius" )
		local stun_duration = self:GetSpecialValueFor( "stun_duration" )
		local damage = self:GetSpecialValueFor( "damage" )
		local hCaster = self:GetCaster()
        local hAbility = self
        
		local flSpeed = self:GetSpecialValueFor( "base_swing_speed" )
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil ) + self:GetCaster():GetRightVector() * 125
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_gaoler_melee_smash_thinker", { duration = flSpeed }, vTarget, self:GetCaster():GetTeamNumber(), false )
	    
	    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_command_restricted", {duration=flSpeed})
             
        Timers:CreateTimer(flSpeed, function()
            
            if  hCaster and hCaster:IsAlive() then
                
                EmitSoundOnLocationWithCaster( vTarget, "OgreTank.GroundSmash", hCaster )
				local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  hCaster  )
				ParticleManager:SetParticleControl( nFXIndex, 0, vTarget )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( impact_radius, impact_radius, impact_radius ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

                GridNav:DestroyTreesAroundPoint(vTarget,impact_radius,false)


				local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(), vTarget, nil, impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false then
						local damageInfo = 
						{
							victim = enemy,
							attacker = hCaster,
							damage = damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = hAbility,
						}

						ApplyDamage( damageInfo )
						if enemy:IsAlive() == false then
							local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
							ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
							ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
							ParticleManager:SetParticleControlForward( nFXIndex, 1, -hCaster:GetForwardVector() )
							ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
							ParticleManager:ReleaseParticleIndex( nFXIndex )
							EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
						else
							enemy:AddNewModifier( hCaster, hAbility, "modifier_stunned", { duration = stun_duration } )
						end
					end
				end
				ScreenShake( vTarget, 10.0, 100.0, 0.5, 1300.0, 0, true )	        	
            end
	    end)

	end
	
end

-----------------------------------------------------------------------------

