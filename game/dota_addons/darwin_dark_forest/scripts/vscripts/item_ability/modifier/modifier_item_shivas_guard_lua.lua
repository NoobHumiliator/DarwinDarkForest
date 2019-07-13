
modifier_item_shivas_guard_lua = class({})

function modifier_item_shivas_guard_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_shivas_guard_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_shivas_guard_lua:IsAura()
	return true
end
----------------------------------------

function modifier_item_shivas_guard_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end
-------------------------------------------


function modifier_item_shivas_guard_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

----------------------------------------

function modifier_item_shivas_guard_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------

function modifier_item_shivas_guard_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end
----------------------------------------

function modifier_item_shivas_guard_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
------------------------------------------
function modifier_item_shivas_guard_lua:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
------------------------------------------
function modifier_item_shivas_guard_lua:GetModifierAura()
	return  "modifier_item_shivas_guard_lua_debuff"
end

----------------------------------------

function modifier_item_shivas_guard_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

----------------------------------------

function modifier_item_shivas_guard_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_item_shivas_guard_lua:GetAuraRadius()
	return self.aura_radius
end

----------------------------------------