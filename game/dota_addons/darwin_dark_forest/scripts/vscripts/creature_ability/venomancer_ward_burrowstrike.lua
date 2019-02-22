venomancer_ward_burrowstrike = class({})
LinkLuaModifier( "modifier_venomancer_ward_burrowstrike", "creature_ability/modifier/modifier_venomancer_ward_burrowstrike", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_venomancer_ward_root", "creature_ability/modifier/modifier_venomancer_ward_root", LUA_MODIFIER_MOTION_HORIZONTAL )


--------------------------------------------------------------------------------


function venomancer_ward_burrowstrike:GetIntrinsicModifierName()
	return "modifier_venomancer_ward_root"
end


--------------------------------------------------------------------------------
function venomancer_ward_burrowstrike:OnAbilityPhaseStart()
	if IsServer() then
	end

	return true
end

--------------------------------------------------------------------------------

function venomancer_ward_burrowstrike:OnAbilityPhaseInterrupted()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function venomancer_ward_burrowstrike:OnSpellStart()
	if IsServer() then
		local vDistance = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		local kv =
		{
			duration = vDistance:Length2D() / self:GetSpecialValueFor( "speed" ),
		    x = self:GetCursorPosition().x,
			y = self:GetCursorPosition().y,
			z = self:GetCursorPosition().z,
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_venomancer_ward_burrowstrike", kv )
		EmitSoundOn( "Ability.SandKing_BurrowStrike", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/sandking_burrowstrike_no_models.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 225  )
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 225  )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------