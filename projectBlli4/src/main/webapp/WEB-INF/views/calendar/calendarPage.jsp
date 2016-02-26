<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<script type="text/javascript">
	
	var dateObj = new Date();
	var thisYear = dateObj.getFullYear();
	var thisMonth = dateObj.getMonth()+1;
	var thisDay = dateObj.getDate();
	
	var y = thisYear;
	var m = thisMonth;
	var d = thisDay;
	
	$(document).ready(function(){
		$("#addScheduleForm").hide();
		showCalendar();
	});
	
	//달력 츌력
	function showCalendar(leftOrRight) {
		
		$.ajax({
			type: "POST",
			url: "${initParam.root}member_getMemberScheduleList.do",
			data: "&memberId=${sessionScope.blliMemberVO.memberId}",
			cache: false,
			success: function(memberScheduleList){
				
				if(leftOrRight=="left") {
					if(m==1) {
						y = y-1;
						m = 12;
					} else {
						m = m-1;
					}
				} else if(leftOrRight=="right") {
					if(m==12) {
						y = y+1;
						m = 1;
					} else {
						m = m+1;
					}
				}
				
				$(".cal_year").html(y+"년");		
				$(".cal_month").html(m+"월");
				
				var calendarText = "<colgroup><col width='148px'><col width='148px'><col width='148px'><col width='148px'>"
									+"<col width='148px'><col width='148px'><col width='148px'></colgroup>"
									+"<tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr>"
									+"<tr>";

			    var d1 = (y+(y-y%4)/4-(y-y%100)/100+(y-y%400)/400 + m*2+(m*5-m*5%9)/9-(m<3?y%4||y%100==0&&y%400?2:3:4))%7;
			    var numberOfDaysOfThisMonth = (m*9-m*9%8)/8%2+(m==2?y%4||y%100==0&&y%400?28:29:30);
			    var totalCellNumber = 35;
			    var yearForDB = y-2000;
			    var monthForDB = m;

			    
			    for (i = 0; i < totalCellNumber; i++) {
			    	
			    	var dayForDB = i+1-d1;
			    	
			    	
			        if (i>0 && i%7==0) {
			        	calendarText += '</tr>\n<tr>';
			        }
			        
			        if (i < d1 || i >= d1+numberOfDaysOfThisMonth) {
			        	calendarText += '<td></td>';
			        } else {
			        	var scheduleText = '';
			        	
			        	//일정 표시 - 해당하지 않으면 반복문 break 하도록 걸어줘야 됨
			        	for(var j=0;j<memberScheduleList.length;j++) {
			        		if(yearForDB<10) {
						    	yearForDB = "0" + yearForDB;
							} 
			        		if(monthForDB<10) {
			        			monthForDB = "0" + monthForDB;
			        		}
			        		if(dayForDB<10) {
			        			dayForDB = "0" + dayForDB;
			        		}
			        		
			        		var dateForDB = yearForDB + "/" + monthForDB + "/" + dayForDB;
			        		
				        	if(dateForDB==memberScheduleList[j].scheduleDate) {
				        		scheduleText += '<p class="cal_bg schedule" style="background:'+memberScheduleList[j].babyColor+';">' + memberScheduleList[j].scheduleTitle;
				        		scheduleText += '<input type="hidden" value='+memberScheduleList[j].scheduleId+'></p>';
				        	}
				        	
				        	if(yearForDB<10) {
						    	yearForDB = yearForDB.substring(1,2);
							}
				        	if(monthForDB<10) {
				        		monthForDB = monthForDB.substring(1,2);
			        		}
				        	if(dayForDB<10) {
				        		dayForDB = dayForDB.substring(1,2);
			        		}
			        	}
						
			        	//string -> number
			        	i = i*1;
			        	
			        	//오늘 일자 표시
			        	if(y==thisYear && m==thisMonth && (i+1-d1)==thisDay) {
			        		calendarText += '<td class="calendarDateCell" style="border: 2px solid red; margin:-3px;"' + (i%7 ? '' : ' style="color:red;"') 
			        						+ ((i-6)%7 ? '' : ' style="color:blue;"')
			        						+ '><p class="cal_day">' + (i+1-d1) + '</p>' + scheduleText +'</td>';
				        } else {
				        	calendarText += '<td class="calendarDateCell"' + (i%7 ? '' : ' style="color:red;"') 
				        					+ ((i-6)%7 ? '' : ' style="color:blue;"')
				        					+ '><p class="cal_day">' + (i+1-d1) + '</p>' + scheduleText +'</td>';
				        }
			        }
			        
			        //달력 주차수가 5줄로 모자를 경우 한 줄 더 늘려준다.
			        if(i==34 && (i+1-d1)<numberOfDaysOfThisMonth) {
			        	totalCellNumber = 42;
			        }
			    }//for
			    
			    $('#calendarTable').html(calendarText);
			}//success
	    });//ajax
		
	}
	
	
	$(document).on('mouseenter', '.calendarDateCell',  function(){
		//오늘이 아닐때만
		if($(this).children().text()!=thisDay){
			$(this).css("background", "rgba(0,128,192,0.1)");
		}
	}).on('mouseleave', '.calendarDateCell', function() {
		if($(this).children().text()!=thisDay){
			$(this).css("background", "rgba(0,128,192,0.05)");
		}
	});
	
	var isPointerInP;
	
	$(document).on('mouseenter', '.schedule',  function(){
		isPointerInP = true;
	}).on('mouseleave', '.schedule', function() {
		isPointerInP = false;
	});
	
	//일정을 추가하고자 하는 일자를 클릭시 해당 일자의 정보와 함께 일정 추가 양식 우측에 출력
	$(document).on("click", ".calendarDateCell", function(){
		
		$(".cal_plus_form").css("background", "#ffffcc");
		
		if(isPointerInP==true) {
			return;
		}
		
		if($(this).children().length>=4) {
			alert("일정은 3개까지 등록하실 수 있습니다.");
			return;
		}
		
		$(".calendarDateCell").css("background", "rgba(0,128,192,0.05)");
		$(this).css("background", "rgba(0,128,192,0.2)"); //유지하게 하자 - if css 이용
		
		var year = $(".cal_year").text().substring(0,4);
		var month = $(".cal_month").text().substring(0, $(".cal_month").text().length-1);
		var day = $(this).children().eq(0).text();
		
		showAddSchduleForm(year, month, day);
	});
	
	
	function showAddSchduleForm(year, month, day) {
		
		if(month<10) {
			month = "0" + month;
		}
		if(day<10) {
			day = "0" + day;
		}
		
		var date = year+"년 " + month+"월 "+day+"일";
		
		var memberBabyNameList = "";
		for(var i=0;i<$("input[name=babyNameList]").length;i++) {
			memberBabyNameList += '<td><input type="radio" name="babyName" value="'+$("input[name=babyNameList]")[i].value+'" style="height:12px;">'
								+ $("input[name=babyNameList]")[i].value
								+ '<input type="hidden" name="babyColor" value="'+$("input[name=babyColor]")[i].value+'"></td>';
		}
		
		$(".cal_plus_ti").text("일정 등록");
		$("#scheduleDetailInfoTable").children().children().siblings().eq(1).children().html(
			memberBabyNameList+'<input type="hidden" name="scheduleDateForAdd" value="'+ year + month + day +'">'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(3).children().siblings().eq(0).html(date);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(3).children().siblings().eq(1).html(
			'<input type="text" name="scheduleLocation" size="10">'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(5).children().html(
				'<input type="text" style="width:100%;" name="scheduleTitle">');
		$("#scheduleDetailInfoTable").children().children().siblings().eq(7).children().html(
				'<textarea name="scheduleContent"></textarea>'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(8).children().html(
			'<a href="#"><img src="./img/regist_schedule.png" alt="등록" class="fl" id="addScheduleBtn"></a>'
			+'<a href="#"><img src="./img/cancel_schedule.png" alt="취소" class="fr" id="cancelScheduleBtn"></a>'
		);
		
		$("#addScheduleForm").show();
		
		//텍스트 애니메이션으로 날짜 변경 알려주기
		//$('#date').animate({'font-size':'16px'}, 1000, 'easeOutQuad');
	}
	
	
	$(document).on("click", "#addScheduleBtn", function(){
		
		if($("input[name=babyName]:checked").length<1) {
			alert("아이를 체크해주세요.");
			return;
		}
		if($("input[name=scheduleLocation]").val()=="") {
			alert("일정 장소를 입력해주세요.");
			return;
		}
		if($("input[name=scheduleTitle]").val()=="") {
			alert("일정 제목을 입력해주세요.");
			return;
		}
		if($("textarea[name=scheduleContent]").val()=="") {
			alert("내용을 입력해주세요.");
			return;
		}
		if($("input[name=scheduleLocation]").val().length>8) {
			alert("장소는 8자 이하로 입력해주세요.");
			return;
		}
		if($("input[name=scheduleTitle]").val().length>20) {
			alert("제목은 20자 이하로 입력해주세요.");
			return;
		}
		if($("textarea[name=scheduleContent]").val().length>100) {
			alert("내용은 100자 이하로 입력해주세요.");
			return;
		}
		
		var babyColor;
		
		if($("input[name=babyName]:checked").siblings().val()==1) {
			babyColor = "#FFDEAD";
		} else if($("input[name=babyName]:checked").siblings().val()==2) {
			babyColor = "#F4A460";
		} else if($("input[name=babyName]:checked").siblings().val()==3) {
			babyColor = "#CD853F";
		}
		
		$.ajax({
			type: "POST",
			url: "${initParam.root}member_addSchedule.do",
			data: "babyName="+$("input[name=babyName]:checked").val()
					+"&babyColor="+babyColor
					+"&scheduleDate="+$("input[name=scheduleDateForAdd]").val()
					+"&memberId=${sessionScope.blliMemberVO.memberId}"
					+"&scheduleTitle="+$("input[name=scheduleTitle]").val()
					+"&scheduleLocation="+$("input[name=scheduleLocation]").val()
					+"&scheduleContent=<pre>"+$("textarea[name=scheduleContent]").val()+"</pre>", //위치 그대로 출력하기 위한 pre태그
			cache: false,
			success: function(bsvo){
				
				//앞에 0이있으면 지워준다
				var year = bsvo.scheduleDate.substring(2,4);
				var month = bsvo.scheduleDate.substring(4,6);
				if(month.indexOf('0')==0) {
					month = month.substring(1);
				}
				var day = bsvo.scheduleDate.substring(6,8);
				if(day.indexOf('0')==0) {
					day = day.substring(1);
				}
				
				//1씩 곱해서 string으로 변한 숫자를 다시 number로 만든다
				year = year*1;
				month = month*1;
				day = day*1;
				
				showCalendar(year, month, day);
				alert("일정이 등록되었습니다.");
				showSchduleDetail(bsvo);
			}
	    });
	});
	
	
	function showSchduleDetail(bsvo) {
		
		var yearToString = bsvo.scheduleDate.substring(0,4)+"년 ";
		
		//1의 자리라서 앞에 0이 붙어있었다면 지워준다.
		var monthToString = bsvo.scheduleDate.substring(4,6)+"월 ";
		if(monthToString.indexOf('0')==0) {
			monthToString = monthToString.substring(1);
		}
		var dayToString = bsvo.scheduleDate.substring(6,8)+"일";
		if(dayToString.indexOf('0')==0) {
			dayToString = dayToString.substring(1);
		}
		
		var dateToString = yearToString + monthToString + dayToString;
										
		$(".cal_plus_ti").text("일정 보기");								
		$("#scheduleDetailInfoTable").children().children().siblings().eq(1).children().html(
			bsvo.babyName
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(3).children().siblings().eq(0).html(
			dateToString
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(3).children().siblings().eq(1).html(
			bsvo.scheduleLocation
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(5).children().html(
			bsvo.scheduleTitle
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(7).children().html(
			bsvo.scheduleContent
			+'<input type="hidden" name="scheduleId" value="'+bsvo.scheduleId+'">'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(8).children().html(
			'<a href="#"><img src="./img/update_schedule.png" alt="수정" class="fl" id="changeFormToUpdateScheduleBtn"></a>'
			+'<a href="#"><img src="./img/delete_schedule.png" alt="삭제" class="fr" id="deleteScheduleBtn"></a>'
		);
			
		$(".cal_plus_form").css("background", bsvo.babyColor);
		$("#addScheduleForm").show();
	}
	
	
	//일정 클릭시 해당 일정의 상세 정보를 보여준다.
	$(document).on("click", ".schedule", function(){
		$.ajax({
			type: "POST",
			url: "${initParam.root}member_getScheduleInfoByScheduleId.do",
			data: "scheduleId="+$(this).children().val(),
			cache: false,
			success: function(bsvo){
				showSchduleDetail(bsvo);
			}
	    });
	});
	
	
	$(document).on("click", "#cancelScheduleBtn", function(){
		$("#addScheduleForm").hide();
	});
	
	$(document).on("click", "#changeFormToUpdateScheduleBtn", function(){
		
		var babyName = $(this).parent().parent().parent().siblings().eq(1).children().text();
		var date = $(this).parent().parent().parent().siblings().eq(3).children().siblings().eq(0).text();
		var location = $(this).parent().parent().parent().siblings().eq(3).children().siblings().eq(1).text();
		var title = $(this).parent().parent().parent().siblings().eq(5).children().text();
		var content = $(this).parent().parent().parent().siblings().eq(7).children().text();
						
		var scheduleId = $("input[name=scheduleId]").val();
		
		$(".cal_plus_ti").text("일정 수정");								
		$("#scheduleDetailInfoTable").children().children().siblings().eq(1).children().html(
			babyName
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(3).children().siblings().eq(0).html(
			date
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(3).children().siblings().eq(1).html(
			'<input type="text" size="14" name="scheduleLocation" value="'+location+'">'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(5).children().html(
			'<input type="text" style="width:100%;" name="scheduleTitle" value="'+title+'">'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(7).children().html(
			'<textarea name="scheduleContent">'+content+'</textarea>'
			+'<input type="hidden" name="scheduleId" value="'+scheduleId+'">'
		);
		$("#scheduleDetailInfoTable").children().children().siblings().eq(8).children().html(
			'<a href="#"><img src="./img/confirm_schedule.png" alt="확인" class="fl" id="updateScheduleBtn"></a>'
			+'<a href="#"><img src="./img/cancel_schedule.png" alt="취소" class="fr" id="cancelScheduleBtn"></a>'
		);
	});
	
	$(document).on("click", "#updateScheduleBtn", function(){
		
		var locationVal = $(this).parent().parent().parent().siblings().eq(3).children().siblings().eq(1).children().val();
		var titleVal = $(this).parent().parent().parent().siblings().eq(5).children().children().val();
		var contentVal = $(this).parent().parent().parent().siblings().eq(7).children().children().val();
		
		var scheduleIdVal = $("input[name=scheduleId]").val();
		
		if(locationVal=="") {
			alert("일정 장소를 입력해주세요.");
			return;
		}
		if(titleVal=="") {
			alert("일정 제목을 입력해주세요.");
			return;
		}
		if(contentVal=="") {
			alert("내용을 입력해주세요.");
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "${initParam.root}member_updateSchedule.do",
			data: "scheduleId="+scheduleIdVal
					+"&scheduleTitle="+titleVal
					+"&scheduleLocation="+locationVal
					+"&scheduleContent="+contentVal,
			cache: false,
			success: function(bsvo){
				
				//1의 자리라서 앞에 0이 붙어있었다면 지워준다.
				var thisYear = "20"+bsvo.scheduleDate.substring(0,2);
				var thisMonth = bsvo.scheduleDate.substring(3,5);
				if(thisMonth.indexOf('0')==0) {
					thisMonth = thisMonth.substring(1);
				}
				var thisDay = bsvo.scheduleDate.substring(6,8);
				if(thisDay.indexOf('0')==0) {
					thisDay = thisDay.substring(1);
				}
				
				bsvo.scheduleDate = thisYear + bsvo.scheduleDate.substring(3,5) + bsvo.scheduleDate.substring(6,8);
				
				//1씩 곱해서 string으로 변한 숫자를 다시 number로 만든다
				thisYear = thisYear*1;
				thisMonth = thisMonth*1;
				thisDay = thisDay*1;
				
				bsvo.scheduleId = scheduleIdVal;
				
				showCalendar(thisYear, thisMonth, thisDay);
				alert("일정이 수정되었습니다.");
				showSchduleDetail(bsvo);
			}
	    });
		
	});
	
	
	$(document).on("click", "#deleteScheduleBtn", function(){
		
		if(!confirm("삭제하시겠습니까?")){
			return;
		};
		
		$.ajax({
			type: "POST",
			url: "${initParam.root}member_deleteSchedule.do",
			data: "scheduleId="+$("input[name=scheduleId]").val(),
			cache: false,
			success: function(){
				showCalendar();
				alert("일정이 삭제되었습니다.");
				$("#addScheduleForm").hide();
			}
	    });
		
	});
	
</script>


<c:set var="season" value=""/> <!-- 계절별로 배경이미지 다르게 -->
<c:choose>
	<c:when test="">
		<body background="./img/calendar_bgimg_winter.jpg" style="background-size:100% 100%;">
	</c:when>
	<c:when test="">
		<body background="./img/calendar_bgimg_winter.jpg" style="background-size:100% 100%;">
	</c:when>
	<c:when test="">
		<body background="./img/calendar_bgimg_winter.jpg" style="background-size:100% 100%;">
	</c:when>
	<c:otherwise>
		<body background="./img/calendar_bgimg_winter.jpg" style="background-size:100% 100%;">
	</c:otherwise>
</c:choose>

	<c:forEach items="${sessionScope.blliMemberVO.blliBabyVOList}" var="blliBabyVOList" varStatus="status">
		<input type="hidden" name="babyNameList" value="${blliBabyVOList.babyName}">
		<input type="hidden" name="babyColor" value="${status.count}">
	</c:forEach>
	
    <div class="jbContent">
		<div class="in_fr">
			<div>
				<div class="result_ti" style='margin-top:10px; text-shadow: 0 0 3px #b3b3b3; -moz-text-shadow: 0 0 3px #b3b3b3; -webkit-text-shadow: 0 0 3px #b3b3b3;'>
					이달의 아이 일정
				</div>
				<div>
					<div id="calendarControllerDiv" style="margin-top:30px; vertical-align:middel;">
						<a href="#">
							<img src="./img/allow_lgray.jpg" alt="왼쪽 화살표" class="fl" onclick="showCalendar('left')">
						</a>
						<div class="fl cal">
							<p class="cal_year"></p><p class="cal_month"></p>
						</div>
						<a href="#">
							<img src="./img/allow_rgray.jpg" alt="오른쪽 화살표" class="fr" onclick="showCalendar('right')">
						</a>
					</div>
					<div class="calendar">
						<table id="calendarTable">
	    				</table>
					</div>
				</div>
			</div>
		</div>
		<div id="addScheduleForm">
			<div class="cal_plus_form">
				<div class="cal_plus_ti"></div>
				<table id="scheduleDetailInfoTable">
					<tr>
						<th colspan="3">누구의 일정인가요?</th>
					</tr>
					<tr>
						<td><!-- 아기 이름 --></td>
					</tr>
					<tr>
						<th colspan="2">날짜</th>
						<th>장소</th>
					</tr>
					<tr>
						<td colspan="2"><!-- 날짜 --></td>
						<td><!-- 장소 --></td>
					</tr>
					<tr>
						<th colspan="3">제목</th>
					</tr
					><tr>
						<td colspan="3"><!-- 제목 --></td>
					</tr>
					<tr>
						<th colspan="3">내용</th>
					</tr>
					<tr>
						<td colspan="3" style="margin-bottom: 20px;"><!-- 내용 --></td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<!-- 이미지 -->
						</td>
					</tr>
				</table>
			</div>
		</div>
    </div>
</body>