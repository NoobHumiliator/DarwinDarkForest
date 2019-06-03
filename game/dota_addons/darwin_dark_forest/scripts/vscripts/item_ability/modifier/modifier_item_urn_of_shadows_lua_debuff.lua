
modifier_item_urn_of_shadows_lua_debuff = class({})

function modifier_item_urn_of_shadows_lua_debuff:IsDebuff() return true end
function modifier_item_urn_of_shadows_lua_debuff:IsHidden() return false end
function modifier_item_urn_of_shadows_lua_debuff:IsPurgable() return true end
function modifier_item_urn_of_shadows_lua_debuff:IsStunDebuff() return false end
function modifier_item_urn_of_shadows_lua_debuff:RemoveOnDeath() return true end


function modifier_item_urn_of_shadows_lua_debuff:OnCreated( kv )
	self.soul_damage_amount = self:GetAbility():GetSpecialValueFor( "soul_damage_amount" )
	if IsServer() then
	   self:StartIntervalThink(1)
    end
end



function modifier_item_urn_of_shadows_lua_debuff:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_damage.vpcf"
end

function modifier_item_urn_of_shadows_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_urn_of_shadows_lua_debuff:GetTexture()
	return "item_urn_of_shadows"
end

function modifier_item_urn_of_shadows_lua_debuff:OnIntervalThink()

		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.soul_damage_amount,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			ability = self:GetAbility()
		}

		ApplyDamage(damageTable)
end
