modifier_fountain_aura_effect_lua = class({})
-------------------------------------------------------------------------------


function modifier_fountain_aura_effect_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
	return funcs
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage( params )

	if self and self:GetAbility() then
	  return self:GetAbility():GetSpecialValueFor( "heal_percent" )
    else 
      return 0 
    end

end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen( params )

	if self and self:GetAbility() then
	  return self:GetAbility():GetSpecialValueFor( "mana_percent" )
	else 
      return 0 
    end

end



-----------------------------------------------------------------------------------
function modifier_fountain_aura_effect_lua:OnCreated()
	if not IsServer() then return end
	self.nParticleIndex = ParticleManager:CreateParticle("particles/items_fx/bottle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
end

function modifier_fountain_aura_effect_lua:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.nParticleIndex, false)
	ParticleManager:ReleaseParticleIndex(self.nParticleIndex)
end