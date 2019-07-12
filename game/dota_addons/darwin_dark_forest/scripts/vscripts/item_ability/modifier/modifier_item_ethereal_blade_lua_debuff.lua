
modifier_item_ethereal_blade_lua_debuff = class({})

function modifier_item_ethereal_blade_lua_debuff:IsHidden()
	return false
end
----------------------------------------
function modifier_item_ethereal_blade_lua_debuff:IsDebuff()
	return true
end
----------------------------------------
function modifier_item_ethereal_blade_lua_debuff:OnCreated()
	self.ability					= self:GetAbility()
	self.caster						= self:GetCaster()
	self.parent						= self:GetParent()
	self.ethereal_damage_bonus	= self.ability:GetSpecialValueFor("ethereal_damage_bonus")
	self.blast_movement_slow	= self.ability:GetSpecialValueFor("blast_movement_slow")

	self:StartIntervalThink(FrameTime())
end
----------------------------------------
function modifier_item_ethereal_blade_lua_debuff:OnIntervalThink()
	if not IsServer() then return end
	if self.parent:IsMagicImmune() then
		self:Destroy()
	end
end

----------------------------------------

function modifier_item_ethereal_blade_lua_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ethereal_blade_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end

function modifier_item_ethereal_blade_lua_debuff:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
	
	return decFuncs
end

function modifier_item_ethereal_blade_lua_debuff:GetModifierMagicalResistanceDecrepifyUnique()
    return self.ethereal_damage_bonus
end

function modifier_item_ethereal_blade_lua_debuff:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_ethereal_blade_lua_debuff:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster():GetTeam()~=self:GetParent():GetTeam() then
	   return self.blast_movement_slow
    else
       return 0
    end
end

