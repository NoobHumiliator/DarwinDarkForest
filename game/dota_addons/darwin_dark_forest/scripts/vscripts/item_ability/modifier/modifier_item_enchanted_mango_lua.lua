
modifier_item_enchanted_mango_lua = class({})

----------------------------------------
function modifier_item_enchanted_mango_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_enchanted_mango_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------

function modifier_item_enchanted_mango_lua:OnCreated( kv )
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )
end

----------------------------------------

function modifier_item_enchanted_mango_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

----------------------------------------

function modifier_item_enchanted_mango_lua:GetModifierConstantHealthRegen( params )
	return self.hp_regen
end

----------------------------------------

