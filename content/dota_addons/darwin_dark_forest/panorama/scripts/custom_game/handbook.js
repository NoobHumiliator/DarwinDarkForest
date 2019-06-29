var prefixMap={
 "nFury":"<font color='#eb6877'>",
 "nDurable":"<font color='#f8b551'>",
 "nElement":"<font color='#00a0e9'>",
 "nHunt":"<font color='#999999'>",
 "nDecay":"<font color='#b3d465'>",
 "nMystery":"<font color='#e9c2ff'>",
}



function SwitchPanel(key){

    var pageData= CustomNetTables.GetTableValue( "hand_book", key)

    var parentPanel= FindDotaHudElement("HandBookContainer")
    parentPanel.RemoveAndDeleteChildren()

    var columnIndex=1

    var keyList = [];

    for (var key in pageData) {
        var keyData = {}
        keyData.key=key
        keyData.number=Object.keys(pageData[key]).length
        keyList.push( keyData );
    }

    keyList.sort(function(a,b){
        return a.number < b.number;
    })
    
	for (var index in keyList) {
        var key1=keyList[index].key
		for (var key2 in pageData[key1]) {
			 var creaturePanel = $.CreatePanel("Panel", parentPanel, pageData[key1][key2].unit_name);
             creaturePanel.BLoadLayoutSnippet("CreatureItem");
             creaturePanel.FindChildTraverse("CreatureIcon").SetImage( "file://{images}/custom_game/creature_portrait/"+pageData[key1][key2].unit_name+".png" );
             creaturePanel.FindChildTraverse("CreatureName").text=$.Localize("" + pageData[key1][key2].unit_name);
		     var ability1=creaturePanel.FindChildTraverse("Ability1")
		     if (pageData[key1][key2].ability_data.ability_1!=undefined)
		     {
		        ability1.abilityname=pageData[key1][key2].ability_data.ability_1;
                ability1.SetHasClass( "AbilityImage", true );
                ability1.SetPanelEvent( "onmouseover", ShowAbilityTooltip (ability1) );
                ability1.SetPanelEvent( "onmouseout",  HideAbilityTooltip (ability1) );
             } else{

             	ability1.AddClass("Hidden")
             }

             var ability2=creaturePanel.FindChildTraverse("Ability2")
             if (pageData[key1][key2].ability_data.ability_2!=undefined)
		     {
		     	var ability2=creaturePanel.FindChildTraverse("Ability2")
                ability2.abilityname=pageData[key1][key2].ability_data.ability_2;
                ability2.SetHasClass( "AbilityImage", true );
                ability2.SetPanelEvent( "onmouseover", ShowAbilityTooltip (ability2) );
                ability2.SetPanelEvent( "onmouseout",  HideAbilityTooltip (ability2) );
             } else {

             	ability2.AddClass("Hidden")

             }

             var ability3=creaturePanel.FindChildTraverse("Ability3")
             if (pageData[key1][key2].ability_data.ability_3!=undefined)
		     {
                ability3.abilityname=pageData[key1][key2].ability_data.ability_3;
                ability3.SetHasClass( "AbilityImage", true );
                ability3.SetPanelEvent( "onmouseover", ShowAbilityTooltip (ability3) );
                ability3.SetPanelEvent( "onmouseout",  HideAbilityTooltip (ability3) );
             } else {

             	ability3.AddClass("Hidden")

             }


             creaturePanel.style.position= ((columnIndex-1)*165)+"px"+" "+((key2-1)*100)+"px 0"

             var index=1
             for (var key in pageData[key1][key2].perk_data) {
             	 var perkLable = creaturePanel.FindChildTraverse("CreaturePerk"+index)
                 perkLable.html=true;
	             perkLable.text = prefixMap[key]+$.Localize("" + key)+":"+pageData[key1][key2].perk_data[key]+"</font>";
                 index=index+1
             }
		}
		columnIndex=columnIndex+1
	}


}


function CloseHandBook(){
    $("#PageHandBook").AddClass("Hidden");
    FindDotaHudElement("ScoreboardContainer").style.opacity=1
}


(function()
{
    
})();
