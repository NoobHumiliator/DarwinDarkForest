item_rod_of_atos_lua = class({})
LinkLuaModifier( "modifier_item_rod_of_atos_lua", "item_ability/modifier/modifier_item_rod_of_atos_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_rod_of_atos_lua_debuff", "item_ability/modifier/modifier_item_rod_of_atos_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_rod_of_atos_lua:GetIntrinsicModifierName()
	return "modifier_item_rod_of_atos_lua"
end

--------------------------------------------------------------------------------


function item_rod_of_atos_lua:OnSpellStart()
	local hCaster=self:GetCaster()

	hCaster:EmitSound("DOTA_Item.RodOfAtos.Cast")

    local vProjectile =
	{
		Target 				= self:GetCursorTarget(),
		Source 				= self:GetCaster(),
		Ability 			= self,
		EffectName 			= "particles/items2_fx/rod_of_atos_attack.vpcf",
		iMoveSpeed			= 1500,
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


function item_rod_of_atos_lua:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end
	
	if hTarget and not hTarget:IsMagicImmune() then
		
		if hTarget:TriggerSpellAbsorb(self) then 
			return nil 
		end

		hTarget:EmitSound("DOTA_Item.RodOfAtos.Target")
		
		hTarget:AddNewModifier(hCaster, self, "modifier_item_rod_of_atos_lua_debuff", {duration = self:GetSpecialValueFor("duration")})

	end
end