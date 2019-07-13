item_manta_lua = class({})
LinkLuaModifier( "modifier_item_manta_lua", "item_ability/modifier/modifier_item_manta_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_manta_lua_invulnerable", "item_ability/modifier/modifier_item_manta_lua_invulnerable", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_manta_lua:GetIntrinsicModifierName()
	return "modifier_item_manta_lua"
end

--------------------------------------------------------------------------------

function item_manta_lua:OnSpellStart()
	
	if IsServer() then
       self:GetCaster():EmitSound("DOTA_Item.Manta.Activate")
	   local nParticle = ParticleManager:CreateParticle("particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	   local duration = self:GetSpecialValueFor("tooltip_illusion_duration")
       local invuln_duration = self:GetSpecialValueFor("invuln_duration")


       local nOutDamage = 0 
       local nIncomeDamage = 100 

       if self:GetCaster():GetAttackCapability()==DOTA_UNIT_CAP_MELEE_ATTACK then
           nOutDamage = self:GetSpecialValueFor("tooltip_damage_outgoing_melee")
           nIncomeDamage =  self:GetSpecialValueFor("tooltip_damage_incoming_melee_total_pct")

       end

       if self:GetCaster():GetAttackCapability()==DOTA_UNIT_CAP_RANGED_ATTACK then
           nOutDamage = self:GetSpecialValueFor("tooltip_damage_outgoing_ranged")
           nIncomeDamage =  self:GetSpecialValueFor("tooltip_damage_incoming_ranged_total_pct")
       end
   
       self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_manta_lua_invulnerable", {duration=invuln_duration})

       Timers:CreateTimer(invuln_duration, function()
		 FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin() + RandomVector(100), true)
	     for i=1,2 do
	   	  CreateIllusion(self:GetCaster(),duration, nIncomeDamage, nOutDamage, self:GetCaster():GetAbsOrigin(), {}, self)
	     end
		 ParticleManager:DestroyParticle(nParticle, false)
		 ParticleManager:ReleaseParticleIndex(nParticle)
	   end)

	end
	
end

--------------------------------------------------------------------------------