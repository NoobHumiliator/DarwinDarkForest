modifier_indicator_durable = class({})

-----------------------------------------------------------------------------------
function modifier_indicator_durable:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_durable:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_indicator_durable:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_durable:IsDebuff()
	return false
end
--------------------------------------------------------------------------------

function modifier_indicator_durable:GetTexture()
	return "rune_illusion"
end
--------------------------------------------------------------------------------

