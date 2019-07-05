modifier_item_guardian_greaves_lua_aura = class({})

--------------------------------------------------------------------------------

function modifier_item_guardian_greaves_lua_aura:IsHidden() 
	return true
end

--------------------------------------------------------------------------------
function modifier_item_guardian_greaves_lua_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_item_guardian_greaves_lua_aura:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:IsAura()
	return true
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:GetModifierAura()
	return  "modifier_item_guardian_greaves_lua_aura_effect"
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:GetAuraRadius()
	return self.aura_radius
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )

	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end

end

----------------------------------------


function modifier_item_guardian_greaves_lua_aura:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_guardian_greaves_lua_aura:DeclareFunctions()
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

function modifier_item_guardian_greaves_lua_aura:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_guardian_greaves_lua_aura:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_guardian_greaves_lua_aura:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
----------------------------------------

function modifier_item_guardian_greaves_lua_aura:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

----------------------------------------
function modifier_item_guardian_greaves_lua_aura:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_guardian_greaves_lua_aura:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end
-------------------------------------------
function modifier_item_guardian_greaves_lua_aura:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_guardian_greaves_lua_aura:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end