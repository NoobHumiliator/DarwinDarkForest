
storegga_melee_smash = class({})
LinkLuaModifier( "modifier_command_restricted", "creature_ability/modifier/modifier_command_restricted", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_melee_smash_thinker", "creature_ability/modifier/modifier_storegga_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function storegga_melee_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function storegga_melee_smash:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Storegga.Grunt", self:GetCaster() )
		local fImpactFrameAsPctOfAnim = 19 / 38
		local fSwingDuration = ( self:GetSpecialValueFor( "swing_anim_duration" ) / self:GetPlaybackRateOverride() ) * fImpactFrameAsPctOfAnim
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil )
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_command_restricted", {duration=fSwingDuration})
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_storegga_melee_smash_thinker", { duration = fSwingDuration }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------

