
modifier_item_shadow_amulet_lua = class({})

function modifier_item_shadow_amulet_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_shadow_amulet_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_shadow_amulet_lua:OnCreated( kv )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
end
-------------------------------------------
function modifier_item_shadow_amulet_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
------------------------------------------

function modifier_item_shadow_amulet_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end