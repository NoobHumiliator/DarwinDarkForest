clinkz_burning_army_lua = class({})
LinkLuaModifier( "modifier_zuus_cloud_lua", "creature_ability/modifier/modifier_zuus_cloud_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function clinkz_burning_army_lua:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_Clinkz.DeathPact.Cast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function zuus_cloud_lua:OnSpellStart()	
	if IsServer() then
 
        local nCount=0
		self.spawn_interval = self:GetSpecialValueFor( "spawn_interval" )
		self.count = self:GetSpecialValueFor( "count" )


        Timers:CreateTimer(self.spawn_interval, function()
      
        	nCount=nCount+1
	    	local hArcher = CreateUnitByName( "npc_dota_creature_clinkz_archer", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	        
	        if nCount==self.count then
	          return nil 
	        else
	          return self.spawn_interval
	        end

	    end)

		local hCloud = CreateUnitByName( "npc_dota_zeus_cloud", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		
		local nParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCloud)
		ParticleManager:SetParticleControl(nParticle, 0, Vector(self:GetCursorPosition().x, self:GetCursorPosition().y, 450))
		ParticleManager:SetParticleControl(nParticle, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(nParticle, 2, Vector(self:GetCursorPosition().x, self:GetCursorPosition().y, self:GetCursorPosition().z + 450))	


		hCloud:SetOwner( self:GetCaster() )
		hCloud:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
		hCloud:AddNewModifier( self:GetCaster(), self, "modifier_zuus_cloud_lua", {} )
		hCloud:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor( "cloud_duration" ) } )
		FindClearSpaceForUnit( hCloud, self:GetCursorPosition(), true )
	end
end

--------------------------------------------------------------------------------
