modifier_fountain_aura_effect_lua = class({})
-------------------------------------------------------------------------------


function modifier_fountain_aura_effect_lua:IsDebuff()
    return false
end


function modifier_fountain_aura_effect_lua:OnCreated()

   self:StartIntervalThink(1)

end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
	return funcs
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage( params )

	if self and self:GetAbility() then
	  return self:GetAbility():GetSpecialValueFor( "heal_percent" )
    else 
      return 0 
    end

end

--------------------------------------------------------------------------------

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen( params )

	if self and self:GetAbility() then
	  return self:GetAbility():GetSpecialValueFor( "mana_percent" )
	else 
      return 0 
    end

end

--补充魔瓶
function modifier_fountain_aura_effect_lua:OnIntervalThink()

	if IsServer() then
		if self:GetParent():HasItemInInventory("item_bottle") then
			for i=1,6 do
		 	   local hItem=self:GetParent():GetItemInSlot(i)
               if hItem~=nil then
                  if hItem:GetAbilityName()=="item_bottle" then
                     hItem:SetCurrentCharges(3)
                  end
               end
			end
		end
	end

end


