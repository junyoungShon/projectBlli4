<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>    
    <table class="table">
    	<c:forEach items="${requestScope.resultList}" var="list">
    	<tr class="table success" style="border: thin; border-style: solid; border-color: black;">
    		<c:forEach items="${list }" var="listInList">
    			<tr>
    				<td>${listInList.midCategory }</td>
    				<td>${listInList.midCategoryId }</td>
    				<td>${listInList.monthlyProductId }</td>
    				<td>${listInList.monthlyProduct }</td>
    				<td>${listInList.minUsableMonth }</td>
    				<td>${listInList.monthlyProductPhotoLink }</td>
    				<td>${listInList.confirmedSmallProductNum }</td>
    			</tr>
		    	${listInList}
    		</c:forEach>
    	</tr>
    	</c:forEach>
    </table>
