item_shadow_amulet_lua = class({})
LinkLuaModifier( "modifier_item_shadow_amulet_lua", "item_ability/modifier/modifier_item_shadow_amulet_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_shadow_amulet_lua_effect", "item_ability/modifier/modifier_item_shadow_amulet_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_shadow_amulet_lua:GetIntrinsicModifierName()
	return "modifier_item_shadow_amulet_lua"
end

--------------------------------------------------------------------------------

function item_shadow_amulet_lua:OnSpellStart()

	local caster    =   self:GetCaster()
	local duration  =   self:GetSpecialValueFor("invis_duration")
	local fade_time =   self:GetSpecialValueFor("fade_time")

	EmitSoundOn("DOTA_Item.ShadowAmulet.Activate", caster)

	Timers:CreateTimer(fade_time, function()

		local particle_invis_start_fx = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)
		caster:AddNewModifier(caster, self, "modifier_item_shadow_amulet_lua_effect", {duration = duration})
	end)
end
