modifier_fury_berserk_lua = class({})


--------------------------------------------------------------------------------

function modifier_fury_berserk_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_fury_berserk_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_fury_berserk_lua:OnCreated( kv )
	if IsServer() then
		self.income_damage_percentage = self:GetAbility():GetSpecialValueFor( "income_damage_percentage" )
	    self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
        self.movement_speed_bonus = self:GetAbility():GetSpecialValueFor( "movement_speed_bonus" )
        self.attack_damage_bonus = self:GetAbility():GetSpecialValueFor( "attack_damage_bonus" )


		local nParticleIndex = ParticleManager:CreateParticle("particles/items2_fx/mask_of_madness.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(nParticleIndex,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
		self:AddParticle(nParticleIndex,true,false,0,false,false)
	end
end

--------------------------------------------------------------------------------

function modifier_fury_berserk_lua:DeclareFunctions()
	local funcs = 
	{
         MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
         MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
         MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

---------------------------------------------------------------------------------
function modifier_fury_berserk_lua:GetModifierIncomingDamage_Percentage()
	return self.income_damage_percentage
end

----------------------------------------------------------------------------------
function modifier_fury_berserk_lua:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed_bonus
end
----------------------------------------------------------------------------------
function modifier_fury_berserk_lua:GetModifierMoveSpeedBonus_Constant()
    return self.movement_speed_bonus
end
----------------------------------------------------------------------------------

function modifier_fury_berserk_lua:GetModifierBaseAttack_BonusDamage()
    return self.attack_damage_bonus
end

----------------------------------------------------------------------------------
function modifier_fury_berserk_lua:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}
	return state
end