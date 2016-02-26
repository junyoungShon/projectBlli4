<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
</head>
<body>
<h1>이곳은 관리자 페이지 인덱스입니다 관리자만 접근할 수 있어요.</h1>
	<ul>
		<li><a href="${initParam.root}member_goMain.do">goMain.do</a></li>
		<li><a href="${initParam.root}admin_sendMail.do?memberId=sk159753&mailForm=findPassword">admin_sendMail.do</a></li>
		<li><a href="${initParam.root}admin_insertBigCategory.do">대분류 리스트 긁어모아</a></li>
		<li><a href="${initParam.root}admin_insertMidCategory.do">중분류 리스트 긁어모아</a></li>
		<li><a href="${initParam.root}admin_insertSmallProduct.do">소분류 리스트 긁어모아</a></li>
		<li><a href="${initParam.root}admin_insertPosting.do">포스팅 리스트 긁어모아</a></li>
		<li><a href="${initParam.root}admin_postingListWithSmallProducts.do">소제품 하나로 추려줘</a></li>
		<li><a href="${initParam.root}admin_unconfirmedSmallProduct.do">소제품 등록해줘</a></li>
		<li><a href="${initParam.root}admin_unconfirmedPosting.do">포스팅 등록해줘</a></li>
		<li><a href="${initParam.root}admin_checkPosting.do">싫어요</a></li>
		<li><a href="${initParam.root}admin_checkMember.do">회원 목록</a></li>
		<li><a href="${initParam.root}admin_checkLog.do">로그 조회</a></li>
		<li><a href="${initParam.root}j_spring_security_logout">로그아웃</a></li>
	</ul>
</html>
