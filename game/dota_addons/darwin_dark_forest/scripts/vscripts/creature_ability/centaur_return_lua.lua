
centaur_return_lua = class({})

LinkLuaModifier( "modifier_centaur_return_lua_passive", "creature_ability/modifier/modifier_centaur_return_lua_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_lua_stack", "creature_ability/modifier/modifier_centaur_return_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_lua_buff", "creature_ability/modifier/modifier_centaur_return_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function centaur_return_lua:GetIntrinsicModifierName()
	return "modifier_centaur_return_lua_passive"
end

--------------------------------------------------------------------------------

function centaur_return_lua:OnSpellStart()

	if IsServer() then
       if self:GetCaster():HasModifier("modifier_centaur_return_lua_stack") then
          local flDuration = self:GetSpecialValueFor("damage_gain_duration")
          self:GetCaster():EmitSound("Hero_Centaur.Retaliate.Cast")
          self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_centaur_return_lua_buff", {duration=flDuration} )
       end
    end

end

--------------------------------------------------------------------------------

