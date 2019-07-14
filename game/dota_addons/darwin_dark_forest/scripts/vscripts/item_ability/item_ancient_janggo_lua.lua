item_ancient_janggo_lua = class({})
LinkLuaModifier( "modifier_item_ancient_janggo_lua", "item_ability/modifier/modifier_item_ancient_janggo_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ancient_janggo_lua_buff", "item_ability/modifier/modifier_item_ancient_janggo_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_ancient_janggo_lua:GetIntrinsicModifierName()
	return "modifier_item_ancient_janggo_lua"
end

--------------------------------------------------------------------------------
function item_ancient_janggo_lua:OnSpellStart()
	if IsServer() then
        self:GetCaster():EmitSound("DOTA_Item.DoE.Activate")
        self:SpendCharge()
        local nearby_allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	    for _, hAlly in pairs(nearby_allies) do          
           hAlly:AddNewModifier(self:GetCaster(), self, "modifier_item_ancient_janggo_lua_buff", {duration=self:GetSpecialValueFor("duration")})		    
	    end
	end
end

--------------------------------------------------------------------------------