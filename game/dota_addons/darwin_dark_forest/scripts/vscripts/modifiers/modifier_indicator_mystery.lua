modifier_indicator_mystery = class({})

-----------------------------------------------------------------------------------
function modifier_indicator_mystery:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_mystery:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_indicator_mystery:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_mystery:IsDebuff()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_mystery:GetTexture()
	return "rune_arcane"
end
--------------------------------------------------------------------------------

