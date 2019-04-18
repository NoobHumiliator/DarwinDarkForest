
modifier_item_sheepstick_lua_debuff = class({})

----------------------------------------
function modifier_item_sheepstick_lua_debuff:IsHidden() return false end
function modifier_item_sheepstick_lua_debuff:IsDebuff() return true end
function modifier_item_sheepstick_lua_debuff:IsPurgable() return true end

-- Declare modifier events/properties
function modifier_item_sheepstick_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

function modifier_item_sheepstick_lua_debuff:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("sheep_movement_speed") end

function modifier_item_sheepstick_lua_debuff:GetModifierModelChange()
	return "models/props_gameplay/pig.vmdl"
end

-- Hexed state
function modifier_item_sheepstick_lua_debuff:CheckState()
	local states = {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return states
end