/* 
* @Author: yl
* @Date:   2016-01-04 13:03:37
* @Last Modified by:   yl
* @Last Modified time: 2016-01-07 11:25:17
*/


window.onload=function(){
	var Ohtml = document.documentElement;
	// 页面加载完执行一次
	getSize();
	function getSize(){
		// 获取屏幕的宽度
	var screenWidth = Ohtml.clientWidth;
		
    Ohtml.style.fontSize = screenWidth/(36) +'px';
	}
	window.onresize = function(){
		getSize();
	}
}


$(document).ready(function() {

	//切换我的理财
	$('.myTab li').click(function(event) {
		$(this).addClass('current').siblings().removeClass('current');
		var i=$(this).index();
		$('.detailCon').children('li').eq(i).show().siblings().hide();
	});

	//切换已赎回
	$('.downTab li').click(function(event) {
		$(this).addClass('current').siblings().removeClass('current');
		var i=$(this).index();
		$('.downDetail').children('li').eq(i).show().siblings().hide();
	});
	
});