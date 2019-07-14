modifier_item_meteor_hammer_lua_burn	= class({})

function modifier_item_meteor_hammer_lua_burn:GetEffectName()
	return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end


function modifier_item_meteor_hammer_lua_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_meteor_hammer_lua_burn:OnCreated()
	if IsServer() then
		self.burn_dps_units=self:GetAbility():GetSpecialValueFor("burn_dps_units")
		self.burn_interval=self:GetAbility():GetSpecialValueFor("burn_interval")
		self:StartIntervalThink(self.burn_interval)
    end
end

function modifier_item_meteor_hammer_lua_burn:OnIntervalThink()
	if IsServer() then
		local vDamageTable= 
		{
			victim 			= self:GetParent(),
			damage 			= self.burn_dps_units,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}			
		ApplyDamage(vDamageTable)
	end
	
end