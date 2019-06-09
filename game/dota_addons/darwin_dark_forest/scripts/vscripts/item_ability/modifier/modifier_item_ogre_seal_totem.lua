
modifier_item_ogre_seal_totem = class({})

------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_ogre_seal_totem:OnCreated( kv )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	 if IsServer() then
    	AddHealthBonus(self:GetCaster(),self.bonus_hp)
    end
end

--------------------------------------------------------------------------------

function modifier_item_ogre_seal_totem:OnDestroy()
    if IsServer() then
    	RemoveHealthBonus(self:GetCaster(),self.bonus_hp)
    end
end

