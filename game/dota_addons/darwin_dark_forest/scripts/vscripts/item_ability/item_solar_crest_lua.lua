item_solar_crest_lua = class({})
LinkLuaModifier( "modifier_item_solar_crest_lua", "item_ability/modifier/modifier_item_solar_crest_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_solar_crest_lua_buff", "item_ability/modifier/modifier_item_solar_crest_lua_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_solar_crest_lua_debuff", "item_ability/modifier/modifier_item_solar_crest_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_solar_crest_lua_self_debuff", "item_ability/modifier/modifier_item_solar_crest_lua_self_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_solar_crest_lua:GetIntrinsicModifierName()
	return "modifier_item_solar_crest_lua"
end

--------------------------------------------------------------------------------
function item_solar_crest_lua:CastFilterResultTarget(hTarget)
	if IsServer() then 
		local hCaster = self:GetCaster()
		if hCaster == hTarget then
			return UF_FAIL_NOT_PLAYER_CONTROLLED
		end
	end
end



function item_solar_crest_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	if hTarget:GetTeam() ~= hCaster:GetTeam() then
		if hTarget:TriggerSpellAbsorb(self) then
			return
		end
	end
    
    hCaster:EmitSound("DOTA_Item.MedallionOfCourage.Activate")

	if hTarget:GetTeamNumber() == hCaster:GetTeamNumber() then
		hTarget:AddNewModifier(hCaster, self, "modifier_item_solar_crest_lua_buff", {duration = duration})
	else
       	hTarget:AddNewModifier(hCaster, self, "modifier_item_solar_crest_lua_debuff", {duration = duration})
	end
    
    hCaster:AddNewModifier(hCaster, self, "modifier_item_solar_crest_lua_self_debuff", {duration = duration})

end