creature_ogre_melee_smash = class({})
LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "creature_ability/modifier/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function creature_ogre_melee_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function creature_ogre_melee_smash:GetCooldown( iLevel )
	return self.BaseClass.GetCooldown( self, self:GetLevel() ) / self:GetCaster():GetHasteFactor() 
end

-----------------------------------------------------------------------------

function creature_ogre_melee_smash:GetPlaybackRateOverride()
	return math.min( 2.0, math.max( self:GetCaster():GetHasteFactor(), 1.0 ) )
end

-----------------------------------------------------------------------------

function creature_ogre_melee_smash:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
		local flSpeed = self:GetSpecialValueFor( "base_swing_speed" ) / self:GetPlaybackRateOverride()
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCursorPosition()
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_tank_melee_smash_thinker", { duration = flSpeed }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------

