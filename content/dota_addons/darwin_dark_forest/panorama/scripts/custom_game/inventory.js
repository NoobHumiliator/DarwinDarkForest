
var typeMap = { 
    
    "gold_crawl_zombie":"skin",
    "gold_zombie":"skin",

    "green":"particle",
    "lava_trail":"particle",
    "paltinum_baby_roshan":"particle",
    "legion_wings":"particle",
    "legion_wings_vip":"particle",
    "legion_wings_pink":"particle",
    "darkmoon":"particle",
    "sakura_trail":"particle",

    "sf_wings":"kill_effect",
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


function RebuildCollections(){

    var data = CustomNetTables.GetTableValue("econ_data", "econ_data");
    if (data === undefined) return;

    var playerId = Game.GetLocalPlayerInfo().player_id;     //玩家ID
    var steam_id = Game.GetPlayerInfo(playerId).player_steamid;
    steam_id = ConvertToSteamId32(steam_id);
    
    $("#InventorySkinPanel").RemoveAndDeleteChildren();
    $("#InventoryImmortalPanel").RemoveAndDeleteChildren();
    $("#InventoryParticlePanel").RemoveAndDeleteChildren();
    $("#InventoryKillEffectPanel").RemoveAndDeleteChildren();

    $("#InventorySkinTitle").AddClass("Hidden")
    $("#InventoryImmortalTitle").AddClass("Hidden")
    $("#InventoryParticleTitle").AddClass("Hidden")
    $("#InventoryKillEffectTitle").AddClass("Hidden")

    data=data[steam_id]

    for (var index in data){
        
        var itemName=data[index].name;
        var isEquip = (data[index].equip=="true")

        var parentPanel= $("#Inventory"+typeMap[itemName]+"Panel")
        $("#Inventory"+typeMap[itemName]+"Title").RemoveClass("Hidden")

        var newItemPanel = $.CreatePanel("Panel", parentPanel, itemName);
        newItemPanel.BLoadLayoutSnippet("CollectionItem");
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
                
                for (var i = thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonEquip").length - 1; i >= 0; i--) {
                    thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonEquip")[i].visible=true;
                }                
                for (var i = thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonRemove").length - 1; i >= 0; i--) {
                    thisItemPanel.GetParent().FindChildrenWithClassTraverse("ButtonRemove")[i].visible=false;
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

function DrawMutation(){
}




(function()
{   RebuildCollections();
    CustomNetTables.SubscribeNetTableListener("econ_data", RebuildCollections);
})();
