modifier_hunt_thirst_lua_passive = modifier_hunt_thirst_lua_passive or class({})

function modifier_hunt_thirst_lua_passive:IsHidden()
	return true
end

function modifier_hunt_thirst_lua_passive:OnCreated()
	self.speed_bonus_threshold = self:GetAbility():GetSpecialValueFor("speed_bonus_threshold")
	self.vision_bonus_threshold = self:GetAbility():GetSpecialValueFor("vision_bonus_threshold")
	self.bonus_movement_speed_pct = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_pct") / self.speed_bonus_threshold
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") / self.speed_bonus_threshold
	self:StartIntervalThink(0.1)
end

function modifier_hunt_thirst_lua_passive:OnRefresh()
	self.speed_bonus_threshold = self:GetAbility():GetSpecialValueFor("speed_bonus_threshold")
	self.vision_bonus_threshold = self:GetAbility():GetSpecialValueFor("vision_bonus_threshold")
	self.bonus_movement_speed_pct = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_pct") / self.speed_bonus_threshold
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") / self.speed_bonus_threshold
end

function modifier_hunt_thirst_lua_passive:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS  + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
		local hpTotalDeficit = 0
		for _,enemy in pairs(enemies) do
			if self:GetCaster():PassivesDisabled() or not self:GetCaster():IsAlive() then
				enemy:RemoveModifierByName("modifier_hunt_thirst_lua_provide_vision")
			else
				if enemy:IsAlive() and self:GetParent():GetTeamNumber()~=enemy:GetTeamNumber()  then
					-- 先处理速度
					if enemy:GetHealthPercent() < self.speed_bonus_threshold then
						local enemyHp = (self.speed_bonus_threshold - enemy:GetHealthPercent())					
						hpTotalDeficit = hpTotalDeficit + enemyHp
					end
					-- 再处理视野
					if enemy:GetHealthPercent() < self.vision_bonus_threshold then
                       enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hunt_thirst_lua_provide_vision", {})
					else
					   enemy:RemoveModifierByName("modifier_hunt_thirst_lua_provide_vision")
					end
				end
			end
		end
		self:SetStackCount(hpTotalDeficit)
	end
end

function modifier_hunt_thirst_lua_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}
	return funcs
end

function modifier_hunt_thirst_lua_passive:GetModifierAttackSpeedBonus_Constant(params)
	return self:GetStackCount() * self.bonus_attack_speed
end

function modifier_hunt_thirst_lua_passive:GetModifierMoveSpeedBonus_Percentage(params)
	return self:GetStackCount() * self.bonus_movement_speed_pct
end

function modifier_hunt_thirst_lua_passive:GetModifierMoveSpeed_Max()
	return 5000
end

function modifier_hunt_thirst_lua_passive:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end
