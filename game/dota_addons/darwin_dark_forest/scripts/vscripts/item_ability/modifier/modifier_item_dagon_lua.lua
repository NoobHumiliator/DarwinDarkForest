
modifier_item_dagon_lua = class({})

----------------------------------------
function modifier_item_dagon_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_dagon_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_item_dagon_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
    self.mana_regen_bonus = self:GetAbility():GetSpecialValueFor( "mana_regen_bonus" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
------------------------------------------
function modifier_item_dagon_lua:OnDestroy()
	 if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
------------------------------------------

function modifier_item_dagon_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

----------------------------------------

function modifier_item_dagon_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_dagon_lua:GetModifierConstantManaRegen( params )
	return self.mana_regen_bonus
end

----------------------------------------


function modifier_item_dagon_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_dagon_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

----------------------------------------




