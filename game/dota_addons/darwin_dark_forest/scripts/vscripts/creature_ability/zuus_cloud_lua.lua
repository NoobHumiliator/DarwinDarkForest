zuus_cloud_lua = class({})
LinkLuaModifier( "modifier_zuus_cloud_lua", "creature_ability/modifier/modifier_zuus_cloud_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function zuus_cloud_lua:OnAbilityPhaseStart()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true );
		EmitSoundOn( "Hero_Zuus.GodsWrath.PreCast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function zuus_cloud_lua:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, true )
	end
end

--------------------------------------------------------------------------------

function zuus_cloud_lua:OnSpellStart()	
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( self.nFXIndex )

		local vStartPosition = self:GetCursorPosition() + Vector( 0, 0, 4000.0 )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		EmitSoundOn( "Hero_Zuus.LightningBolt.Cloud" , self:GetCaster() )

		local radius = self:GetSpecialValueFor( "radius" )

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
