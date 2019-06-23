modifier_indicator_fury = class({})

-----------------------------------------------------------------------------------
function modifier_indicator_fury:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_fury:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_indicator_fury:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_fury:IsDebuff()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_fury:GetTexture()
	return "rune_haste"
end
--------------------------------------------------------------------------------

