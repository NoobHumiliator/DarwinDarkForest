item_ethereal_blade_lua = class({})
LinkLuaModifier( "modifier_item_ethereal_blade_lua", "item_ability/modifier/modifier_item_ethereal_blade_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ethereal_blade_lua_debuff", "item_ability/modifier/modifier_item_ethereal_blade_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_ethereal_blade_lua:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua"
end

--------------------------------------------------------------------------------

function item_ethereal_blade_lua:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor("duration")

		self:GetCaster():EmitSound("DOTA_Item.EtherealBlade.Activate")

	    local vProjectile =
		{
				Target 				= self:GetCursorTarget(),
				Source 				= self:GetCaster(),
				Ability 			= self,
				EffectName 			= "particles/items_fx/ethereal_blade.vpcf",
				iMoveSpeed			= 1275,
				vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 20,
				bProvidesVision 	= false,
		}
		
		ProjectileManager:CreateTrackingProjectile(vProjectile)
	end
end


function item_ethereal_blade_lua:OnProjectileHit(hTarget, location)
	if IsServer() then 
	
		if hTarget and not hTarget:IsMagicImmune() then

			if hTarget:TriggerSpellAbsorb(self) then 
				return nil 
			end
			
			hTarget:EmitSound("DOTA_Item.EtherealBlade.Target")
				
			if hTarget:GetTeam() == self:GetCaster():GetTeam() then
					hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_ethereal_blade_lua_debuff", {duration = self.duration})
			else
					hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_ethereal_blade_lua_debuff", {duration = self.duration})								
					local damageTable = {
						victim 			= hTarget,
						damage 			= self:GetCaster():GetAttackDamage()*2+self:GetSpecialValueFor("blast_damage_base"),
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self
					}								
					ApplyDamage(damageTable)						
			end
	    end
	end
end