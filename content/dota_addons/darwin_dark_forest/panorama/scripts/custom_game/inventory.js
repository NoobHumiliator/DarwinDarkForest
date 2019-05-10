
var typeMap = { 
    
    "gold_crawl_zombie":"Skin",
    "gold_zombie":"Skin",


    "shearing_deposition":"Immortal",
    "glare_of_the_tyrant":"Immortal",
    "golden_scavenging_guttleslug":"Immortal",
    


    "green":"Particle",
    "lava_trail":"Particle",
    "paltinum_baby_roshan":"Particle",
    "legion_wings":"Particle",
    "legion_wings_vip":"Particle",
    "legion_wings_pink":"Particle",
    "darkmoon":"Particle",
    "sakura_trail":"Particle",

    "sf_wings":"KillEffect",
    "huaji":"KillEffect",
    "jibururen_mark":"KillEffect",
    "question_mark":"KillEffect",
}



function SubmitKey(){

	
}


function OnChangeEquip(itemName,isEquip) {
    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if ( !playerInfo )
        return;
    var playerId = playerInfo.player_id;
    GameEvents.SendCustomGameEventToServer('ChangeEquip', {
        playerId:playerId, itemName:itemName, isEquip:isEquip, type:typeMap[itemName]
    })
}


function EconDataArrive(){

    var econ_data = CustomNetTables.GetTableValue("econ_data", "econ_data");

    RebuildCollections(econ_data)
}





function RebuildCollections(econ_data){


    if (econ_data === undefined) return;

    var playerId = Game.GetLocalPlayerInfo().player_id;     //玩家ID
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    steam_id = ConvertToSteamId32(steam_id);

    var playerData = econ_data["econ_info"][steam_id]
    var dnaValue = econ_data["dna"][steam_id]

    if (playerData === undefined) return;

    if ( $( "#LoadingPanel" ) == undefined) return;
    
    $( "#LoadingPanel" ).AddClass("Hidden");
    $( "#InventoryRightContainer" ).RemoveClass("Hidden");

    $("#InventorySkinPanel").RemoveAndDeleteChildren();
    $("#InventoryImmortalPanel").RemoveAndDeleteChildren();
    $("#InventoryParticlePanel").RemoveAndDeleteChildren();
    $("#InventoryKillEffectPanel").RemoveAndDeleteChildren();

    $("#InventorySkinTitle").AddClass("Hidden")
    $("#InventoryImmortalTitle").AddClass("Hidden")
    $("#InventoryParticleTitle").AddClass("Hidden")
    $("#InventoryKillEffectTitle").AddClass("Hidden")
    
    $("#DrawMutationButton").enabled=false;

    $( "#DnaStorageLabel" ).text=" X "+dnaValue;
    
    if (dnaValue>=50)
    {
        $("#DrawMutationButton").enabled=true;
    }

    data=playerData

    var econRarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");

    for (var index in data){
        
        var itemName=data[index].name;
        
        //过滤没有name的数据
        if (data[index].name == undefined)
        {
            continue;
        }

        var isEquip = (data[index].equip=="true")


        var parentPanel= $("#Inventory"+typeMap[itemName]+"Panel")

        $("#Inventory"+typeMap[itemName]+"Title").RemoveClass("Hidden")

        var newItemPanel = $.CreatePanel("Panel", parentPanel, itemName);
        newItemPanel.BLoadLayoutSnippet("CollectionItem");
        
        var rarityLevel = econRarity[itemName]
        
        if (rarityLevel==1) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("rarity_normal");
        }
        if (rarityLevel==2) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("rarity_rare");
            newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Rare")
            newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleRare")
        }
        if (rarityLevel==3) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("rarity_mythical");
            newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Mythical")
            newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleMythical")
        }
        if (rarityLevel==4) {
            newItemPanel.FindChildTraverse("collection_item_rarity").text = $.Localize("rarity_immortal");
            newItemPanel.FindChildTraverse("collection_item_rarity").AddClass("Rarity_Immortal")
            newItemPanel.FindChildTraverse("collection_item_title_panel").AddClass("TitleImmortal")
        }

        newItemPanel.FindChildTraverse("collection_item_title").text = $.Localize("econ_" + itemName);

        newItemPanel.FindChildTraverse("collection_item_image").SetImage("file://{resources}/images/custom_game/econ/" + itemName + ".png");

        if (isEquip){
            newItemPanel.FindChildTraverse("button_equip").visible = false;
        }else{
            newItemPanel.FindChildTraverse("button_remove").visible = false;
        }
        //注意此处写法，不会导致局部变量歧义
        (function(thisItemPanel,thisItemName){
        newItemPanel.FindChildTraverse("button_equip").SetPanelEvent("onactivate", 
           function(){
                
                if (typeMap[thisItemName]=="Particle" || typeMap[thisItemName]=="KillEffect")
                {
                    for (var i = thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonEquip").length - 1; i >= 0; i--) {
                        thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonEquip")[i].visible=true;
                    }                
                    for (var i = thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonRemove").length - 1; i >= 0; i--) {
                        thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonRemove")[i].visible=false;
                    }
                }

	            thisItemPanel.FindChildTraverse("button_equip").visible=false;
	            thisItemPanel.FindChildTraverse("button_remove").visible=true;
	            OnChangeEquip(thisItemName,true);

           });
	    newItemPanel.FindChildTraverse("button_remove").SetPanelEvent("onactivate", 
        	function() {
                
	            thisItemPanel.FindChildTraverse("button_equip").visible=true;
	            thisItemPanel.FindChildTraverse("button_remove").visible=false;
	            OnChangeEquip(thisItemName,false);
            });
        })(newItemPanel,itemName);
    }
}


function CloseInventory(){
	$( "#page_inventory" ).ToggleClass("Hidden");
}

function ShowLotteryPage(){
    FindDotaHudElement("page_lottery").ToggleClass("Hidden");
}




(function()
{   
    CustomNetTables.SubscribeNetTableListener("econ_data", EconDataArrive);
})();
