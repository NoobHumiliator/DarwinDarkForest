decay_necrolyte_reapers_scythe = class({})
LinkLuaModifier("modifier_decay_necrolyte_reapers_scythe", "creature_ability/modifier/modifier_decay_necrolyte_reapers_scythe", LUA_MODIFIER_MOTION_NONE)


function decay_necrolyte_reapers_scythe:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_durable_damage_return_lua", { duration = duration }  )
	EmitSoundOn( "Hero_NyxAssassin.SpikedCarapace", self:GetCaster() )
end

--------------------------------------------------------------------------------

function decay_necrolyte_reapers_scythe:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()

		hCaster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		hTarget:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
		
		hCaster:EmitSound("necrolyte_necr_ability_reap_0"..math.random(1,3))


		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local stun_duration = self:GetSpecialValueFor("stun_duration")

		hTarget:AddNewModifier(hCaster, self, "modifier_decay_necrolyte_reapers_scythe", {duration = stun_duration+FrameTime()})
	end
end