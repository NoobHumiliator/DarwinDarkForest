
modifier_item_robe_lua = class({})

----------------------------------------
function modifier_item_crown_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_robe_lua:GetTexture()
	return "item_robe"
end

----------------------------------------

function modifier_item_robe_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
end

----------------------------------------

function modifier_item_robe_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

----------------------------------------

function modifier_item_robe_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------

