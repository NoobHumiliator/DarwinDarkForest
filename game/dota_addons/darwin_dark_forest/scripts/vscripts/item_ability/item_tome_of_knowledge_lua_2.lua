item_tome_of_knowledge_lua_2 = class({})


function item_tome_of_knowledge_lua_2:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()

        hCaster:EmitSound("Item.TomeOfKnowledge")
        self.xp_bonus = self:GetSpecialValueFor( "xp_bonus" )

        self:SpendCharge()
        local nPlayerId = hCaster:GetMainControllingPlayer()
        local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
        
        if hHero then
          hHero.nCustomExp=hHero.nCustomExp+self.xp_bonus
          --计算等级
          local nNewLevel=CalculateNewLevel(hHero)
          --如果 升级
       	  if nNewLevel~=hHero.nCurrentCreepLevel then
       	   	 hHero.nCurrentCreepLevel=nNewLevel
	         LevelUpAndEvolve(nPlayerId,hHero)
	         end
            --更新UI显示
           CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
           CustomNetTables:SetTableValue( "player_info", tostring(nPlayerId), {current_exp=hHero.nCustomExp-vEXP_TABLE[nNewLevel],next_level_need=vEXP_TABLE[nNewLevel+1]-vEXP_TABLE[nNewLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       
        end
	end
end
