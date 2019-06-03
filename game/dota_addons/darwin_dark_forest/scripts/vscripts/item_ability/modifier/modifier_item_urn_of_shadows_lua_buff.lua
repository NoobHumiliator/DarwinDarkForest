
modifier_item_urn_of_shadows_lua_buff = class({})

function modifier_item_urn_of_shadows_lua_buff:IsDebuff() return false end
function modifier_item_urn_of_shadows_lua_buff:IsHidden() return false end
function modifier_item_urn_of_shadows_lua_buff:IsPurgable() return true end
function modifier_item_urn_of_shadows_lua_buff:IsStunDebuff() return false end
function modifier_item_urn_of_shadows_lua_buff:RemoveOnDeath() return true end


function modifier_item_urn_of_shadows_lua_buff:OnCreated( kv )
	self.soul_heal_amount = self:GetAbility():GetSpecialValueFor( "soul_heal_amount" )
end


function modifier_item_urn_of_shadows_lua_buff:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		}
	return decFuns
end

function modifier_item_urn_of_shadows_lua_buff:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end

function modifier_item_urn_of_shadows_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_urn_of_shadows_lua_buff:GetTexture()
	return "item_urn_of_shadows"
end

function modifier_item_urn_of_shadows_lua_buff:GetModifierConstantHealthRegen()
	return self.soul_heal_amount
end

