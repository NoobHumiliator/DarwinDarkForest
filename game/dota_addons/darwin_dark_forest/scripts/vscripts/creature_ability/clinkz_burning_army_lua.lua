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

function clinkz_burning_army_lua:OnSpellStart()	
	if IsServer() then
 
		self.spawn_interval = self:GetSpecialValueFor( "spawn_interval" )
		self.count = self:GetSpecialValueFor( "count" )
       	self.range = self:GetSpecialValueFor( "range" )


		local vForwardVector =  (self:GetCaster()-self:GetCursorPosition()):Normalized()
        
        local flDistance = self.range/(self.count-1)

        local nCurrentCount=0
        Timers:CreateTimer(self.spawn_interval, function()
      
        	local vPosition = nCurrentCount*vForwardVector*flDistance+self:GetCursorPosition()
	    	local hArcher = CreateUnitByName( "npc_dota_creature_clinkz_archer", vPosition, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	        hArcher:SetOwner( self:GetCaster() )
            hArcher:SetControllableByPlayer(nil, false)
            hArcher:AddNewModifier( self:GetCaster(), self, "modifier_clinkz_burning_army_lua", {} )
		    hArcher:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor( "duration" ) } )
            FindClearSpaceForUnit( hArcher, vPosition, true )
	        nCurrentCount=nCurrentCount+1
	        if nCurrentCount==self.count then
	          return nil 
	        else
	          return self.spawn_interval
	        end
	    end)

	end
end

--------------------------------------------------------------------------------
