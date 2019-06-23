modifier_indicator_hunt = class({})

-----------------------------------------------------------------------------------
function modifier_indicator_hunt:IsHidden()
	return false
end
--------------------------------------------------------------------------------
function modifier_indicator_hunt:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
function modifier_indicator_hunt:IsPurgable()
	return false
end
-------------------------------------------------------------------------------

function modifier_indicator_hunt:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_indicator_hunt:GetTexture()
	return "rune_invis"
end
--------------------------------------------------------------------------------

