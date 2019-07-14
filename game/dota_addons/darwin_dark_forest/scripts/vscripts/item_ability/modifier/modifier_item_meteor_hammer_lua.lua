
modifier_item_meteor_hammer_lua = class({})

function modifier_item_meteor_hammer_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_meteor_hammer_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_meteor_hammer_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------


function modifier_item_meteor_hammer_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_meteor_hammer_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

----------------------------------------

function modifier_item_meteor_hammer_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_meteor_hammer_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_meteor_hammer_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

----------------------------------------
function modifier_item_meteor_hammer_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_meteor_hammer_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end
-------------------------------------------