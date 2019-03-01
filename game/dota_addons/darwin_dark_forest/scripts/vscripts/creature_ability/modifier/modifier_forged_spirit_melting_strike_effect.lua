modifier_forged_spirit_melting_strike_effect = class({})
--------------------------------------------------------------------------------

function modifier_forged_spirit_melting_strike_effect:IsHidden()
	return false
end
-------------------------------------------------------------------------------
function modifier_forged_spirit_melting_strike_effect:GetTexture()
	return "forged_spirit_melting_strike"
end

--------------------------------------------------------------------------------

function modifier_forged_spirit_melting_strike_effect:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end


function modifier_forged_spirit_melting_strike_effect:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
	    return self:GetStackCount() * -1 * self:GetAbility():GetSpecialValueFor( "armor_removed" )
	else
		self:Destroy()
	end
end
