frostbitten_icicle = class({})
LinkLuaModifier( "modifier_frostbitten_icicle", "creature_ability/modifier/modifier_frostbitten_icicle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostbitten_icicle_thinker", "creature_ability/modifier/modifier_frostbitten_icicle_thinker", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------

function frostbitten_icicle:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function frostbitten_icicle:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Tusk.IceShards.Projectile", self:GetCaster() )
		CreateModifierThinker( self:GetCaster(), self, "modifier_frostbitten_icicle_thinker", {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
	end
end

------------------------------------------------------------------
