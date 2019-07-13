
modifier_item_diffusal_blade_lua_debuff = class({})

function modifier_item_diffusal_blade_lua_debuff:IsHidden()
	return false
end
----------------------------------------
function modifier_item_diffusal_blade_lua_debuff:IsDebuff()
	return false
end
----------------------------------------

function modifier_item_diffusal_blade_lua_debuff:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	return decFuns
end

----------------------------------------

function modifier_item_diffusal_blade_lua_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -100
end
