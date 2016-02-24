package kr.co.blli.model.security;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.blli.model.member.MemberService;
import kr.co.blli.model.vo.BlliBabyVO;
import kr.co.blli.model.vo.BlliMemberVO;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class BlliAuthenticationSuccessHandler implements AuthenticationSuccessHandler{
	/**
	  * @Method Name : onAuthenticationSuccess
	  * @Method 설명 : 자동로그인 후 세션 정보 담아줌
	  * @작성일 : 2016. 1. 18.
	  * @작성자 : junyoung
	  * @param request
	  * @param response
	  * @param authentication
	  * @throws IOException
	  * @throws ServletException
	 */
	@Resource
	private MemberService memberService;
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		HttpSession session = request.getSession();
		BlliMemberVO blliMemberVO = null;;
		try {
			blliMemberVO = memberService.selectBlliMemberInfoByMemberId(authentication.getName());
			List <BlliBabyVO> blliBabyVOList=memberService.selectBabyListByMemberId(blliMemberVO.getMemberId());
			blliMemberVO.setBlliBabyVOList(blliBabyVOList);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		if(blliMemberVO==null){
			session.invalidate();
			response.sendRedirect("index.do");
		}else if(blliMemberVO.getMemberState()==-1){
			session.invalidate();
			response.sendRedirect("index.do");
		}else{
			//메인페이지로 이동할 때 회원이 가진 아이리스트를 전달 받는다.
			session.setAttribute("blliMemberVO", blliMemberVO);
			response.sendRedirect("authorityCheck.do");
		}
		
	}
}
