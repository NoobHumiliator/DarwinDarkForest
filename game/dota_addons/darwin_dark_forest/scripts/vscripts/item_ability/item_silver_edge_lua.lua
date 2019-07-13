item_silver_edge_lua = class({})
LinkLuaModifier( "modifier_item_silver_edge_lua", "item_ability/modifier/modifier_item_silver_edge_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_silver_edge_lua_buff", "item_ability/modifier/modifier_item_silver_edge_lua_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_silver_edge_lua_debuff", "item_ability/modifier/modifier_item_silver_edge_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_silver_edge_lua:GetIntrinsicModifierName()
	return "modifier_item_silver_edge_lua"
end

--------------------------------------------------------------------------------

function item_silver_edge_lua:OnSpellStart()

	local hCaster    =   self:GetCaster()
	local windwalk_duration  =   self:GetSpecialValueFor("windwalk_duration")
	local windwalk_fade_time =   self:GetSpecialValueFor("windwalk_fade_time")

	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", hCaster)

	Timers:CreateTimer(windwalk_fade_time, function()
		local nParticle = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(nParticle, 0, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(nParticle)

		hCaster:AddNewModifier(hCaster, self, "modifier_item_silver_edge_lua_buff", {duration = windwalk_duration})
	end)
end

