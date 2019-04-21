function FindDotaHudElement(id){
    var hudRoot;
    for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
        hudRoot = panel;
    }
    var comp = hudRoot.FindChildTraverse(id);
    return comp;
}

function OpenGuide(){

}

function OpenRank(){
	FindDotaHudElement("page_rank").ToggleClass("Hidden");
}

function OpenInventory(){

}


function TipsOver(message, pos){
    $.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize(message));
}

function TipsOut(){
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}

function OpenGuide()
{
    

}



(function()
{
    
})();
