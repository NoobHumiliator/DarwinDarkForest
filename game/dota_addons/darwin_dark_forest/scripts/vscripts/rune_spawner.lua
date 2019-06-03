if RuneSpawner == nil then
  RuneSpawner = {}
  RuneSpawner.__index = RuneSpawner
end

function RuneSpawner:Init()
  
  RuneSpawner.flTimeInterval=120
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
         
    --根据间隔刷符
    Timers:CreateTimer(RuneSpawner.flTimeInterval, function()
        RuneSpawner:SpawnOneRune()
        return RuneSpawner.flTimeInterval
    end)

end


function RuneSpawner:SpawnOneRune()

   local nDice= RandomInt(1, 6)
   local sType= RuneSpawner.vTypeMap[nDice]
   print("Spawn Rune item_rune_"..sType)
   local hRune = CreateItem("item_rune_"..sType, nil, nil)
   local vVector = GetRandomValidPosition()
   CreateItemOnPositionSync(vVector, hRune)
   local hVisionRevealer = CreateUnitByName( "npc_rune_revealer_"..sType, vVector, false, nil, nil, DOTA_TEAM_NEUTRALS )
   hRune.hVisionRevealer=hVisionRevealer

   local data =
   {
      rune_type = sType
   }
   CustomGameEventManager:Send_ServerToAllClients( "rune_spawned", data )

   Timers:CreateTimer(0.1, function()
        if  hVisionRevealer and not hVisionRevealer:IsNull() and hVisionRevealer:IsAlive() then
          for nTeam = 0, (DOTA_TEAM_COUNT-1) do
              AddFOWViewer(nTeam, vVector, 600, 0.5, false)
          end
          return 0.5
        else
          return nil
        end
   end)
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

       CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerId),"UpdateRadar", {current_exp=hHero.nCustomExp-vEXP_TABLE[hHero.nCurrentCreepLevel],next_level_need=vEXP_TABLE[hHero.nCurrentCreepLevel+1]-vEXP_TABLE[hHero.nCurrentCreepLevel],perk_table=GameMode.vPlayerPerk[nPlayerId] } )
       CustomNetTables:SetTableValue( "player_perk", tostring(nPlayerId), GameMode.vPlayerPerk[nPlayerId] )
       
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

