<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
.menubar{
border:none;
border:0px;
margin:0px;
padding:0px;
font: 67.5% "Lucida Sans Unicode", "Bitstream Vera Sans", "Trebuchet Unicode MS", "Lucida Grande", Verdana, Helvetica, sans-serif;
font-size:100%;
font-weight:bold;
}

.menubar ul{
/* background: rgb(0,0,0);  */
height:50px;
list-style:none;
margin:0;
padding:0;
}

.menubar li{
float:left;
padding:0px;
}

.menubar li a{
/* background: rgb(109,109,109); */
color:#ffffff;
display:block;
font-weight:normal;
line-height:65px;
margin:0px;
padding:0px 25px;
text-align:center;
text-decoration:none;
}

.menubar li a:hover, .menubar ul li:hover a{
/* background: rgb(71,71,71); */
color:#FFFFFF;
text-decoration:none;
}

.menubar li ul{
/* background: rgb(109,109,109); */
display:none; /* 평상시에는 드랍메뉴가 안보이게 하기 */
height:auto;
padding:0px;
margin:0px;
border:0px;
position:absolute;
width:200px;
z-index:200;
/*top:1em;
/*left:0;*/
}

.menubar li:hover ul{
display:block; /* 마우스 커서 올리면 드랍메뉴 보이게 하기 */
}

.menubar li li {
background: lightpink;
display:block;
float:none;
margin:0px;
padding:0px;
width:200px;
z-index:9999;
}

.menubar li:hover li a{
background:none;
}

.menubar li ul a{
display:block;
height:50px;
font-size:12px;
font-style:normal;
margin:0px;
padding:0px 10px 0px 15px;
text-align:left;
}

.menubar li ul a:hover, .menubar li ul li:hover a{
background: rgb(71,71,71);
border:0px;
color:#ffffff;
text-decoration:none;
}

.menubar p{
clear:left;
}
</style>
<c:if test="${requestScope['javax.servlet.forward.request_uri']!='/projectBlli4/member_goMain.do'}">
	<form action="${initParam.root}searchSmallProduct.do" method="get">
		<div class="jbMenu">
		    <div class="in_fr">
				<a href="${initParam.root}member_goMain.do"><img src="${initParam.root}img/top_logo.png" alt="탑로고" class="logo" style="margin-top:-6px"></a>
				<div class="top_search">
					<input type="text" class="search_text" placeholder="검색어를 입력하세요" name="searchWord">
					<a href="#" onclick="$(this).closest('form').submit()"><img src="${initParam.root}img/search.png" alt="검색"></a>
				</div>
				<div class="top_nav">
					<div class="menubar">
					<ul>
					 <li><a href="${initParam.root}member_goMain.do">Main</a></li>
					 <li><a href="#">알림</a></li>
					 <li><a href="${initParam.root}member_goCalenderPage.do?memberId=${sessionScope.blliMemberVO.memberId}">아이 일정</a></li>
					 <li><a href="#" id="current">마이페이지</a>
						<ul>
					     <li><a href="${initParam.root}member_goDibPage.do">찜 제품 확인</a></li>
					     <li><a href="${initParam.root}member_goScrapePage.do">스크랩 포스팅확인</a></li>
					     <li><a href="#">추천 제품확인</a></li>
					     <li><a href="${initParam.root}member_goModifyMemberInfoPage.do">회원 정보 수정</a></li>
					     <li><a href="${initParam.root}member_goModifyBabyInfoPage.do">아이정보 확인</a></li>
					    
					    </ul>
					 </li>
					  <li><a href="${initParam.root}logout.do">로그아웃</a></li>
					</ul>
					</div>
					<%-- <a href="${initParam.root}member_goModifyMemberInfoPage.do">회원정보수정</a>   ㅣ   
						<a href="${initParam.root}member_goModifyBabyInfoPage.do">아이정보수정</a>   ㅣ  
					 <a href="#">스크랩</a>
					ㅣ <a href="#">알림</a> ㅣ <a href="${initParam.root}member_goCalenderPage.do?memberId=${sessionScope.blliMemberVO.memberId}">아이일정</a> ㅣ <a href="${initParam.root}logout.do">로그아웃</a> --%>
				</div>
			</div>
		</div>
	</form>
</c:if>
<c:if test="${requestScope['javax.servlet.forward.request_uri']=='/projectBlli4/member_goMain.do'}">
	<form action="${initParam.root}searchSmallProduct.do" method="get">
		<div class="main_top">
			<div class="in_fr">
				<div class="top_nav">
					<div class="menubar">
					<ul>
					 <li><a href="${initParam.root}member_goMain.do">Main</a></li>
					 <li><a href="#">알림</a></li>
					 <li><a href="${initParam.root}member_goCalenderPage.do?memberId=${sessionScope.blliMemberVO.memberId}">아이 일정</a></li>
					 <li><a href="#" id="current">마이페이지</a>
						<ul>
					     <li><a href="${initParam.root}member_goDibPage.do">찜 제품 확인</a></li>
					     <li><a href="${initParam.root}member_goScrapePage.do">스크랩 포스팅확인</a></li>
					     <li><a href="#">추천 제품확인</a></li>
					     <li><a href="${initParam.root}member_goModifyMemberInfoPage.do">회원 정보 수정</a></li>
					     <li><a href="${initParam.root}member_goModifyBabyInfoPage.do">아이정보 확인</a></li>
					    
					    </ul>
					 </li>
					  <li><a href="${initParam.root}logout.do">로그아웃</a></li>
					</ul>
					</div>
					<%-- <a href="${initParam.root}member_goDibPage.do">찜</a>   ㅣ
					<a href="${initParam.root}member_goScrapePage.do">스크랩</a>   ㅣ
					<a href="${initParam.root}member_goModifyMemberInfoPage.do">회원정보수정</a>   ㅣ   
					<a href="${initParam.root}member_goModifyBabyInfoPage.do">아이정보수정</a>   ㅣ  
					<a href="#">알림</a>   ㅣ   
					<a href="${initParam.root}member_goCalenderPage.do?memberId=${sessionScope.blliMemberVO.memberId}">아이일정</a> ㅣ
					<a href="${initParam.root}logout.do">로그아웃</a> --%>
				</div>
				<div class="main_logo">
					<a href="#"><img src="${initParam.root}img/main_logo.png" alt="로고" style="margin-top:-6px"></a>
					<input type="text" class="search_text2" placeholder="검색어를 입력하세요" name="searchWord">
				<a href="#" onclick="$(this).closest('form').submit()"><img src="${initParam.root}img/search.png" alt="검색"></a>
				</div>
				
			</div>
		</div>
	</form>
	<form action="${initParam.root}searchSmallProduct.do" method="get" id="test">
		<div class="jbMenu">
			<div class="in_fr">
				<a href="${initParam.root}member_goMain.do"><img src="${initParam.root}img/top_logo.png" style="margin-top:-6px" alt="탑로고"
					class="logo"></a>
				<div class="top_search">
					<input type="text" class="search_text" placeholder="검색어를 입력하세요" name="searchWord">
					<a href="${initParam.root}searchSmallProduct.do" onclick="$('#test').submit()"><img src="${intiParam.root}img/search.png" alt="검색"></a>
				</div>
				<div class="top_nav">
					<div class="menubar">
					<ul>
					 <li><a href="${initParam.root}member_goMain.do">Main</a></li>
					 <li><a href="#">알림</a></li>
					 <li><a href="${initParam.root}member_goCalenderPage.do?memberId=${sessionScope.blliMemberVO.memberId}">아이 일정</a></li>
					 <li><a href="#" id="current">마이페이지</a>
						<ul>
					     <li><a href="${initParam.root}member_goDibPage.do">찜 제품 확인</a></li>
					     <li><a href="${initParam.root}member_goScrapePage.do">스크랩 포스팅확인</a></li>
					     <li><a href="#">추천 제품확인</a></li>
					     <li><a href="${initParam.root}member_goModifyMemberInfoPage.do">회원 정보 수정</a></li>
					     <li><a href="${initParam.root}member_goModifyBabyInfoPage.do">아이정보 확인</a></li>
					    </ul>
					 </li>
					  <li><a href="${initParam.root}logout.do">로그아웃</a></li>
					</ul>
					</div>
				</div>
			</div>
		</div>
	</form>
</c:if>
