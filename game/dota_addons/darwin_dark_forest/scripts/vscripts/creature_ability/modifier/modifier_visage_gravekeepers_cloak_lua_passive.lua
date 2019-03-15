modifier_visage_gravekeepers_cloak_lua_passive = modifier_visage_gravekeepers_cloak_lua_passive or class({})


function modifier_visage_gravekeepers_cloak_lua_passive:OnCreated()
	if IsServer() then
		self.recovery_time = self:GetAbility():GetSpecialValueFor("recovery_time")
		self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
		self.max_layers = self:GetAbility():GetSpecialValueFor("max_layers")
		self.minimum_damage = self:GetAbility():GetSpecialValueFor("minimum_damage")
		self:StartIntervalThink(self.recovery_time)
    end
end

function modifier_visage_gravekeepers_cloak_lua_passive:OnRefresh()
	if IsServer() then
		self.recovery_time = self:GetAbility():GetSpecialValueFor("recovery_time")
		self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
		self.max_layers = self:GetAbility():GetSpecialValueFor("max_layers")
		self.minimum_damage = self:GetAbility():GetSpecialValueFor("minimum_damage")
    end
end

function modifier_visage_gravekeepers_cloak_lua_passive:OnIntervalThink()
	if IsServer() then
		local nStacksNumber= 0
		if self:GetParent():HasModifier("modifier_visage_gravekeepers_cloak_lua_effect") then
			nStacksNumber=self:GetParent():GetModifierStackCount("modifier_visage_gravekeepers_cloak_lua_effect", self:GetParent())
		end
		if nStacksNumber<self.max_layers then
			self:SetStackCount(nStacksNumber+1)
		end
	end
end

function modifier_visage_gravekeepers_cloak_lua_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}
	return funcs
end

function modifier_visage_gravekeepers_cloak_lua_passive:GetModifierAttackSpeedBonus_Constant(params)
	return self:GetStackCount() * self.bonus_attack_speed
end

function modifier_visage_gravekeepers_cloak_lua_passive:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.bonus_movement_speed_pct
end

function modifier_visage_gravekeepers_cloak_lua_passive:GetModifierMoveSpeed_Max()
	return 5000
end

function modifier_visage_gravekeepers_cloak_lua_passive:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end
