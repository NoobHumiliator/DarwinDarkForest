
modifier_item_kaya_lua = class({})

----------------------------------------
function modifier_item_kaya_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_kaya_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
----------------------------------------

function modifier_item_kaya_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
    self.mana_regen_bonus = self:GetAbility():GetSpecialValueFor( "mana_regen_bonus" )
    self.manacost_reduction = self:GetAbility():GetSpecialValueFor( "manacost_reduction" )

end

----------------------------------------

function modifier_item_kaya_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
	}

	return funcs
end

----------------------------------------

function modifier_item_kaya_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_kaya_lua:GetModifierConstantManaRegen( params )
	return self.mana_regen_bonus
end

----------------------------------------


function modifier_item_kaya_lua:GetModifierPercentageManacost( params )
	return self.manacost_reduction
end

----------------------------------------

