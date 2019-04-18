item_enchanted_mango_lua = class({})
LinkLuaModifier( "modifier_item_enchanted_mango_lua", "item_ability/modifier/modifier_item_enchanted_mango_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_enchanted_mango_lua:GetIntrinsicModifierName()
	return "modifier_item_enchanted_mango_lua"
end

--------------------------------------------------------------------------------


function item_enchanted_mango_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		self.replenish_amount = self:GetSpecialValueFor( "replenish_amount" )
        local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		
        self:GetCaster():EmitSound( "DOTA_Item.Mango.Activate")

        hCaster:GiveMana(self.replenish_amount)
        self:SpendCharge()
	end
end
