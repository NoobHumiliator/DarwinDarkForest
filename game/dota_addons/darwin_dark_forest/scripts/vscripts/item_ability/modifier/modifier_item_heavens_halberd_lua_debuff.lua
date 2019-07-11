
modifier_item_heavens_halberd_lua_debuff = class({})
----------------------------------------
function modifier_item_heavens_halberd_lua_debuff:IsHidden()
	return false
end
----------------------------------------

function modifier_item_heavens_halberd_lua_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf" 
end
----------------------------------------
function modifier_item_heavens_halberd_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end
----------------------------------------
function modifier_item_heavens_halberd_lua_debuff:IsDebuff()
	return true
end
----------------------------------------
function modifier_item_heavens_halberd_lua_debuff:CheckState() 
  local state = {
    [MODIFIER_STATE_DISARMED] = true,
  }
  return state
end

