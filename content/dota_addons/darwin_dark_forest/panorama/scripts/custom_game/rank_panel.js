


function refreshTopPanel(gamemode, data) {
	var parent = $("#" + gamemode);
	parent.RemoveAndDeleteChildren();
	for (var index in data){
		var player = data[index];
		var rating = player.rating;
        
        //将秒数转为 时分秒
        $.Msg("rating"+rating)
        if (gamemode=="pve_mode_players")
        {
        	rating=FormatSeconds(rating)
        }

		var steamid = player.player_steam_id;
		var m_PlayerPanel = $.CreatePanel("Panel", parent, "");
		m_PlayerPanel.BLoadLayoutSnippet("LadderPlayer");
        var steamid64 = '765' + (parseInt(steamid) + 61197960265728).toString();
		m_PlayerPanel.FindChildTraverse("player_avatar").steamid = steamid64;
        m_PlayerPanel.FindChildTraverse("player_user_name").steamid = steamid64;
        m_PlayerPanel.FindChildTraverse("rank_text").text = rating;
        m_PlayerPanel.FindChildTraverse("rank_index").text = index;
	}
}

function FormatSeconds(value) {
    var theTime = parseInt(value);// 秒
    var theTime1 = 0;// 分
    var theTime2 = 0;// 小时
    if(theTime > 60) {
        theTime1 = parseInt(theTime/60);
        theTime = parseInt(theTime%60);
            if(theTime1 > 60) {
            theTime2 = parseInt(theTime1/60);
            theTime1 = parseInt(theTime1%60);
            }
    }
        var result = ""+parseInt(theTime)+"\"";
        if(theTime1 > 0) {
           result = ""+parseInt(theTime1)+"\'"+result;
        }
        if(theTime2 > 0) {
          result = ""+parseInt(theTime2)+":"+result;
        }
    return result;
}


function RebuildRank(){
	var rank_data = CustomNetTables.GetTableValue("rank_data", "rank_data");
	if (rank_data === undefined) return;
	refreshTopPanel('pve_mode_players', rank_data['pve'])	
	refreshTopPanel('solo_mode_players', rank_data['solo'])	
	refreshTopPanel('three_player_mode_players', rank_data['three_player'])	
}

(function(){
	RebuildRank();
	var now = new Date();
	var currentSeason = $("#current_season");
	currentSeason.SetDialogVariable ("year", toString(now.getFullYear()));
	currentSeason.SetDialogVariableInt("month",now.getMonth() + 1);

	CustomNetTables.SubscribeNetTableListener("rank_data", RebuildRank);
})();
