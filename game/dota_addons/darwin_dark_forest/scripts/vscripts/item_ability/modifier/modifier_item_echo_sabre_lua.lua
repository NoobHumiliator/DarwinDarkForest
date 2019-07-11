
modifier_item_echo_sabre_lua = class({})

function modifier_item_echo_sabre_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_echo_sabre_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_echo_sabre_lua:OnCreated( kv )
	self.spell_amplify = self:GetAbility():GetSpecialValueFor( "spell_amplify" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
  	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
    self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------


function modifier_item_echo_sabre_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_echo_sabre_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

----------------------------------------

function modifier_item_echo_sabre_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amplify
end

----------------------------------------


function modifier_item_echo_sabre_lua:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

----------------------------------------

function modifier_item_echo_sabre_lua:GetModifierConstantManaRegen( params )
	return self.bonus_mana_regen
end

----------------------------------------
function modifier_item_echo_sabre_lua:GetModifierConstantHealthRegen(kv)
	return self.bonus_health_regen
end

-------------------------------------------
function modifier_item_echo_sabre_lua:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end


function modifier_item_echo_sabre_lua:OnAttackLanded(keys)
	local hParent = self:GetParent()
	local hTarget = keys.target
	
	if keys.attacker == hParent and self:GetAbility() then
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
			hParent:PerformAttack(hTarget, true, true, true, false, true, false, false)
			hTarget:AddNewModifier(self.parent, self:GetAbility(), "modifier_item_echo_sabre_lua_debuff", {duration = self.slow_duration})
		end
	end
end