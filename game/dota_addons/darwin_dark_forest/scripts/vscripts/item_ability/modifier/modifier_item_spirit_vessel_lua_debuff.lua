
modifier_item_spirit_vessel_lua_debuff = class({})

function modifier_item_spirit_vessel_lua_debuff:IsDebuff() return true end
function modifier_item_spirit_vessel_lua_debuff:IsHidden() return false end
function modifier_item_spirit_vessel_lua_debuff:IsPurgable() return true end
function modifier_item_spirit_vessel_lua_debuff:IsStunDebuff() return false end
function modifier_item_spirit_vessel_lua_debuff:RemoveOnDeath() return true end


function modifier_item_spirit_vessel_lua_debuff:OnCreated( kv )
	self.soul_damage_amount = self:GetAbility():GetSpecialValueFor( "soul_damage_amount" )
	self.soul_damage_percentage = self:GetAbility():GetSpecialValueFor( "soul_damage_percentage" )
	self.hp_regen_reduction_enemy = self:GetAbility():GetSpecialValueFor( "hp_regen_reduction_enemy" )

	if IsServer() then
	   self:StartIntervalThink(1)
    end
end

function modifier_item_spirit_vessel_lua_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end


function modifier_item_spirit_vessel_lua_debuff:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_damage.vpcf"
end

function modifier_item_spirit_vessel_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spirit_vessel_lua_debuff:GetTexture()
	return "item_urn_of_shadows"
end

function modifier_item_spirit_vessel_lua_debuff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
    }

    return decFuncs
end

function modifier_item_spirit_vessel_lua_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.hp_regen_reduction_enemy * (-1)
end

function modifier_item_spirit_vessel_lua_debuff:OnIntervalThink()

		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.soul_damage_amount+self:GetParent():GetHealth()*(self.soul_damage_percentage/100),
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			ability = self:GetAbility()
		}

		ApplyDamage(damageTable)
end
