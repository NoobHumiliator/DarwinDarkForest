
modifier_item_vanguard_lua = class({})

function modifier_item_vanguard_lua:IsHidden()
	return true
end
----------------------------------------

function modifier_item_vanguard_lua:GetTexture()
	return "item_crown"
end
----------------------------------------

function modifier_item_vanguard_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_vanguard_lua:OnCreated( kv )
    self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
    self.block_chance = self:GetAbility():GetSpecialValueFor( "block_chance" )
    self.block_damage_melee = self:GetAbility():GetSpecialValueFor( "block_damage_melee" )
    self.block_damage_ranged = self:GetAbility():GetSpecialValueFor( "block_damage_ranged" )
    
    if self:GetCaster():GetAttackCapability()==1 then
        self.block_damage = self.block_damage_melee
    else
        self.block_damage = self.block_damage_ranged
    end

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_health)
    end
end
-------------------------------------------


function modifier_item_vanguard_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_health)
    end
end

---------------------------------------------

function modifier_item_vanguard_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

----------------------------------------
function modifier_item_vanguard_lua:OnAttacked (event)

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


function modifier_item_vanguard_lua:GetModifierConstantHealthRegen( params )
	return self.bonus_health_regen
end

----------------------------------------

function modifier_item_vanguard_lua:GetModifierPhysical_ConstantBlock( params )
	return self.block_damage
end

----------------------------------------