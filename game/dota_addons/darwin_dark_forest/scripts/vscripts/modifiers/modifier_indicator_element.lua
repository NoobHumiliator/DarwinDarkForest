modifier_indicator_element = class({})

-----------------------------------------------------------------------------------
function modifier_indicator_element:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_element:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_indicator_element:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_element:IsDebuff()
	return false
end
--------------------------------------------------------------------------------

function modifier_indicator_element:GetTexture()
	return "rune_doubledamage"
end
--------------------------------------------------------------------------------

