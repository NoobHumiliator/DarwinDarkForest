item_veil_of_discord_lua = class({})
LinkLuaModifier( "modifier_item_veil_of_discord_lua", "item_ability/modifier/modifier_item_veil_of_discord_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_veil_of_discord_lua_effect", "item_ability/modifier/modifier_item_veil_of_discord_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_veil_of_discord_lua:GetIntrinsicModifierName()
	return "modifier_item_veil_of_discord_lua"
end

--------------------------------------------------------------------------------

function item_veil_of_discord_lua:OnSpellStart()
	-- Ability properties
	local caster        =   self:GetCaster()
	local target_loc    =   self:GetCursorPosition()

	local radius            =   self:GetSpecialValueFor("debuff_radius")
	local resist_debuff_duration   =   self:GetSpecialValueFor("resist_debuff_duration")

	-- Emit sound
	caster:EmitSound("DOTA_Item.VeilofDiscord.Activate")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(radius,1 ,1 ))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(caster:GetTeamNumber(),
			target_loc,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_ALL,
			0,
			FIND_ANY_ORDER,
			false)

	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff
		enemy:AddNewModifier(caster, self, "modifier_item_veil_of_discord_lua_effect", {duration = resist_debuff_duration})
	end
end


function item_veil_of_discord_lua:GetAOERadius()
	return self:GetSpecialValueFor("debuff_radius")
end
