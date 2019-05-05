
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
        newItemPanel.FindChildTraverse("lottery_item_title").text = $.Localize("econ_" + itemName);
        newItemPanel.FindChildTraverse("lottery_item_image").SetImage("file://{resources}/images/custom_game/econ/" + itemName + ".png");

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




(function()
{
    BuildLottery();
})();
