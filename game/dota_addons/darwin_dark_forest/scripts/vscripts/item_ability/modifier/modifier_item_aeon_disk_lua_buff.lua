
modifier_item_aeon_disk_lua_buff = class({})

function modifier_item_aeon_disk_lua_buff:IsHidden()
	return false
end
----------------------------------------

function modifier_item_aeon_disk_lua_buff:IsDebuff()
	return false
end
----------------------------------------
function modifier_item_aeon_disk_lua_buff:GetStatusEffectName()
	return "particles/items4_fx/combo_breaker_buff.vpcf"
end

------------------------------------------
function modifier_item_aeon_disk_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------
function modifier_item_aeon_disk_lua_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_aeon_disk_lua_buff:OnCreated( kv )
    self.status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
end

---------------------------------------------

function modifier_item_aeon_disk_lua_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE

	}

	return funcs
end
-------------------------------------------------------------

function modifier_item_aeon_disk_lua_buff:GetModifierStatusResistanceStacking(params)
	return self.status_resistance
end

function modifier_item_aeon_disk_lua_buff:GetModifierIncomingDamage_Percentage(params)
	return -100
end