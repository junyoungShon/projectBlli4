package kr.co.blli.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.blli.model.admin.AdminService;
import kr.co.blli.model.vo.BlliLogVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;
import kr.co.blli.model.vo.ListVO;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdminController {
	@Resource
	private AdminService adminService;
	
	@RequestMapping("admin_adminIndex.do")
	public String goAdminIndexPage(){
		return "admin_adminIndex";
	}
	@RequestMapping("admin_sendMail.do")
	public String sendMail(String memberId, String mailForm) {
		
		String viewName = "admin/sendMail_success";
		try {
			adminService.sendMail(memberId, mailForm);
		} catch (Exception e) {
			e.printStackTrace();
			viewName = "admin/sendMail_fail";
		}
		
		return viewName;
	}
	/**
	 * 
	 * @Method Name : unconfirmedPosting
	 * @Method 설명 : 확정안된 포스팅의 리스트를 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("admin_unconfirmedPosting.do")
	public ModelAndView unconfirmedPosting(String pageNo, String category, String searchWord) throws IOException{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin_unconfirmedPosting");
		ListVO lvo= adminService.unconfirmedPosting(pageNo, category, searchWord);
		mav.addObject("resultList", lvo);
		mav.addObject("category", category);
		mav.addObject("searchWord", searchWord);
		if(category.equals("smallProductId")){
			mav.addObject("smallProductId",searchWord);
			mav.addObject("smallProduct", adminService.selectSmallProductBySmallProductId(searchWord));
		}
		return mav;
	}	
	/**
	 * 
	 * @Method Name : postingListWithSmallProducts
	 * @Method 설명 : 두개 이상의 소제품과 관련된 포스팅의 리스트를 반환해주는 메서드
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("admin_postingListWithSmallProducts.do")
	public ModelAndView postingListWithSmallProducts(String pageNo) throws IOException{
		return new ModelAndView("admin/postingListWithSmallProducts","resultList",adminService.postingListWithSmallProducts(pageNo));
	}
	/**
	 * 
	 * @Method Name : unconfirmedSmallProduct
	 * @Method 설명 : 확정안된 소제품의 리스트를 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 */
	@RequestMapping("admin_unconfirmedSmallProduct.do")
	public ModelAndView unconfirmedSmallProduct(String pageNo){
		return new ModelAndView("admin_unconfirmedSmallProduct","resultList",adminService.unconfirmedSmallProduct(pageNo));
	}	
	/**
	 * 
	 * @Method Name : unconfirmedSmallProduct
	 * @Method 설명 : 확정안된 소제품의 리스트를 중분류 아이디를 기준으로 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 */
	@RequestMapping("admin_unconfirmedSmallProductByMidCategoryId.do")
	public ModelAndView unconfirmedSmallProductByMidCategoryId(String midCategoryId,String pageNo){
		ModelAndView mav = new ModelAndView("admin_unconfirmedSmallProduct","resultList",adminService.unconfirmedSmallProductByMidCategoryId(midCategoryId,pageNo));
		mav.addObject("midCategoryId", midCategoryId);
		return mav;
	}
	/**
	 * 
	 * @Method Name : admin_managingProductByMonthAge.do
	 * @Method 설명 : 확정안된 소제품의 리스트를 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 */
	@RequestMapping("admin_managingProductByMonthAge.do")
	public ModelAndView admin_managingProductByMonthAge(int minimumMonthAge){
		ModelAndView mav = new ModelAndView("admin_managingProductByMonthAge","resultList",adminService.managingProductByMonthAge(minimumMonthAge));
		mav.addObject("monthlyMidCategoryIndex", adminService.monthlyMidCategoryIndex());
		mav.addObject("currentIndex", minimumMonthAge);
		return mav;
	}	
	/**
	 * 
	 * @Method Name : selectProduct
	 * @Method 설명 : 두개 이상의 소제품과 관련된 포스팅의 소제품을 확정하는 메서드
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param urlAndProduct
	 */
	@ResponseBody
	@RequestMapping("admin_selectProduct.do")
	public void selectProduct(@RequestBody List<Map<String, Object>> urlAndImage){
		adminService.selectProduct(urlAndImage);
	}
	/**
	 * 
	 * @Method Name : registerPosting
	 * @Method 설명 : 확정안된 포스팅을 확정하는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param urlAndProduct
	 */
	@ResponseBody
	@RequestMapping("admin_registerPosting.do")
	public void registerPosting(@RequestBody List<Map<String, Object>> urlAndImage){
		adminService.registerPosting(urlAndImage);
	}
	/**
	 * 
	 * @Method Name : registerSmallProduct
	 * @Method 설명 : 확정안된 소제품을 확정하는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param smallProductInfo
	 */
	@ResponseBody
	@RequestMapping("admin_registerSmallProduct.do")
	public void registerSmallProduct(@RequestBody List<Map<String, Object>> smallProductInfo){
		adminService.registerSmallProduct(smallProductInfo);
	}
	/**
	  * @Method Name : makingWordCloud
	  * @Method 설명 : 워드클라우드 만드는 임시 메서드
	  * @작성일 : 2016. 2. 11.
	  * @작성자 : junyoung
	  * @param blliPostingVO
	 */
	@RequestMapping("admin_makingWordCloud.do")
	public void makingWordCloud(BlliPostingVO blliPostingVO){
		ArrayList<BlliPostingVO> list = (ArrayList<BlliPostingVO>)adminService.selectConfirmedPosting();
		System.out.println(list.toString());
		adminService.insertAndUpdateWordCloud(list);
	}
	/**
	 * 
	 * @Method Name : checkLog
	 * @Method 설명 : 로그 조회를 위한 메서드
	 * @작성일 : 2016. 2. 10.
	 * @작성자 : hyunseok
	 * @return
	 */
	@RequestMapping("admin_checkLog.do")
	public ModelAndView checkLog(){
		ArrayList<BlliLogVO> list = (ArrayList<BlliLogVO>)adminService.checkLog();
		return new ModelAndView("admin/log", "logList", list);
	}	
	/**
	 * 
	 * @Method Name : snsShareCountUp
	 * @Method 설명 : 확정안된 소제품을 확정하는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param smallProductInfo
	 */
	@ResponseBody
	@RequestMapping("snsShareCountUp.do")
	public void snsShareCountUp(String smallProductId){
		adminService.snsShareCountUp(smallProductId);
	}
	@RequestMapping("admin_allProductDownLoader.do")
	public void allProductDownLoader(){
		adminService.allProductDownLoader();
	}
	@RequestMapping("admin_midCategoryUseWhenModifyBySmallProduct.do")
	public void midCategoryUseWhenModifyBySmallProduct(){
		adminService.midCategoryUseWhenModifyBySmallProduct();
	}
	
	@RequestMapping("admin_checkPosting.do")
	public ModelAndView checkPosting(){
		ArrayList<BlliPostingVO> list = (ArrayList<BlliPostingVO>)adminService.checkPosting();
		return new ModelAndView("admin/checkPosting", "postingList", list);
	}	
	@ResponseBody
	@RequestMapping("admin_deletePosting.do")
	public void deletePosting(BlliPostingVO postingVO){
		adminService.deletePosting(postingVO);
	}
	@ResponseBody
	@RequestMapping("admin_notAdvertisingPosting.do")
	public void notAdvertisingPosting(BlliPostingVO postingVO){
		adminService.notAdvertisingPosting(postingVO);
	}
	@RequestMapping("admin_checkMember.do")
	public ModelAndView checkMember(){
		ArrayList<BlliMemberVO> list = (ArrayList<BlliMemberVO>)adminService.checkMember();
		return new ModelAndView("admin/checkMember", "memberList", list);
	}
	@RequestMapping("admin_checkUserExceptionLog.do")
	public ModelAndView checkUserExceptionLog() throws IOException{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/userExceptionLog");
		return mav.addObject("list", adminService.checkUserExceptionLog());
	}
	@RequestMapping("admin_monthlyProductImageDownLoader.do")
	public void monthlyProductImageDownLoader(){
		adminService.monthlyProductImageDownLoader();
	}
	@RequestMapping("admin_selectConfirmedbyadminProductByMidCategoryId.do")
	@ResponseBody
	public List<HashMap<String,String>> selectConfirmedbyadminProductByMidCategoryId(String midCategoryId){
		return adminService.selectConfirmedbyadminProductByMidCategoryId(midCategoryId);
	}
	@RequestMapping("admin_selectConfirmedProductByMidCategoryId.do")
	@ResponseBody
	public List<HashMap<String,String>> admin_selectConfirmedProductByMidCategoryId(String midCategoryId){
		return adminService.selectConfirmedProductByMidCategoryId(midCategoryId);
	}
	@RequestMapping("admin_insertPostingBySmallProduct.do")
	public ModelAndView insertPostingBySmallProduct(BlliSmallProductVO blliSmallProductVO) throws IOException{
		ModelAndView mav = new ModelAndView();
		adminService.insertPostingBySmallProduct(blliSmallProductVO);
		System.out.println(blliSmallProductVO);
		mav.setViewName("redirect:admin_unconfirmedPosting.do?pageNo=1&category=smallProductId&searchWord="+blliSmallProductVO.getSmallProductId());
		return mav;
	}
}
