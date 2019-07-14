item_sphere_lua = class({})
LinkLuaModifier( "modifier_item_sphere_lua", "item_ability/modifier/modifier_item_sphere_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_sphere_lua:GetIntrinsicModifierName()
	return "modifier_item_sphere_lua"
end

--------------------------------------------------------------------------------
function item_sphere_lua:OnSpellStart()
	if IsServer() then
        local hTarget = self:GetCursorTarget()
        self:GetCaster():RemoveModifierByName("modifier_item_sphere_target")
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_sphere_target", {duration = 13})
	end
end

--------------------------------------------------------------------------------
function item_sphere_lua:CastFilterResultTarget(hTarget)
	if IsServer() then 
		local hCaster = self:GetCaster()
		if hCaster == hTarget then
			return UF_FAIL_NOT_PLAYER_CONTROLLED
		end
	end
end
