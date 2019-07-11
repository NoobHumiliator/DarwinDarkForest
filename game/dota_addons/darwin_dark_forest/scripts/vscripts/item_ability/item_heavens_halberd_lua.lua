item_heavens_halberd_lua = class({})
LinkLuaModifier( "modifier_item_heavens_halberd_lua", "item_ability/modifier/modifier_item_heavens_halberd_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_heavens_halberd_lua_debuff", "item_ability/modifier/modifier_item_heavens_halberd_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_heavens_halberd_lua:GetIntrinsicModifierName()
	return "modifier_item_heavens_halberd_lua"
end

--------------------------------------------------------------------------------

function item_heavens_halberd_lua:OnSpellStart()

	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:TriggerSpellAbsorb(self) then
			return nil
	end

	hTarget:EmitSound("DOTA_Item.HeavensHalberd.Activate")
    
    local disarm_melee = self:GetSpecialValueFor( "disarm_melee" )
    local disarm_range = self:GetSpecialValueFor( "disarm_range" )
    
    if hTarget:GetAttackCapability()=DOTA_UNIT_CAP_RANGED_ATTACK then
        hTarget:AddNewModifier(hCaster, self, "modifier_item_heavens_halberd_lua_debuff", {duration=disarm_range})
    end


    if hTarget:GetAttackCapability()=DOTA_UNIT_CAP_MELEE_ATTACK then
       hTarget:AddNewModifier(hCaster, self, "modifier_item_heavens_halberd_lua_debuff", {duration=disarm_melee})
    end

end

--------------------------------------------------------------------------------