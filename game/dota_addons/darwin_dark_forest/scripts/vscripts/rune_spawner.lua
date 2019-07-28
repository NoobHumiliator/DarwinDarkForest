if RuneSpawner == nil then
  RuneSpawner = {}
  RuneSpawner.__index = RuneSpawner
end

function RuneSpawner:Init()
  

  ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(RuneSpawner, "OnGameRulesStateChange"), self)
  ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( RuneSpawner, "OnItemPickUp"), self )

  RuneSpawner.vTypeMap={

      [1]="element",
      [2]="mystery",
      [3]="durable",
      [4]="fury",
      [5]="decay",
      [6]="hunt"

  }

  RuneSpawner.vRuneMap={

      ["item_rune_element"]=1,
      ["item_rune_mystery"]=2,
      ["item_rune_durable"]=3,
      ["item_rune_fury"]=4,
      ["item_rune_decay"]=5,
      ["item_rune_hunt"]=6,

  }

  RuneSpawner.vRuneSoundMap={

      ["item_rune_element"]="Rune.DD",
      ["item_rune_mystery"]="Rune.Arcane",
      ["item_rune_durable"]="Rune.Illusion",
      ["item_rune_fury"]="Rune.Haste",
      ["item_rune_decay"]="Rune.Regen",
      ["item_rune_hunt"]="Rune.Invis",

  }

end


function RuneSpawner:OnGameRulesStateChange()

  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    self:Begin()
  end

end

function RuneSpawner:Begin()
         
    --根据人数 调整刷符间隔
    
    if GameRules.nTotalHeroNumber==nil then
          CountAverageLevel()
    end

    Timers:CreateTimer(600/GameRules.nTotalHeroNumber, function()
        RuneSpawner:WarnRuneSpawn()
        -- 1人10分钟  10人60秒 12人50秒
        return 600/GameRules.nTotalHeroNumber
    end)
end


function RuneSpawner:WarnRuneSpawn()

   local nDice= RandomInt(1, 6)
   local sType= RuneSpawner.vTypeMap[nDice]
   local vVector = GetRandomValidPosition()


   local hVisionRevealer = CreateUnitByName( "npc_rune_revealer_"..sType, vVector, false, nil, nil, DOTA_TEAM_NEUTRALS )
   hVisionRevealer.sType=sType
   hVisionRevealer.vVector=vVector

   local data =
   {
      rune_type = sType
   }
   CustomGameEventManager:Send_ServerToAllClients( "warn_rune_spawn", data )

   for nTeam = 0, (DOTA_TEAM_COUNT-1) do
       MinimapEvent( nTeam, hVisionRevealer, hVisionRevealer:GetAbsOrigin().x, hVisionRevealer:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 15 )
   end


   Timers:CreateTimer(0.1, function()
        if  hVisionRevealer and not hVisionRevealer:IsNull() and hVisionRevealer:IsAlive() then
          for nTeam = 0, (DOTA_TEAM_COUNT-1) do
              AddFOWViewer(nTeam, vVector, 850, 0.5, false)
          end
          return 0.5
        else
          return nil
        end
   end)

end


function RuneSpawner:SpawnRune(hVisionRevealer)

   local sType=hVisionRevealer.sType
   local vVector=hVisionRevealer.vVector

   local hRune = CreateItem("item_rune_"..sType, nil, nil)
   CreateItemOnPositionSync(vVector, hRune)
   hRune.hVisionRevealer=hVisionRevealer

end


function RuneSpawner:OnItemPickUp(event)
   
   local hItem = EntIndexToHScript( event.ItemEntityIndex )
   local hOwner = EntIndexToHScript( event.UnitEntityIndex )
   
   --神符拾取
   if  hItem.hVisionRevealer and not hItem.hVisionRevealer:IsNull() and hItem.hVisionRevealer:IsAlive() then

       local nPlayerId = hOwner:GetOwner():GetPlayerID()
       local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)
       local nType = RuneSpawner.vRuneMap[hItem:GetAbilityName()]
       EmitGlobalSound(RuneSpawner.vRuneSoundMap[hItem:GetAbilityName()])

       GameMode.vPlayerPerk[nPlayerId][nType]=GameMode.vPlayerPerk[nPlayerId][nType]+ 20
       
       if GameMode.vPlayerPerk[nPlayerId][nType]>100 then
          GameMode.vPlayerPerk[nPlayerId][nType]=100
       end

       CustomNetTables:SetTableValue( "player_info", tostring(nPlayerId), {current_exp=hHero.nCustomExp-vEXP_TABLE[hHero.nCurrentCreepLevel],next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )       

       local data =
       {
          rune_type = RuneSpawner.vTypeMap[nType],
          unit_name = hOwner:GetUnitName(),
          player_id = nPlayerId
       }

       CustomGameEventManager:Send_ServerToAllClients( "rune_pick_up", data )


       UTIL_Remove ( hItem )
       UTIL_Remove ( hItem.hVisionRevealer )
   end

end

