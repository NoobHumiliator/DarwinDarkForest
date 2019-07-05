
modifier_item_shadow_amulet_lua_effect = class({})

function modifier_item_shadow_amulet_lua_effect:IsHidden()
	return true
end
----------------------------------------
function modifier_item_shadow_amulet_lua_effect:IsDebuff()
	return false
end

function modifier_item_shadow_amulet_lua_effect:OnCreated()
	if IsServer() then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invisible", {duration=self:GetAbility():GetSpecialValueFor("invis_duration")})
	end
end

----------------------------------------
function modifier_item_shadow_amulet_lua_effect:CheckState()
	local state =   {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end

function modifier_item_shadow_amulet_lua_effect:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_item_shadow_amulet_lua_effect:GetModifierInvisibilityLevel()
	return 1
end


function modifier_item_shadow_amulet_lua_effect:DeclareFunctions()
   local funcs = { MODIFIER_EVENT_ON_UNIT_MOVED }
   return funcs
end

function modifier_item_shadow_amulet_lua_effect:OnUnitMoved(keys)
	 if IsServer() then
		 local parent = self:GetParent()
		 local caster =  self:GetCaster()
		 local ability = self:GetAbility()
		 if keys.unit == parent then
		 	if self:GetParent():FindModifierByName("modifier_invisible") then
		 		self:GetParent():FindModifierByName("modifier_invisible"):Destroy()
		 	end
			self:Destroy()
		 end
	 end
end
