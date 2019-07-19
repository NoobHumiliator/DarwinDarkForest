modifier_centaur_return_lua_buff = modifier_centaur_return_lua_buff or class({})


function modifier_centaur_return_lua_buff:IsHidden()
	return false
end

function modifier_centaur_return_lua_buff:IsDebuff()
	return false
end

function modifier_centaur_return_lua_buff:OnCreated()
	if IsServer() then
	  local nCount = self:GetCaster():FindModifierByName("modifier_centaur_return_lua_stack"):GetStackCount()
	  self:GetParent():RemoveModifierByName("modifier_centaur_return_lua_stack")
      self:SetStackCount(nCount)
    end
end



function modifier_centaur_return_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_centaur_return_lua_buff:GetModifierBaseDamageOutgoing_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("damage_gain_pct")*self:GetStackCount()
end

--------------------------------------------------------------------------------
