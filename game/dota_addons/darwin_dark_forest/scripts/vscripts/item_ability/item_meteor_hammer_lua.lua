
LinkLuaModifier("modifier_item_meteor_hammer_lua", "item_ability/modifier/modifier_item_meteor_hammer_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_lua_burn", "item_ability/modifier/modifier_item_meteor_hammer_lua_burn", LUA_MODIFIER_MOTION_NONE)


item_meteor_hammer_lua	= class({})

function item_meteor_hammer_lua:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_lua"
end

function item_meteor_hammer_lua:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end


function item_meteor_hammer_lua:OnSpellStart()
	
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if IsServer() then
		self.vPosition	= self:GetCursorPosition()

		self:GetCaster():EmitSound("DOTA_Item.MeteorHammer.Channel")

		AddFOWViewer(self:GetCaster():GetTeam(), self.vPosition, self.impact_radius, 3.8, false)

		self.nParticleIndex	= ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeam())
		ParticleManager:SetParticleControl(self.nParticleIndex, 0, self.vPosition)
		ParticleManager:SetParticleControl(self.nParticleIndex, 1, Vector(self.impact_radius, 1, 1))
		
		self.nParticleIndex2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())

		self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
    end
end


function item_meteor_hammer_lua:OnChannelFinish(bInterrupted)
	if IsServer() then

	self:GetCaster():RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if bInterrupted then
		self:GetCaster():StopSound("DOTA_Item.MeteorHammer.Channel")
		ParticleManager:DestroyParticle(self.nParticleIndex, true)
		ParticleManager:DestroyParticle(self.nParticleIndex2, true)
	else
		self:GetCaster():EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.nParticleIndex3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(self.nParticleIndex3, 0, self.vPosition + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.nParticleIndex3, 1, self.vPosition)
		ParticleManager:SetParticleControl(self.nParticleIndex3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.nParticleIndex3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.vPosition, self.impact_radius, true)			
				EmitSoundOnLocationWithCaster(self.vPosition, "DOTA_Item.MeteorHammer.Impact", self:GetCaster())
			
				local vEnemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.vPosition, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, hEnemy in pairs(vEnemies) do
					hEnemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					hEnemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self.stun_duration})
					hEnemy:AddNewModifier(self:GetCaster(), self, "modifier_item_meteor_hammer_lua_burn", {duration = self.burn_duration})
							
					local damageTable = {
						victim 			= hEnemy,
						damage 			= self.impact_damage_units,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.nParticleIndex)
	ParticleManager:ReleaseParticleIndex(self.nParticleIndex2)
    end
end