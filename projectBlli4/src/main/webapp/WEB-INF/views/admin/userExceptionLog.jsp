<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC>
<html>
<head>
<style type="text/css">
html, body{
	height: 100%;
}
table {
	width: 70%;
	line-height: 21px;
	border-top: 1px solid #cccccc;
	border-left: 1px solid #cccccc;
	border-collapse: collapse;
	margin: auto;
	table-layout: fixed;
}
#mainTable {
	margin-top: 100px;
}
#subTable {
	margin-top: 20px;
	width: 90%;
}
#subTable2 {
	margin-bottom: 20px;
}
table th, table td {
	color: #678197;
	text-align: center;
	border-right: 1px solid #cccccc;
	border-bottom: 1px solid #cccccc;
	padding: 3px 0;
	text-align: center;
}
table th {
	background-color: #eeeeee;
}
</style>
<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그 조회</title>
</head>
<body>
<div style='margin: auto; padding: 10px;'></div>
<table id="mainTable" style="table-layout: fixed;">
	<tr>
		<th style="width:35px;">번호</th>
		<th style="width:250px;">발생메서드</th>
		<th style="width:350px;">발생클래스</th>
		<th style="width:150px;">발생 일자</th>
		<th style="width:500px;">익셉션내용</th>
	</tr>
	<c:forEach items="${requestScope.list}" var="log" varStatus="index">
	<tr>
		<td>${log.number}</td>
		<td>${log.methodName}</td>
		<td>${log.className}</td>
		<td>${log.occuredTime}</td>
		<td style="text-align: justify;"><div style="width: 500px;word-break:break-all;">${log.exceptionContent}</div></td>
	</tr>
	</c:forEach>
</table>
<div id="detailPopUp" style="display:none; width:70%; height:auto; background-color: white; overflow-y: auto;">
</div>
</body>
</html>
