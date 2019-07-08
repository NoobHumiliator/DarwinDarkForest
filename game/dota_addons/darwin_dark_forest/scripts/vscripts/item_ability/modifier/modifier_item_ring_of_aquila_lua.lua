
modifier_item_ring_of_aquila_lua = class({})

function modifier_item_ring_of_aquila_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_ring_of_aquila_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_ring_of_aquila_lua:IsAura()
	return true
end
----------------------------------------

function modifier_item_ring_of_aquila_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )
    self.aura_radius=self:GetAbility():GetSpecialValueFor( "aura_radius" )

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------


function modifier_item_ring_of_aquila_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_ring_of_aquila_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

----------------------------------------

function modifier_item_ring_of_aquila_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_ring_of_aquila_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_ring_of_aquila_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
----------------------------------------

function modifier_item_ring_of_aquila_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

----------------------------------------
function modifier_item_ring_of_aquila_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_ring_of_aquila_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end
-------------------------------------------
function modifier_item_ring_of_aquila_lua:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_ring_of_aquila_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end

function modifier_item_ring_of_aquila_lua:GetModifierAura()
	return  "modifier_item_ring_of_aquila_lua_effect"
end

----------------------------------------

function modifier_item_ring_of_aquila_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

----------------------------------------

function modifier_item_ring_of_aquila_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_item_ring_of_aquila_lua:GetAuraRadius()
	return self.radius
end

----------------------------------------