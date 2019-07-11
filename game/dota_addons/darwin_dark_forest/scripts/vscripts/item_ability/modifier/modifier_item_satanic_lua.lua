
modifier_item_satanic_lua = class({})

function modifier_item_satanic_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_satanic_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_satanic_lua:OnCreated( kv )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
    self.status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------
function modifier_item_satanic_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end
------------------------------------------
function modifier_item_satanic_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_satanic_lua:GetModifierPreAttack_BonusDamage(kv)
	return self.bonus_damage
end

-------------------------------------------
function modifier_item_satanic_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_satanic_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end

----------------------------------------------

function modifier_item_satanic_lua:GetModifierStatusResistanceStacking(params)
	return self.status_resistance
end


function modifier_item_satanic_lua:OnAttackLanded( keys )
	if IsServer() then

		local parent = self:GetParent()
		local attacker = keys.attacker

		if parent ~= attacker then
			return end

		local target = keys.target

		local damage = keys.damage
		local flArmor = target:GetPhysicalArmorValue(false)
		local heal = damage * self:GetAbility():GetSpecialValueFor("lifesteal_percent") * 0.01 * (1 - ((0.052 * flArmor) / (0.9 + 0.048 * math.abs(flArmor) ) ))

		if attacker:IsIllusion()  then
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		else
			attacker:Heal(heal, attacker)
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		end
	end
end