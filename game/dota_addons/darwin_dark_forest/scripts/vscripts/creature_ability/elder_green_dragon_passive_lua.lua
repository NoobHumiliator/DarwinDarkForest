
elder_green_dragon_passive_lua = class({})

LinkLuaModifier( "modifier_elder_green_dragon_passive_lua_passive", "creature_ability/modifier/modifier_elder_green_dragon_passive_lua_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_knight_corrosive_breath_debuff_lua", "creature_ability/modifier/modifier_dragon_knight_corrosive_breath_debuff_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function elder_green_dragon_passive_lua:GetIntrinsicModifierName()
	return "modifier_elder_green_dragon_passive_lua_passive"
end

--------------------------------------------------------------------------------


function elder_green_dragon_passive_lua:OnOwnerDied()
	if IsServer() then
        local nParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())
        ParticleManager:SetParticleControlEnt(nParticleIndex,0,self:GetCaster(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetCaster():GetAbsOrigin(),true)
	    local hCaster=self:GetCaster()
		Timers:CreateTimer({
		    endTime = 1,
		    callback = function()
		       hCaster:AddNoDraw(true)
		    end
		})
	end
end

--------------------------------------------------------------------------------

