//保证玩家无法选取自己的英雄

function OnUpdateSelectedUnit()
{
     var unit = Players.GetSelectedEntities(Players.GetLocalPlayer());
     var creepIndex = CustomNetTables.GetTableValue( "player_creature_index", Players.GetLocalPlayer()).creepIndex
     if ( Entities.IsValidEntity(creepIndex) && unit[0] ==  Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())  )
     {  
     	GameUI.SelectUnit(creepIndex, false)
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




(function () {

    // Built-In Dota client events
    GameEvents.Subscribe( "dota_player_update_selected_unit", OnUpdateSelectedUnit );
    CustomNetTables.SubscribeNetTableListener( "player_creature_index", OnPlayerCreatureChange );


})();