lycan_boss_claw_attack = class({})
LinkLuaModifier( "modifier_lycan_boss_claw_attack", "creature_ability/modifier/modifier_lycan_boss_claw_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )
		self.shapeshift_animation_time = self:GetSpecialValueFor( "shapeshift_animation_time" )
		self.shapeshift_initial_delay = self:GetSpecialValueFor( "shapeshift_initial_delay" )

		
		local bShapeshift = true

		local kv = {}
		if bShapeshift then
			kv["duration"] = self.shapeshift_animation_time
			kv["initial_delay"] = self.shapeshift_initial_delay
		else
			kv["duration"] = self.animation_time
			kv["initial_delay"] = self.initial_delay
		end
	
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_lycan_boss_claw_attack", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_lycan_boss_claw_attack" )
	end
end

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_lycan_boss_claw_attack" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 

--------------------------------------------------------------------------------