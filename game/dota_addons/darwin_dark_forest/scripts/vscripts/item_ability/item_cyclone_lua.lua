item_cyclone_lua = class({})
LinkLuaModifier( "modifier_item_cyclone_lua", "item_ability/modifier/modifier_item_cyclone_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_cyclone_lua_effect", "item_ability/modifier/modifier_item_cyclone_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_cyclone_lua:GetIntrinsicModifierName()
	return "modifier_item_cyclone_lua"
end

--------------------------------------------------------------------------------

function item_cyclone_lua:CastFilterResultTarget(hTarget)
	if IsServer() then 
		local hCaster = self:GetCaster()
		if hCaster:GetTeamNumber() == hTarget:GetTeamNumber() and hCaster ~= hTarget then
			return UF_FAIL_FRIENDLY
		end
		if hCaster ~= hTarget and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
	end
end


function item_cyclone_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hCaster:GetTeamNumber() ~= hTarget:GetTeamNumber() then
		hTarget:Purge(true, false, false, false, false)
	else
		hCaster:Purge(false, true, false, false, false)
	end
	hTarget:AddNewModifier(hCaster, self, "modifier_item_cyclone_lua_effect", {duration = self:GetSpecialValueFor("cyclone_duration")})
end