<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="left_col scroll-view">

          <div class="navbar nav_title" style="border: 0;">
            <a href="index.html" class="site_title"><i class="fa fa-paw"></i> <span>블리 관리자 메뉴</span></a>
          </div>
          <div class="clearfix"></div>

          <!-- menu prile quick info -->
          <div class="profile">
            <div class="profile_pic">
              <img src="${initParam.root}img/jjim_ov.png" alt="..." class="img-circle profile_img">
            </div>
            <div class="profile_info">
              <span>Welcome,</span>
              <h2>Admin</h2>
            </div>
          </div>
          <!-- /menu prile quick info -->
          <br />
          <!-- sidebar menu -->
          <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">

            <div class="menu_section">
              <h3>General</h3>
              <ul class="nav side-menu">
                <li><a href="${initParam.root}admin_adminIndex.do"><i class="fa fa-home"></i> Home <span class="fa fa-chevron-down"></span></a>
                </li>
                <li><a><i class="fa fa-edit"></i> 상품 관리 <span class="fa fa-chevron-down"></span></a>
                  <ul class="nav child_menu" style="display: none">
                    <li><a href="${initParam.root}admin_managingProductByMonthAge.do?minimumMonthAge=-2">시기별 추천 상품관리</a>
                    </li>
                    <li><a href="${initParam.root}admin_unconfirmedSmallProduct.do">소제품 등록</a>
                    </li>
                  </ul>
                </li>
                <li><a><i class="fa fa-desktop"></i> Crawler Controller <span class="fa fa-chevron-down"></span></a>
                  <ul class="nav child_menu" style="display: none">
                  	<li><a href="${initParam.root}admin_insertBigCategory.do">대분류 리스트 긁어모아</a></li>
					<li><a href="${initParam.root}admin_insertMidCategory.do">중분류 리스트 긁어모아</a></li>
					<li><a href="${initParam.root}admin_insertSmallProduct.do">소분류 리스트 긁어모아</a></li>
					<li><a href="${initParam.root}admin_insertPosting.do">포스팅 리스트 긁어모아</a></li>
                  </ul>
                </li>
                <li><a><i class="fa fa-table"></i> 기타 관리 메뉴 <span class="fa fa-chevron-down"></span></a>
                  <ul class="nav child_menu" style="display: none">
                   <li><a href="${initParam.root}admin_postingListWithSmallProducts.do">소제품 하나로 추려줘</a></li>
					<li><a href="${initParam.root}admin_unconfirmedPosting.do">포스팅 등록해줘</a></li>
					<li><a href="${initParam.root}admin_checkPosting.do">싫어요</a></li>
					<li><a href="${initParam.root}admin_checkMember.do">회원 목록</a></li>
					<li><a href="${initParam.root}admin_checkLog.do">로그 조회</a></li>
					<li><a href="${initParam.root}logout.do">로그아웃</a></li>
					<li><a href="${initParam.root}admin_midCategoryUseWhenModifyBySmallProduct.do">중분류 제품 사용시기 수정 - 소분류 제품 사용시기를 기준으로</a></li>
					<li><a href="${initParam.root}admin_allProductDownLoader.do">모든 제품 사진 다운로드</a></li>
					<li><a href="${initParam.root}admin_checkUserExceptionLog.do">사용자에의한 익셉션 확인</a></li>
					<li><a href="${initParam.root}admin_makingWordCloud.do">현재 confirmed인 포스팅을 대상으로 워드클라우드 생성</a></li>
					<li><a href="${initParam.root}admin_monthlyProductImageDownLoader.do">블리의 월령별 추천상품을 모두 다운로드해요</a></li>
                  </ul>
                </li>
                
              </ul>
            </div>
          
          </div>
          <!-- /sidebar menu -->
          <!-- /menu footer buttons -->
          <div class="sidebar-footer hidden-small">
            <a data-toggle="tooltip" data-placement="top" title="Settings">
              <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
            </a>
            <a data-toggle="tooltip" data-placement="top" title="FullScreen">
              <span class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span>
            </a>
            <a data-toggle="tooltip" data-placement="top" title="Lock">
              <span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span>
            </a>
            <a data-toggle="tooltip" data-placement="top" title="Logout">
              <span class="glyphicon glyphicon-off" aria-hidden="true"></span>
            </a>
          </div>
          <!-- /menu footer buttons -->
        </div>