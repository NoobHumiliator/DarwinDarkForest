
modifier_item_bottle_lua_texture_controller = class({})

function modifier_item_bottle_lua_texture_controller:IsHidden() return true end
function modifier_item_bottle_lua_texture_controller:IsPurgable() return false end
function modifier_item_bottle_lua_texture_controller:IsDebuff() return false end
function modifier_item_bottle_lua_texture_controller:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_bottle_lua_texture_controller:OnCreated()
	self:StartIntervalThink(0.1)
end


function modifier_item_bottle_lua_texture_controller:OnIntervalThink()
     
     if IsServer() then
		if self:GetAbility():IsCooldownReady() and self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
			self:GetAbility():SetCurrentCharges(3)
		end
		local nStack = self:GetAbility():GetCurrentCharges() + 1
		self:SetStackCount(nStack)
	end


	 self:GetAbility().sTextureName = "bottle_lua_"..(self:GetStackCount()-1)
end