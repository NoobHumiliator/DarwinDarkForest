modifier_bounty_hunter_track_lua_debuff = modifier_bounty_hunter_track_lua_debuff or class({})




function modifier_bounty_hunter_track_lua_debuff:OnCreated()
    
	-- Add overhead particle only for the caster's team
	self.nParticleShieldIndex = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl(self.nParticleShieldIndex, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.nParticleShieldIndex, false, false, -1, false, true)

	-- Add the track particle only for the caster's team
	self.nParticleTrailIndex = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl(self.nParticleTrailIndex, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.nParticleTrailIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.nParticleTrailIndex, 8, Vector(1,0,0))
	self:AddParticle(self.nParticleTrailIndex, false, false, -1, false, false)
	self:StartIntervalThink(0.2)
end

function modifier_bounty_hunter_track_lua_debuff:OnIntervalThink()
     if IsServer() then
		 if self and self.GetCaster and self:GetCaster() and self:GetCaster():IsAlive() and ( not self:GetCaster():IsNull() ) then
	        AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), 1000, 0.2, true)
	     end
     end
end


function modifier_bounty_hunter_track_lua_debuff:IsAura()
	return true
end

function modifier_bounty_hunter_track_lua_debuff:GetModifierAura()
	return "modifier_bounty_hunter_track_lua_speed"
end

function modifier_bounty_hunter_track_lua_debuff:GetAuraRadius()
	return 900
end

function modifier_bounty_hunter_track_lua_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end


function modifier_bounty_hunter_track_lua_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end


function modifier_bounty_hunter_track_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
	return state
end

function modifier_bounty_hunter_track_lua_debuff:DeclareFunctions()
	local funcs = 
	{
         MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end


function modifier_bounty_hunter_track_lua_debuff:GetModifierProvidesFOWVision()
	
	return 1
end
