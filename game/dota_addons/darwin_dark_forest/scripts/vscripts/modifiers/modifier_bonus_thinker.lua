modifier_bonus_thinker = class({})



function modifier_bonus_thinker:GetTexture()
	return "dazzle_bad_juju"
end

-----------------------------------------------------------------------------------
function modifier_bonus_thinker:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_bonus_thinker:IsPermanent()
	return false
end
--------------------------------------------------------------------------------
function modifier_bonus_thinker:IsPurgable()
	return false
end
--------------------------------------------------------------------------------


function modifier_bonus_thinker:DeclareFunctions()

	local funcs = {

		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE

	}
	return funcs

end
----------------------------------------------------------------

function modifier_bonus_thinker:GetModifierPercentageManacost()
	return 100
end

function modifier_bonus_thinker:GetModifierCooldownReduction_Constant()
	return 100
end