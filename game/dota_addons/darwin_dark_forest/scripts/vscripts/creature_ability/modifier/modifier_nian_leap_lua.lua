-- Leap movement modifier
modifier_nian_leap_lua = class({})

function modifier_nian_leap_lua:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
   	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.impact_radius = self.ability:GetSpecialValueFor("impact_radius")


	if IsServer() then

		-- Variables
		self.time_elapsed = 0
		self.leap_z = 0
        
        _self=self
		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			_self.distance = (_self.caster:GetAbsOrigin() - _self.target_point):Length2D()
			_self.jump_time = 0.8
            _self.jump_speed = _self.distance/_self.jump_time
			_self.direction = (_self.target_point - _self.caster:GetAbsOrigin()):Normalized()

			_self.frametime = FrameTime()
			_self:StartIntervalThink(_self.frametime)
		end)
	end
end

function modifier_nian_leap_lua:OnIntervalThink()

	-- Vertical Motion
	self:VerticalMotion(self.caster, self.frametime)

	-- Horizontal Motion
	self:HorizontalMotion(self.caster, self.frametime)
	
end

function modifier_nian_leap_lua:IsHidden() return false end
function modifier_nian_leap_lua:IsPurgable() return false end
function modifier_nian_leap_lua:IsDebuff() return false end

function modifier_nian_leap_lua:VerticalMotion(me, dt)
	if IsServer() then

		-- Check if we're still jumping
		if self.time_elapsed < self.jump_time then

			-- Check if we should be going up or down
			if self.time_elapsed <= self.jump_time / 2 then
				-- Going up
				self.leap_z = self.leap_z + 8
				self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
			else
				-- Going down
				self.leap_z = self.leap_z - 8
				if self.leap_z > 0 then
					self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
				end

			end
		end
	end
end

function modifier_nian_leap_lua:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still jumping
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.jump_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.jump_speed * dt
			self.caster:SetAbsOrigin(new_location)
		else

            local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

            local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetParent(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}
                    EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "OgreTank.GroundSmash", self:GetParent() )
					enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
				end
			end

            GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(),self.impact_radius,false)

			self:Destroy()
			FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		end
	end
end
