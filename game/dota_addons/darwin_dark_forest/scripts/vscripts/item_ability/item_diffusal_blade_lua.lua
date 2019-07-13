item_diffusal_blade_lua = class({})
LinkLuaModifier( "modifier_item_diffusal_blade_lua", "item_ability/modifier/modifier_item_diffusal_blade_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_diffusal_blade_lua_debuff", "item_ability/modifier/modifier_item_diffusal_blade_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_diffusal_blade_lua:GetIntrinsicModifierName()
	return "modifier_item_diffusal_blade_lua"
end

--------------------------------------------------------------------------------

function item_diffusal_blade_lua:OnSpellStart()
	-- Ability properties
	local hCaster = self:GetCaster()

	local hTarget = self:GetCursorTarget()

	local particle_target = "particles/generic_gameplay/generic_manaburn.vpcf"
	local modifier_purge = "modifier_item_imba_diffusal_slow"
	local modifier_root = "modifier_item_imba_diffusal_root"

	local purge_slow_duration = ability:GetSpecialValueFor("purge_slow_duration")

	EmitSoundOn("DOTA_Item.DiffusalBlade.Activate", hCaster)

	local nParticle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(nParticle, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(nParticle)

	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	-- Play target sound
	EmitSoundOn("DOTA_Item.DiffusalBlade.Target", hTarget)

	hTarget:AddNewModifier(hCaster, self, "modifier_item_diffusal_blade_lua_debuff", {duration = purge_slow_duration})

end

