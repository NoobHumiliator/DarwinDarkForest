item_satanic_lua = class({})
LinkLuaModifier( "modifier_item_satanic_lua", "item_ability/modifier/modifier_item_satanic_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_satanic_lua_buff", "item_ability/modifier/modifier_item_satanic_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_satanic_lua:GetIntrinsicModifierName()
	return "modifier_item_satanic_lua"
end

--------------------------------------------------------------------------------

function item_satanic_lua:OnSpellStart()
    if IsServer() then
      local hCaster=self:GetCaster()
      hCaster:EmitSound("DOTA_Item.Satanic.Activate")
      hCaster:AddNewModifier(hCaster, self, "modifier_item_satanic_lua_buff", {duration=self:GetSpecialValueFor("unholy_duration")})
    end
end


