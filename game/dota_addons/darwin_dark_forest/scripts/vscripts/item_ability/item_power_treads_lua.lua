LinkLuaModifier( "modifier_item_power_treads_lua", "item_ability/modifier/modifier_item_power_treads_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_power_treads_lua_0", "item_ability/modifier/modifier_item_power_treads_lua_0", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_power_treads_lua_1", "item_ability/modifier/modifier_item_power_treads_lua_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_power_treads_lua_2", "item_ability/modifier/modifier_item_power_treads_lua_2", LUA_MODIFIER_MOTION_NONE )


item_power_treads_lua = class({})



function item_power_treads_lua:GetIntrinsicModifierName()
  return "modifier_item_power_treads_lua"
end


function item_power_treads_lua:OnSpellStart() --0力 1敏 2智

	 if IsServer() then        

        self.nState =  (self.nState+1)%3
        for i = 0,2 do
            self:GetCaster():RemoveModifierByName("modifier_item_power_treads_lua_"..i)
        end

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_power_treads_lua_"..self.nState, {})
	 end

end

function item_power_treads_lua:GetAbilityTextureName()
  if IsClient() then
    local hCaster = self:GetCaster()
    if hCaster:HasModifier("modifier_item_power_treads_lua_0") then
         return "power_treads_lua_0"
    end
    if hCaster:HasModifier("modifier_item_power_treads_lua_1") then
         return "power_treads_lua_1"
    end
    if hCaster:HasModifier("modifier_item_power_treads_lua_2") then
         return "power_treads_lua_2"
    end
    return "power_treads_lua_2"
  end
end