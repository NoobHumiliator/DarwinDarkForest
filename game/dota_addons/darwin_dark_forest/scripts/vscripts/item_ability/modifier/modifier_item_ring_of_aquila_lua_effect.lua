
modifier_item_ring_of_aquila_lua_effect = class({})

function modifier_item_ring_of_aquila_lua_effect:IsHidden()
	return false
end
----------------------------------------
function modifier_item_ring_of_aquila_lua_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------
function modifier_item_ring_of_aquila_lua_effect:GetTexture()
	return "item_ring_of_aquila"
end

----------------------------------------

function modifier_item_ring_of_aquila_lua_effect:OnCreated( kv )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "aura_mana_regen" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "aura_bonus_armor" )
end

---------------------------------------------

function modifier_item_ring_of_aquila_lua_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

	}

	return funcs
end


function modifier_item_ring_of_aquila_lua_effect:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

-------------------------------------------
function modifier_item_ring_of_aquila_lua_effect:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
