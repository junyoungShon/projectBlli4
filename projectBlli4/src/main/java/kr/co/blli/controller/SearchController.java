package kr.co.blli.controller;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.blli.model.posting.PostingService;
import kr.co.blli.model.product.ProductService;
import kr.co.blli.model.scheduler.CategoryAndProductScheduler;
import kr.co.blli.model.scheduler.PostingMarker;
import kr.co.blli.model.scheduler.PostingScheduler;
import kr.co.blli.model.vo.BlliBuyLinkClickVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliMidCategoryVO;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;
import kr.co.blli.model.vo.BlliWordCloudVO;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SearchController {
	
	@Resource
	private PostingService postingService;
	
	@Resource
	private ProductService productService;
	
	//스케줄러 완성 전까지 임시 사용
	@Resource
	private CategoryAndProductScheduler categoryAndProductScheduler;
	//스케줄러 완성 전까지 임시 사용
	@Resource
	private PostingScheduler postingScheduler;
	//포스팅 채점기 완성전까지 임시사용
	@Resource
	private PostingMarker postingMarker;
	
	//스케줄러 완성 전까지 임시 사용
	@RequestMapping("admin_insertPosting.do")
	public ModelAndView insertPosting() throws IOException{
		postingScheduler.insertPosting();
		return new ModelAndView("insertDataResult");
	}
	/**
	 * 
	 * @Method Name : searchSmallProduct
	 * @Method 설명 : 검색어에 해당하는 페이지를 출력해주는 메서드
	 * @작성일 : 2016. 2. 3.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @param searchWord
	 * @return
	 */
	@RequestMapping("searchSmallProduct.do")
	public ModelAndView searchSmallProduct(String pageNo, String searchWord,HttpServletRequest request){
		HttpSession session = request.getSession();
		String memberId = "anonymous";
		if(session!=null){
			BlliMemberVO blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
			if(blliMemberVO!=null){
				memberId = blliMemberVO.getMemberId();
			}
		}
		ModelAndView mav = new ModelAndView();
		if(searchWord == null){
			searchWord = "";
		}
		ArrayList<BlliSmallProductVO> smallProductList = productService.searchBigCategory(pageNo, searchWord);
		String viewName = "blli_searchResultPage";
		if(smallProductList.isEmpty()){
			smallProductList = productService.searchMidCategory(pageNo, searchWord);
			if(!smallProductList.isEmpty()){ // 검색 페이지(중분류명을 기준으로)로 go!
				for(int i = 0;i<smallProductList.size();i++){
					List<BlliWordCloudVO> list = productService.selectWordCloudList
							(smallProductList.get(i).getSmallProductId());
					smallProductList.get(i).setBlliWordCloudVOList(list);
					smallProductList.get(i).setPostingList(postingService.getPostingSlideListInfo(smallProductList.get(i).getSmallProductId()));
					if(session!=null){
						BlliMemberVO blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
						BlliSmallProductVO blliSmallProductVO = productService.productDibChecker(blliMemberVO.getMemberId(),smallProductList.get(i));
						smallProductList.get(i).setIsDib(blliSmallProductVO.getIsDib());
					}
				}
				mav.addObject("resultList", smallProductList);
				int totalSmallProduct = productService.totalSmallProductOfMidCategory(searchWord);
				mav.addObject("totalPage", (int)Math.ceil(totalSmallProduct/5.0));
				mav.addObject("totalSmallProduct", totalSmallProduct);
				mav.addObject("searchWord", searchWord);
			}else{
				HashMap<String, Object> smallProductInfo = productService.searchSmallProduct(searchWord);
				if(smallProductInfo.get("smallProduct") != null){ // 소제품 상세 페이지로 go!
					ArrayList<BlliPostingVO> postingList = 
							postingService.searchPostingListInProductDetail(((BlliSmallProductVO)smallProductInfo.get("smallProduct")).getSmallProductId(),memberId,"1");
					viewName = "blli_smallProductDetailPage";
					mav.addObject("smallProductInfo", smallProductInfo);
					mav.addObject("blliPostingVOList", postingList);
				}else{ // 검색 페이지(제품명을 기준으로)로 go!
					smallProductList = productService.searchSmallProductList(pageNo, searchWord);
					if(!smallProductList.isEmpty()){
						for(int i = 0;i<smallProductList.size();i++){
							List<BlliWordCloudVO> list = productService.selectWordCloudList
									(smallProductList.get(i).getSmallProductId());
							smallProductList.get(i).setBlliWordCloudVOList(list);
							smallProductList.get(i).setPostingList(postingService.getPostingSlideListInfo(smallProductList.get(i).getSmallProductId()));
							if(session!=null){
								BlliMemberVO blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
								BlliSmallProductVO blliSmallProductVO = productService.productDibChecker(blliMemberVO.getMemberId(),smallProductList.get(i));
								smallProductList.get(i).setIsDib(blliSmallProductVO.getIsDib());
							}
						}
						mav.addObject("resultList", smallProductList);
						int totalSmallProduct = productService.totalSmallProductRelatedSearchWord(searchWord);
						mav.addObject("totalPage", (int)Math.ceil(totalSmallProduct/5.0));
						mav.addObject("totalSmallProduct", totalSmallProduct);
						mav.addObject("searchWord", searchWord);
					}else{ // 검색 페이지(포스팅 제목과 내용을 기준으로)로 go!
						ArrayList<BlliPostingVO> postingList = postingService.getPostingList(pageNo, searchWord);
						for(int i=0;i<postingList.size();i++){
							BlliSmallProductVO smallProductVO = productService.getSmallProductBySmallProductId(postingList.get(i).getSmallProductId());
							smallProductVO.setPostingVO(postingList.get(i));
							smallProductList.add(smallProductVO);
						}
						mav.addObject("resultList", smallProductList);
						int totalPosting = postingService.totalPosting(searchWord);
						mav.addObject("totalPage", (int)Math.ceil(totalPosting/5.0));
						mav.addObject("totalPosting", totalPosting);
						mav.addObject("searchWord", searchWord);
					}
				}
			}
		}else{ // 검색 페이지(대분류명을 기준으로)로 go!
			for(int i=0;i<smallProductList.size();i++){
				List<BlliWordCloudVO> list = productService.selectWordCloudList
						(smallProductList.get(i).getSmallProductId());
				smallProductList.get(i).setBlliWordCloudVOList(list);
				smallProductList.get(i).setPostingList(postingService.getPostingSlideListInfo(smallProductList.get(i).getSmallProductId()));
				//소제품 찜 여부 체크
				if(session!=null){
					BlliMemberVO blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
					BlliSmallProductVO blliSmallProductVO = productService.productDibChecker(blliMemberVO.getMemberId(),smallProductList.get(i));
					smallProductList.get(i).setIsDib(blliSmallProductVO.getIsDib());
				}
			}
			mav.addObject("resultList", smallProductList);
			int totalSmallProduct = productService.totalSmallProductOfBigCategory(searchWord);
			mav.addObject("totalPage", (int)Math.ceil(totalSmallProduct/5.0));
			mav.addObject("totalSmallProduct", totalSmallProduct);
			mav.addObject("searchWord", searchWord);
		}
		
		mav.setViewName(viewName);
		return mav;
	}
	/**
	 * 
	 * @Method Name : getPostingList
	 * @Method 설명 : 검색어(소제품)에 해당하는 포스팅 리스트의 두번째 페이지 이상에서 해당 페이지를 반환해주는 메서드
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @param searchWord
	 * @return
	 */
	@ResponseBody
	@RequestMapping("getPostingList.do")
	public ArrayList<BlliPostingVO> getPostingList(String pageNo, String searchWord){
		return postingService.searchPosting(pageNo, searchWord);
	}
	//스케줄러 완성 전까지 임시 사용
	@RequestMapping("admin_insertBigCategory.do")
	public ModelAndView insertBigCategory() throws IOException{
		categoryAndProductScheduler.insertBigCategory();
		return new ModelAndView("insertDataResult");
	}
	//스케줄러 완성 전까지 임시 사용
	@RequestMapping("admin_insertMidCategory.do")
	public ModelAndView insertMidCategory() {
		categoryAndProductScheduler.insertMidCategory();
		return new ModelAndView("insertDataResult");
	}
	//스케줄러 완성 전까지 임시 사용
	@RequestMapping("admin_insertSmallProduct.do")
	public ModelAndView insertSmallProduct() {
		categoryAndProductScheduler.insertSmallProduct();
		return new ModelAndView("insertDataResult");
	}
	/**
	  * @Method Name : goPosting
	  * @Method 설명 : 포스팅으로 이동하기 위한 메서드!
	  * @작성일 : 2016. 1. 22.
	  * @작성자 : junyoung
	  * @param blliPostingVO
	  * @return
	 */
	@RequestMapping("admin_goPosting.do")
	public ModelAndView goPosting(BlliPostingVO blliPostingVO){
		ModelAndView mav = new ModelAndView();
		mav.addObject(blliPostingVO);
		mav.setViewName("/blli/postingContents");
		return mav;
	}
	/**
	  * @Method Name : recordResidenceTime
	  * @Method 설명 : 체류시간을 기록하는 메서드
	  * @작성일 : 2016. 1. 22.
	  * @작성자 : junyoung
	  * @param blliPostingVO
	 */
	@RequestMapping("recordResidenceTime.do")
	@ResponseBody
	public String recordResidenceTime(BlliPostingVO blliPostingVO){
		postingService.recordResidenceTime(blliPostingVO);
		return "success";
	}
	
	@RequestMapping("member_goMidCategoryDetailView.do")
	public ModelAndView goMidCategoryDetailView(BlliMidCategoryVO blliMidCategoryVO){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("blli_midCategoryDetailPage");
		blliMidCategoryVO.getMidCategoryId();
		return mav;
	}
	/**
	 * @Method Name : goSmallProductDetailView
	 * @Method 설명 : 소제품을 클릭할 때 소제품 상세 페이지를 출력해주는 메서드
	 * @작성일 : 2016. 2. 3.
	 * @작성자 : hyunseok
	 * @param smallProduct
	 * @return
	 */
	@RequestMapping("goSmallProductDetailView.do")
	public ModelAndView goSmallProductDetailView(String smallProduct,HttpServletRequest request){
		HttpSession session = request.getSession();
		BlliMemberVO blliMemberVO = null;
		ModelAndView mav = new ModelAndView();
		if(session!=null){
			blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
		}
		HashMap<String, Object> smallProductInfo = productService.searchSmallProduct(smallProduct);
		String smallProductId = ((BlliSmallProductVO)smallProductInfo.get("smallProduct")).getSmallProductId() ;
		ArrayList<BlliPostingVO> postingList = 
				postingService.searchPostingListInProductDetail(smallProductId,blliMemberVO.getMemberId(),"1");
		List<BlliWordCloudVO> wordCloudList = productService.selectWordCloudList(smallProductId);
		if(session!=null){
			blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
			BlliSmallProductVO blliSmallProductVO = productService.productDibChecker(blliMemberVO.getMemberId(),(BlliSmallProductVO) smallProductInfo.get("smallProduct"));
			((BlliSmallProductVO) smallProductInfo.get("smallProduct")).setIsDib(blliSmallProductVO.getIsDib());
		}
		ArrayList<BlliPostingVO> postingSlideList = postingService.getPostingSlideListInfo(smallProductId);
		mav.addObject("postingSlideList", postingSlideList);
		mav.addObject("smallProductInfo", smallProductInfo);
		mav.addObject("blliPostingVOList", postingList);
		mav.addObject("blliMemberVO",blliMemberVO);
		mav.addObject("wordCloudList",wordCloudList);
		mav.setViewName("blli_smallProductDetailPage");
		return mav;
	}
	/**
	 * 
	 * @Method Name : getSmallProductList
	 * @Method 설명 : 중분류 상세 페이지 무한 스크롤을 위한 페이징 메서드
	 * @작성일 : 2016. 2. 3.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @param searchWord
	 * @return
	 */
	@ResponseBody
	@RequestMapping("member_getSmallProductList.do")
	public ArrayList<BlliSmallProductVO> getSmallProductList(String pageNo, String searchWord, HttpServletRequest request){
		HttpSession session = request.getSession();
		ArrayList<BlliSmallProductVO> smallProductList = productService.searchBigCategory(pageNo, searchWord);
		if(smallProductList.isEmpty()){
			smallProductList = productService.searchMidCategory(pageNo, searchWord);
			if(smallProductList.isEmpty()){
				smallProductList = productService.searchSmallProductList(pageNo, searchWord);
			}
		}
		for(int i=0;i<smallProductList.size();i++){
			smallProductList.get(i).setBlliWordCloudVOList(productService.selectWordCloudList(smallProductList.get(i).getSmallProductId()));
			//소제품 찜 여부 체크
			if(session!=null){
				BlliMemberVO blliMemberVO = (BlliMemberVO) session.getAttribute("blliMemberVO");
				BlliSmallProductVO blliSmallProductVO = productService.productDibChecker(blliMemberVO.getMemberId(),smallProductList.get(i));
				smallProductList.get(i).setIsDib(blliSmallProductVO.getIsDib());
			}
			smallProductList.get(i).setPostingList(postingService.getPostingSlideListInfo(smallProductList.get(i).getSmallProductId()));
		}
		return smallProductList;
	}
	@RequestMapping("member_selectSmallProductRank.do")
	@ResponseBody
	public List<BlliSmallProductVO> selectSmallProductRank(String midCategoryId){
		return productService.selectSmallProductRank(midCategoryId);
	}
	@RequestMapping("member_selectPostingBySmallProduct.do")
	@ResponseBody
	public List<BlliPostingVO> selectPostingBySmallProduct(String smallProductIdList ,String pageNum,String memberId){
		//return productService.selectSmallProductRank(midCategoryId);
		String list[] = smallProductIdList.split("/");
		List<BlliSmallProductVO> blliSmallProductVOList = new ArrayList<BlliSmallProductVO>();
		for(int i=0;i<list.length;i++){
			BlliSmallProductVO blliSmallProductVO = new BlliSmallProductVO(); 
			blliSmallProductVO.setSmallProductId(list[i]);
			blliSmallProductVOList.add(blliSmallProductVO);
		}
		return productService.selectPostingBySmallProductList(blliSmallProductVOList, memberId, pageNum);
	}
	
	@RequestMapping("selectPostingBySmallProductInSmallProductDetailView.do")
	@ResponseBody
	public List<BlliPostingVO> selectPostingBySmallProductInSmallProductDetailView(String smallProductId ,String pageNum,HttpServletRequest request){
		ArrayList<BlliPostingVO> postingList = 
				postingService.searchPostingListInProductDetail(smallProductId,request,pageNum);
		return postingList;
	}
	@RequestMapping("footerStatics.do")
	@ResponseBody
	public HashMap<String,String> footerStatics(){
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("productStatics", productService.selectTotalProductNum());
		map.put("postingStatics", postingService.selectTotalPostingtNum());
		return map;
	}
	
	@RequestMapping("goBuyMidPage.do")
	public ModelAndView goBuyMidPage(BlliBuyLinkClickVO blliBuyLinkClickVO,HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		String targetURL = request.getParameter("buyLink");
		mav.setViewName("buyMidPage");
		mav.addObject("blliBuyLinkClickVO", blliBuyLinkClickVO);
		mav.addObject("targetURL", targetURL);
		productService.buyLinkClick(blliBuyLinkClickVO);
		return mav;
	}
	
	//임시 메서드
	@RequestMapping("postingMarker.do")
	public void postingMarker() throws ParseException{
		postingMarker.postingMarkering();
	}
	//임시 메서드
	@RequestMapping("productMarker.do")
	public void productMarker() throws ParseException{
		postingMarker.productMarkering();
	}
	//임시 메서드
	@RequestMapping("smallProductRankingMaker.do")
	public void smallProductRankingMaker() throws ParseException{
		postingMarker.smallProductRankingMaker();
	}
	
}
