
item_ward_observer_lua = class({})

--------------------------------------------------------------------------------

function item_ward_observer_lua:GetAOERadius()
	return self:GetSpecialValueFor( "vision_range" )
end

--------------------------------------------------------------------------------

function item_ward_observer_lua:OnSpellStart()
	if IsServer() then

		local flDuration = self:GetSpecialValueFor( "lifetime" )
        
        self:GetCaster():EmitSound("DOTA_Item.ObserverWard.Activate")
        local hWard = CreateUnitByName("npc_dota_observer_wards", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
        hWard:AddNewModifier(self:GetCaster(), self, "modifier_invisible", {})
        hWard:AddNewModifier(self:GetCaster(), self, "modifier_kill",  {duration = flDuration})

        self:SpendCharge()

	end
end


--------------------------------------------------------------------------------
