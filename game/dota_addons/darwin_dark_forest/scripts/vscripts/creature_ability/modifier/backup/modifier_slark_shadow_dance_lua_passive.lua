modifier_slark_shadow_dance_lua_passive = class({})

--------------------------------------------------------------------------------

function modifier_slark_shadow_dance_lua_passive:IsHidden() return false end
function modifier_slark_shadow_dance_lua_passive:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_slark_shadow_dance_lua_passive:OnCreated()
	if IsServer() then
	  self.activation_delay = self:GetAbility():GetSpecialValueFor("activation_delay")
	  self:GetParent().flLastSeenDuration = 0
	  self:StartIntervalThink(0.1)
    end
end


function modifier_slark_shadow_dance_lua_passive:OnIntervalThink()
  if IsServer() then
      local vEnemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
      for _,hEnemy in pairs(vEnemies) do
      	  if hEnemy:CanEntityBeSeenByMyTeam(self:GetParent())  then
               print("can see"..hEnemy:GetUnitName())
      	  	   self:GetParent().flLastSeenDuration = 0
               if self:GetParent():HasModifier("modifier_slark_shadow_dance_lua_speed") then
				  self:GetParent():RemoveModifierByName("modifier_slark_shadow_dance_lua_speed")
			   end
               return 
		  end
      end
      self:GetParent().flLastSeenDuration = self:GetParent().flLastSeenDuration + 0.1
      
      print("self.flLastSeenDuration"..self:GetParent().flLastSeenDuration)
      if self:GetParent().flLastSeenDuration and self:GetParent().flLastSeenDuration > self.activation_delay then
      	print("123")
		if not self:GetParent():HasModifier("modifier_slark_shadow_dance_lua_speed") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_slark_shadow_dance_lua_speed", {})
		end
	  end
	end
end


