
modifier_item_sange_and_yasha = class({})

function modifier_item_sange_and_yasha:IsHidden()
	return true
end
----------------------------------------
function modifier_item_sange_and_yasha:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_sange_and_yasha:OnCreated( kv )

	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )

    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )
    self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )

    self.maim_chance = self:GetAbility():GetSpecialValueFor( "maim_chance" )
    self.maim_duration = self:GetAbility():GetSpecialValueFor( "maim_duration" )


    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end

end
--------------------------------------------
function modifier_item_sange_and_yasha:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
--------------------------------------------

function modifier_item_sange_and_yasha:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,

        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end


----------------------------------------

function modifier_item_sange_and_yasha:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end
----------------------------------------
function modifier_item_sange_and_yasha:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist
end
-----------------------------------------
function modifier_item_sange_and_yasha:GetModifierConstantHealthRegen( params )
	return self.bonus_health_regen
end
-----------------------------------------

function modifier_item_sange_and_yasha:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
-------------------------------------------
function modifier_item_sange_and_yasha:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end
-------------------------------------------
function modifier_item_sange_and_yasha:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed_pct
end
-------------------------------------------
function modifier_item_sange_and_yasha:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end


function modifier_item_sange_and_yasha:OnAttackLanded( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hTarget = params.target

		if hAttacker == nil or hAttacker ~= self:GetParent() or hTarget == nil then
			return 0
		end

		if RandomInt(1, 100) < self.maim_chance then

			hTarget:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_item_sange_and_yasha_debuff", { duration = self.maim_duration } )

		end

	end
	return 0
end



