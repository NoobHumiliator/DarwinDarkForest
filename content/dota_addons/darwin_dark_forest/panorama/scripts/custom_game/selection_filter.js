//保证玩家无法选取自己的英雄

function OnUpdateSelectedUnit()
{
     var unit = Players.GetSelectedEntities(Players.GetLocalPlayer());
     var creepData= CustomNetTables.GetTableValue( "player_creature_index", Players.GetLocalPlayer())
     
     if (creepData!=undefined &&  creepData.creepIndex!=undefined && Entities.IsValidEntity(creepData.creepIndex))
     {
         //如果选中的是自己的英雄（F1）
         if ( unit[0]  ==  Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())  )
         {  
            GameUI.SelectUnit(creepData.creepIndex, false)
         }
     //数据异常，向后台重新请求数据
     } else {
        GameEvents.SendCustomGameEventToServer('RequestCreatureIndex', {playerId:Players.GetLocalPlayer()})
     }
}

//如果玩家产生的新的单位,强制选中
function OnPlayerCreatureChange(tableName,key,value)
{    
     if (key==Players.GetLocalPlayer())
     {
         GameUI.SelectUnit(value.creepIndex, false)
     }
}


//点击头像选中单位
function UpdateSelect(keys)
{    
     GameUI.SelectUnit(keys.creepIndex, false)
}




(function () {

    // Built-In Dota client events
    GameEvents.Subscribe( "dota_player_update_selected_unit", OnUpdateSelectedUnit );
    GameEvents.Subscribe( "UpdateSelect", UpdateSelect );
    CustomNetTables.SubscribeNetTableListener( "player_creature_index", OnPlayerCreatureChange );
   
})();