item_dagon_3_lua = class({})
LinkLuaModifier( "modifier_item_dagon_lua", "item_ability/modifier/modifier_item_dagon_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_dagon_3_lua:GetIntrinsicModifierName()
	return "modifier_item_dagon_lua"
end

--------------------------------------------------------------------------------


function item_dagon_3_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()

		if hTarget:TriggerSpellAbsorb(self) then
			return nil
		end
		self.damage = self:GetSpecialValueFor( "damage" )


        -- Draw particle
		local nParticle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(nParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		
		ParticleManager:SetParticleControl(nParticle, 2, Vector(self.damage))


        hCaster:EmitSound("DOTA_Item.Dagon.Activate")
        hTarget:EmitSound("DOTA_Item.Dagon5.Target")
        
        ApplyDamage({attacker = hCaster, victim = hTarget, ability = self, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

	end
end
