modifier_centaur_return_lua_passive = modifier_centaur_return_lua_passive or class({})


function modifier_centaur_return_lua_passive:IsHidden()
	return true
end


function modifier_centaur_return_lua_passive:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED }
	return funcs
end


function modifier_centaur_return_lua_passive:OnAttackLanded(keys)
	if IsServer() then
        if keys.target==self:GetParent() then

        	local nParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(nParticleIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(nParticleIndex, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(nParticleIndex)

           	local vDamageInfo  =
			{
				victim = keys.attacker,
				attacker = self:GetParent(),
				damage = self:GetAbility():GetSpecialValueFor("return_damage"),
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self:GetAbility(),
			}

		    ApplyDamage( vDamageInfo )
            
            if keys.attacker.bMainCreep or keys.attacker:GetLevel()>self:GetParent():GetLevel() then
			    if self:GetParent():HasModifier("modifier_centaur_return_lua_stack") then
	               local vModifier=self:GetParent():FindModifierByName("modifier_centaur_return_lua_stack")
	               local nCount = vModifier:GetStackCount()
	               if nCount<self:GetAbility():GetSpecialValueFor("max_stacks") then
	                   vModifier:SetStackCount(nCount+1)
	               end
			    else
			    	local vModifier=self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_centaur_return_lua_stack", {})
	                vModifier:SetStackCount(1)
			    end
		    end
			
        end
	end
end
