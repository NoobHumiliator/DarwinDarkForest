
modifier_item_poor_mans_shield_lua = class({})

function modifier_item_poor_mans_shield_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_poor_mans_shield_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_poor_mans_shield_lua:OnCreated( kv )

    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )

    self.block_chance = self:GetAbility():GetSpecialValueFor( "block_chance" )
    self.block_damage_melee = self:GetAbility():GetSpecialValueFor( "block_damage_melee" )
    self.block_damage_ranged = self:GetAbility():GetSpecialValueFor( "block_damage_ranged" )
    
    if self:GetCaster().GetAttackCapability and self:GetCaster():GetAttackCapability()==1 then
        self.block_damage = self.block_damage_melee
    else
        self.block_damage = self.block_damage_ranged
    end

end
---------------------------------------------

function modifier_item_poor_mans_shield_lua:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

----------------------------------------
function modifier_item_poor_mans_shield_lua:OnAttacked (event)

     if RandomInt(1, 100) < self.block_chance then   
        if self:GetCaster():GetAttackCapability()==1 then
	        self.block_damage = self.block_damage_melee
	    else
	        self.block_damage = self.block_damage_ranged
	    end 
     else
     	self.block_damage=0
     end
	
end
----------------------------------------

function modifier_item_poor_mans_shield_lua:GetModifierPreAttack_BonusDamage( params )
    return self.bonus_damage
end
----------------------------------------

function modifier_item_poor_mans_shield_lua:GetModifierAttackSpeedBonus_Constant( params )
    return self.bonus_attack_speed
end
----------------------------------------
function modifier_item_poor_mans_shield_lua:GetModifierPhysicalArmorBonus( params )
    return self.bonus_armor
end
-------------------------------------------
function modifier_item_poor_mans_shield_lua:GetModifierMoveSpeedBonus_Percentage( params )
    return self.bonus_move_speed_pct
end
-------------------------------------------
function modifier_item_poor_mans_shield_lua:GetModifierPhysical_ConstantBlock( params )
    return self.block_damage
end

----------------------------------------