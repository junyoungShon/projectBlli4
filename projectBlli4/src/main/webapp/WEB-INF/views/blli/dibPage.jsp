<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
.detail_list th {
	background-color: #FD9595; 
	border-top: 2px solid red;
}
.dib_mid_category {
	width: 1000px;
	margin: auto;
	font-size:15px;
	font-weight:bold;
	font-family:'Nanum Barun Gothic';
	line-height:30px;
	margin-top: 65px;
}
.dib_mid_category a:HOVER {
	color: #ff7f50;
}
.detail_list.fl, .detail_list.fr{width:500px; height:300px; margin:0 auto; position:relative;}
.header {
	position: absolute;
    left: 0;
    top: 0;
    width: 410px;
    height: 42px;
    background: #FD9595;
    margin-top: 62px;
    margin-left: 20px;
    border-top: 3px solid red;
}
.body{overflow-x:hidden; overflow-y:scroll; width:100%; height:100%;}
table{background-color: white; width: 100%; overflow-x: hidden; overflow-y: scroll;}
table th{height:30px;}
.th-inner {    
	position: absolute;
    top: 0;
    line-height: 30px;
    text-align: center;
    margin-top: 70px;
    width: 16%;
}
</style>
<!-- bxSlider Javascript file -->
<script src="${initParam.root}js/jquery.bxslider.min.js"></script>
<!-- bxSlider CSS file -->
<link href="${initParam.root}css/jquery.bxslider.css" rel="stylesheet" />
<script src='http://connect.facebook.net/en_US/all.js'></script>
<script src="https://developers.kakao.com/sdk/js/kakao.story.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="/js/kakaolink.js"></script>
<script>
FB.init({appId: "476938162497817", status: true, cookie: true});
	
function postToFeed(smallProduct, smallProductMainPhotoLink) {
	alert(smallProduct);
  var obj = {
    method: 'feed',
    redirect_uri:"http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct="+smallProduct,
    link: "http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct="+smallProduct,
    picture: 'http://bllidev.dev/blli/scrawlImage/smallProduct/'+smallProductMainPhotoLink,
    name: '충동구매보다 빠른 합리적 소비!',
    caption: '블리가 추천하는 유아용품! 포스팅과 함께 확인하세요',
    description: '블리가 추천하는 유아용품! 광고없는 !! 포스팅과 함께 확인하세요'
  };

  function callback(response) {
		snsShareCountUp();
  }
  FB.ui(obj, callback);
}
 // 사용할 앱의 JavaScript 키를 설정해 주세요.
Kakao.init('7e613c0241d9f07553638f04b7df66ef');

function kakaolink_send(text, targetURL){
	var n = "http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=".length;
	var koreanWord = targetURL.substring(n,targetURL.length);
	var url = targetURL.substring(0,n)+encodeURIComponent(koreanWord);
	alert("koreanWord:"+koreanWord);
	Kakao.Auth.login({
		success: function(authObj) {
			 Kakao.API.request( {
				 url : '/v1/api/story/linkinfo',
				 data : {
				   url : url
				 }
			   }).then(function(res) {
				 // 이전 API 호출이 성공한 경우 다음 API를 호출합니다.
				 return Kakao.API.request( {
				   url : '/v1/api/story/post/link',
				   data : {
					 link_info : res
				   }
				 });
			   }).then(function(res) {
				 return Kakao.API.request( {
				   url : '/v1/api/story/mystory',
				   data : { id : res.id }
				 });
			   }).then(function(res) {
				 snsShareCountUp();
			   }, function (err) {
				 alert(JSON.stringify(err));
			   });
		}
	});
}
function snsShareCountUp(){
	 $.ajax({
			type:"get",
			url:"admin_snsShareCountUp.do?smallProductId=${smallProductInfo.smallProductId}",
			success:function(){
				
			}
	}); 
}

//블로그로 이동시키며 체류시간을 측정하는 함수
function goBlogPosting(targetURL,smallProductId){
	//도착시간 체크를 위해 
	var connectDate = new Date();
	var connectTime = connectDate.getTime();
	window.open(targetURL, "_blank");
	//중복 실행 방지 메서드
	var count = 0;
	//다시 사용자가 본 서비스 브라우져에서 움직였을 때 메서드 체류시간 기록
	setTimeout(function(){
		$('body').mouseover(function(){
			if(count==0){
				count=1;
				var exitDate = new Date();
				var exitTime = exitDate.getTime();
				var residenceTime = Math.round((exitTime - connectTime)/1000);
				$.ajax({
					type:"get",
					url:"recordResidenceTime.do?postingUrl="
						+targetURL+"&smallProductId="
						+smallProductId+"&postingTotalResidenceTime="
						+residenceTime,
						success:function(date){
						alert('체류시간 기록 완료 : '+residenceTime+'초');
						}
				});
			}else{
				return false;
			}
	 	}); 
	},2000);
}

//===== Scroll to Top ==== 
$(window).scroll(function() {
    if ($(this).scrollTop() >= 200) {        // If page is scrolled more than 50px
        $('#return-to-top').fadeIn(200);    // Fade in the arrow
    } else {
        $('#return-to-top').fadeOut(200);   // Else fade out the arrow
    }
});
$('#return-to-top').click(function() {      // When arrow is clicked
	$('body,html').stop().animate({
        scrollTop : 0                       // Scroll to top of body
    }, 2000);
});

//스크롤 이벤트
$(window).on("scroll",function () {
	infiniteScroll();
});

var totalPage = ${requestScope.smallProductList.totalPage};
var pageNo = 1;
var midCategory = "${requestScope.currMidCategory}";

//스크롤 감지 및 호출
function infiniteScroll(){
	var deviceMargin = 0; // 기기별 상단 마진
	var $scrollTop = $(window).scrollTop();
	var $contentsHeight = Math.max($("html").height(),$("#body").height());
	var $screenHeight = window.innerHeight || document.documentElement.clientHeight || 
							document.getElementsByTagName("body")[0].clientHeight; // 스크린 높이 구하기
	if($scrollTop >=  $contentsHeight - $screenHeight) {
		pageNo++;
		if(totalPage >= pageNo){
			setTimeout(function(){
				loadDibSmallProduct(pageNo, midCategory);
			},1000);
		}else{
			return false;
		}
	}
}

function loadDibSmallProduct(pageNo, midCategory){
	$.ajax({
		type: "POST",
		url: "${initParam.root}member_getDibSmallProductList.do",
		data: "pageNo="+pageNo+"&midCategory="+midCategory,
		success: function(resultData){
			var appendInfo = "";
			for(var i=0;i<resultData.length;i++){
				if(pageNo%2 == 0){
					if(i%2 == 0){
						appendInfo += "<div style='width: 100%; height: 575px; background-color: honeydew;'>";
					}else{
						appendInfo += "<div style='width: 100%; height: 575px;'>";
					}
				}else{
					if(i%2 == 0){
						appendInfo += "<div style='width: 100%; height: 575px;'>";
					}else{
						appendInfo += "<div style='width: 100%; height: 575px; background-color: honeydew;'>";
					}
				}
				appendInfo += "<div style='width: 1050px; margin: auto; height: 575px;'>";
				appendInfo += "<div class='slider"+pageNo+"' style='float: left;'>";
				for(var j=0;j<resultData[i].postingList.length;j++){
					appendInfo += "<div class='slide'>";
					appendInfo += "<a href='javascript:goBlogPosting(\""+resultData[i].postingList[j].postingUrl+"\",\""+resultData[i].postingList[j].smallProductId+"\");' data-tooltip-text='블로그 구경가기'>";
					appendInfo += "<img src='"+resultData[i].postingList[j].postingPhotoLink+"' class='postingImg' width='145px;' alt='"+resultData[i].smallProduct+"'>";
					appendInfo += "</a>";
					appendInfo += "</div>";
				}
				appendInfo += "</div>";
				appendInfo += "<div class='in_fr' style='height:575px; display: inline-block; width: 395px;'>";
				appendInfo += "<div class='result_con' style='width: 330px;'>";
				appendInfo += "<div class='result_ti' style='width: 345px;'>";
				appendInfo += resultData[i].smallProduct;
				appendInfo += "</div>";
				appendInfo += "<div>";
				appendInfo += "<div class='result_foto fl'>";
				appendInfo += "<img src='"+resultData[i].smallProductMainPhotoLink+"' alt='"+resultData[i].smallProduct+"'"; 
				appendInfo += "style='width: 100%; height: 100%; vertical-align: middle; cursor: pointer;'";
				appendInfo += "onclick='script:location.href=\"${initParam.root}goSmallProductDetailView.do?smallProduct="+resultData[i].smallProduct+"\";'>";
				appendInfo += "<div class='product_month'>";
				appendInfo += resultData[i].smallProductWhenToUseMin+"~"+resultData[i].smallProductWhenToUseMax+"<br/>";
				appendInfo += "개월";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "<div class='fl'>";
				appendInfo += "<div class='product_text' style='height: 150px; width: 340px; overflow-y: hidden;'>";
				appendInfo += "하은맘 프라임 샴푸 의자 이젠 32개월 모야 안고 머리감기는 일 너무 힘들어요~ 무게도 덩치도 발육이 남다른 모야 ~ 구상도를보면 참 많은 생각을 하시고 제작하신것 같아요";
				appendInfo += "</div>";
				appendInfo += "<div class='product_price' style='width: 360px;'>";
				appendInfo += "<div class='fl' style='width: 60px; display: inline-block;'>";
				appendInfo += "<p class='result_gray'>최저가</p>";
				appendInfo += "<p class='result_price'>"+resultData[i].minPrice+"원</p>";
				appendInfo += "</div>";
				appendInfo += "<div style='width: 30px; display: inline-block;'>";
				appendInfo += "<p class='result_sns' style='font-size: 15px;'>"+resultData[i].dbInsertPostingCount+"</p>";
				appendInfo += "<p class='result_sns_text' style='font-size: 5px;'>blog</p>";
				appendInfo += "</div>";
				appendInfo += "<div style='width: 30px; display: inline-block;'>";
				appendInfo += "<p class='result_sns' style='font-size: 15px;'>"+resultData[i].smallProductScore+"</p>";
				appendInfo += "<p class='result_sns_text' style='font-size: 5px;'>Point</p>";
				appendInfo += "</div>";
				appendInfo += "<div class='fr' style='width: 40px; height: 40px; display: inline-block;'>";
				appendInfo += "<div style='margin-top: 3px; cursor: pointer;' class='smallProductDibBtn' data-tooltip-text='찜해두시면 스크랩페이지에서 다시 보실 수 있어요!'>";
				if(resultData[i].isDib == 0){
					appendInfo += "<i class='fa fa-heart-o fa-2x' style='color: red'></i>";
				}else{
					appendInfo += "<i class='fa fa-heart fa-2x' style='color: red'></i>";
				}
				appendInfo += "<span style='font-size: 15px ;color: gray;' class='dibsCount'>"+resultData[i].smallProductDibsCount+"</span>";
				appendInfo += "<input type='hidden' value='"+resultData[i].smallProductId+"' class='smallProductId'>";
				appendInfo += "</div>";
				appendInfo += "</div>"; 
				appendInfo += "<div class='result_last fr' style='width: 150px; margin-top: 4px;'>";
				appendInfo += "<div style='text-align:center;'>";
				appendInfo += "<a onclick='postToFeed(\""+resultData[i].smallProduct+"\", \""+resultData[i].smallProductMainPhotoLink+"\"); return false;' style='cursor: pointer;'><img src='${initParam.root}img/fbShareBtn.png' alt='페이스북 공유하기'></a>";
				appendInfo += "<a style='cursor:pointer; margin-left: 4px;' id='kakao-login-btn' onclick='kakaolink_send(\"블리!\", \"http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct="+resultData[i].smallProduct+"\");'>";
				appendInfo += "<img src='${initParam.root}img/kakaoShareBtnOriginal.png' alt='카스 공유하기'></a>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>"; 
				appendInfo += "<div class='in_fr' style='clear:both; display: inline-block; width: 450px; height: 575px;'>";
				appendInfo += "<div class='detail_list fl' style='width: 410px; height: 247.5px;'>";
				appendInfo += "<div class='result_ti'>";
				appendInfo += "쇼핑몰 리스트"; 
				appendInfo += "</div>";
				appendInfo += "<div class='header'></div>";
				appendInfo += "<div style='overflow-y:auto; height: 207.5px;' class='body'>";
				appendInfo += "<table>";
				appendInfo += "<colgroup>";
				appendInfo += "<col width='20%'>";
				appendInfo += "<col width='20%'>";
				appendInfo += "<col width='20%'>";
				appendInfo += "<col width='20%'>";
				appendInfo += "<col width='20%'>";
				appendInfo += "</colgroup>";
				appendInfo += "<tr>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner'>쇼핑몰</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner'>판매가</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner'>배송비</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner'>부가정보</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner'>사러가기</div>";
				appendInfo += "</th>";
				appendInfo += "</tr>";
				for(var j=0;j<resultData[i].blliSmallProductBuyLinkVOList.length;j++){
					appendInfo += "<tr>";
					appendInfo += "<td>";
					appendInfo += resultData[i].blliSmallProductBuyLinkVOList[j].seller;
					appendInfo += "</td>";
					appendInfo += "<td>";
					appendInfo += resultData[i].blliSmallProductBuyLinkVOList[j].buyLinkPrice+"원";
					appendInfo += "</td>";
					appendInfo += "<td>";
					appendInfo += resultData[i].blliSmallProductBuyLinkVOList[j].buyLinkDeliveryCost;
					appendInfo += "</td>";
					appendInfo += "<td>";
					if(resultData[i].blliSmallProductBuyLinkVOList[j].buyLinkOption == null){
						appendInfo += "없음";
					}else{
						appendInfo += resultData[i].blliSmallProductBuyLinkVOList[j].buyLinkOption;
					}
					appendInfo += "</td>";
					appendInfo += "<td>";
					appendInfo += "<form action='goBuyMidPage.do' method='post'>";
					appendInfo += "<img src='${initParam.root}img/bt_buy.png' alt='사러가기' onclick='submit();' style='cursor: pointer;'>";
					appendInfo += "<input type='hidden' name='buyLink' value='"+resultData[i].blliSmallProductBuyLinkVOList[j].buyLink+"'>"; 
					appendInfo += "<input type='hidden' name='smallProductId' value='"+resultData[i].smallProductId+"'>"; 
					appendInfo += "<input type='hidden' name='memberId' value='${sessionScope.blliMemberVO.memberId}'>"; 
					appendInfo += "<input type='hidden' name='seller' value='"+resultData[i].blliSmallProductBuyLinkVOList[j].seller+"'>"; 
					appendInfo += "</form>";
					appendInfo += "</td>";
					appendInfo += "</tr>";
				}
				appendInfo += "</table>";
				appendInfo += "</div>";
				appendInfo += "</div>"; 
				appendInfo += "<div class='detail_list fr' style='width: 410px; height: 247.5px; padding-top: 0px;'>";
				appendInfo += "<div class='result_ti'>";
				appendInfo += "동일 제품점수별로 보기";
				appendInfo += "</div>";
				appendInfo += "<div class='header' style='margin-top: 42px;'></div>";
				appendInfo += "<div style='overflow-y:auto; height: 207.5px;' class='body'>";
				appendInfo += "<table id='otherProductInfo'>";
				appendInfo += "<colgroup>";
				appendInfo += "<col width='10%'>";
				appendInfo += "<col width='50%'>";
				appendInfo += "<col width='20%'>";
				appendInfo += "<col width='20%'>";
				appendInfo += "</colgroup>";
				appendInfo += "<tr>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner' style='margin-top: 50px; width: 7%;'>순위</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner' style='margin-top: 50px; width: 45%;'>제품명</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner' style='margin-top: 50px; width: 15%;'>점수</div>";
				appendInfo += "</th>";
				appendInfo += "<th>";
				appendInfo += "<div class='th-inner' style='margin-top: 50px; width: 16%;'>보러가기</div>";
				appendInfo += "</th>";
				appendInfo += "</tr>";
				for(var j=0;j<resultData[i].otherSmallProductList.length;j++){
					appendInfo += "<tr>";
					appendInfo += "<td>";
					appendInfo += (j+1);
					appendInfo += "</td>";
					appendInfo += "<td>";
					appendInfo += resultData[i].otherSmallProductList[j].smallProduct;
					appendInfo += "</td>";
					appendInfo += "<td>";
					appendInfo += resultData[i].otherSmallProductList[j].smallProductScore;
					appendInfo += "</td>";
					appendInfo += "<td>";
					appendInfo += "<a href='${initParam.root}goSmallProductDetailView.do?smallProduct="+resultData[i].otherSmallProductList[j].smallProduct+"'><img src='${initParam.root}img/bt_see.png' alt='보러가기'></a>";
					appendInfo += "</td>";
					appendInfo += "</tr>";
				}
				appendInfo += "</table>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
				appendInfo += "</div>";
			} //for

			$("#dibContent").append(appendInfo);
			$('.slider'+pageNo).bxSlider({
			    mode: 'vertical',
			    minSlides: 3,
			    slideMargin: 10
			});
		} //success
	}); //ajax
}
$(document).on("click", ".smallProductDibBtn", function(){
	//소제품 찜하기 스크립트
	var smallProductId = $(this).children('.smallProductId').val();
	$.ajax({
		type:"get",
		url:"member_smallProductDib.do?memberId=${sessionScope.blliMemberVO.memberId}&smallProductId="+smallProductId,
		success:function(result){
			$('.smallProductDibBtn').each(function(index){
				if($($('.smallProductDibBtn').get(index)).children('.smallProductId').val()==smallProductId){
					if(result==1){
						$($('.smallProductDibBtn').get(index)).children('.fa').removeClass("fa-heart-o").addClass("fa-heart");
						var dibsCount = $($('.smallProductDibBtn').get(index)).children('.dibsCount').text();
						dibsCount *= 1
						$($('.smallProductDibBtn').get(index)).children('.dibsCount').text(dibsCount+1);
					}else{
						$($('.smallProductDibBtn').get(index)).children('.fa').removeClass("fa-heart").addClass("fa-heart-o");
						var dibsCount = $($('.smallProductDibBtn').get(index)).children('.dibsCount').text();
						dibsCount *= 1
						$($('.smallProductDibBtn').get(index)).children('.dibsCount').text(dibsCount-1);
					}
				}
			}) 
		}
	});
});

$(document).ready(function(){
	
	$( '.jbMenu' ).addClass( 'jbFixed' );
	
	$(".postingImg").show();
	
	$('.slider').bxSlider({
	    mode: 'vertical',
	    minSlides: 3,
	    slideMargin: 10
	});
	
	$(".allDibMidCategory").click(function(){
		location.href="${initParam.root}member_goDibPage.do?midCategory=allMidCategory";
	});
	
	$(".dibMidCategory").click(function(){
		location.href="${initParam.root}member_goDibPage.do?midCategory="+$(this).text();
	});
	
});
</script>
<div class="dib_mid_category">
	<c:if test="${fn:length(requestScope.midCategoryList) >= 2}">
		<c:set var="allDibMidCategoryCount" value="${0}"/>
		<c:forEach items="${requestScope.midCategoryList}" var="midCategory">
			<c:set var="allDibMidCategoryCount" value="${allDibMidCategoryCount + midCategory.value}"/>
		</c:forEach>
		<c:if test="${requestScope.currMidCategory == 'allMidCategory'}">
			<a href="#" class="allDibMidCategory" style="color: #ff7f50">전체</a>(${allDibMidCategoryCount}) &nbsp; &nbsp; 
		</c:if>
		<c:if test="${requestScope.currMidCategory != 'allMidCategory'}">
			<a href="#" class="allDibMidCategory">전체</a>(${allDibMidCategoryCount}) &nbsp; &nbsp; 
		</c:if>
	</c:if>
	<c:forEach items="${requestScope.midCategoryList}" var="midCategory">
		<c:if test="${midCategory.key == requestScope.currMidCategory}">
			<a href="#" class="dibMidCategory" style="color: #ff7f50">${midCategory.key}</a>(${midCategory.value}) &nbsp; &nbsp;
		</c:if>
		<c:if test="${midCategory.key != requestScope.currMidCategory}">
			<a href="#" class="dibMidCategory">${midCategory.key}</a>(${midCategory.value}) &nbsp; &nbsp;
		</c:if>
	</c:forEach>
</div>
<div id="dibContent">
	<c:forEach items="${requestScope.smallProductList.list}" var="smallProductInfo" varStatus="index">
	<c:if test="${index.count%2 == 0}">
	<div style="width: 100%; height: 575px; background-color: honeydew;">
	</c:if>
	<c:if test="${index.count%2 != 0}">
		<div style="width: 100%; height: 575px;">
	</c:if>
	<div style="width: 1050px; margin: auto; height: 575px;">
	<div class="slider" style="float: left;">
		<c:forEach items="${smallProductInfo.postingList}" var="postingList">
			<div class="slide">
				<a href="javascript:goBlogPosting('${postingList.postingUrl}','${smallProductInfo.smallProductId}');" data-tooltip-text="블로그 구경가기">
					<img src="${postingList.postingPhotoLink}" style="display: none;" class="postingImg" width="145px;" alt="${smallProductInfo.smallProduct}">
				</a>
			</div>
		</c:forEach>
	</div>
		<div class="in_fr" style="height:575px; display: inline-block; width: 395px;">
			<div class="result_con" style="width: 330px;">
				<div class="result_ti" style="width: 345px;">
					${smallProductInfo.smallProduct} 
				</div>
				<div>
					<div class="result_foto fl">
						<img src="${smallProductInfo.smallProductMainPhotoLink}" alt="${smallProductInfo.smallProduct}" 
						style="width: 100%; height: 100%; vertical-align: middle; cursor: pointer;" 
						onclick="script:location.href='${initParam.root}goSmallProductDetailView.do?smallProduct=${smallProductInfo.smallProduct}';">
						<div class="product_month">
							${smallProductInfo.smallProductWhenToUseMin}~${smallProductInfo.smallProductWhenToUseMax}<br/>
							개월
						</div>
					</div>
				</div>
			</div>
			<div class="fl">
				<div class="product_text" style="height: 150px; width: 340px; overflow-y: hidden;">
					하은맘 프라임 샴푸 의자 이젠 32개월 모야 안고 머리감기는 일 너무 힘들어요~ 무게도 덩치도
					발육이 남다른 모야 ~ 구상도를보면 참 많은 생각을 하시고 제작하신것 같아요
				</div>
				<div class="product_price" style="width: 360px;">
					<div class="fl" style="width: 60px; display: inline-block;">
						<p class="result_gray">최저가</p>
						<p class="result_price">${smallProductInfo.minPrice}원</p>
					</div>
					<div style="width: 30px; display: inline-block;">
						<p class="result_sns" style="font-size: 15px;">${smallProductInfo.dbInsertPostingCount}</p>
						<p class="result_sns_text" style="font-size: 5px;">blog</p>
					</div>
					<div style="width: 30px; display: inline-block;">
						<p class="result_sns" style="font-size: 15px;">${smallProductInfo.smallProductScore}</p>
						<p class="result_sns_text" style="font-size: 5px;">Point</p>
					</div>
					<div class="fr" style="width: 40px; height: 40px; display: inline-block;">
						<div style="margin-top: 3px; cursor: pointer;" class="smallProductDibBtn" data-tooltip-text="찜해두시면 스크랩페이지에서 다시 보실 수 있어요!">
							<c:if test="${smallProductInfo.isDib==0}">
								<i class="fa fa-heart-o fa-2x" style="color: red"></i>
							</c:if>
							<c:if test="${smallProductInfo.isDib==1}">
								<i class="fa fa-heart fa-2x" style="color: red"></i>
							</c:if>
								<span style="font-size: 15px ;color: gray;" class="dibsCount">${smallProductInfo.smallProductDibsCount}</span>
								<input type="hidden" value="${smallProductInfo.smallProductId}" class="smallProductId">
						</div>
					</div>
					<div class="result_last fr" style="width: 150px; margin-top: 4px;">
						<div style="text-align:center;">
						<!-- 페이스북 공유 -->
							    <!-- 공유끝 -->
						<a onclick='postToFeed("${smallProductInfo.smallProduct}", "${smallProductInfo.smallProductMainPhotoLink}"); return false;' style="cursor: pointer;"><img src="${initParam.root}img/fbShareBtn.png" alt="페이스북 공유하기"></a>
						<a style="cursor:pointer;" id='kakao-login-btn' 
						onclick="kakaolink_send('블리!', 'http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=${smallProductInfo.smallProduct}');" >
						<img src="${initParam.root}img/kakaoShareBtnOriginal.png" alt="카스 공유하기"></a>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="in_fr" style="clear:both; display: inline-block; width: 450px; height: 575px;">
				<div class="detail_list fl" style="width: 410px; height: 247.5px;">
					<div class="result_ti">
						쇼핑몰 리스트 
					</div>
					<div class="header"></div>
					<div style="overflow-y:auto; height: 207.5px;" class="body">
						<table>
							<colgroup>
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
							</colgroup>
							<thead>
							<tr>
								<th>
									<div class="th-inner">쇼핑몰</div>
								</th>
								<th>
									<div class="th-inner">판매가</div>
								</th>
								<th>
									<div class="th-inner">배송비</div>
								</th>
								<th>
									<div class="th-inner">부가정보</div>
								</th>
								<th>
									<div class="th-inner">사러가기</div>
								</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach items="${smallProductInfo.blliSmallProductBuyLinkVOList}" var="sellerInfo">
								<tr>
									<td>
										${sellerInfo.seller}
									</td>
									<td>
										${sellerInfo.buyLinkPrice}원
									</td>
									<td>
										${sellerInfo.buyLinkDeliveryCost}
									</td>
									<td>
										<c:if test="${sellerInfo.buyLinkOption == null}">
											없음
										</c:if>
										<c:if test="${sellerInfo.buyLinkOption != null}">
											${sellerInfo.buyLinkOption}
										</c:if>
									</td>
									<td>
										<form action="goBuyMidPage.do" method="post">
											<img src="${initParam.root}img/bt_buy.png" alt="사러가기" onclick="submit();" style="cursor: pointer;">
											<input type="hidden" name="buyLink" value="${sellerInfo.buyLink}"> 
											<input type="hidden" name="smallProductId" value="${smallProductInfo.smallProductId}"> 
											<input type="hidden" name="memberId" value="${sessionScope.blliMemberVO.memberId}"> 
											<input type="hidden" name="seller" value="${sellerInfo.seller}"> 
										</form>
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="detail_list fr" style="width: 410px; height: 247.5px; padding-top: 0px;">
					<div class="result_ti">
						동일 제품점수별로 보기
					</div>
					<div class="header" style="margin-top: 42px;"></div>
					<div style="overflow-y:auto; height: 207.5px;" class="body">
						<table id="otherProductInfo">
							<colgroup>
								<col width="10%">
								<col width="50%">
								<col width="20%">
								<col width="20%">
							</colgroup>
							<thead>
							<tr>
								<th>
									<div class="th-inner" style="margin-top: 50px; width: 7%;">순위</div>
								</th>
								<th>
									<div class="th-inner" style="margin-top: 50px; width: 45%;">제품명</div>
								</th>
								<th>
									<div class="th-inner" style="margin-top: 50px; width: 15%;">점수</div>
								</th>
								<th>
									<div class="th-inner" style="margin-top: 50px; width: 16%;">보러가기</div>
								</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach items="${smallProductInfo.otherSmallProductList}" var="productList" varStatus="rank">
								<tr>
									<td>
										${rank.count}
									</td>
									<td>
										${productList.smallProduct}
									</td>
									<td>
										${productList.smallProductScore}
									</td>
									<td>
										<a href="${initParam.root}goSmallProductDetailView.do?smallProduct=${productList.smallProduct}"><img src="${initParam.root}img/bt_see.png" alt="보러가기"></a>
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	</c:forEach>
</div>
<a href="#" id="return-to-top"><i class="fa fa-chevron-up"></i></a>