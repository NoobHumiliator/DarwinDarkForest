durable_damage_return_lua = class({})
LinkLuaModifier( "modifier_durable_damage_return_lua","creature_ability/modifier/modifier_durable_damage_return_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function durable_damage_return_lua:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_durable_damage_return_lua", { duration = duration }  )
	EmitSoundOn( "Hero_NyxAssassin.SpikedCarapace", self:GetCaster() )
end

--------------------------------------------------------------------------------