modifier_respawn_invulnerable = class({})


function modifier_respawn_invulnerable:IsDebuff()
	return false
end
function modifier_respawn_invulnerable:GetTexture()
	return "omniknight_repel"
end

function modifier_respawn_invulnerable:GetStatusEffectName()
    return "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8.vpcf"
end



function modifier_respawn_invulnerable:OnCreated(table)
     local nWingsParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
     ParticleManager:SetParticleControl(nWingsParticleIndex, 0, self:GetParent():GetAbsOrigin())
     ParticleManager:SetParticleControlEnt(nWingsParticleIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
     self:AddParticle(nWingsParticleIndex, false, false, -1, false, false)    

    -- Halo particle
    local nHaloParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(nHaloParticleIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)    
    self:AddParticle(nHaloParticleIndex, false, false, -1, false, false)    
end



function modifier_respawn_invulnerable:DeclareFunctions()
  local funcs = 
  {
       MODIFIER_EVENT_ON_TAKEDAMAGE,
       MODIFIER_EVENT_ON_ATTACK_START,
       MODIFIER_EVENT_ON_ABILITY_START,
       MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }

  return funcs
end

function modifier_respawn_invulnerable:CheckState()
  local state = {
    [MODIFIER_STATE_INVULNERABLE] = true,
  }
  return state
end


function modifier_respawn_invulnerable:OnTakeDamage (params)
  if IsServer() then
    --动手打人
    if self:GetParent() == params.attacker then
         self:Destroy()
    end
  end
end


function modifier_respawn_invulnerable:GetModifierMoveSpeedBonus_Constant (params)
  return 350
end
