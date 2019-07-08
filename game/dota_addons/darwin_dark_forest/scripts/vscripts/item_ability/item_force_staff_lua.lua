item_force_staff_lua = class({})
LinkLuaModifier( "modifier_item_force_staff_lua", "item_ability/modifier/modifier_item_force_staff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_force_staff_lua_effect", "item_ability/modifier/modifier_item_force_staff_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_force_staff_lua:GetIntrinsicModifierName()
	return "modifier_item_force_staff_lua"
end

--------------------------------------------------------------------------------


function item_force_staff_lua:OnSpellStart()
	if IsServer() then

		if self:GetCursorTarget():TriggerSpellAbsorb(ability) then
		   return nil
	    end
	
	    EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCursorTarget())
	    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_force_staff_lua_effect", {duration = 0.5})
	end
end


