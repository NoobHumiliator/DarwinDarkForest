item_sheepstick_lua = class({})
LinkLuaModifier( "modifier_item_sheepstick_lua", "item_ability/modifier/modifier_item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_sheepstick_lua_debuff", "item_ability/modifier/modifier_item_sheepstick_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_sheepstick_lua:GetIntrinsicModifierName()
	return "modifier_item_sheepstick_lua"
end

--------------------------------------------------------------------------------

function item_sheepstick_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()
		local flHexDuration = self:GetSpecialValueFor("sheep_duration")

		if hTarget:TriggerSpellAbsorb(self) then
			return nil
		end
        
        hTarget:EmitSound("DOTA_Item.Sheepstick.Activate")

        -- Play the target particle
		local nPfx = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControl(nPfx, 0, hTarget:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(nPfx)
		hTarget:AddNewModifier(hCaster, self, "modifier_item_sheepstick_lua_debuff", {duration = flHexDuration})
	end
end


