package kr.co.blli.model.member;

import java.util.HashMap;
import java.util.List;

import kr.co.blli.model.vo.BlliBabyVO;
import kr.co.blli.model.vo.BlliBreakAwayVO;
import kr.co.blli.model.vo.BlliMailVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliNoticeVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliScheduleVO;

public interface MemberDAO {

	public BlliMemberVO findMemberByIdForLogin(String memberId);

	public void insertMemberInfo(BlliMemberVO blliMemberVO);

	public void updateMemberEmail(BlliMemberVO blliMemberVO);

	public void insertBabyInfo(BlliBabyVO blliBabyVO);

	public void updateMemberAuthority(BlliMemberVO blliMemberVO);

	public BlliMemberVO selectBlliMemberInfoByMemberId(String memberId);

	public List<BlliBabyVO> selectBabyListByMemberId(String memberId);

	public void changeRecommendingBaby(BlliBabyVO blliBabyVO);

	
	//용호 작성 영역
	public BlliMemberVO findMemberInfoById(String memberId);
	public BlliMailVO findMailSubjectAndContentByMailForm(String mailForm);
	public List<BlliMemberVO> getMemberHavingBabyAgeChangedList();
	public List<BlliBabyVO> getBabyAgeChangedListOfMember(String memberId);
	public void updateMemberInfoByEmail(BlliMemberVO blliMemberVO);
	public void deleteBabyInfo(BlliMemberVO blliMemberVO);
	public String findMemberNameByEmail(String memberEmail);
	public void updateMemberPasswordToTemporaryPassword(BlliMemberVO blliMemberVO);
	public int addSchedule(BlliScheduleVO bsvo);
	public BlliScheduleVO selectSchedule(BlliScheduleVO bsvo);
	public void updateSchedule(BlliScheduleVO bsvo);
	public void deleteSchedule(BlliScheduleVO bsvo);
	public List<BlliScheduleVO> getMemberScheduleList(String memberId);
	public BlliScheduleVO getScheduleInfoByScheduleId(String scheduleId);
	public void deleteSchedule(String scheduleId);
	public List<BlliScheduleVO> getScheduleIdAndDateByMemberId(String memberId);
	public void updateCheckStateAndLeftDays(HashMap<String, Integer> updateWithThis);
	public List<BlliNoticeVO> getNoticeList();
	public List<String> getAllMemberIdList();

	
	
	//현석 작성 영역
	public int denySendEmail(String memberEmail);
	public List<BlliPostingVO> getScrapeInfoByMemberId(BlliMemberVO memberVO);

	public int acceptSendEmail(String memberEmail);

	public int selectMailAgreeByMemberId(String memberId);

	public void updateMemberStatusByMemberId(BlliBreakAwayVO blliBreakAwayVO);

	public void breakAwayFromBlli(BlliBreakAwayVO blliBreakAwayVO);



	





}
