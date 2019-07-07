
modifier_item_solar_crest_lua_self_debuff = class({})

---------------------------------------
function modifier_item_solar_crest_lua_self_debuff:IsHidden()
	return true
end

function modifier_item_solar_crest_lua_self_debuff:IsDebuff()
	return true
end

function modifier_item_solar_crest_lua_self_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

----------------------------------------
function modifier_item_solar_crest_lua_self_debuff:GetEffectName()
	return "particles/items2_fx/medallion_of_courage.vpcf" 
end
----------------------------------------
function modifier_item_solar_crest_lua_self_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end
-------------------------------------------

function modifier_item_solar_crest_lua_self_debuff:GetModifierPhysicalArmorBonus( params )
	return -self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end
