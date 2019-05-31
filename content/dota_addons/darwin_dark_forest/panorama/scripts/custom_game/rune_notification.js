"use strict";




function OnRuneSpawned( key )
{
	$( "#AlertMessage" ).SetHasClass( "ShowMessage", true );
	$( "#AlertMessage_Icon" ).SetImage( "file://{images}/custom_game/rune/"+key.rune_type+".png" );
    $( "#AlertMessage_Label" ).text = $.Localize("rune_spawn_" + itemName);
	$.Schedule( 3, ClearRuneSpawnMessage );
}


function ClearRuneSpawnMessage()
{
	$( "#AlertMessage" ).SetHasClass( "ShowMessage", false );
}





(function () {
	GameEvents.Subscribe( "rune_spawned", OnRuneSpawned );
	GameEvents.Subscribe( "rune_pick_up", OnRunePickUp );
})();

