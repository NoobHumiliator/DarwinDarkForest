spectre_haunt_lua = class({})
LinkLuaModifier( "modifier_spectre_haunt_lua_fly", "creature_ability/modifier/modifier_spectre_haunt_lua_fly", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spectre_haunt_lua:OnSpellStart()
	if IsServer() then
		local vCreeps={}
        local vMapCreeps = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCursorPosition(), nil, -1, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		local nIllustionNumber=0
        
        --剔除信使
        for _,hCreep in pairs(vMapCreeps) do
        	if hCreep:GetAttackCapability() ~= 0 then
        		table.insert(vCreeps, hCreep)
        	end
        end
        

		for _,hCreep in ipairs(vCreeps) do
		 	 if hCreep.bMainCreep then
                  local vLocation = hCreep:GetAbsOrigin()
			      local hIllustion=CreateIllusion(self:GetCaster(),self:GetSpecialValueFor("duration"), self:GetSpecialValueFor("illusion_damage_incoming")-100, self:GetSpecialValueFor("illusion_damage_outgoing")-100, vLocation, {}, self)
				  EmitSoundOn("Hero_Spectre.Haunt",hCreep)
				  hIllustion:SetForceAttackTarget(hCreep)
	              hIllustion:AddNewModifier(hIllustion, self, "modifier_spectre_haunt_lua_fly", {})
				  hIllustion.hHauntOwner=self:GetCaster()
				  nIllustionNumber=nIllustionNumber+1
		 	 end
		end
        
        --补足数量
        if nIllustionNumber<9 and  #vCreeps>0  then
           for i=1,9-nIllustionNumber do
           	  local hCreep = vCreeps[RandomInt(1, #vCreeps)]
           	  local vLocation = hCreep:GetAbsOrigin()
		      local hIllustion=CreateIllusion(self:GetCaster(),self:GetSpecialValueFor("duration"), self:GetSpecialValueFor("illusion_damage_incoming")-100, self:GetSpecialValueFor("illusion_damage_outgoing")-100, vLocation, {}, self)
			  EmitSoundOn("Hero_Spectre.Haunt",hCreep)
			  hIllustion:SetForceAttackTarget(hCreep)
			  FindClearSpaceForUnit(hIllustion, vLocation, false)
	          hIllustion:AddNewModifier(hIllustion, self, "modifier_spectre_haunt_lua_fly", {})
			  hIllustion.hHauntOwner=self:GetCaster()
			  nIllustionNumber=nIllustionNumber+1
           end
        end
        
        EmitGlobalSound("Hero_Spectre.HauntCast")

	end
end

--------------------------------------------------------------------------------