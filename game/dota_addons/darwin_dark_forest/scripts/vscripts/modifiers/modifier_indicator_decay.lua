modifier_indicator_decay = class({})

-----------------------------------------------------------------------------------
function modifier_indicator_decay:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_decay:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_indicator_decay:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_decay:IsDebuff()
	return false
end
--------------------------------------------------------------------------------

function modifier_indicator_decay:GetTexture()
	return "rune_regen"
end
--------------------------------------------------------------------------------

