item_black_king_bar_lua = class({})
LinkLuaModifier( "modifier_item_black_king_bar_lua", "item_ability/modifier/modifier_item_black_king_bar_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_black_king_bar_lua_buff", "item_ability/modifier/modifier_item_black_king_bar_lua_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_black_king_bar_lua:GetIntrinsicModifierName()
	return "modifier_item_black_king_bar_lua"
end

--------------------------------------------------------------------------------

function item_black_king_bar_lua:OnSpellStart()
	
	if IsServer() then
       	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetCaster())
       	local duration = self:GetSpecialValueFor("duration")
        local max_level = self:GetSpecialValueFor("max_level")

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_black_king_bar_lua_buff", {Duration = duration})
	    
	    local nLevel = self:GetLevel()
	    if nLevel<max_level then
           self:SetLevel(nLevel+1)
	    end
	end
	
end

--------------------------------------------------------------------------------