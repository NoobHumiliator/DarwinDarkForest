
modifier_item_sphere_lua = class({})

function modifier_item_sphere_lua:IsHidden()
	return true
end
----------------------------------------
function modifier_item_sphere_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_item_sphere_lua:OnCreated( kv )

    if IsServer() then
    	AddHealthBonus(self:GetCaster(),self:GetAbility():GetSpecialValueFor( "bonus_health" ))
    	self:StartIntervalThink(FrameTime())
    end
end
-------------------------------------------

function modifier_item_sphere_lua:OnIntervalThink()
    if IsServer() then
    	if self:GetAbility():IsCooldownReady() and not self:GetParent():HasModifier("modifier_item_sphere_target") then            
           self:GetParent():AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_item_sphere_target", {duration = 13})
    	end
    end
end


-------------------------------------------


function modifier_item_sphere_lua:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self:GetAbility():GetSpecialValueFor( "bonus_health" ))
    end
end

---------------------------------------------

function modifier_item_sphere_lua:DeclareFunctions()
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

function modifier_item_sphere_lua:GetModifierSpellAmplify_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "spell_amplify" )
end

----------------------------------------


function modifier_item_sphere_lua:GetModifierPreAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end

----------------------------------------

function modifier_item_sphere_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
end
----------------------------------------

function modifier_item_sphere_lua:GetModifierConstantManaRegen( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
end

----------------------------------------
function modifier_item_sphere_lua:GetModifierConstantHealthRegen(kv)
	return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

-------------------------------------------
function modifier_item_sphere_lua:GetModifierMagicalResistanceBonus( params )
	return self:GetAbility():GetSpecialValueFor( "magic_resistance" )
end
-------------------------------------------
function modifier_item_sphere_lua:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end
-------------------------------------------
function modifier_item_sphere_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )
end