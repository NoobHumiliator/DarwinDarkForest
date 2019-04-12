fury_berserk_lua = class({})
LinkLuaModifier( "modifier_fury_berserk_lua","creature_ability/modifier/modifier_fury_berserk_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function fury_berserk_lua:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_fury_berserk_lua", { duration = duration }  )
	EmitSoundOn( "DOTA_Item.MaskOfMadness.Activate", self:GetCaster() )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------