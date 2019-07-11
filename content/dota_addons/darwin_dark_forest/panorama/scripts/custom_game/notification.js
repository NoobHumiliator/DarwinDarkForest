"use strict";


function OnWarnRuneSpawn( key )
{
	$( "#AlertMessage" ).RemoveClass( "Hidden");
	$( "#AlertMessage_Icon" ).SetImage( "file://{images}/custom_game/rune/"+key.rune_type+".png" );
    $( "#AlertMessage_Label" ).text = $.Localize("rune_spawn_" + key.rune_type);
	$.Schedule( 4.5, ClearRuneSpawnMessage );
}


function OnCourierSpawned( key )
{
	$( "#CourierMessage" ).RemoveClass( "Hidden");
	var item_image_name = "file://{images}/items/" + key.item_texture_name.replace( "item_", "" ) + ".png"
	$( "#CourierMessage_Icon" ).SetImage(item_image_name);
    $( "#CourierMessage_Label" ).text = $.Localize("courier_spawn");
	$.Schedule( 4.5, ClearCourierMessage );
}

function OnRingSpawned( key )
{
	$( "#RingMessage" ).RemoveClass( "Hidden");
	$( "#RingMessage_Icon" ).SetImage("file://{images}/custom_game/ring_icon.png");
    $( "#RingMessage_Label" ).text = $.Localize("ring_spawn");
	$.Schedule( 4.5, ClearRingMessage );
}



function ClearRuneSpawnMessage()
{
	$("#AlertMessage").AddClass( "Hidden" );

}

function ClearCourierMessage()
{
	$("#CourierMessage").AddClass( "Hidden" );
}

function ClearRingMessage()
{
	$("#RingMessage").AddClass( "Hidden" );
}



function OnRunePickUp(key)
{
	$( "#PickupMessage").RemoveClass( "Hidden");
    
    var unitName = key.unit_name
    var original = CustomNetTables.GetTableValue( "econ_unit_replace",unitName)
	if (original!= null && original!= undefined)
	{
		unitName=original.sOriginalUnitName;
	}
    
    //Js里面再替换回来
    unitName=unitName.replace("npc_dota_creature_player_", "npc_dota_creature_")

	$( "#PickupMessage_Unit" ).SetImage( "file://{images}/custom_game/creature_portrait/"+unitName+".png" );
   	$( "#PickupMessage_Rune" ).SetImage( "file://{images}/custom_game/rune/"+key.rune_type+".png" );
    
    var teamId=Players.GetTeam(key.player_id)
    var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];

    $( "#PickupMessage_Unit_Text" ).style.color = teamColor;

    var palyerName =  Players.GetPlayerName( key.player_id) 

    $( "#PickupMessage_Unit_Text" ).text=palyerName+"("+$.Localize("" + key.unit_name)+")";
    $( "#PickupMessage_Rune_Text" ).text=$.Localize("rune_pickup_" + key.rune_type);
    
    $.Schedule( 4, ClearRunePickUpMessage );

}

function ClearRunePickUpMessage()
{
	$( "#PickupMessage" ).AddClass( "Hidden");   
}





(function () {
	GameEvents.Subscribe( "warn_rune_spawn", OnWarnRuneSpawn );
	GameEvents.Subscribe( "rune_pick_up", OnRunePickUp );
	GameEvents.Subscribe( "courier_spawned", OnCourierSpawned );
	GameEvents.Subscribe( "ring_spawned", OnRingSpawned );
})();

