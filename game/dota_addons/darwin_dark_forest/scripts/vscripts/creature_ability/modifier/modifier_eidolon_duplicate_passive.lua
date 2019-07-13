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
             		 local  vLocation =self:GetParent():GetAbsOrigin()
                     local hIllustion=CreateIllusion(self:GetParent(),self:GetAbility():GetSpecialValueFor("duration"), self:GetAbility():GetSpecialValueFor("illusion_damage_incoming")-100, self:GetAbility():GetSpecialValueFor("illusion_damage_outgoing")-100, vLocation, {}, self:GetAbility())
					 hIllustion.hHauntOwner=self:GetParent()
					 EmitSoundOn("Hero_Enigma.Demonic_Conversion", self:GetParent())
					 self:SetStackCount(0)
             	else
             		self:SetStackCount(self:GetStackCount()+1)
             	end
             end
		end
	end
end