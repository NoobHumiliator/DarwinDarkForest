function SubmitTaobaoCode(){
    
    $("#SubmitTaobaoCodeButtonLabel").AddClass("Hidden")
    $("#SubmitTaobaoCodeButtonLoading").RemoveClass("Hidden")
    $("#SubmitTaobaoCodeButton").enabled=false;


    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if ( !playerInfo )
        return;
    var playerId = playerInfo.player_id;

    var code= $("#TaobaoCodeEntry").text;

    GameEvents.SendCustomGameEventToServer('SubmitTaobaoCode', {
        playerId:playerId, code:code
    })
}


function OnChangeEquip(itemName,isEquip) {
    var playerInfo = Game.GetPlayerInfo( Players.GetLocalPlayer() );
    if ( !playerInfo )
        return;
    var playerId = playerInfo.player_id;
    
    var econ_type = CustomNetTables.GetTableValue("econ_type", "econ_type");
    var typeMap=econ_type;

    GameEvents.SendCustomGameEventToServer('ChangeEquip', {
        playerId:playerId, itemName:itemName, isEquip:isEquip, type:typeMap[itemName]
    })
}


function EconDataArrive(){

    var econ_data = CustomNetTables.GetTableValue("econ_data", "econ_data");

    RebuildCollections(econ_data)
}

function ShowTaoBaoQRCode(){

   $("#TaoBaoQRCodeContainer").RemoveClass("Hidden")
}

function CloseTaoBaoQRCode(){

   $("#TaoBaoQRCodeContainer").AddClass("Hidden")
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

    var econ_type = CustomNetTables.GetTableValue("econ_type", "econ_type");
    var typeMap=econ_type;

    
    $( "#LoadingPanel" ).AddClass("Hidden");
    $( "#InventoryRightContainer" ).RemoveClass("Hidden");

    $("#InventorySkinTitle").AddClass("Hidden")
    $("#InventoryImmortalTitle").AddClass("Hidden")
    $("#InventoryParticleTitle").AddClass("Hidden")
    $("#InventoryKillEffectTitle").AddClass("Hidden")
    $("#InventoryKillSoundTitle").AddClass("Hidden")
    
    $("#DrawMutationButton").enabled=false;

    $( "#DnaStorageLabel" ).text=" X "+dnaValue;
    
    if (dnaValue>=50)
    {
        $("#DrawMutationButton").enabled=true;
    }

    data=playerData

    var econRarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
    
    var typeNumberMap={}
    
    typeNumberMap["Immortal"]=0
    typeNumberMap["Skin"]=0
    typeNumberMap["Particle"]=0
    typeNumberMap["KillEffect"]=0
    typeNumberMap["KillSound"]=0


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

        typeNumberMap[typeMap[itemName]] = typeNumberMap[typeMap[itemName]]+1

        //如果已经有此物品，跳过不处理
        if (parentPanel.FindChildTraverse(itemName))
        {
            continue;
        }

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
                
                if (typeMap[thisItemName]=="Particle" || typeMap[thisItemName]=="KillEffect" || typeMap[thisItemName]=="KillSound")
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
    

    //调整面板的高度，适应滚动条
    for(var key in typeNumberMap){
        if (typeNumberMap[key]>0)
        {
            var panelHeight = 277* Math.ceil(typeNumberMap[key]/5);
            $("#Inventory"+key+"Panel").style.height=(panelHeight+"px;");
        }
    }

}


function CloseInventory(){
	$( "#page_inventory" ).ToggleClass("Hidden");
}

function ShowLotteryPage(){
    FindDotaHudElement("page_lottery").ToggleClass("Hidden");
}


function TaobaoCodeResult (keys) {

    
    if ($("#SubmitTaobaoCodeButtonLabel")==undefined)
    {
       return;
    }

    $("#SubmitTaobaoCodeButtonLabel").RemoveClass("Hidden")
    $("#SubmitTaobaoCodeButtonLoading").AddClass("Hidden")
    $("#SubmitTaobaoCodeButton").enabled=true;
    
    $("#TaobaoCodeNotify").RemoveClass("GreenAlert")
    $("#TaobaoCodeNotify").RemoveClass("RedAlert")

    if (keys.type=="1") {
        

        $("#TaobaoCodeNotify").text=$.Localize("TaobaoCodeSuccess")+keys.dna_bonus;
        $("#TaobaoCodeNotify").AddClass("GreenAlert")
    }

    if (keys.type=="2") { 

        $("#TaobaoCodeNotify").text=$.Localize("InvalideTaobaoCode");
        $("#TaobaoCodeNotify").AddClass("RedAlert")
    }
    
    if (keys.type=="3") {

        $("#TaobaoCodeNotify").text=$.Localize("TaobaoCodeOccupied");
        $("#TaobaoCodeNotify").AddClass("RedAlert")
    }
}



(function()
{   
    CustomNetTables.SubscribeNetTableListener("econ_data", EconDataArrive);
    GameEvents.Subscribe( "TaobaoCodeResult", TaobaoCodeResult ); //返回充值信息


})();
