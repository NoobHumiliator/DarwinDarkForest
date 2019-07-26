modifier_eidolon_duplicate_passive = class({})

function modifier_eidolon_duplicate_passive:IsHidden()
	return self:GetStackCount() ==0
end



function modifier_eidolon_duplicate_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end



function modifier_eidolon_duplicate_passive:OnAttackLanded( params )
	if IsServer() then
		local hAttacker = params.attacker
		if hAttacker ~= nil and hAttacker == self:GetParent() then
             if self:GetStackCount() ==0 then
             	 self:SetStackCount(1)
             else
             	if self:GetStackCount()+1 == self:GetAbility():GetSpecialValueFor( "count" ) then
             		 local vLocation =self:GetParent():GetAbsOrigin()
                     local nPlayerId = self:GetParent():GetMainControllingPlayer()
                     
                     if  nPlayerId and PlayerResource:GetSelectedHeroEntity(nPlayerId) then
                     	local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerId)
                        if hHero.vDuplicateUnits==nil then
                           hHero.vDuplicateUnits={}
                        end
                        --去除无效的单位
                        for k,hUnit in pairs(hHero.vDuplicateUnits) do
                        	if hUnit==nil or (hUnit:IsNull()) or (not hUnit:IsAlive()) then
                                table.remove(hHero.vDuplicateUnits,k)
                        	end 
                        end
                        if #hHero.vDuplicateUnits<10 then
                        	local hIllustion=CreateIllusion(self:GetParent(),self:GetAbility():GetSpecialValueFor("duration"), self:GetAbility():GetSpecialValueFor("illusion_damage_incoming")-100, self:GetAbility():GetSpecialValueFor("illusion_damage_outgoing")-100, vLocation, {}, self:GetAbility())
							hIllustion.hHauntOwner=self:GetParent()
							EmitSoundOn("Hero_Enigma.Demonic_Conversion", self:GetParent())
							table.insert(hHero.vDuplicateUnits, hIllustion)      
                        end
                     else
                     	--无英雄控制单位不受限制
                        local hIllustion=CreateIllusion(self:GetParent(),self:GetAbility():GetSpecialValueFor("duration"), self:GetAbility():GetSpecialValueFor("illusion_damage_incoming")-100, self:GetAbility():GetSpecialValueFor("illusion_damage_outgoing")-100, vLocation, {}, self:GetAbility())
						hIllustion.hHauntOwner=self:GetParent()
						EmitSoundOn("Hero_Enigma.Demonic_Conversion", self:GetParent())        
                     end
					 self:SetStackCount(0)
             	else
             		self:SetStackCount(self:GetStackCount()+1)
             	end
             end
		end
	end
end