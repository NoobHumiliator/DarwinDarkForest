modifier_durable_damage_return_lua = class({})


--------------------------------------------------------------------------------

function modifier_durable_damage_return_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_durable_damage_return_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_durable_damage_return_lua:OnCreated( kv )
	if IsServer() then
		local nParticleIndex = ParticleManager:CreateParticle("particles/items_fx/blademail.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(nParticleIndex,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
		self:AddParticle(nParticleIndex,true,false,0,false,false)
	end
end

--------------------------------------------------------------------------------

function modifier_durable_damage_return_lua:DeclareFunctions()
	local funcs = 
	{
         MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_durable_damage_return_lua:OnTakeDamage (event)

	if event.unit == self:GetParent() then
        
		local hCaster = self:GetParent()
		local original_damage = event.original_damage
		local ability = self:GetAbility()
        ApplyDamage(
        	{ 
        	  victim = event.attacker, 
        	  attacker = event.unit, 
        	  ability=self:GetAbility(), 
        	  damage = event.original_damage, 
        	  damage_type = event.damage_type,
        	  damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION
        	}
         )
	end

end