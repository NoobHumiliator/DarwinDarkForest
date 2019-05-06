
var options = {
    scrollDom:null,                         //滚动显示的dom  这里是使用class选择器
    scrollId:null,                          //滚动的dom上的属性号，是用来标记滚动结束获得的id号对应的奖项
    startPosition:1,                        //开始位置
    stopPosition:5,                         //停止位置
    totalCircle:3,                          //滚动的圈数
    speed:0.4,                              //正常速度  （这里的速度就是定时器的时间间隔，间隔越短，速度越快）
    speedUp:0.1,                            //加速的时候速度
    speedDown:0.6,                          //减速的时候速度
    speedUpPosition:3,                      //加速点
    speedDownPosition:5,                    //减速点    
    domNumber:14                             
 };




function BuildLottery(){


	for (var i=1;i<=options.domNumber;i++){

        var itemName = "green";
		var parentPanel= $("#LotteryCell_"+i)
		var newItemPanel = $.CreatePanel("Panel", parentPanel, itemName);

        newItemPanel.BLoadLayoutSnippet("LotteryItem");
        newItemPanel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_unknow");
        newItemPanel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/blank.png");

	}


}



var LotteryInitSpeed=0.4
var LotteryCircle = 0
var LotteryCircleStep = 0
var IsLotteryFinish= false;


function StartLottery(){
    
    //正在滚动，不进行触发
	if(LotteryCircleStep !=0 ) {
        return false;
    }
    var playerId = Game.GetLocalPlayerInfo().player_id;
    GameEvents.SendCustomGameEventToServer( "DrawLottery", {playerId:playerId} );

    Scroll();
}


function CloseLottery(){
    $("#page_lottery").AddClass("Hidden");
}

function Scroll () {

    if(IsLotteryFinish){
        //结束定时任务 恢复初始化参数   
        LotteryCircle=0;
        LotteryCircleStep=0;
        options.speed = LotteryInitSpeed;
        IsLotteryFinish = false;			
        return;
    }

    
    ChangeNext();
    $.Schedule(options.speed,Scroll);
}

//加速
function SpeedUp () {
    if(LotteryCircleStep == options.speedUpPosition){
        options.speed = options.speedUp;
    }
}
function SpeedDown () {

    var tmp1 = options.stopPosition-options.speedDownPosition;
    var tmp2 = options.totalCircle+1;
    if(tmp1<=0){
        tmp1 = options.domNumber + tmp1;
        tmp2 = tmp2-1;
    }

    if(options.startPosition==tmp1 && LotteryCircle==tmp2)
        options.speed = options.speedDown;
}

function ChangeDomClass () {


	var panel= $("#LotteryCell_"+options.startPosition)
    panel.AddClass("Active")
    
    
    if(options.startPosition==1) {
      var lastpanel= $("#LotteryCell_"+options.domNumber)
      lastpanel.RemoveClass("Active")
    } else {
      var lastpanel= $("#LotteryCell_"+(options.startPosition-1))
      lastpanel.RemoveClass("Active")
    }
    
    options.startPosition++;
}



function ChangeNext() {

    LotteryCircleStep++;
    //完成一圈
    if(options.startPosition==options.domNumber+1){
        options.startPosition=1;
        LotteryCircle++;
    }

    if(LotteryCircle==options.totalCircle+1 && options.startPosition==options.stopPosition){
        IsLotteryFinish = true;
    }
    ChangeDomClass();
    SpeedUp();
    SpeedDown();
}


function SetFakeCells(number,level,array){

    var indexs = DrawRandomFromArray(array,number)

    for (var i = indexs.length - 1; i >= 0; i--) {
        var panel = $("#LotteryCell_"+indexs[i])
        var econ_rarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
        
        var temp=[]
        for(var key in econ_rarity){
          if (econ_rarity[key]==level)
          {
            temp.push(key)
          }
        }
        var item_name = temp[Math.floor((Math.random()*temp.length))]
        panel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_"+item_name);
        panel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/"+item_name+".png");
    }

}


function DrawLotteryResultArrive(data)
{   

   $.Msg(data)
   if (data.type==1 || data.type==2)
   {
        var arrayObj = new Object();
        arrayObj.array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]; 
        
        //设置目标位置
        var targetIndex = DrawRandomFromArray(arrayObj.array,1)[0]       
        var targetPanel = $("#LotteryCell_"+targetIndex)
        targetPanel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_"+data.item_name);
        targetPanel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/"+data.item_name+".png");
        
        var econ_rarity = CustomNetTables.GetTableValue("econ_rarity", "econ_rarity");
        var targetLevel=econ_rarity[data.item_name]        
        $.Msg(arrayObj.array)
        //设置假砖块位置 根据真砖块等级 减少假砖块数量
        SetFakeCells(targetLevel==4?0:1,4,arrayObj.array)
        $.Msg(arrayObj.array)
        SetFakeCells(targetLevel==3?1:2,3,arrayObj.array)
        $.Msg(arrayObj.array)
        SetFakeCells(targetLevel==2?3:4,2,arrayObj.array)
        $.Msg(arrayObj.array)
        SetFakeCells(targetLevel==1?6:7,1,arrayObj.array)
        $.Msg(arrayObj.array)
   }
}



(function()
{
    BuildLottery();
    GameEvents.Subscribe( "DrawLotteryResultArrive", DrawLotteryResultArrive ); //持久化服务器对于抽奖处理完毕
})();
