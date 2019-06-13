function FindDotaHudElement(id){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}

function OpenRank(){
	FindDotaHudElement("page_rank").ToggleClass("Hidden");
}

function OpenInventory(){
    FindDotaHudElement("page_inventory").ToggleClass("Hidden");  
}

function OpenInstruction(){
    FindDotaHudElement("page_instruction").ToggleClass("Hidden");  
}

function CloseInstruction(){
    FindDotaHudElement("page_instruction").AddClass("Hidden")
}   



function TipsOver(message, pos){
    $.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize(message));
}

function TipsOut(){
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}




(function()
{
    $.Schedule(6, function(){
      TipsOver('TopMenuIcon_Guide_message','TopMenuIcon_Guide')
    });

    $.Schedule(10, function(){
      TipsOver('TopMenuIcon_Rank_message','TopMenuIcon_Rank')
    });

    $.Schedule(14, function(){
      TipsOver('TopMenuIcon_Inventory_message','TopMenuIcon_Inventory')
    });

    $.Schedule(18, function(){
      TipsOut()
    });
    
    
})();
