(function()
{
	//$("#PerkRadarPanel").style.position.x
	$.Msg( $("#PerkRadarPanel").actuallayoutwidth );
	$.Msg( $("#PerkRadarPanel").actualyoffset      );
    
    //重新定位雷达位置，确定中心坐标
    var width =Game.GetScreenWidth()
    var height =Game.GetScreenHeight()
    //2.33333 21:9
    //1.777 16:9
    //1.6   16:10
    //1.33  4:3
    var radio=width/height
    var x=1430;
    var y=830;
    var perk_radar_panel_size=160;

    if (2.0<radio)
    {
        $("#PerkRadarContainer").style.position="1720px 830px 0"
        x=1750;
    }
    if (1.7<radio&&radio<2.0) //16:9
    {
    	$("#PerkRadarContainer").style.position="1400px 830px 0"
    	x=1430
    }
	if ( 1.5<radio&&radio<1.7)
    {
    	$("#PerkRadarContainer").style.position="1100px 830px 0"
    	x=1130
    }
    if ( radio<1.4 )
    {
    	$("#PerkRadarContainer").style.position="900px 830px 0"
    	x=930
    }
    var center_y=x+0.5*perk_radar_panel_size;
    var center_x=y-0.5*perk_radar_panel_size;
    


    //$.Msg( "style.width"+$("#PerkRadarPanel").style );
    //$.Msg( $("#PerkRadarPanel").style);
})();
