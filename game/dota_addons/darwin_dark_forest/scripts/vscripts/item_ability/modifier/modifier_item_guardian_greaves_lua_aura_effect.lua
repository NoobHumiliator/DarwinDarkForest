-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_guardian_greaves_lua_aura_effect == nil then modifier_item_guardian_greaves_lua_aura_effect = class({}) end
function modifier_item_guardian_greaves_lua_aura_effect:IsHidden() return false end
function modifier_item_guardian_greaves_lua_aura_effect:IsDebuff() return false end
function modifier_item_guardian_greaves_lua_aura_effect:IsPurgable() return false end

function modifier_item_guardian_greaves_lua_aura_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.aura_health_regen = ability:GetSpecialValueFor("aura_health_regen")
	self.aura_armor = ability:GetSpecialValueFor("aura_armor")
	self.aura_health_regen_bonus = ability:GetSpecialValueFor("aura_health_regen_bonus")
	self.aura_armor_bonus = ability:GetSpecialValueFor("aura_armor_bonus")
	self.min_health_threshold = ability:GetSpecialValueFor("min_health_threshold")
end

function modifier_item_guardian_greaves_lua_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_guardian_greaves_lua_aura_effect:GetModifierPhysicalArmorBonus()
	if self:GetParent():GetHealthPercent()<self.min_health_threshold then 
       return self.aura_armor + self.aura_armor_bonus
    else
       return self.aura_armor
    end
end

function modifier_item_guardian_greaves_lua_aura_effect:GetModifierConstantHealthRegen()
	if self:GetParent():GetHealthPercent()<self.min_health_threshold then 
       return self.aura_health_regen + self.aura_health_regen_bonus
    else
       return self.aura_health_regen
    end
end
