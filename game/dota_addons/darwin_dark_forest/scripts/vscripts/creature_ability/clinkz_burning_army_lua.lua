clinkz_burning_army_lua = class({})
LinkLuaModifier( "modifier_clinkz_burning_army_lua", "creature_ability/modifier/modifier_clinkz_burning_army_lua", LUA_MODIFIER_MOTION_NONE )
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
 
		local spawn_interval = self:GetSpecialValueFor( "spawn_interval" )
		local count = self:GetSpecialValueFor( "count" )
       	self.range = self:GetSpecialValueFor( "range" )


		local vForwardVector =  (self:GetCursorPosition()-self:GetCaster():GetAbsOrigin()):Normalized()
		local vCursorPosition= self:GetCursorPosition()
        
        local flDistance = self.range/(count-1)

        local nCurrentCount=0

        local hCaster = self:GetCaster()

        local hAbility = self

        Timers:CreateTimer(spawn_interval, function()
      
        	local vPosition = nCurrentCount*vForwardVector*flDistance+vCursorPosition
	    	local hArcher = CreateUnitByName( "npc_dota_creature_clinkz_archer", vPosition, true, hCaster, hCaster, hCaster:GetTeamNumber() )
	        hArcher:SetOwner( hCaster)
            --hArcher:SetControllableByPlayer(nil, false)
            hArcher:AddNewModifier(hCaster, hAbility, "modifier_clinkz_burning_army_lua", {} )
		    hArcher:AddNewModifier(hCaster, hAbility, "modifier_kill", { duration = hAbility:GetSpecialValueFor( "duration" ) } )
            FindClearSpaceForUnit( hArcher, vPosition, true )

            if hCaster:HasAbility("clinkz_searing_arrows") then
				local hAbility = hArcher:AddAbility("clinkz_searing_arrows")
				hAbility:UpgradeAbility(true)
				hArcher:SetLevel( hCaster:FindAbilityByName("clinkz_searing_arrows"):GetLevel() )
				hAbility:ToggleAutoCast()
			end

			hArcher:SetBaseDamageMax(hCaster:GetBaseDamageMax())
            hArcher:SetBaseDamageMin(hCaster:GetBaseDamageMin())
			
            ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_burning_army_start.vpcf", PATTACH_POINT_FOLLOW, hArcher)

			local nParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_burning_army.vpcf", PATTACH_POINT_FOLLOW, hArcher)
			ParticleManager:ReleaseParticleIndex(nParticleIndex)
			hArcher:EmitSound("Hero_Clinkz.Skeleton_Archer.Spawn")

	        nCurrentCount=nCurrentCount+1
	        if nCurrentCount==count then
	          return nil 
	        else
	          return spawn_interval
	        end
	    end)

	end
end

--------------------------------------------------------------------------------
