modifier_bonus_ring_effect = class({})


function modifier_bonus_ring_effect:IsDebuff()
	return false
end
function modifier_bonus_ring_effect:GetTexture()
	return "disruptor_kinetic_field"
end


function modifier_bonus_ring_effect:OnCreated( keys )
	if IsServer() then
		self.vCenter = Vector(keys.x, keys.y, keys.z)
		self.flRadius = keys.radius
		self.flOriginalSpeed = self:GetParent():GetBaseMoveSpeed()
		self:StartIntervalThink( 0.5 )
	end
end


function modifier_bonus_ring_effect:DeclareFunctions()
   local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
   }
   return funcs
end


function modifier_bonus_ring_effect:GetModifierMoveSpeed_Absolute()
    if IsServer() then
       local flDistance = ( self:GetParent():GetAbsOrigin()+self:GetParent():GetForwardVector()*100 - self.vCenter):Length2D()
       if  flDistance>self.flRadius then
          return 0.1
       else
       	  return self.flOriginalSpeed
       end

    end
end


function modifier_bonus_ring_effect:OnIntervalThink()
    if IsServer() then
         local flDistance = ( self:GetParent():GetAbsOrigin() - self.vCenter):Length2D()
         if  flDistance>self.flRadius then
           self:Destroy()
         end
         if self.hThinker:IsNull() then
            self:Destroy()
         end
         
         if self:GetParent():GetOwner() and self:GetParent():GetOwner().GetPlayerID then

	         local nPlayerId = self:GetParent():GetOwner():GetPlayerID()
	         local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
             
             --如果圈中生物是玩家的主控生物
             if hHero and hHero.hCurrentCreep == self:GetParent() then

                local flExp = 0.5

                flExp=flExp+ (vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel])*0.004

                GainExpAndUpdateRadar(nPlayerId,hHero,flExp)

             end

         end

    end
end
