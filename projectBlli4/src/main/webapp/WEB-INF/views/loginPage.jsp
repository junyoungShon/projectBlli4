<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>블리 - 충동구매보다 빠른 합리적 쇼핑!</title>
<link href="${initParam.root}img/favicon/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<link rel="stylesheet" type="text/css" href="./css/reset.css" />
<link rel="stylesheet" type="text/css" href="./css/css.css" />
<link id="bs-css" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet">
<link href="${initParam.root}css/ct-paper.css" rel="stylesheet"/>
<link href="${initParam.root}css/css.css" rel="stylesheet"/>
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<script src="${initParam.root}js/bootstrap.min.js"></script>
<!--  Plugins -->
<script src="${initParam.root}js/ct-paper-radio.js"></script>
<script src="${initParam.root}js/ct-paper.js"></script> 
<script type="text/javascript">
	function appReadyAlert(){
		alert('현재 APP은 개발 중입니다.')
	}	
	$(document).ready(function(){
		
		$.ajax({
			type:"get",
			url:"footerStatics.do",
			success:function(data){
				$('.footerProductStatics').text(data.productStatics);
				$('.footerPostingStatics').text(data.postingStatics);
			}
		});
		//엔터 클릭시 로그인
		$('#memberPassword').keyup(function(key){
			if (key.keyCode == 13) {
				$('.loginButton').click();
	        }
		});
		$('.loginButton').click(function(){
			if($('#memberId').val()==""){
				alert('id를 입력해주세요');
				$('#memberId').focus(); 
				return false;
			}
			if($('#memberPassword').val()==""){
				alert('비밀번호를 입력해주세요');
				$('#memberPassword').focus(); 
				return false;
			}
			$('#loginfrm').submit();
		});
		$('input[name="remember-me"]').change(function(){
			if($(this).is(':checked')==true){
				if(!confirm('자동로그인 기능은 보안을 위해 개인컴퓨터에서만 실행시켜주세요')){
					$(this).attr("checked",false);
				}
			}
		});
		
		if("${requestScope.memberEmail}"!="") {
			alert("회원님의 이메일로 임시 비밀번호가 발송되었습니다.");
		}
	});
</script>
</head>
<body class="loginPage_bg">
<c:if test="${requestScope.loginFail=='true'}">
	<script type="text/javascript">
		alert('로그인에 실패했습니다. 비밀번호를 확인해주세요!');
	</script>
</c:if>
		<div class="loginComp_bg" style="height: 350px; margin-top: 5%; height:450px;">
			<div class="title" style="margin-top: 40px;">
				Email Login
			</div>
			<form id="loginfrm" name="loginfrm" method="POST" action="${initParam.root}j_spring_security_check">
				<label><input type="text" name="memberId" placeholder="Email Id" style="width: 
				250px; margin-top:20px;" id="memberId"></label><br>
				<label><input type="password" placeholder="Password" name="memberPassword"
				style="margin-top:20px; width: 250px" id="memberPassword"></label><br>
				<label>
					<input type="checkbox" name="remember-me" style="width: 15px; height: 15px; margin-top:20px;"/> 자동로그인 체크
				</label>
				<br>
				<input type="button" class="loginButton" value="로그인" style="margin-top:20px;"> 
			</form>
			<br><br>
			<a href="${initParam.root}goFindPasswordPage.do"><font color="white"><b>비밀번호 찾기</b></font></a><br>
			<a href="${initParam.root}goJoinMemberPage.do"><font color="white"><b>이메일 회원가입</b></font></a>
		</div>
			<div class="login_bottom">
			<div class="fl login_bottom_ft">
				블리는 <span class="footerProductStatics"></span>개의 상품을 소개하고, 관련된 <span class="footerPostingStatics"></span>개의 블로그를 분석하고 소개합니다.
			</div>
			<div class="fr">
				<div class="login_bottom_right">
				<a href="#" onclick="appReadyAlert();"><img src="./img/bottom_app1.png" alt="안드로이드 다운로드받기"></a>
				<a href="#" onclick="appReadyAlert();"><img src="./img/bottom_app2.png" alt="애플 다운로드받기"></a>
				</div>
			</div>
		</div>
</body>
</html>      

