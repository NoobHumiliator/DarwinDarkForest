
modifier_item_satanic_lua_buff = class({})

function modifier_item_satanic_lua_buff:IsHidden()
	return false
end
----------------------------------------

function modifier_item_satanic_lua_buff:IsDebuff()
	return false
end
----------------------------------------

function modifier_item_satanic_lua_buff:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

----------------------------------------

function modifier_item_satanic_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
----------------------------------------

function modifier_item_satanic_lua_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_item_satanic_lua_buff:OnAttackLanded( keys )
	if IsServer() then

		local parent = self:GetParent()
		local attacker = keys.attacker

		if parent ~= attacker then
			return end

		local target = keys.target

		local damage = keys.damage

		local flArmor = target:GetPhysicalArmorValue(false)

        local heal = damage * self:GetAbility():GetSpecialValueFor("unholy_lifesteal_percent") * 0.01 * (1 - ((0.052 * flArmor) / (0.9 + 0.048 * math.abs(flArmor) ) ))

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