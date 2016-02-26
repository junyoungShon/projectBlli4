package kr.co.blli.model.scheduler;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.co.blli.model.member.MemberDAO;
import kr.co.blli.model.member.MemberService;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliScheduleVO;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class NoticeScheduler {
	@Resource
	private MemberDAO memberDAO;
	@Resource
	private MemberService memberService;
	
	/**
	  * @Method Name : getNoticeVOList
	  * @Method 설명 : 주기적으로 회원 일정의 알림 상태를 업데이트하는 스케줄러
	  * @작성일 : 2016. 2. 26.
	  * @작성자 : yongho
	  * @param memberId
	  * @return
	  */
	@Scheduled(cron = "00 00 00 * * *") // 매일 00시 모든 회원의 일정 알림 상태를 업데이트
	//@Scheduled(cron = "00/05 * * * * *") //테스트용
	public void updateCheckStateScheduler() {
		
		List<String> memberIdList = memberService.getAllMemberIdList();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String currentDate = formatter.format(new Date());
		HashMap<String, Integer> updateWithThis = new HashMap<String, Integer>();
		
		for(int i=0; i<memberIdList.size(); i++) {
			
			List<BlliScheduleVO> sidList = memberDAO.getScheduleIdAndDateByMemberId(memberIdList.get(i));
			
			for(int j=0;j<sidList.size();j++) {
				
				Date today = null;
				Date scheduleDate = null;
				try {
					today = formatter.parse(currentDate);
					scheduleDate = formatter.parse(sidList.get(j).getScheduleDate());
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				// 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
				long diffTime = scheduleDate.getTime() - today.getTime();
				int leftDays = (int) (diffTime / (24 * 60 * 60 * 1000));
				
				System.out.println("일정까지 남은일수: " + leftDays);
				
				updateWithThis.put("scheduleId", sidList.get(j).getScheduleId());
				
				//0, 1, 3, 7일 남은 것들만 출력되도록 checkState 세팅
				if(leftDays == 0 || leftDays == 1 || leftDays == 3 || leftDays == 7) {
					updateWithThis.put("noticeOrNot", 1);
					updateWithThis.put("leftDays", leftDays);
				} else {
					updateWithThis.put("noticeOrNot", -1);
				}
				
				memberDAO.updateCheckStateAndLeftDays(updateWithThis);
			}
			
		}
		
	}
	
}
