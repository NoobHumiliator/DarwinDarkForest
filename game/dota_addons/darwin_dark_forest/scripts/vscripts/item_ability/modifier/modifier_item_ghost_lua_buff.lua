modifier_item_ghost_lua_buff = class({})

function modifier_item_ghost_lua_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ghost_lua_buff:OnCreated()
	self.ability					= self:GetAbility()
	self.caster						= self:GetCaster()
	self.parent						= self:GetParent()
	self.extra_spell_damage_percent		= self.ability:GetSpecialValueFor("extra_spell_damage_percent")
	
	self:StartIntervalThink(FrameTime())
end

function modifier_item_ghost_lua_buff:OnIntervalThink()
	if not IsServer() then return end
	if self.parent:IsMagicImmune() then
		self:Destroy()
	end
end

function modifier_item_ghost_lua_buff:OnRefresh()
	self:OnCreated()
end

function modifier_item_ghost_lua_buff:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end

function modifier_item_ghost_lua_buff:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    }
	
	return decFuncs
end

function modifier_item_ghost_lua_buff:GetModifierMagicalResistanceDecrepifyUnique()
    return self.extra_spell_damage_percent
end

function modifier_item_ghost_lua_buff:GetAbsoluteNoDamagePhysical()
	return 1
end

