modifier_item_hurricane_pike_lua_buff = modifier_item_hurricane_pike_lua_buff or class({})

function modifier_item_hurricane_pike_lua_buff:IsDebuff() return false end
function modifier_item_hurricane_pike_lua_buff:IsHidden() return false end
function modifier_item_hurricane_pike_lua_buff:IsPurgable() return true end


function modifier_item_hurricane_pike_lua_buff:DeclareFunctions()
	local decFuncs =   {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		                MODIFIER_EVENT_ON_ATTACK,
		                MODIFIER_EVENT_ON_ORDER,
		                MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
		               }
	return decFuncs
end


function modifier_item_hurricane_pike_lua_buff:GetModifierAttackSpeedBonus_Constant()
	if not IsServer() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed_effect")
end

function modifier_item_hurricane_pike_lua_buff:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return 999999
end

function modifier_item_hurricane_pike_lua_buff:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
			if self:GetStackCount()==0 then
				self:Destroy()
			end
		else
			self:Destroy()
		end
	end
end


function modifier_item_hurricane_pike_lua_buff:OnOrder( keys )
	if not IsServer() then return end
	
	if keys.order_type == 4 and keys.unit == self:GetParent() then

		if keys.target ~= self.target then
             self:Destroy()
		end
		
	end
end