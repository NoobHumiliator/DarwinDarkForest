var radar_radius=79.18
var perkNameMap = ["element","mystery","durable","fury","decay","hunt"];

function UpdateRadar()
{
   var player_info = CustomNetTables.GetTableValue("player_info", Players.GetLocalPlayer());

   var currentLevelExp =  player_info.current_exp;
   var nextLevelExp =  player_info.next_level_need;
   var current_exp= parseFloat(player_info.current_exp).toFixed(0);


   var text = current_exp + "/" + player_info.next_level_need + $.Localize("#exp");
   $("#LevelProgressLable").text=text;
   $("#ProgressBarLeft").style.width= (player_info.current_exp/player_info.next_level_need*100)+"%";
    
   var element=player_info.perk_table["1"];
   if (element>0)
   {    
        if (element>99) { element = 99 }
        var element_y = (element/100)*radar_radius/2
        var element_x =  element_y*1.732
        $("#RadarDot_1").SetHasClass("Opacity", false);  
        $("#RadarDot_1").style.position= (element_x+73)+"px"+" "+(element_y+73)+"px 0"
   } else {
        $("#RadarDot_1").SetHasClass("Opacity", true);
   }

   var durable=player_info.perk_table["3"];
   if (durable>0)
   {
       if (durable>99) { durable = 99 }
       var durable_y = -1*(durable/100)*radar_radius/2
       var durable_x = -1*durable_y*1.732
       $("#RadarDot_3").SetHasClass("Opacity", false);  
       $("#RadarDot_3").style.position= (durable_x+73)+"px"+" "+(durable_y+73)+"px 0"
   } else {
       $("#RadarDot_3").SetHasClass("Opacity", true);  
   }

   var decay=player_info.perk_table["5"];
   if (decay>0)
   {
        if (decay>99) { decay = 99 }
        var decay_y = (decay/100)*radar_radius/2
        var decay_x = -1*decay_y*1.732
        $("#RadarDot_5").SetHasClass("Opacity", false);  
        $("#RadarDot_5").style.position= (decay_x+73)+"px"+" "+(decay_y+73)+"px 0"
    } else {
        $("#RadarDot_5").SetHasClass("Opacity", true);  
    }

   var mystery=player_info.perk_table["2"];
   if (mystery>0)
   {
        if (mystery>99) { mystery = 99 }
        var mystery_y = -1*(mystery/100)*radar_radius/2
        var mystery_x = mystery_y*1.732
        $("#RadarDot_2").SetHasClass("Opacity", false);
        $("#RadarDot_2").style.position= (mystery_x+73)+"px"+" "+(mystery_y+73)+"px 0"
   } else {
        $("#RadarDot_2").SetHasClass("Opacity", true);  
   }

   var fury=player_info.perk_table["4"]
   if (fury>0)
   {
        if (fury>99) { fury = 99 }
        var fury_y = -1*(fury/100)*radar_radius
        $("#RadarDot_4").SetHasClass("Opacity", false);
        $("#RadarDot_4").style.position= "73px "+(fury_y+73)+"px 0"
   } else {
        $("#RadarDot_4").SetHasClass("Opacity", true);  
   }
   
   var hunt=player_info.perk_table["6"]
   
   if (hunt>0)
   {    
        if (hunt>99) { hunt = 99 }
        var hunt_y =  (hunt/100)*radar_radius
        $("#RadarDot_6").SetHasClass("Opacity", false);
        $("#RadarDot_6").style.position= "73px "+(hunt_y+73)+"px 0"
   } else {
        $("#RadarDot_6").SetHasClass("Opacity", true);  
   }

}


function ShowRadarTooltip(index)
{
    var perk =  CustomNetTables.GetTableValue( "player_info", Players.GetLocalPlayer()).perk_table[index].toFixed(1);

    var title=$.Localize("#"+perkNameMap[index-1])+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='#FF943F'>"+perk+"<font/>";
    var detail="#ui_detail_"+perkNameMap[index-1];

    $.DispatchEvent("DOTAShowTitleTextTooltip", $( "#RadarLabel_"+index), title, detail);
}

function HideRadarTooltip(index)
{
   $.DispatchEvent( "DOTAHideTitleTextTooltip",$( "#RadarLabel_"+index) );
}


function ShowRadarDotTooltip(index)
{
    var perk =  CustomNetTables.GetTableValue( "player_info", Players.GetLocalPlayer()).perk_table[index].toFixed(1);

    var title=$.Localize("#"+perkNameMap[index-1])+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='#FF943F'>"+perk+"<font/>";
    var detail="#ui_detail_"+perkNameMap[index-1];

    $.DispatchEvent("DOTAShowTitleTextTooltip", $( "#RadarDot_"+index), title, detail);
} 

function HideRadarDotTooltip(index)
{
   $.DispatchEvent( "DOTAHideTitleTextTooltip",$( "#RadarDot_"+index) );
}







(function()
{
	//$("#PerkRadarPanel").style.position.x
    CustomNetTables.SubscribeNetTableListener("player_info", UpdateRadar);


    // 根据分辨率 重新定位雷达位置
    var width =Game.GetScreenWidth()
    var height =Game.GetScreenHeight()
    //2.33333 21:9
    //1.777 16:9
    //1.6   16:10
    //1.33  4:3
    var radio=width/height

    if (2.0<radio)
    {
        $("#PerkRadarContainer").style.position="1720px 830px 0"
    }
    if (1.7<radio&&radio<2.0) //16:9
    {
    	$("#PerkRadarContainer").style.position="1400px 830px 0"
    }
	  if ( 1.5<radio&&radio<1.7) //16:10
    {
    	$("#PerkRadarContainer").style.position="1250px 830px 0"
    }
    if ( radio<1.4 )
    {
    	$("#PerkRadarContainer").style.position="1050px 825px 0"
    }
    
})();
