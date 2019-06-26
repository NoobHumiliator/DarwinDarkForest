spectre_haunt_single_lua = class({})
--------------------------------------------------------------------------------

function spectre_haunt_single_lua:OnSpellStart()
	if IsServer() then
       local vLocation = self:GetCursorTarget():GetAbsOrigin()
       local hIllustion=CreateIllusion(self:GetCaster(),self:GetSpecialValueFor("duration"), self:GetSpecialValueFor("illusion_damage_incoming")-100, self:GetSpecialValueFor("illusion_damage_outgoing")-100, vLocation, {}, self)
	   EmitSoundOn("Hero_Spectre.Haunt", self:GetCursorTarget())
	   EmitSoundOn("Hero_Spectre.HauntCast", self:GetCaster())
	   hIllustion:SetForceAttackTarget(self:GetCursorTarget())
	   hIllustion.hHauntOwner=self:GetCaster()
	end
end

--------------------------------------------------------------------------------