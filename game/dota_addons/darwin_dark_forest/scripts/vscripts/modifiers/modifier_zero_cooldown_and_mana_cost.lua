modifier_zero_cooldown_and_mana_cost = class({})


-----------------------------------------------------------------------------------
function modifier_zero_cooldown_and_mana_cost:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_zero_cooldown_and_mana_cost:IsPermanent()
	return false
end
--------------------------------------------------------------------------------
function modifier_zero_cooldown_and_mana_cost:IsPurgable()
	return false
end
--------------------------------------------------------------------------------


function modifier_zero_cooldown_and_mana_cost:DeclareFunctions()

	local funcs = {

		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE

	}
	return funcs

end
----------------------------------------------------------------

function modifier_zero_cooldown_and_mana_cost:GetModifierPercentageManacost()
	return 1
end

function modifier_zero_cooldown_and_mana_cost:GetModifierCooldownReduction_Constant()
	return 99
end