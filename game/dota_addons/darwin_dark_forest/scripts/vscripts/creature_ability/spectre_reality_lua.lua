spectre_reality_lua = class({})

function spectre_reality_lua:OnSpellStart()
	if IsServer() then
       
        
        local hTarget

        local vCreeps = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCursorPosition(), nil, -1, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		for _,hCreep in ipairs(vCreeps) do
		 	 if hCreep.hHauntOwner and hCreep.hHauntOwner==self:GetCaster() then
                hTarget=hCreep
                break
		 	 end
		end

        if hTarget==nil and self:GetCursorTarget() and self:GetCursorTarget().hHauntOwner==self:GetCaster()  then
           hTarget=self:GetCursorTarget()
        end


       if hTarget then
       	   local vTargetLocation = hTarget:GetAbsOrigin()
           local vCasterLocation = self:GetCaster():GetAbsOrigin()
           EmitSoundOnLocationWithCaster(vTargetLocation, "Hero_Spectre.Reality", self:GetCaster())
           hTarget:SetAbsOrigin(vCasterLocation)
		   self:GetCaster():SetAbsOrigin(vTargetLocation)
		   --换位后取消强制攻击
		   hTarget:SetForceAttackTarget(nil)
       end
	end
end