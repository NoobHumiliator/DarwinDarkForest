modifier_dragon_knight_corrosive_breath_debuff_lua = modifier_dragon_knight_corrosive_breath_debuff_lua or class({})

function modifier_dragon_knight_corrosive_breath_debuff_lua:IsHidden()
	return false
end

function modifier_dragon_knight_corrosive_breath_debuff_lua:IsDebuff()
	return true
end

function modifier_dragon_knight_corrosive_breath_debuff_lua:OnCreated()
	 self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage_per_tick")
	 self:StartIntervalThink(1)
end


function modifier_dragon_knight_corrosive_breath_debuff_lua:OnIntervalThink()

	local nFinalDamage = ApplyDamage({
			attacker 		= self:GetCaster(),
			victim 			= self:GetParent(),
			ability 		= self:GetAbility(),
			damage 			= self.damage_per_tick,
			damage_type 	= DAMAGE_TYPE_MAGICAL,
			damage_flags	= DOTA_DAMAGE_FLAG_NONE
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), nFinalDamage, nil)

end
