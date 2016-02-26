<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
.result_bg1, .result_bg2 {
	margin-top: 0px;
	height: 490px;
}
.result_con {
	width: 470px;
}
.result_last ul {
	margin-top: 0px;
}
.result_last {
    width: 110px;
}
.result_last.fr {
	height: 185px;
}
.fr {
	height: 50px;
	width: 110px;
}
.result_sns {
	border-bottom: 1px solid red;
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
.div_table{overflow-y:auto; width:100%; height:100%;}
table{background-color: white; width: 100%;}
table th{height:30px;}
.th-inner {    
	position: absolute;
    top: 0;
    line-height: 30px;
    text-align: center;
    margin-top: 70px;
    width: 16%;
}
#searchResult {
    margin-top: 65px;
    width: 1000px;
    margin-left: auto;
    margin-right: auto;
    font-family: 'Nanum Barun Gothic';
    font-weight: bold;
    font-size: 15px;
    line-height: 40px;
}
.flickity-prev-next-button.next {
	right: 10px;
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.story.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="/js/kakaolink.js"></script>
<script src='http://connect.facebook.net/en_US/all.js'></script>
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
			url:"snsShareCountUp.do?smallProductId=${smallProductInfo.smallProductId}",
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

$(document).ready(function(){

	var bodyHeight = $("#body").height();
	var jbMenuHeight = $(".jbMenu").height();
	var footerHeight = $(".container.footer footer").height();
	var windowHeight = window.innerHeight;
	if("${fn:length(requestScope.resultList)}" == 0 || windowHeight > (bodyHeight+jbMenuHeight+footerHeight)){
		$(".container.footer").css("position", "absolute");
		$(".container.footer").css("width", "100%");
		$(".container.footer").css("bottom", "0px");
	}
	
	
	$( '.jbMenu' ).addClass( 'jbFixed' );
	
	$(".slide_img_list").flickity({
		cellAlign: 'left',
		imagesLoaded: 'true',
		wrapAround: 'true'
	});
	
	//소제품 찜하기 스크립트
	$('.in_fr').on("click", ".smallProductDibBtn",function(){
		var smallProductId = $(this).children('.smallProductId').val();
		$.ajax({
			type:"get",
			url:"member_smallProductDib.do?memberId=${sessionScope.blliMemberVO.memberId}&smallProductId="+smallProductId,
			success:function(result){
				alert(result);
				$('.smallProductDibBtn').each(function(index){
					if($($('.smallProductDibBtn').get(index)).children('.smallProductId').val()==smallProductId){
						if(result==1){
							$($('.smallProductDibBtn').get(index)).children('.fa').removeClass("fa-heart-o").addClass("fa-heart");
							$($('.smallProductDibBtn').get(index)).children('.dibsCount').text(Number($($('.smallProductDibBtn').get(index)).children('.dibsCount').text())+1);							
						}else{
							$($('.smallProductDibBtn').get(index)).children('.fa').removeClass("fa-heart").addClass("fa-heart-o");
							$($('.smallProductDibBtn').get(index)).children('.dibsCount').text(Number($($('.smallProductDibBtn').get(index)).children('.dibsCount').text())-1);		
						}
					}
				}) 
			}
		});
	}); 
	
	// ===== Scroll to Top ==== 
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
	    }, 200);
	});

	
	
	var pageNo = 2;
	var searchWord = "${requestScope.searchWord}";
	var totalPage = ${requestScope.totalPage};
	
	//스크롤 이벤트
	$(window).on("scroll",function () {
		infiniteScroll();
	});
	
	//스크롤 감지 및 호출
	function infiniteScroll(){
		var deviceMargin = 0; // 기기별 상단 마진
		var $scrollTop = $(window).scrollTop();
		var $contentsHeight = Math.max($("html").height(),$("#body").height());
		var $screenHeight = window.innerHeight || document.documentElement.clientHeight || 
								document.getElementsByTagName("body")[0].clientHeight; // 스크린 높이 구하기
		if($scrollTop ==  $contentsHeight - $screenHeight) {
			if(totalPage < pageNo){
				return false;
			}
			loadArticle(pageNo);
			pageNo++;
		}
	}
	
	//ajax 로드
	function loadArticle(pageNo){
	    $.ajax({
			type: "POST",
			url: "${initParam.root}member_getSmallProductList.do",
			data: "pageNo="+pageNo+"&searchWord="+searchWord,
			success: function(resultData){
				var div = "";
				for(var i=0;i<resultData.length;i++){
					if(i%2 == 0){
						div += "<div class='result_bg2'>";
					}else{
						div += "<div class='result_bg1'>";
					}
					div += "<div class='in_fr'>";
					div += "<div class='result_con' style='height: 450px;'>";
					div += "<div class='result_ti'>";
					div += "<a href='${initParam.root}goSmallProductDetailView.do?smallProduct="+resultData[i].smallProduct+"' style='text-decoration:none; color: black;'>"+resultData[i].smallProduct+"</a>"; 
					div += "</div>";
					div += "<div>";
					div += "<div class='result_foto fl' style='width: 320px;'>";
					div += "<img src='"+resultData[i].smallProductMainPhotoLink+"' alt='"+resultData[i].smallProduct+"' style='width: 80%; height: 100%; vertical-align: middle; margin-left: 50px;'>";
					div += "<div class='product_month' style='margin-left: 50px;'>";
					div += resultData[i].smallProductWhenToUseMin+"~"+resultData[i].smallProductWhenToUseMax+"<br/>";
					div += "개월";
					div += "</div>";
					div += "</div>";
					div += "<div style='width: 130px; height: 235px; float: right;'>";
					div += "<div class='result_last fr' style='width: 130px; text-align: right; margin-top: 30px;'>";
					div += "<div style='margin-top: 110px;'>";
					div += "<img src='${initParam.root}img/kakaoShareBtnOriginal.png' alt='카스 공유하기' style='margin-right: 20px; margin-bottom: 5px; cursor: pointer;' onclick='kakaolink_send(\"블리!\", \"http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct="+resultData[i].smallProduct+"\");'>";
					div += "<img src='${initParam.root}img/fbShareBtn.png' alt='페이스북 공유하기' style='margin-right: 19px; cursor: pointer;' onclick='postToFeed(\""+resultData[i].smallProduct+"\", \""+resultData[i].smallProductMainPhotoLink+"\"); return false;'>";
					div += "</div>";
					div += "<ul>";
					div += "<li>";
					div += "<p class='result_sns'>"+resultData[i].smallProductRanking+"</p>";
					div += "<p class='result_sns_text'>Rank</p>";
					div += "</li>";
					div += "<li>";
					div += "<p class='result_sns'>"+resultData[i].smallProductScore+"</p>";
					div += "<p class='result_sns_text'>Point</p>";
					div += "</li>";
					div += "<li>";
					div += "<p class='result_sns'>"+resultData[i].dbInsertPostingCount+"</p>";
					div += "<p class='result_sns_text'>Blog</p>";
					div += "</li>";
					div += "</ul>";
					div += "</div>";
					div += "<div class='fr' style='float: left; margin-top: 30px;'>";
					div += "<div class='fl' style='margin-top: 10px;'>";
					div += "<p class='result_gray'>최저가</p>";
					div += "<p class='result_price'>"+resultData[i].minPrice+"원</p>";
					div += "</div>";
					div += "<div class='fr' style='width: 54px;'>";
					div += "<div style='margin-top: 15px; float: right; cursor: pointer;' class='smallProductDibBtn' data-tooltip-text='찜해두시면 스크랩페이지에서 다시 보실 수 있어요!'>";
					if(resultData[i].isDib == 0){
						div += "<i class='fa fa-heart-o fa-2x' style='color: red'></i>";
					}else{
						div += "<i class='fa fa-heart fa-2x' style='color: red'></i>";
					}
					div += "<span class='dibsCount' style='font-size: 15px ;color: gray;'>"+resultData[i].smallProductDibsCount+"</span>";
					div += "<input type='hidden' value='"+resultData[i].smallProductId+"' class='smallProductId'>";
					div += "</div>";
					div += "</div>";
					div += "</div>";
					div += "</div>";
					div += "</div>";
					div += "<div class='midKeyword' style='width: 100px; padding: 0px; clear: both; background: none; padding-top: 30px; line-height: 30px; margin-left: 0px;'>";
					div += "<div class='result_ti'>";
					div += "Keyword";
					div += "</div>";
					div += "<ul style='width: 470px;'>";
					var wordList = resultData[i].blliWordCloudVOList;
					for(var j=0;j<wordList.length;j++){
						div += "<li>";
						div += "<span class='midKeyword"+wordList[j].wordLevel+"'>"+wordList[j].word+"</span>";
						div += "</li>";
					}
					div += "</ul>";
					div += "</div>";
					div += "</div>";
					div += "<div class='detail_list fl' style='width: 410px; height: 450px;'>";
					div += "<div class='result_ti'>";
					div += "쇼핑몰 리스트"; 
					div += "</div>";
					div += "<div class='header'></div>";
					div += "<div style='height: 207.5px;' class='div_table'>";
					div += "<table>";
					div += "<colgroup>";
					div += "<col width='20%'>";
					div += "<col width='20%'>";
					div += "<col width='20%'>";
					div += "<col width='20%'>";
					div += "<col width='20%'>";
					div += "</colgroup>";
					div += "<thead>";
					div += "<tr>";
					div += "<th>";
					div += "<div class='th-inner'>쇼핑몰</div>";
					div += "</th>";
					div += "<th>";
					div += "<div class='th-inner'>판매가</div>";
					div += "</th>";
					div += "<th>";
					div += "<div class='th-inner'>배송비</div>";
					div += "</th>";
					div += "<th>";
					div += "<div class='th-inner'>부가정보</div>";
					div += "</th>";
					div += "<th>";
					div += "<div class='th-inner'>사러가기</div>";
					div += "</th>";
					div += "</tr>";
					div += "</thead>";
					div += "<tbody>";
					var sellerInfo = resultData[i].blliSmallProductBuyLinkVOList;
					for(var j=0;j<sellerInfo.length;j++){
						div += "<tr>";
						div += "<td>";
						div += sellerInfo[j].seller;
						div += "</td>";
						div += "<td>";
						div += sellerInfo[j].buyLinkPrice+"원";
						div += "</td>";
						div += "<td>";
						div += sellerInfo[j].buyLinkDeliveryCost;
						div += "</td>";
						div += "<td>";
						if(sellerInfo[j].buyLinkOption == null){
							div += "없음";
						}else{
							div += sellerInfo[j].buyLinkOption;
						}
						div += "</td>";
						div += "<td>";
						div += "<form action='goBuyMidPage.do' method='post'>";
						div += "<img src='${initParam.root}img/bt_buy.png' alt='사러가기' onclick='submit();' style='cursor: pointer;'>";
						div += "<input type='hidden' name='buyLink' value='"+sellerInfo[j].buyLink+"'>"; 
						div += "<input type='hidden' name='smallProductId' value='"+sellerInfo[j].smallProductId+"'>"; 
						div += "<input type='hidden' name='memberId' value='${sessionScope.blliMemberVO.memberId}'>"; 
						div += "<input type='hidden' name='seller' value='"+sellerInfo[j].seller+"'>"; 
						div += "</form>";
						div += "</td>";
						div += "</tr>";
					}
					div += "</tbody>";
					div += "</table>";
					div += "</div>";
					div += "<div style='height: 197.5px;'>";
					div += "<div class='result_ti'>";
					div += "Blog";
					div += "</div>";
					div += "<div class='jbMenu2' style='height: 152.5px; padding: 0px; background-color: transparent;'>";
					div += "<div class='slide_img_list' style='height: 152.5px;'>";
					var postingList = resultData[i].postingList;
					for(j=0;j<postingList.length;j++){
						div += "<div style='height: 152.5px; display: inline-block;'>";
						div += "<a href='javascript:goBlogPosting('"+postingList[j].postingUrl+"','"+postingList[j].smallProductId+"');'>";
						div += "<img src='"+postingList[j].postingPhotoLink+"' alt='"+postingList[j].smallProduct+"' class='slideImg' style='height: 142.5px; padding: 5px;'>";
						div += "</a>";
						div += "</div>";
					}
					div += "</div>";
					div += "</div>";
					div += "</div>";
					div += "</div>";
					div += "</div>";
					div += "</div>";
				}
				$("#body").append(div);
				$(".slide_img_list").flickity({
					cellAlign: 'left',
					imagesLoaded: 'true',
					wrapAround: 'true'
				});
			}
	    });
	}
});
</script>
<div id="body">
<c:if test="${fn:length(requestScope.resultList) == 0}">
	<div style="margin-top: 65px; width: 100%; position: absolute; top: 0px; bottom: 79px; text-align: center;">
		<div style="height: 10%; padding-top: 15%;">
			<img src="${initParam.root}image/blliLogo_orange.jpg" style="height: 100%;">
		</div>
		<div style="font-size: x-large; height: 10%; line-height: 100px;">
			<font color="red">'${requestScope.searchWord}'</font>에 대한 검색 결과가 없습니다.
		</div>
		<div style="color: gray; line-height: 30px;">
			정확한 검색어 인지 확인하시고 다시 검색해 주세요.
		</div>
	</div>
</c:if>
<c:if test="${fn:length(requestScope.resultList) != 0}">
<div id="searchResult">
	<font color="#FD9595">'${requestScope.searchWord}'</font>에 대한 검색 결과 ${requestScope.totalSmallProduct}건
</div>
<c:forEach items="${requestScope.resultList}" var="smallProductList" varStatus="i">
<c:if test="${i.count%2 == 1}">
<div class="result_bg1">
</c:if>
<c:if test="${i.count%2 == 0}">
<div class="result_bg2">
</c:if>
	<div class="in_fr">
		<div class="result_con" style="height: 450px;">
			<div class="result_ti">
				<a href="${initParam.root}goSmallProductDetailView.do?smallProduct=${smallProductList.smallProduct}" style="text-decoration:none; color: black;">${smallProductList.smallProduct}</a> 
			</div>
			<div>
				<div class="result_foto fl" style="width: 320px;">
					<img src="${smallProductList.smallProductMainPhotoLink}" alt="${smallProductList.smallProduct}" style="width: 80%; height: 100%; vertical-align: middle; margin-left: 50px; cursor: pointer;" onclick="${initParam.root}goSmallProductDetailView.do?smallProduct=${smallProductList.smallProduct}">
					<div class="product_month" style="margin-left: 50px;">
						${smallProductList.smallProductWhenToUseMin}~${smallProductList.smallProductWhenToUseMax}<br/>
						개월
					</div>
				</div>
				<div style="width: 130px; height: 235px; float: right;">
					<div class="result_last fr" style="width: 130px; text-align: right; margin-top: 30px;">
					<div style="margin-top: 110px;">
						<img src="${initParam.root}img/kakaoShareBtnOriginal.png" alt="카스 공유하기" style="margin-right: 20px; margin-bottom: 5px; cursor: pointer;" onclick="kakaolink_send('블리!', 'http://bllidev.dev/blli/goSmallProductDetailView.do?smallProduct=${smallProductList.smallProduct}');">
						<img src="${initParam.root}img/fbShareBtn.png" alt="페이스북 공유하기" style="margin-right: 19px; cursor: pointer;" onclick='postToFeed("${smallProductList.smallProduct}", "${smallProductList.smallProductMainPhotoLink}"); return false;'>
					</div>
					<ul>
						<li>
							<p class="result_sns">${smallProductList.smallProductRanking}</p>
							<p class="result_sns_text">Rank</p>
						</li>
						<li>
							<p class="result_sns">${smallProductList.smallProductScore}</p>
							<p class="result_sns_text">Point</p>
						</li>
						<li>
							<p class="result_sns">${smallProductList.dbInsertPostingCount}</p>
							<p class="result_sns_text">Blog</p>
						</li>
					</ul>
				</div>
					<div class="fr" style="float: left; margin-top: 30px;">
							<div class="fl" style="margin-top: 10px;">
								<p class="result_gray">최저가</p>
								<p class="result_price">${smallProductList.minPrice}원</p>
							</div>
							<div class="fr" style="width: 54px;">
								<div style="margin-top: 15px; float: right; cursor: pointer;" class="smallProductDibBtn" data-tooltip-text="찜해두시면 스크랩페이지에서 다시 보실 수 있어요!">
							<c:if test="${smallProductList.isDib==0}">
								<i class="fa fa-heart-o fa-2x" style="color: red"></i>
							</c:if>
							<c:if test="${smallProductList.isDib==1}">
								<i class="fa fa-heart fa-2x" style="color: red"></i>
							</c:if>
								<span class="dibsCount" style="font-size: 15px ;color: gray;">${smallProductList.smallProductDibsCount}</span>
								<input type="hidden" value="${smallProductList.smallProductId}" class="smallProductId">
							</div>
							</div>
					</div>
				</div>
			</div>
			
			<div class="midKeyword" style="width: 100px; padding: 0px; clear: both; background: none; padding-top: 30px; line-height: 30px; margin-left: 0px;">
				<div class="result_ti">
					Keyword
				</div>
				<ul style="width: 470px;">
					<c:forEach items="${smallProductList.blliWordCloudVOList}" var="wordList">
						<li>
							<span class="midKeyword${wordList.wordLevel}">${wordList.word}</span>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		
		<div class="detail_list fl" style="width: 410px; height: 450px;">
			<div class="result_ti">
				쇼핑몰 리스트 
			</div>
			<div class="header"></div>
			<div style="height: 207.5px;" class="div_table">
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
					<c:forEach items="${smallProductList.blliSmallProductBuyLinkVOList}" var="sellerInfo">
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
			
			<div style="height: 197.5px;">
				<div class="result_ti">
					Blog
				</div>
				<div class="jbMenu2" style="height: 152.5px; padding: 0px; background-color: transparent;">
					<div class="slide_img_list" style="height: 152.5px;">
						<c:forEach items="${smallProductList.postingList}" var="postingList">
							<div style="height: 152.5px; display: inline-block;">
								<a href="javascript:goBlogPosting('${postingList.postingUrl}','${smallProductList.smallProductId}');">
									<img src="${postingList.postingPhotoLink}" alt="${smallProductList.smallProduct}" class="slideImg" style="height: 142.5px; padding: 5px;">
								</a>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
			
		</div>
		
	</div>
</div>
</c:forEach>
<a href="#" id="return-to-top"><i class="fa fa-chevron-up"></i></a>
</div>
</c:if>
