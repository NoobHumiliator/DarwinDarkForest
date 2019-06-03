item_spirit_vessel_lua = class({})
LinkLuaModifier( "modifier_item_spirit_vessel_lua", "item_ability/modifier/modifier_item_spirit_vessel_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spirit_vessel_lua_buff", "item_ability/modifier/modifier_item_spirit_vessel_lua_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spirit_vessel_lua_debuff", "item_ability/modifier/modifier_item_spirit_vessel_lua_debuff", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_spirit_vessel_lua:GetIntrinsicModifierName()
	return "modifier_item_spirit_vessel_lua"
end

--------------------------------------------------------------------------------


function item_spirit_vessel_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()
		local duration = self:GetSpecialValueFor( "duration" )

		EmitSoundOn("DOTA_Item.UrnOfShadows.Activate", hTarget)

        if hCaster:GetTeamNumber() == hTarget:GetTeamNumber() then
        	 hTarget:AddNewModifier(hCaster, self, "modifier_item_spirit_vessel_lua_buff", {duration=duration})
        else
        	 hTarget:AddNewModifier(hCaster, self, "modifier_item_spirit_vessel_lua_debuff", {duration=duration})
        end
	end
end
