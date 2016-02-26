<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<style type="text/css">
	.alertDiv{
		margin-top: -15px;
	    font-size: 11px;
	    margin-bottom: 10px;
	}
</style>

<script type="text/javascript">
	//이메일 유효성 변수
	var emailValidity = true;
	//회원 이름 유효성 변수
	var memberNameValidity = true;
	//회원 비밀번호 유효성 변수
	var passwordValidity = false;
	//회원 비밀번호 확인 유효성 변수
	var repasswordValidity = false;
	
	$(document).ready(function(){
		$(':input[name="breakAwayReason"]').keyup(function(){
			$(this).val($(':input[name="breakAwayReason"]').val().substring(0,100));
		});
		$('#breakAwayFromBlliModal').on('hidden.bs.modal', function (e) {
			$(':input[name="breakAwayReason"]').val('');
		});
		$.ajax({
			type:"get",
			url:"footerStatics.do",
			success:function(data){
				$('.footerProductStatics').text(data.productStatics);
				$('.footerPostingStatics').text(data.postingStatics);
			}
		});
		//입력 값 초기화
		$(':input[name="memberPassword"]').val('');
		$(':input[name="memberRePassword"]').val('');
		
		
		$(':input[name="memberName"]').keyup(function(){
			//유저의 입력값
			var userName = $(this).val();
			if(userName==""){
				$('#memberNameInsertMSG').text('성함 혹은 별칭을 입력해주세요');
			}
			if(userName.length>=10){
				$('#memberNameInsertMSG').text('성함 혹은 별칭은 9글자 이하로 입력해주세요');
				$(this).val(userName.substring(0,9));
			}else if(userName.length>0){
				$('#memberNameInsertMSG').text('유효한 이름입니다!');
				memberNameValidity = true;
			}
			
		});
		$(':input[name="memberPassword"]').keyup(function(){
			//유저의 입력값
			var userPassword = $(this).val();
			if(userPassword==""){
				$('#memberPasswordInsertMSG').text('비밀번호를 입력 해주세요');
			}
			if(userPassword.length>=12){
				$('#memberPasswordInsertMSG').text('비밀번호는 6글자 이상, 12글자 이하로 입력해주세요');
				$(this).val(userPassword.substring(0,12));
			}else if(userPassword.length>6){
				$('#memberPasswordInsertMSG').text('유효한 비밀번호입니다!');
				passwordValidity = true;
			}
		});
		$(':input[name="memberRePassword"]').keyup(function(){
			var userRePassword = $(this).val();
			if(userRePassword==""){
				$('#memberRePasswordInsertMSG').text('비밀번호를 확인 해주세요');
			}
			if(userRePassword.length>=12){
				$('#memberRePasswordInsertMSG').text('비밀번호는 6글자 이상, 12글자 이하로 입력해주세요');
				$(this).val(userRePassword.substring(0,12));
			}else if(userRePassword.length>6){
				if($(':input[name="memberPassword"]').val()==userRePassword){
					$('#memberRePasswordInsertMSG').text('비밀번호가 확인되었습니다.');
					repasswordValidity = true;
				}else{
					$('#memberRePasswordInsertMSG').text('비밀번호가 서로 일치하지 않습니다.');
				}
			}
		});
		
	});
		function submitMemberInfo(){
			if(!memberNameValidity){
				alert('입력하신 이름을 확인해주세요');
				$(':input[name="memberName"]').focus();
				return false;	
			}
			if(!passwordValidity){
				alert('입력하신 비밀번호를 확인해주세요');
				$(':input[name="memberPassword"]').focus();
				return false;	
			}
			if(!repasswordValidity){
				alert('확인하신 비밀번호가 올바르지않습니다.');
				$(':input[name="memberRePassword"]').focus();
				return false;	
			}
			document.getElementById("memberInfoForm").submit();
		}
		function emailReceiveStatusChanger(){
			var emailStatus = $('#emailReceiveStatus').val();
			if(emailStatus==0){
				if(confirm('정말 이메일 수신동의를 해제하시겠습니까?')){
					$.ajax({
						type:"get",
						url:"member_denySendEmail.do?memberEmail=${sessionScope.blliMemberVO.memberEmail}",
						success:function(data){
							$('#emailStatusDIV').text('이메일 수신 거부');
							$('#emailReceiveStatus').val('1');
							alert('이메일 수신이 거부되었습니다!');
						}
					});
				}
			}else{
					$.ajax({
						type:"get",
						url:"member_acceptSendEmail.do?memberEmail=${sessionScope.blliMemberVO.memberEmail}",
						success:function(data){
							$('#emailStatusDIV').text('이메일 수신 동의');
							$('#emailReceiveStatus').val('0');
							alert('이메일 수신이 동의되었습니다!');
						}
					});
			}
		}
		function breakAwayFromBlli(){
			if($(':input[name="breakAwayReason"]').val().length<10){
				alert('탈퇴사유를 10자 이상 작성해주세요');
			}else if($(':input[name="breakAwayReason"]').val().length>100){
				alert('탈퇴사유는 10자 이상 100자 미만으로 작성해주세요!');
			}else if(confirm('탈퇴하신 이메일로는 다시 가입하실 수 없습니다. 정말 탈퇴하시겠습니까?')){
				$('#breakAwayFromBlliForm').submit();
			}
		}
</script>

</head>
        <div class="register-background" style="background-image: url('${initParam.root}img/modifyBg.jpg"> 
            <div class="filter-black"></div>
                <div class="container">
                    <div class="row">
                        <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1 ">
                            <div class="register-card">
                                <h3 class="title">회원 정보 수정</h3>
                                <form class="register-form" method="post" name="memberInfo" id="memberInfoForm"action="member_updateMemberInfoByEmail.do">
                                	<input type="hidden" name="memberId" value="${requestScope.blliMemberVO.memberId}"  readonly="readonly">
                                    <input type="hidden" name="memberEmail" placeholder="이메일 주소를 입력해주세요" value="${requestScope.blliMemberVO.memberEmail}">
                                    <div class="alertDiv" id="memberIdInsertMSG"></div>
                                    <label>이름</label>
                                    <input type="text" class="form-control" name="memberName" placeholder="${requestScope.blliMemberVO.memberName}" value="${requestScope.blliMemberVO.memberName}">
									<div class="alertDiv" id="memberNameInsertMSG"></div>
                                    <label>새로운 비밀번호</label>
                                    <input type="password" class="form-control" name="memberPassword" placeholder="비밀번호(6자 이상)">
                                    <div class="alertDiv" id="memberPasswordInsertMSG"></div>
                                    <label>비밀번호 확인</label>
                                    <input type="password" class="form-control" name="memberRePassword" placeholder="비밀번호 확인">
                                    <div class="alertDiv" id="memberRePasswordInsertMSG"></div>
                                    <a class="btn btn-danger btn-block" onclick="submitMemberInfo()" style="margin-top:30px;">수정</a>
                                </form>
                                <div class="forgot">
                                	<c:if test="${requestScope.blliMemberVO.mailAgree==0}">
                                    	<a href="#" class="btn btn-simple btn-danger" onclick="emailReceiveStatusChanger()" id="emailStatusDIV">이메일 수신 거부 하기</a>
                                	</c:if>
                                	<c:if test="${requestScope.blliMemberVO.mailAgree==1}">
                                    	<a href="#" class="btn btn-simple btn-danger" onclick="emailReceiveStatusChanger()" id="emailStatusDIV">이메일 수신 동의 하기</a>
                                	</c:if>
                                	<input type="hidden" value="${requestScope.blliMemberVO.mailAgree}" id="emailReceiveStatus">
                                    <a href="#" class="btn btn-simple btn-danger" data-toggle="modal" data-target="#breakAwayFromBlliModal">회원 탈퇴하기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>     
        </div>
<div class="login_bottom">
			<div class="fl login_bottom_ft">
				블리는 <span class="footerProductStatics"></span>개의 상품을 소개하고, 관련된 <span class="footerPostingStatics"></span>개의 블로그를 분석하고 소개합니다.
			</div>
			<div class="fr">
				<div class="login_bottom_right">
				<a href="${initParam.root}adminIndex.do"><img src="./img/bottom_app1.png" alt="안드로이드 다운로드받기"></a>
				<a href="#"><img src="./img/bottom_app2.png" alt="애플 다운로드받기"></a>
				</div>
			</div>
		</div>
		<div class="modal fade" id="breakAwayFromBlliModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">회원 탈퇴하기</h4>
      </div>
      <div class="modal-body">
        <p></p>
        <form action="breakAwayFromBlli.do" method="post" id="breakAwayFromBlliForm">
        	<textarea class="form-control" rows="3" placeholder="탈퇴사유를 적어주세요!(10자 이상)" name="breakAwayReason"></textarea>
        	<input type="hidden" name="memberId" value="${sessionScope.blliMemberVO.memberId}">
        </form>
      </div>
      <div class="modal-footer" style="padding:10px;">
        <button type="button" class="btn btn-default" data-dismiss="modal">탈퇴취소</button>
        <button type="button" class="btn btn-primary" onclick="breakAwayFromBlli()">탈퇴 완료</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->