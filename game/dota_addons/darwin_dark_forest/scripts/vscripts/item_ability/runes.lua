function PickUpRune( event )
	local hCaster = event.caster
	local hAbility = event.ability
    local nType = tonumber(event.Type)
    local nPerkValue = tonumber(event.Perk_Value)
    
    if hCaster and hCaster.GetOwner and hCaster:GetOwner() and hCaster:GetOwner().GetPlayerID then

        --print("456"..hAbility:GetContainer().hVisionRevealer:GetUnitName())

	    local nPlayerId = hCaster:GetOwner():GetPlayerID()
	    local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
	    GameMode.vPlayerPerk[nPlayerId][nType]=GameMode.vPlayerPerk[nPlayerId][nType]+ nPerkValue
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[hHero.nCurrentCreepLevel],next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
        CustomNetTables:SetTableValue( "player_info", tostring(nPlayerId), {current_exp=hHero.nCustomExp-vEXP_TABLE[hHero.nCurrentCreepLevel],next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       
    end
end