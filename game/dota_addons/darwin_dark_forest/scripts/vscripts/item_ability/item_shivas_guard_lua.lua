item_shivas_guard_lua = class({})
LinkLuaModifier( "modifier_item_shivas_guard_lua", "item_ability/modifier/modifier_item_shivas_guard_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_shivas_guard_lua_debuff", "item_ability/modifier/modifier_item_shivas_guard_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_shivas_guard_lua_slow", "item_ability/modifier/modifier_item_shivas_guard_lua_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_shivas_guard_lua:GetIntrinsicModifierName()
	return "modifier_item_black_king_bar_lua"
end

--------------------------------------------------------------------------------
function item_shivas_guard_lua:OnSpellStart()


	local blast_radius = self:GetSpecialValueFor("blast_radius")
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local damage = self:GetSpecialValueFor("blast_damage")
    local blast_debuff_duration = self:GetSpecialValueFor("blast_debuff_duration")
    
	local current_loc = self:GetCaster():GetAbsOrigin()

	-- Play cast sound
	self:GetCaster():EmitSound("DOTA_Item.ShivasGuard.Activate")
	
	local nParticleIndex = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(nParticleIndex, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(nParticleIndex, 1, Vector(blast_radius, (blast_radius/blast_speed) * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(nParticleIndex)

	-- Initialize targets hit table
	local targets_hit = {}

	-- Main blasting loop
	local current_radius = 0
	local tick_interval = 0.1

	Timers:CreateTimer(tick_interval, function()
		-- Give vision
		AddFOWViewer(self:GetCaster():GetTeamNumber(), current_loc, current_radius, 0.1, false)

		current_radius = current_radius + blast_speed * tick_interval
		current_loc = self:GetCaster():GetAbsOrigin()

		-- Iterate through enemies in the radius
		local nearby_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			-- Check if this enemy was already hit
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			-- If not, blast it
			if not enemy_has_been_hit then
				-- Play hit particle

				local hit_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				-- Deal damage
				ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_shivas_guard_lua_slow", {duration=blast_debuff_duration})

				-- Add enemy to the targets hit table
				targets_hit[#targets_hit + 1] = enemy
			end
		end

		-- If the current radius is smaller than the maximum radius, keep going
		if current_radius < blast_radius then
			return tick_interval
		end
	end)
end
