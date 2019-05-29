
modifier_item_power_treads_lua = class({})

function modifier_item_power_treads_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_power_treads_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_power_treads_lua:OnCreated( kv )
    self.bonus_movement_speed_passive = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed_passive" )
    self.bonus_attack_speed_passive = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_passive" )
    
    --默认力量假腿
    if IsServer() then
       self:GetAbility().nState=0
       self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_power_treads_lua_0", {})
    end
end
-------------------------------------------
function modifier_item_power_treads_lua:OnRemoved( kv )
	if IsServer() then
	    for i = 0,2 do
	        self:GetParent():RemoveModifierByName("modifier_item_power_treads_lua_"..i)
	    end
    end
end
-------------------------------------------
function modifier_item_power_treads_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE
	}

	return funcs
end

------------------------

function modifier_item_power_treads_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_movement_speed_passive
end
-------------------------------------------
function modifier_item_power_treads_lua:GetModifierMoveSpeedBonus_Percentage_Unique( params )
	return self.bonus_attack_speed_passive
end