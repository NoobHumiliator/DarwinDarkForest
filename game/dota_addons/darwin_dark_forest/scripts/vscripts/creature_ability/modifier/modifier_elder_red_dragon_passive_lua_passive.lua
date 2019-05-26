modifier_elder_red_dragon_passive_lua_passive = modifier_elder_red_dragon_passive_lua_passive or class({})

function modifier_elder_red_dragon_passive_lua_passive:IsHidden()
	return true
end

function modifier_elder_red_dragon_passive_lua_passive:OnCreated()
	 --会导致闪退
	 --self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_dragon_knight_splash_attack", {})
     self:GetParent():SetMaterialGroup("1")
     self.radius = self:GetAbility():GetSpecialValueFor("radius")

end



function modifier_elder_red_dragon_passive_lua_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	return decFuns
end

function modifier_elder_red_dragon_passive_lua_passive:OnAttackLanded(params)
    
   if IsServer() then
   	    if self:GetParent() == params.attacker then

   	    	local vUnits =  FindUnitsInRadius( self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
            
            print(#vUnits)
            for _,hUnit in ipairs(vUnits) do

            	print("hUnit:GetUnitName()"..hUnit:GetUnitName())

            	if  hUnit~=params.target then

            		 ApplyDamage({
						attacker 		= self:GetParent(),
						victim 			= hUnit,
						ability 		= self:GetAbility(),
						damage 			= self:GetParent():GetAttackDamage(),
						damage_type 	= DAMAGE_TYPE_PHYSICAL,
						damage_flags	= DOTA_DAMAGE_FLAG_NONE
				     })

            	end

            end
	        
        end
    end

end