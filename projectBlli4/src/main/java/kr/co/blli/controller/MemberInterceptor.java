package kr.co.blli.controller;

import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.blli.model.member.MemberService;
import kr.co.blli.model.vo.BlliBabyVO;
import kr.co.blli.model.vo.BlliMemberVO;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class MemberInterceptor extends HandlerInterceptorAdapter{
	
	@Resource
	private MemberService memberService;
	
	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
		Boolean flag = true;
		HttpSession session =  request.getSession();
		if(session!=null){
			if(session.getAttribute("SPRING_SECURITY_CONTEXT")!=null){
				SecurityContext ctx=(SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
				Authentication auth=ctx.getAuthentication();
				//메인 페이지로 이동하며 세션에 blliMemberVO객체를 담아준다.
				//Query : member_id,member_email,member_name,member_state,authority,recommending_baby_name
				BlliMemberVO blliMemberVO = memberService.selectBlliMemberInfoByMemberId(auth.getName());
				//메인페이지로 이동할 때 회원이 가진 아이리스트를 전달 받는다.
				List <BlliBabyVO> blliBabyVOList=memberService.selectBabyListByMemberId(blliMemberVO.getMemberId());
				session.setAttribute("blliMemberVO", blliMemberVO);
				if(blliMemberVO.getMemberState()==-1){
					response.sendRedirect("logout.do");
					return false;
				}
			}
		}else{
			flag = false;
		}
		return flag;
	}
}
