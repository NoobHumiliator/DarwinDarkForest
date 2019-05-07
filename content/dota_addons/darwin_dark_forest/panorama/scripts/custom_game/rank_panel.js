function CloseRank(){
     $( "#page_rank" ).ToggleClass("Hidden");
}


function refreshTopPanel(gamemode, data) {
	var parent = $("#" + gamemode);
	parent.RemoveAndDeleteChildren();
	for (var index in data){
		var player = data[index];
		var rating = player.rating;
        
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
	currentSeason.SetDialogVariable ("year", now.getFullYear().toString());
	currentSeason.SetDialogVariableInt("month",now.getMonth() + 1);

	CustomNetTables.SubscribeNetTableListener("rank_data", RebuildRank);
})();
