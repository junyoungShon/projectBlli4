package kr.co.blli.model.admin;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.co.blli.model.vo.BlliMailVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliMidCategoryVO;
import kr.co.blli.model.vo.BlliMonthlyProductVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;
import kr.co.blli.model.vo.BlliWordCloudVO;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDAOImpl implements AdminDAO{
	@Resource
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public BlliMemberVO findMemberInfoById(String memberId) {
		return sqlSessionTemplate.selectOne("admin.findMemberInfoById", memberId);
	}
	@Override
	public BlliMailVO findMailSubjectAndContentByMailForm(String mailForm) {
		return sqlSessionTemplate.selectOne("admin.findMailSubjectAndContentByMailForm", mailForm);
	}
	@Override
	public List<BlliPostingVO> unconfirmedPosting(String pageNo) {
		return sqlSessionTemplate.selectList("admin.unconfirmedPosting", pageNo);
	}
	@Override
	public int totalUnconfirmedPosting() {
		return sqlSessionTemplate.selectOne("admin.totalUnconfirmedPosting");
	}
	@Override
	public List<BlliPostingVO> postingListWithSmallProducts(String pageNo) {
		return sqlSessionTemplate.selectList("admin.postingListWithSmallProducts", pageNo);
	}
	@Override
	public int totalPostingWithProducts() {
		return sqlSessionTemplate.selectOne("admin.totalPostingWithProducts");
	}
	@Override
	public List<BlliSmallProductVO> unconfirmedSmallProduct(String pageNo) {
		return sqlSessionTemplate.selectList("admin.unconfirmedSmallProduct", pageNo);
	}
	@Override
	public List<BlliSmallProductVO> unconfirmedSmallProductByMidCategoryId(HashMap<String, String> paraMap) {
		return sqlSessionTemplate.selectList("admin.unconfirmedSmallProductByMidCategoryId", paraMap);
	}
	@Override
	public int totalUnconfirmedSmallProduct() {
		return sqlSessionTemplate.selectOne("admin.totalUnconfirmedSmallProduct");
	}
	@Override
	public void deletePosting(BlliPostingVO vo) {
		sqlSessionTemplate.delete("admin.deletePosting", vo);
	}
	@Override
	public void selectProduct(BlliPostingVO vo) {
		sqlSessionTemplate.update("admin.selectProduct", vo);
		sqlSessionTemplate.update("admin.deleteProduct", vo);
	}
	@Override
	public void deleteProduct(String postingUrl) {
		sqlSessionTemplate.update("admin.deleteProduct", postingUrl);
	}
	@Override
	public int registerPosting(BlliPostingVO vo) {
		return sqlSessionTemplate.update("admin.registerPosting", vo);
	}
	@Override
	public void deleteSmallProduct(String smallProductId) {
		sqlSessionTemplate.update("admin.deleteSmallProduct", smallProductId);
	}
	@Override
	public void registerSmallProduct(BlliSmallProductVO vo) {
		sqlSessionTemplate.update("admin.registerSmallProduct", vo);
	}
	@Override
	public void registerAndUpdateSmallProduct(BlliSmallProductVO vo) {
		sqlSessionTemplate.update("admin.registerAndUpdateSmallProduct", vo);
	}
	@Override
	public void updateSmallProductName(BlliSmallProductVO vo) {
		sqlSessionTemplate.update("admin.updateSmallProductName", vo);
	}
	@Override
	public void updateMidCategoryWhenToUse(BlliSmallProductVO vo) {
		sqlSessionTemplate.update("admin.updateMidCategoryWhenToUseMin", vo);
		sqlSessionTemplate.update("admin.updateMidCategoryWhenToUseMax", vo);
	}
	@Override
	public String getMidCategoryId(String smallProductId) {
		return sqlSessionTemplate.selectOne("admin.getMidCategoryId", smallProductId);
	}
	@Override
	public void updatePostingCount(BlliPostingVO vo) {
		sqlSessionTemplate.update("admin.updatePostingCount", vo);
	}
	@Override
	public List<BlliPostingVO> makingWordCloud(String smallProductId) {
		return sqlSessionTemplate.selectList("admin.makingWordCloud", smallProductId);
	}
	@Override
	public String selectPostingContentByPostingUrl(BlliPostingVO blliPostingVO) {
		return sqlSessionTemplate.selectOne("admin.selectPostingContentByPostingUrl", blliPostingVO);
	}
	@Override
	public int updateWordCloud(BlliWordCloudVO blliWordCloudVO) {
		return sqlSessionTemplate.update("admin.updateWordCloud", blliWordCloudVO);
	}
	@Override
	public void insertWordCloud(BlliWordCloudVO blliWordCloudVO) {
		sqlSessionTemplate.insert("admin.insertWordCloud", blliWordCloudVO);
	}
	@Override
	public void snsShareCountUp(String smallProductId) {
		sqlSessionTemplate.update("admin.snsShareCountUp", smallProductId);
	}
	@Override
	public List<BlliMidCategoryVO> selectAllMidCategory() {
		return sqlSessionTemplate.selectList("admin.selectAllMidCategory");
	}
	@Override
	public List<BlliSmallProductVO> selectAllSmallProduct() {
		return sqlSessionTemplate.selectList("admin.selectAllSmallProduct");
	}
	@Override
	public List<BlliPostingVO> checkPosting() {
		return sqlSessionTemplate.selectList("admin.checkPosting");
	}
	@Override
	public void notAdvertisingPosting(BlliPostingVO postingVO) {
		sqlSessionTemplate.update("admin.notAdvertisingPosting", postingVO);
	}
	@Override
	public List<BlliMemberVO> checkMember() {
		return sqlSessionTemplate.selectList("admin.checkMember");
	}
	@Override
	public int updateSmallProductStatus(String smallProductId) {
		return sqlSessionTemplate.update("admin.updateSmallProductStatus", smallProductId);
	}
	@Override
	public void insertPermanentDeadPosting(BlliPostingVO vo) {
		sqlSessionTemplate.insert("admin.insertPermanentDeadPosting", vo);
	}
	@Override
	public void updatePostingStatusToconfirmed(String smallProductId) {
		sqlSessionTemplate.update("admin.updatePostingStatusToconfirmed", smallProductId);
	}
	@Override
	public List<BlliPostingVO> unconfirmedPostingBySearchSmallProduct(String pageNo, String searchWord) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("pageNo", pageNo);
		map.put("searchWord", searchWord);
		return sqlSessionTemplate.selectList("admin.unconfirmedPostingBySearchSmallProduct", map);
	}
	@Override
	public List<BlliPostingVO> unconfirmedPostingBySearchsmallProductId(String pageNo, String searchWord) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("pageNo", pageNo);
		map.put("searchWord", searchWord);
		return sqlSessionTemplate.selectList("admin.unconfirmedPostingBySearchsmallProductId", map);
	}
	@Override
	public int totalUnconfirmedPostingBySearchSmallProduct(String searchWord) {
		return sqlSessionTemplate.selectOne("admin.totalUnconfirmedPostingBySearchSmallProduct", searchWord);
	}
	@Override
	public int totalUnconfirmedPostingBySearchSmallProductId(String searchWord) {
		return sqlSessionTemplate.selectOne("admin.totalUnconfirmedPostingBySearchSmallProductId", searchWord);
	}
	@Override
	public BlliSmallProductVO getSmallProductWhenToUse(String midCategoryId) {
		return sqlSessionTemplate.selectOne("admin.getSmallProductWhenToUse", midCategoryId);
	}
	@Override
	public BlliSmallProductVO selectMinMaxUseWhenByMidcategoryId(String midCategoryId) {
		return sqlSessionTemplate.selectOne("admin.selectMinMaxUseWhenByMidcategoryId", midCategoryId);
	}
	@Override
	public void updateMinMaxUseWhenByMidcategoryId(BlliMidCategoryVO blliMidCategoryVO){
		sqlSessionTemplate.update("admin.updateMinMaxUseWhenByMidcategoryId", blliMidCategoryVO);
	}
	@Override
	public void updateMidCategoryMainPhotoLink(
			BlliMidCategoryVO blliMidCategoryVO) {
		sqlSessionTemplate.update("admin.updateMidCategoryMainPhotoLink", blliMidCategoryVO);
	}
	@Override
	public void updateSmallProductMainPhotoLink(
			BlliSmallProductVO blliSmallProductVO) {
		sqlSessionTemplate.update("admin.updateSmallProductMainPhotoLink", blliSmallProductVO);
	}
	@Override
	public List<BlliPostingVO> selectConfirmedPostingUrlAndSmallProductId() {
		return sqlSessionTemplate.selectList("admin.selectConfirmedPostingUrlAndSmallProductId");
	}
	@Override
	public List<BlliMonthlyProductVO> selectAllMonthlyProduct() {
		return sqlSessionTemplate.selectList("admin.selectAllMonthlyProduct");
	}
	@Override
	public List<BlliMidCategoryVO> selectMidCategoryByMonthlyProductID(String monthlyProductId) {
		return sqlSessionTemplate.selectList("admin.selectMidCategoryByMonthlyProductID",monthlyProductId);
	}
	@Override
	public void updatMonthlyProductPhotoLink(BlliMonthlyProductVO blliMonthlyProductVO) {
		sqlSessionTemplate.update("admin.updatMonthlyProductPhotoLink",blliMonthlyProductVO);
	}
	@Override
	public List<HashMap<String, Object>> selectMonthlyMidProductList(int minUsableMonth) {
		return sqlSessionTemplate.selectList("admin.selectMonthlyMidProductList",minUsableMonth);
	}
	@Override
	public List<HashMap<String, String>> selectSmallProductByMidCategoryId(String midCategoryId) {
		return sqlSessionTemplate.selectList("admin.selectSmallProductByMidCategoryId",midCategoryId);
	}
	@Override
	public String countConfirmedPostingNumBySmallProductId(String smallProductId) {
		return sqlSessionTemplate.selectOne("admin.countConfirmedPostingNumBySmallProductId", smallProductId);
	}
	@Override
	public String countBuyLinkNumBySmallProductId(String smallProductId) {
		return sqlSessionTemplate.selectOne("admin.countBuyLinkNumBySmallProductId", smallProductId);
	}
	@Override
	public int selectConfirmedSmallProductNum(String midCategoryId) {
		return sqlSessionTemplate.selectOne("admin.selectConfirmedSmallProductNum", midCategoryId);
	}
	@Override
	public int selectConfirmedbyadminSmallProductNum(String midCategoryId) {
		return sqlSessionTemplate.selectOne("admin.selectConfirmedbyadminSmallProductNum", midCategoryId);
	}
	@Override
	public int selectUnconfirmedSmallProductNum(String midCategoryId) {
		return sqlSessionTemplate.selectOne("admin.selectUnconfirmedSmallProductNum", midCategoryId);
	}
	@Override
	public int totalUnconfirmedSmallProductInMidCategory(String midCategoryId) {
		return sqlSessionTemplate.selectOne("admin.totalUnconfirmedSmallProductInMidCategory",midCategoryId);
	}
	@Override
	public List<BlliSmallProductVO> selectConfirmedbyadminProductIdListByMidCategoryId(String midCategoryId) {
		return sqlSessionTemplate.selectList("admin.selectConfirmedbyadminProductIdListByMidCategoryId",midCategoryId);
	}
	@Override
	public List<BlliSmallProductVO> selectConfirmedProductByMidCategoryId(String midCategoryId) {
		return sqlSessionTemplate.selectList("admin.selectConfirmedProductByMidCategoryId",midCategoryId);
	}
	@Override
	public String selectConfirmedBlogNum(String smallProductId) {
		return sqlSessionTemplate.selectOne("admin.selectConfirmedBlogNum", smallProductId);
	}
	@Override
	public String selectUnconfirmedBlogNum(String smallProductId) {
		return sqlSessionTemplate.selectOne("admin.selectUnconfirmedBlogNum", smallProductId);
	}
	@Override
	public List<HashMap<Integer,Integer>> selectMonthlyMidCategoryIndex() {
		return sqlSessionTemplate.selectList("admin.selectMonthlyMidCategoryIndex");
	}
	@Override
	public void deleteOtherSmallProductPosting(BlliPostingVO vo) {
		sqlSessionTemplate.delete("admin.deleteOtherSmallProductPosting", vo);
	}
	@Override
	public void insertOtherSmallProductPermanentDeadPosting(BlliPostingVO vo) {
		sqlSessionTemplate.insert("admin.insertOtherSmallProductPermanentDeadPosting", vo);
	}
	@Override
	public List<BlliPostingVO> selectOtherSmallProductForPosting(BlliPostingVO vo) {
		return sqlSessionTemplate.selectList("admin.selectOtherSmallProductForPosting",vo);
	}
	@Override
	public String selectSmallProductBySmallProductId(String searchWord) {
		return sqlSessionTemplate.selectOne("admin.selectSmallProductBySmallProductId", searchWord);
	}
}
