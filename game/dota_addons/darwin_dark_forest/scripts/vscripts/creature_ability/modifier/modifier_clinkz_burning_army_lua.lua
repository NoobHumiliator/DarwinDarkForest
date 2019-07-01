modifier_clinkz_burning_army_lua =  class({})

function modifier_clinkz_burning_army_lua:IsDebuff()	
	return false 
end

function modifier_clinkz_burning_army_lua:IsHidden() 				
	return true
end

function modifier_clinkz_burning_army_lua:IsPurgable() 				
	return false 
end


function modifier_clinkz_burning_army_lua:OnCreated()
	if IsServer() then
		self.cloud_bolt_interval = self:GetAbility():GetSpecialValueFor( "cloud_bolt_interval" )
		self.cloud_bolt_damage = self:GetAbility():GetSpecialValueFor( "cloud_bolt_damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	    self:StartIntervalThink( self.cloud_bolt_interval )
	end
end

function modifier_zuus_cloud_lua:OnIntervalThink()
	if IsServer() then
		local vEnemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
	    for _,hUnit in pairs(vEnemies) do
			if hUnit:IsAlive() then
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, hUnit)
					vTargetPoint = hUnit:GetAbsOrigin()
					ParticleManager:SetParticleControl(particle, 0, Vector(vTargetPoint.x, vTargetPoint.y, vTargetPoint.z))
					ParticleManager:SetParticleControl(particle, 1, Vector(vTargetPoint.x, vTargetPoint.y, 2000))
					ParticleManager:SetParticleControl(particle, 2, Vector(vTargetPoint.x, vTargetPoint.y, vTargetPoint.z))
				    
				    local vDamageTable 			= {}
					vDamageTable.attacker 		= self:GetParent()
					vDamageTable.ability 		= self:GetAbility()
					vDamageTable.damage_type 	= DAMAGE_TYPE_MAGICAL
					vDamageTable.damage			= self.cloud_bolt_damage
					vDamageTable.victim 		= hUnit
					ApplyDamage(vDamageTable)

					EmitSoundOn("Hero_Zuus.LightningBolt.Cast",self:GetParent())

				break
			end
		end
	end
end


function modifier_zuus_cloud_lua:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_EVENT_ON_ATTACKED,
		}
	return decFuns
end

function modifier_zuus_cloud_lua:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_zuus_cloud_lua:CheckState()
	local state =
		{
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		}
	return state
end

function modifier_zuus_cloud_lua:OnAttacked( keys )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	local attacker = keys.attacker

	if keys.target ~= egg then
		return
	end

	if  egg:GetHealth()<=1 then
		egg:Kill(ability, attacker)
	else
		egg:SetHealth( egg:GetHealth()-1 )
	end
end