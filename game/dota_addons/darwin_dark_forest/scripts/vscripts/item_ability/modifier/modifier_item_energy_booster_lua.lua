
modifier_item_energy_booster_lua = class({})

function modifier_item_energy_booster_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_energy_booster_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------


function modifier_item_energy_booster_lua:OnCreated( kv )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
end
-------------------------------------------
function modifier_item_energy_booster_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
------------------------------------------

function modifier_item_energy_booster_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end