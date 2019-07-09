modifier_item_guardian_shell = class({})

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:IsHidden() 
	return true
end
-------------------------------------------------------------------------------
function modifier_item_guardian_shell:OnCreated( kv )

	if IsServer() then
         self:GetParent():RemoveModifierByName("modifier_dark_seer_surge")
		 self.flMoveSpeed = self:GetParent():GetIdealSpeedNoSlows()
    end
end
--------------------------------------------------------------------------------
function modifier_item_guardian_shell:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_item_guardian_shell:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_item_guardian_shell:CheckState()
	local state = 
	{
		[MODIFIER_STATE_ROOTED] = false,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

----------------------------------------

function modifier_item_guardian_shell:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

----------------------------------------

function modifier_item_guardian_shell:GetModifierMagicalResistanceBonus( params )
	return self:GetAbility():GetSpecialValueFor( "magic_resistance" )
end

----------------------------------------

function modifier_item_guardian_shell:GetModifierMoveSpeed_AbsoluteMin( params )
	return self.flMoveSpeed
end