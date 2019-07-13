
modifier_item_diffusal_blade_lua = class({})

function modifier_item_diffusal_blade_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_diffusal_blade_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_diffusal_blade_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )

end
---------------------------------------------

function modifier_item_diffusal_blade_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}

	return funcs
end

----------------------------------------

function modifier_item_diffusal_blade_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------
function modifier_item_diffusal_blade_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
----------------------------------------

function modifier_item_diffusal_blade_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
----------------------------------------

function modifier_item_diffusal_blade_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end
-------------------------------------------
function modifier_item_diffusal_blade_lua:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_diffusal_blade_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end

-------------------------------------------
function modifier_item_diffusal_blade_lua:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then

        local hAttacker = keys.attacker
		local hTarget = keys.target

		if hAttacker == self:GetParent() then

			if hTarget:GetMaxMana() == 0 then
				return nil
			end

			if hTarget:IsMagicImmune() then
				return nil
			end

			local nParticle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:SetParticleControl(nParticle, 0, hTarget:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(nParticle)

			local flManaBurn = 0
			if hAttacker:IsIllusion() then
				if hAttacker:GetAttackCapability()==DOTA_UNIT_CAP_MELEE_ATTACK then
				  flManaBurn = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_melee")
				end
                if hAttacker:GetAttackCapability()==DOTA_UNIT_CAP_RANGED_ATTACK then
				  flManaBurn = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
				end
			else
				flManaBurn = self:GetAbility():GetSpecialValueFor("feedback_mana_burn")
			end

			local flTargetMana = hTarget:GetMana()

			-- Burn mana
			hTarget:ReduceMana(flManaBurn)
			local flDamage = flManaBurn * self:GetAbility():GetSpecialValueFor("damage_per_burn")

			return flDamage
		end
      
	end
end


