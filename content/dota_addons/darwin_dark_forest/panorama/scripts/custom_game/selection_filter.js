//保证玩家无法选取自己的英雄

function OnUpdateSelectedUnit()
{
     var unit = Players.GetSelectedEntities(Players.GetLocalPlayer());
     if (unit ==  Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()))
     {
     	var playerCreatureIndex = CustomNetTables.GetTableValue( "player_creature_index", Players.GetLocalPlayer()).creepIndex
     	GameUI.SelectUnit(playerCreatureIndex, false)
     }
}




(function () {

    // Built-In Dota client events
    GameEvents.Subscribe( "dota_player_update_selected_unit", OnUpdateSelectedUnit );
})();