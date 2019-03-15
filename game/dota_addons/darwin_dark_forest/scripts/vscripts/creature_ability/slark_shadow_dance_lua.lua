slark_shadow_dance_lua = class({})
LinkLuaModifier( "modifier_slark_shadow_dance_lua_invisible","creature_ability/modifier/modifier_slark_shadow_dance_lua_invisible", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
--[[
function slark_shadow_dance_lua:GetIntrinsicModifierName()
	return "modifier_slark_shadow_dance_lua_passive"
end
]]
--------------------------------------------------------------------------------

function slark_shadow_dance_lua:OnSpellStart()
	if IsServer() then
		local duration = self:GetSpecialValueFor( "duration" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_slark_shadow_dance_lua_invisible", { duration = duration }  )
		EmitSoundOn( "Hero_Slark.ShadowDance", self:GetCaster() )
	end
end
--------------------------------------------------------------------------------

