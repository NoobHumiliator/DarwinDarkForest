
decay_tombstone = class({})
LinkLuaModifier( "modifier_decay_tombstone", "creature_ability/modifier/modifier_decay_tombstone", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function decay_tombstone:ProcsMagicStick()
	return false
end
--------------------------------------------------------------------------------

function decay_tombstone:OnSpellStart()
	if IsServer() then

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local hTombstone = CreateUnitByName( "npc_dota_creature_tombstone", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hTombstone ~= nil then

			local flDuration = self:GetSpecialValueFor( "tomb_duration" )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_decay_tombstone", { duration = flDuration } )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = flDuration } )
            hTombstone.nPlayerId=self:GetCaster():GetMainControllingPlayer()


			local nTombstoneFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nTombstoneFX, 0, self:GetCursorPosition() )	
			ParticleManager:SetParticleControlEnt( nTombstoneFX, 1, self:GetCaster(), flDuration, "attach_attack1", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( nTombstoneFX, 2, Vector( flDuration, flDuration, duration ) )
			ParticleManager:ReleaseParticleIndex( nTombstoneFX )

			EmitSoundOn( "Hero_Undying.Tombstone", hTombstone )
		end
	end
end

--------------------------------------------------------------------------------
