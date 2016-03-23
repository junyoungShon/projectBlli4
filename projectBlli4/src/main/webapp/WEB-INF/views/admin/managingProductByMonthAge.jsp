<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>    
  <link href="${initParam.root}css/icheck/flat/green.css" rel="stylesheet">
  <link href="${initParam.root}css/datatables/tools/css/dataTables.tableTools.css" rel="stylesheet">
  <style>
  	.smallProductDetailTable{
  		display: none;
  	}
  </style>
  <script>
  	$(document).ready(function(){
  		$('.confirmedbyadminSmallProduct').click(function(){
  			var midCategoryId = $(this).siblings('.midCategoryId').children('.midCategoryIdValue').val();
  			var midCategoryCell = '#'+midCategoryId
  			//표 초기화
  			if($(midCategoryCell).css('display')=='none'){
  				$(midCategoryCell).css('display','block')
	  			$(this).parent().css('background-color','lightgoldenrodyellow');
  				$(this).css('background-color','aquamarine');
	  			var addHtml = 
	  			'<thead><tr class="smallProductDetail headings"><td>소분류아이디</td><td>소분류명</td><td>네이버랭킹순</td><td>구매링크 수</td><td>클릭 수</td><td>컨펌드블로그 수</td><td>언컨펌드블로그수</td>'
	  			+'<td>총블로그 수</td><td>블로그관리하러가기</td></tr></thead><tbody>'
	  			
	  			$.ajax({
					type:"get",
					url:"admin_selectConfirmedbyadminProductByMidCategoryId.do?midCategoryId="+midCategoryId,
					success:function(data){
						for(var i=0;i<data.length;i++){
							addHtml += '<tr>';
							addHtml += '<td>'+data[i].smallProductId+'</td>';
							addHtml += '<td>'+data[i].smallProduct+'</td>';
							addHtml += '<td>'+data[i].naverShoppingRank+'</td>';
							addHtml += '<td>'+data[i].buyLinkNum+'</td>';
							addHtml += '<td>'+data[i].smallProductClickNum+'</td>';
							addHtml += '<td>'+data[i].confirmedBlogNum+'</td>';
							addHtml += '<td>'+data[i].unconfirmedBlogNum+'</td>';
							addHtml += '<td>'+data[i].totalBlogNum+'</td>';
							addHtml += '<td><a href="admin_unconfirmedPosting.do?category=smallProductId&searchWord='+data[i].smallProductId+'" target="_blank">블로그 관리 가기</a></td>';
							addHtml += '</tr>';
						}
						addHtml += '</tbody>'
						alert(addHtml)
			  			$(midCategoryCell).html(addHtml);
					}
				});
	  			
	  	
  			}else{
	  			$(midCategoryCell).css('display','none');
	  			$(this).parent().css('background-color','#f9f9f9');
	  			$(this).siblings('.confirmedSmallProduct').css('background-color','#f9f9f9');
	  			
	  			$(this).css('background-color','#f9f9f9');
  			}
			
  			
  			
  			
  		});
  		$('.confirmedSmallProduct').click(function(){
  			var midCategoryId = $(this).siblings('.midCategoryId').children('.midCategoryIdValue').val();
  			var midCategoryCell = '#'+midCategoryId
  			
  			//표 초기화
  			if($(midCategoryCell).css('display')=='none'){
  				$(midCategoryCell).css('display','block');
	  			$(this).parent().css('background-color','lightgoldenrodyellow');
	  			$(this).css('background-color','aquamarine');
  				var addHtml = 
  		  			'<thead><tr class="smallProductDetail headings"><td>소분류아이디</td><td>소분류명</td><td>네이버랭킹순</td><td>구매링크 수</td><td>클릭 수</td><td>컨펌드블로그 수</td><td>언컨펌드블로그수</td>'
  		  			+'<td>총블로그 수</td><td>블로그관리하러가기</td></tr></thead><tbody>'
	  			$.ajax({
					type:"get",
					url:"admin_selectConfirmedProductByMidCategoryId.do?midCategoryId="+midCategoryId,
					success:function(data){
						for(var i=0;i<data.length;i++){
							addHtml += '<tr>';
							addHtml += '<td>'+data[i].smallProductId+'</td>';
							addHtml += '<td>'+data[i].smallProduct+'</td>';
							addHtml += '<td>'+data[i].naverShoppingRank+'</td>';
							addHtml += '<td>'+data[i].buyLinkNum+'</td>';
							addHtml += '<td>'+data[i].smallProductClickNum+'</td>';
							addHtml += '<td>'+data[i].confirmedBlogNum+'</td>';
							addHtml += '<td>'+data[i].unconfirmedBlogNum+'</td>';
							addHtml += '<td>'+data[i].totalBlogNum+'</td>';
							addHtml += '<td></td>';
							addHtml += '</tr>';
						}
						addHtml += '</tbody>'
							alert(addHtml)
			  			$(midCategoryCell).html(addHtml);
					}
				});
	  			
	  			
  			}else{
	  			$(midCategoryCell).css('display','none');
	  			$(this).parent().css('background-color','#f9f9f9');
	  			$(this).siblings('.confirmedSmallProduct').css('background-color','#f9f9f9');
	  			$(this).siblings('.confirmedbyadminSmallProduct').css('background-color','#f9f9f9');
	  			$(this).css('background-color','#f9f9f9');
  			}
			
  			
  		});
  	});
  </script>
  
    <table class="table">
    	
    </table>
         <!-- page content -->
        <div class="">
          <div class="page-title" style="width:100%">
            <div class="title_left" style="width:100%">
              <h3>
                    시기별 중분류 관리 페이지 (${requestScope.currentIndex} 개월)
                       <ol class="breadcrumb" style="font-size: 20px">
                      <c:forEach items="${requestScope.monthlyMidCategoryIndex}" var="mapList">
						  <li>
							<a href="${initParam.root}admin_managingProductByMonthAge.do?minimumMonthAge=${mapList.MINUSABLEMONTH}">
							  ${mapList.MINUSABLEMONTH}개월 ( ${mapList.TOTALCOUNT}개의 컨펌드 상품 )
						 	</a>
						  </li>
                      </c:forEach>
						</ol>
                </h3>
            </div>

            
          </div>
          <div class="clearfix"></div>

          <div class="row">

            <div class="col-md-12 col-sm-12 col-xs-12">
              <div class="x_panel">
                <div class="x_title">
                 
                </div>
                <div class="x_content">
                  <table id="example" class="table table-striped">
                    <thead>
                      <tr class="headings">
                        <th>
                          <input type="checkbox" class="tableflat">
                        </th>
                        <th>중분류명 </th>
                        <th>중분류 아이디 </th>
                        <th>월령별 제품 아이디 </th>
                        <th>월령별 제품명 </th>
                        <th>최소 사용연령 </th>
                        <th>컨펌 소제품 수 </th>
                        <th>컨펌바이어드민 소제품 수 </th>
                        <th>언컨펌 소제품 수</th>
                      </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${requestScope.resultList}" var="list" varStatus="status">
                    	<c:forEach items="${list }" var="listInList" varStatus="count">
                    	
	                        <td class="a-center ">
	                          <input type="checkbox" class="tableflat">
	                        </td>
	                        <td class=" ">${listInList.midCategory }</td>
	                        <td class="midCategoryId">
	                        	<input type="hidden" class="midCategoryIdValue" value="${listInList.midCategoryId }">
	                        	<a href="admin_unconfirmedSmallProductByMidCategoryId.do?midCategoryId=${listInList.midCategoryId }" target="_blank">
		                       		${listInList.midCategoryId }
	                        	</a>
	                        </td>
	                        <td class=" ">${listInList.monthlyProductId } <i class="success fa fa-long-arrow-up"></i>
	                        </td>
	                        <td class=" ">${listInList.monthlyProduct }</td>
	                        <td class=" ">${listInList.minUsableMonth }</td>
	                        <td class="confirmedSmallProduct">${listInList.confirmedSmallProductNum } (확정소제품보기)</td>
	                        <td class="confirmedbyadminSmallProduct">${listInList.confirmedbyadminSmallProductNum } (비확정소제품보기)</td>
	                        <td class=" last">
	                        <a href="admin_unconfirmedSmallProductByMidCategoryId.do?midCategoryId=${listInList.midCategoryId }" target="_blank">
	                        ${listInList.unconfirmedSmallProductNum }(소제품관리하기)</a>
	                        </td>
	                     <tr><td colspan="9"><table id="${listInList.midCategoryId }" class="smallProductDetailTable table table-striped"></table></tr>

	                   
                      </c:forEach>
                    </c:forEach>
                    </tbody>

                  </table>
                </div>
              </div>
            </div>
            </div>
            </div>
            
 
