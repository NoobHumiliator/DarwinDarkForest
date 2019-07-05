item_guardian_greaves_lua = class({})
LinkLuaModifier( "modifier_item_guardian_greaves_lua_aura_effect", "item_ability/modifier/modifier_item_guardian_greaves_lua_aura_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_guardian_greaves_lua_aura", "item_ability/modifier/modifier_item_guardian_greaves_lua_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_guardian_greaves_lua:GetIntrinsicModifierName()
	return "modifier_item_guardian_greaves_lua_aura"
end

--------------------------------------------------------------------------------
function item_guardian_greaves_lua:OnSpellStart()
	if IsServer() then

		-- Parameters
		local replenish_health = self:GetSpecialValueFor("replenish_health")
		local replenish_mana = self:GetSpecialValueFor("replenish_mana")
		local replenish_radius = self:GetSpecialValueFor("replenish_radius")

		-- Cast Mend
		GreavesActivate(self:GetCaster(), self, replenish_health, replenish_mana, replenish_radius)
	end
end
---------------------------------------------------------------------------------

function GreavesActivate(caster, ability, heal_amount, mana_amount, heal_radius)
	-- Purge debuffs from the caster
	caster:Purge(false, true, false, true, false)

	-- Play activation sound and particle
	caster:EmitSound("Item.GuardianGreaves.Activate")
	local cast_pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(nearby_allies) do

		ally:Heal(heal_amount, caster)
		ally:GiveMana(mana_amount)

		-- Show hp & mana overhead messages
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana_amount, nil)

		-- Play target sound
		ally:EmitSound("Item.GuardianGreaves.Target")

		-- Play target particle
		local target_pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:SetParticleControl(target_pfx, 0, ally:GetAbsOrigin())

	end
end