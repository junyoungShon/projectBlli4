package kr.co.blli.model.member;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.co.blli.model.vo.BlliBabyVO;
import kr.co.blli.model.vo.BlliBreakAwayVO;
import kr.co.blli.model.vo.BlliMailVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliNoticeVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliScheduleVO;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO{
	@Resource
	private SqlSessionTemplate sqlSessionTemplate;

	
	
	@Override
	public BlliMemberVO findMemberByIdForLogin(String memberId) {
		return sqlSessionTemplate.selectOne("member.findMemberByIdForLogin", memberId);
	}
	
	@Override
	public void insertMemberInfo(BlliMemberVO blliMemberVO) {
		sqlSessionTemplate.insert("member.insertMemberInfo", blliMemberVO);
	}

	@Override
	public void updateMemberEmail(BlliMemberVO blliMemberVO) {
		sqlSessionTemplate.update("member.updateMemberEmail",blliMemberVO);
	}
	
	@Override
	public void insertBabyInfo(BlliBabyVO blliBabyVO) {
		sqlSessionTemplate.insert("member.insertBabyInfo",blliBabyVO);
	}
	
	@Override
	public void updateMemberAuthority(BlliMemberVO blliMemberVO) {
		sqlSessionTemplate.update("updateMemberAuthority", blliMemberVO);
	}
	
	@Override
	public BlliMemberVO selectBlliMemberInfoByMemberId(String memberId) {
		return sqlSessionTemplate.selectOne("member.selectBlliMemberInfoByMemberId", memberId);
	}

	@Override
	public List<BlliBabyVO> selectBabyListByMemberId(String memberId) {
		return sqlSessionTemplate.selectList("member.selectBabyListByMemberId", memberId);
	}

	@Override
	public void changeRecommendingBaby(BlliBabyVO blliBabyVO) {
		sqlSessionTemplate.update("member.changeRecommendingBaby", blliBabyVO);
	}
	
	@Override
	public void updateMemberInfoByEmail(BlliMemberVO blliMemberVO) {
		sqlSessionTemplate.update("member.updateMemberInfoByEmail", blliMemberVO);
	}
	
	@Override
	public void deleteBabyInfo(BlliMemberVO blliMemberVO) {
		sqlSessionTemplate.delete("member.deleteBabyInfo", blliMemberVO);
	}
	
	
	
	//용호 작성 영역
	@Override
	public BlliMemberVO findMemberInfoById(String memberId) {
		return sqlSessionTemplate.selectOne("member.findMemberInfoById", memberId);
	}
	@Override
	public BlliMailVO findMailSubjectAndContentByMailForm(String mailForm) {
		return sqlSessionTemplate.selectOne("member.findMailSubjectAndContentByMailForm", mailForm);
	}
	@Override
	public List<BlliMemberVO> getMemberHavingBabyAgeChangedList() {
		return sqlSessionTemplate.selectList("member.getMemberHavingBabyAgeChangedList");	
	}
	@Override
	public List<BlliBabyVO> getBabyAgeChangedListOfMember(String memberId) {
		return sqlSessionTemplate.selectList("member.getBabyAgeChangedListOfMember", memberId);	
	}
	@Override
	public String findMemberNameByEmail(String memberEmail) {
		return sqlSessionTemplate.selectOne("member.findMemberNameByEmail", memberEmail);
	}
	@Override
	public void updateMemberPasswordToTemporaryPassword(BlliMemberVO blliMemberVO) {
		sqlSessionTemplate.update("member.updateMemberPasswordToTemporaryPassword", blliMemberVO);
	}
	@Override
	public int addSchedule(BlliScheduleVO bsvo) {
		sqlSessionTemplate.insert("member.addSchedule", bsvo);
		return bsvo.getScheduleId();
	}
	@Override
	public BlliScheduleVO selectSchedule(BlliScheduleVO bsvo) {
		return sqlSessionTemplate.selectOne("member.selectSchedule", bsvo);
	}
	@Override
	public void updateSchedule(BlliScheduleVO bsvo) {
		sqlSessionTemplate.update("member.updateSchedule", bsvo);
	}
	@Override
	public void deleteSchedule(BlliScheduleVO bsvo) {
		sqlSessionTemplate.update("member.deleteSchedule", bsvo);
	}
	@Override
	public List<BlliScheduleVO> getMemberScheduleList(String memberId) {
		return sqlSessionTemplate.selectList("member.getMemberScheduleList", memberId);
	}
	@Override
	public BlliScheduleVO getScheduleInfoByScheduleId(String scheduleId) {
		return sqlSessionTemplate.selectOne("member.getScheduleInfoByScheduleId", scheduleId);
	}
	@Override
	public void deleteSchedule(String scheduleId) {
		sqlSessionTemplate.delete("member.deleteSchedule", scheduleId);
	}
	@Override
	public List<BlliScheduleVO> getScheduleIdAndDateByMemberId(String memberId) {
		return sqlSessionTemplate.selectList("member.getScheduleIdAndDateByMemberId", memberId);
	}
	@Override
	public void updateCheckStateAndLeftDays(HashMap<String, Integer> updateWithThis) {
		sqlSessionTemplate.update("member.updateCheckStateAndLeftDays", updateWithThis);
	}
	@Override
	public List<BlliNoticeVO> getNoticeList() {
		return sqlSessionTemplate.selectList("member.getNoticeList");
	}
	@Override
	public List<String> getAllMemberIdList() {
		return sqlSessionTemplate.selectList("member.getAllMemberIdList");
	}
	
	
	//현석 작성 영역
	@Override
	public int denySendEmail(String memberEmail) {
		return sqlSessionTemplate.update("member.denySendEmail", memberEmail);
	}
	
	@Override
	public int acceptSendEmail(String memberEmail) {
		return sqlSessionTemplate.update("member.acceptSendEmail", memberEmail);
	}

	@Override
	public List<BlliPostingVO> getScrapeInfoByMemberId(BlliMemberVO memberVO) {
		return sqlSessionTemplate.selectList("member.getScrapeInfoByMemberId", memberVO);
	}

	@Override
	public int selectMailAgreeByMemberId(String memberId) {
		return sqlSessionTemplate.selectOne("member.selectMailAgreeByMemberId", memberId);
	}

	@Override
	public void updateMemberStatusByMemberId(BlliBreakAwayVO blliBreakAwayVO) {
		sqlSessionTemplate.update("member.updateMemberStatusByMemberId", blliBreakAwayVO);
	}

	@Override
	public void breakAwayFromBlli(BlliBreakAwayVO blliBreakAwayVO) {
		sqlSessionTemplate.insert("member.breakAwayFromBlli",blliBreakAwayVO);
	}

	
	

	

}
