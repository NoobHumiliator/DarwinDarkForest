nian_pin_lua = class({})
LinkLuaModifier( "modifier_nian_pin_lua", "creature_ability/modifier/modifier_nian_pin_lua", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function nian_pin_lua:GetChannelTime()
	self.duration = self:GetSpecialValueFor( "duration" )

	return self.duration
end

--------------------------------------------------------------------------------

function nian_pin_lua:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function nian_pin_lua:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_nian_pin_lua", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function nian_pin_lua:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_nian_pin_lua" )
	end
end

--------------------------------------------------------------------------------
function nian_pin_lua:GetChannelAnimation( params )
	return ACT_DOTA_NIAN_PIN_LOOP
end

--------------------------------------------------------------------------------