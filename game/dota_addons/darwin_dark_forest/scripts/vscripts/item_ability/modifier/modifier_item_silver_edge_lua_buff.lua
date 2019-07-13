
modifier_item_silver_edge_lua_buff = class({})

function modifier_item_silver_edge_lua_buff:IsHidden()
	return false
end
----------------------------------------

function modifier_item_silver_edge_lua_buff:IsDebuff()
	return false
end
----------------------------------------

function modifier_item_silver_edge_lua_buff:OnCreated()
	if IsServer() then
       self.windwalk_movement_speed= self:GetAbility():GetSpecialValueFor("windwalk_movement_speed")
       self.windwalk_bonus_damage= self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage")
	end
end



----------------------------------------
function modifier_item_silver_edge_lua_buff:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,

		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,

	}
	return funcs
end

function modifier_item_silver_edge_lua_buff:GetModifierMoveSpeedBonus_Percentage() 
	return self.windwalk_movement_speed 
end

function modifier_item_silver_edge_lua_buff:OnAbilityExecuted( keys )
	if IsServer() then
		if keys.unit == self:GetParent() then
			self:Destroy()
		end
	end
end

function modifier_item_silver_edge_lua_buff:GetModifierPreAttack_BonusDamagePostCrit(params)

	return self.windwalk_bonus_damage

end


function modifier_item_silver_edge_lua_buff:CheckState()
	local state =   {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end

function modifier_item_silver_edge_lua_buff:GetModifierInvisibilityLevel()
	return 1
end


function modifier_item_silver_edge_lua_buff:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then

			local ability  = self:GetAbility()
			local backstab_duration = self:GetAbility():GetSpecialValueFor("backstab_duration")

			params.target:AddNewModifier(params.attacker, ability, "modifier_item_silver_edge_lua_debuff", {duration = backstab_duration})

			self:Destroy()
		end
	end
end
