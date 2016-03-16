package kr.co.blli.model.admin;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import kr.co.blli.model.vo.BlliDetailException;
import kr.co.blli.model.vo.BlliLogVO;
import kr.co.blli.model.vo.BlliMailVO;
import kr.co.blli.model.vo.BlliMemberVO;
import kr.co.blli.model.vo.BlliMidCategoryVO;
import kr.co.blli.model.vo.BlliMonthlyProductVO;
import kr.co.blli.model.vo.BlliPagingBean;
import kr.co.blli.model.vo.BlliPostingVO;
import kr.co.blli.model.vo.BlliSmallProductVO;
import kr.co.blli.model.vo.BlliUserExceptionLogVO;
import kr.co.blli.model.vo.BlliWordCloudVO;
import kr.co.blli.model.vo.ListVO;
import kr.co.blli.utility.BlliFileDownLoader;
import kr.co.blli.utility.BlliWordCounter;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.web.servlet.view.velocity.VelocityConfig;

@Service
public class AdminServiceImpl implements AdminService{
	@Resource
	private AdminDAO adminDAO;
	
	@Resource
	private JavaMailSender mailSender;
	@Resource
	private VelocityConfig velocityConfig;
	@Resource
	private BlliFileDownLoader blliFileDownLoader;
	@Resource
	private BlliWordCounter blliWordCounter;
	
	
	
	/**
	  * @Method Name : sendMail
	  * @Method 설명 : 스케줄러에 의해  주기적으로 실행되는 메일 발송 메소드. 실행 시기 : 회원가입시, ...? 
	  * @작성일 : 2016. 1. 18.
	  * @작성자 : yongho
	  * @param recipient
	  * @param subject
	  * @param text
	  * @param textParams
	  * @param formUrl
	  * @throws FileNotFoundException
	  * @throws URISyntaxException
	 * @throws MessagingException 
	 * @throws UnsupportedEncodingException 
	  */
	@Override
	public void sendMail(String memberId, String mailForm) throws FileNotFoundException, URISyntaxException, UnsupportedEncodingException, MessagingException {
		
		BlliMailVO mlvo = adminDAO.findMailSubjectAndContentByMailForm(mailForm);
		BlliMemberVO mbvo = adminDAO.findMemberInfoById(memberId);
		
		String recipient = mbvo.getMemberEmail();
		String subject = mlvo.getMailSubject();
		String contentFile = mlvo.getMailContentFile();
		
		Map<String, Object> textParams = new HashMap<String, Object>();
		
		if(mailForm.equals("findPassword")) {
			textParams.put("memberPassword", mbvo.getMemberPassword());
			textParams.put("memberName", mbvo.getMemberName());
		}
		
		MimeMessage message = mailSender.createMimeMessage();
		
		String mailText = null;
		if(textParams != null) {
			mailText = VelocityEngineUtils.mergeTemplateIntoString(velocityConfig.getVelocityEngine(), contentFile, "utf-8", textParams);
		}
		
		message.setFrom(new InternetAddress("admin@blli.co.kr","블리", "utf-8"));
		message.addRecipient(RecipientType.TO, new InternetAddress(recipient)); //import javax.mail.Message.RecipientType;
		message.setSubject(subject);
		message.setText(mailText, "utf-8", "html");
		
		mailSender.send(message);
		
	}
	/**
	 * 
	 * @Method Name : unconfirmedPosting
	 * @Method 설명 : 확정안된 포스팅의 리스트를 pagingBean과 함께 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 * @throws IOException
	 */
	public ListVO unconfirmedPosting(String pageNo, String category, String searchWord) throws IOException {
		if(pageNo == null || pageNo == ""){
			pageNo = "1";
		}
		ArrayList<BlliPostingVO> postingList = new ArrayList<BlliPostingVO>();
		int total = 0;
		if(category == null || category.equals("")){
			postingList = (ArrayList<BlliPostingVO>)adminDAO.unconfirmedPosting(pageNo);
			total = adminDAO.totalUnconfirmedPosting();
		}else if(category.equals("smallProduct")){
			postingList = (ArrayList<BlliPostingVO>)adminDAO.unconfirmedPostingBySearchSmallProduct(pageNo, searchWord.trim());
			total = adminDAO.totalUnconfirmedPostingBySearchSmallProduct(searchWord.trim());
		}else if(category.equals("smallProductId")){
			postingList = (ArrayList<BlliPostingVO>)adminDAO.unconfirmedPostingBySearchsmallProductId(pageNo, searchWord.trim());
			total = adminDAO.totalUnconfirmedPostingBySearchSmallProductId(searchWord.trim());
		}
		for(int i=0;i<postingList.size();i++){
			String url = postingList.get(i).getPostingUrl();
			String smallProduct = postingList.get(i).getSmallProduct();
			Document doc = Jsoup.connect("http://shopping.naver.com/search/all_search.nhn?query="+smallProduct+
					"&pagingIndex=1&pagingSize=40&productSet=model&viewType=list&sort=rel&searchBy=none&frm=NVSHMDL").timeout(0).get();
			Elements imgTag = doc.select("img");
			HashMap<String, String> smallProductImage = new HashMap<String, String>();
			for(Element e : imgTag){
				if(e.attr("alt").equals(smallProduct)){
					smallProductImage.put(smallProduct, e.attr("data-original"));
					postingList.get(i).setSmallProductImage(smallProductImage);
					break;
				}
			}
			ArrayList<String> imgList = new ArrayList<String>(); 
			doc = Jsoup.connect(url).get();
			String frameSourceUrl = "http://blog.naver.com" + doc.select("#mainFrame").attr("src");
			doc = Jsoup.connect(frameSourceUrl).get();
			Elements imgTagList = doc.select("#postViewArea img");
			if(imgTagList.size() != 0){ //스마트에디터가 아닐 경우
				for(Element e : imgTagList){
					String imgSrc = e.attr("src");
					if(imgSrc.contains("postfiles") || imgSrc.contains("blogfiles")){
						imgList.add(imgSrc);
					}
				}
			}else{ //스마트에디터일 경우
				imgTagList = doc.select(".se_mediaImage");
				for(Element e : imgTagList){
					imgList.add(e.attr("src"));
				}
			}
			postingList.get(i).setImageList(imgList); //포스팅에 등록된 모든 이미지 vo에 저장
		}
		BlliPagingBean paging = new BlliPagingBean(total, Integer.parseInt(pageNo));
		ListVO lvo = new ListVO(postingList, paging);
		return lvo;
	}
	
	/**
	 * 
	 * @Method Name : postingListWithSmallProducts
	 * @Method 설명 : 두개 이상의 소제품과 관련된 포스팅의 리스트와 pagingBean을 반환해주는 메서드 
	 * @작성일 : 2016. 1. 19.
	 * @return
	 * @throws IOException
	 */
	@Override
	public ListVO postingListWithSmallProducts(String pageNo) throws IOException {
		if(pageNo == null || pageNo == ""){
			pageNo = "1";
		}
		// 두개 이상의 소제품을 가지고 있는 포스팅 할당
		ArrayList<BlliPostingVO> postingList = (ArrayList<BlliPostingVO>)adminDAO.postingListWithSmallProducts(pageNo); 
		String url = "";
		String imgSource = "";
		HashMap<String, String> smallProductImageList = new HashMap<String, String>();
		for(int i=0;i<postingList.size();i++){
			ArrayList<BlliSmallProductVO> smallProductList = new ArrayList<BlliSmallProductVO>();
			//이전 postingUrl과 현재 postingUrl이 같을 경우 해당 포스팅VO를 지우고 인덱스를 -1 해줌
			if(postingList.get(i).getPostingUrl().equals(url)){ 
				postingList.remove(i);
				i--;
				continue;
			}else{ //이전 postingUrl과 현재 postingUrl이 다를 경우 현재 postingUrl에 해당하는 소제품 목록과 대표 이미지 vo에 저장
				url = postingList.get(i).getPostingUrl();
				BlliSmallProductVO smallProductVO = new BlliSmallProductVO();
				smallProductVO.setSmallProduct(postingList.get(i).getSmallProduct());
				smallProductVO.setSmallProductId(postingList.get(i).getSmallProductId());
				smallProductList.add(smallProductVO);
				Document doc = Jsoup.connect("http://shopping.naver.com/search/all_search.nhn?query="+postingList.get(i).getSmallProduct()+
						"&pagingIndex=1&pagingSize=40&productSet=model&viewType=list&sort=rel&searchBy=none&frm=NVSHMDL").get();
				Elements imgTag = doc.select("img");
				for(Element e : imgTag){
					if(e.attr("alt").equals(postingList.get(i).getSmallProduct())){
						imgSource = e.attr("data-original");
						smallProductImageList.put(postingList.get(i).getSmallProduct(), imgSource);
						break;
					}
				}
				for(int j=i+1;j<postingList.size();j++){
					if(url.equals(postingList.get(j).getPostingUrl())){
						smallProductVO = new BlliSmallProductVO();
						smallProductVO.setSmallProduct(postingList.get(j).getSmallProduct());
						smallProductVO.setSmallProductId(postingList.get(j).getSmallProductId());
						smallProductList.add(smallProductVO);
						if(!smallProductImageList.containsKey(postingList.get(j).getSmallProduct())){
							doc = Jsoup.connect("http://shopping.naver.com/search/all_search.nhn?query="+postingList.get(j).getSmallProduct()+
									"&pagingIndex=1&pagingSize=40&productSet=model&viewType=list&sort=rel&searchBy=none&frm=NVSHMDL").get();
							imgTag = doc.select("img");
							for(Element e : imgTag){
								if(e.attr("alt").equals(postingList.get(j).getSmallProduct())){
									imgSource = e.attr("data-original");
									smallProductImageList.put(postingList.get(j).getSmallProduct(), imgSource);
									break;
								}
							}
						}
					}else{
						break;
					}
				}
				postingList.get(i).setSmallProductImage(smallProductImageList);
				postingList.get(i).setSmallProductList(smallProductList);
			}
			ArrayList<String> imgList = new ArrayList<String>(); 
			Document doc = Jsoup.connect(url).get();
			String frameSourceUrl = "http://blog.naver.com" + doc.select("#mainFrame").attr("src");
			doc = Jsoup.connect(frameSourceUrl).get();
			Elements imgTag = doc.select("#postViewArea img");
			if(imgTag.size() != 0){ //스마트에디터가 아닐 경우
				for(Element e : imgTag){
					String imgSrc = e.attr("src");
					if(imgSrc.contains("postfiles") || imgSrc.contains("blogfiles")){
						imgList.add(imgSrc);
					}
				}
			}else{ //스마트에디터일 경우
				imgTag = doc.select(".se_mediaImage");
				for(Element e : imgTag){
					imgList.add(e.attr("src"));
				}
			}
			postingList.get(i).setImageList(imgList); //포스팅에 등록된 모든 이미지 vo에 저장
		}
		int total = adminDAO.totalPostingWithProducts();
		BlliPagingBean paging = new BlliPagingBean(total, Integer.parseInt(pageNo));
		ListVO lvo = new ListVO(postingList, paging);
		return lvo;
	}
	/**
	 * 
	 * @Method Name : unconfirmedSmallProduct
	 * @Method 설명 : 확정안된 소제품 리스트와 pagingBean을 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 */
	@Override
	public ListVO unconfirmedSmallProduct(String pageNo) {
		if(pageNo == null || pageNo == ""){
			pageNo = "1";
		}
		ArrayList<BlliSmallProductVO> smallProductList = (ArrayList<BlliSmallProductVO>)adminDAO.unconfirmedSmallProduct(pageNo);
		int total = adminDAO.totalUnconfirmedSmallProduct();
		BlliPagingBean paging = new BlliPagingBean(total, Integer.parseInt(pageNo));
		paging.setNumberOfPostingPerPage(10);
		ListVO lvo = new ListVO();
		lvo.setList(smallProductList);
		lvo.setPagingBean(paging);
		return lvo;
	}
	/**
	 * 
	 * @Method Name : unconfirmedSmallProductByMidCategoryId
	 * @Method 설명 : 확정안된 소제품 리스트와 pagingBean을 반환해주는 메서드 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param pageNo
	 * @return
	 */
	@Override
	public ListVO unconfirmedSmallProductByMidCategoryId(String midCategoryId,String pageNo) {
		if(pageNo == null || pageNo == ""){
			pageNo = "1";
		}
		HashMap<String,String> paraMap = new HashMap<String, String>();
		
		paraMap.put("midCategoryId", midCategoryId);
		paraMap.put("pageNo", pageNo);
		
		ArrayList<BlliSmallProductVO> smallProductList = (ArrayList<BlliSmallProductVO>)adminDAO.unconfirmedSmallProductByMidCategoryId(paraMap);
		int total = adminDAO.totalUnconfirmedSmallProductInMidCategory(midCategoryId);
		BlliPagingBean paging = new BlliPagingBean(total, Integer.parseInt(pageNo));
		paging.setNumberOfPostingPerPage(10);
		ListVO lvo = new ListVO();
		lvo.setList(smallProductList);
		lvo.setPagingBean(paging);
		return lvo;
	}
	
	/**
	 * @Method Name : selectProduct
	 * @Method 설명 : 두개 이상의 소제품을 가지고 있는 포스팅을 한개의 소제품으로 변경해주는 메서드
	 * @작성일 : 2016. 1. 19.
	 * @param urlAndProduct
	 */
	@Override
	public void selectProduct(List<Map<String, Object>> urlAndImage) {
		ArrayList<BlliPostingVO> blliPostingVOList = new ArrayList<BlliPostingVO>();
		for(int i=0;i<urlAndImage.size();i++){
			String delete = urlAndImage.get(i).get("del").toString();
			String postingUrl = urlAndImage.get(i).get("postingUrl").toString();
			String postingPhotoLink = urlAndImage.get(i).get("postingPhotoLink").toString();
			String smallProduct = urlAndImage.get(i).get("smallProduct").toString();
			String smallProductId = urlAndImage.get(i).get("smallProductId").toString();
			String postingTitle = urlAndImage.get(i).get("postingTitle").toString();
			BlliPostingVO vo = new BlliPostingVO();
			vo.setPostingUrl(postingUrl);
			vo.setPostingPhotoLink(postingPhotoLink);
			vo.setSmallProduct(smallProduct);
			vo.setSmallProductId(smallProductId);
			vo.setPostingTitle(postingTitle);
			if(delete.equals("YES")){
				adminDAO.deletePosting(vo);
				adminDAO.insertPermanentDeadPosting(vo);
			}else{
				vo.setPostingPhotoLink(blliFileDownLoader.imgFileDownLoader(
						postingPhotoLink,UUID.randomUUID().toString().replace("-", ""), "postingImage"));
				blliPostingVOList.add(vo);
				adminDAO.selectProduct(vo);
				adminDAO.updatePostingCount(vo);
				adminDAO.updateSmallProductStatus(smallProductId);
			}
		}
		insertAndUpdateWordCloud(blliPostingVOList);
	}
	/**
	 * 
	 * @Method Name : registerPosting
	 * @Method 설명 : 확정안된 포스팅을 확정해주는 메서드(사용자가 볼 수 있게 전환) 
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param urlAndProduct
	 */
	@Override
	public void registerPosting(List<Map<String, Object>> urlAndImage) {
		ArrayList<BlliPostingVO> blliPostingVOList = new ArrayList<BlliPostingVO>();
		for(int i=0;i<urlAndImage.size();i++){
			String delete = urlAndImage.get(i).get("del").toString();
			String postingUrl = urlAndImage.get(i).get("postingUrl").toString();
			String postingPhotoLink = urlAndImage.get(i).get("postingPhotoLink").toString();
			String smallProductId = urlAndImage.get(i).get("smallProductId").toString();
			String postingTitle = urlAndImage.get(i).get("postingTitle").toString();
			BlliPostingVO vo = new BlliPostingVO();
			//이미지 파일 다운로드
			vo.setPostingUrl(postingUrl);
			vo.setSmallProductId(smallProductId);
			vo.setPostingTitle(postingTitle);
			if(delete.equals("YES")){
				adminDAO.deletePosting(vo);
				adminDAO.insertPermanentDeadPosting(vo);
			}else{
				vo.setPostingPhotoLink(blliFileDownLoader.imgFileDownLoader(
						postingPhotoLink,UUID.randomUUID().toString().replace("-", ""), "postingImage"));
				blliPostingVOList.add(vo);
				int updateResult = adminDAO.registerPosting(vo);
				if(updateResult != 0){
					adminDAO.updatePostingCount(vo);
				}
			}
			int updateResult = adminDAO.updateSmallProductStatus(smallProductId);
			if(updateResult != 0){
				String midCategoryId = adminDAO.getMidCategoryId(smallProductId);
				BlliSmallProductVO smallProductVO = adminDAO.getSmallProductWhenToUse(midCategoryId);
				smallProductVO.setMidCategoryId(midCategoryId);
				adminDAO.updateMidCategoryWhenToUse(smallProductVO);
			}
		}
		insertAndUpdateWordCloud(blliPostingVOList);
	}
	/**
	 * 
	 * @Method Name : registerSmallProduct
	 * @Method 설명 : 확정안된 소제품을 확정해주는 메서드(포스팅 검색 대상으로 전환)
	 * @작성일 : 2016. 1. 27.
	 * @작성자 : hyunseok
	 * @param smallProductInfo
	 */
	@Override
	public void registerSmallProduct(List<Map<String, Object>> smallProductInfo) {
		for(int i=0;i<smallProductInfo.size();i++){
			String delete = smallProductInfo.get(i).get("delete").toString();
			BlliSmallProductVO vo = new BlliSmallProductVO();
			vo.setSmallProductId(smallProductInfo.get(i).get("smallProductId").toString());
			vo.setSmallProduct(smallProductInfo.get(i).get("smallProduct").toString());
			vo.setMidCategoryId(adminDAO.getMidCategoryId(smallProductInfo.get(i).get("smallProductId").toString()));
			if(delete.equals("삭제")){
				adminDAO.deleteSmallProduct(vo.getSmallProductId());
			}else{
				String smallProductWhenToUseMin = smallProductInfo.get(i).get("smallProductWhenToUseMin").toString();
				String smallProductWhenToUseMax = smallProductInfo.get(i).get("smallProductWhenToUseMax").toString();
				if((smallProductWhenToUseMin == null || smallProductWhenToUseMin == "") && 
						(smallProductWhenToUseMax == null || smallProductWhenToUseMax == "")){
					adminDAO.updateSmallProductName(vo);
				}else{
					adminDAO.updatePostingStatusToconfirmed(vo.getSmallProductId());
					int updateResult = adminDAO.updateSmallProductStatus(vo.getSmallProductId());
					if(smallProductWhenToUseMin == null || smallProductWhenToUseMin == ""){
						smallProductWhenToUseMin = "0";
					}
					if(smallProductWhenToUseMax == null || smallProductWhenToUseMax == ""){
						smallProductWhenToUseMax = "36";
					}
					vo.setSmallProductWhenToUseMin(Integer.parseInt(smallProductWhenToUseMin));
					vo.setSmallProductWhenToUseMax(Integer.parseInt(smallProductWhenToUseMax));
					if(updateResult == 1){
						adminDAO.updateMidCategoryWhenToUse(vo);
					}
					if(vo.getSmallProduct() == null || vo.getSmallProduct() == ""){
						adminDAO.registerSmallProduct(vo);
					}else{
						adminDAO.registerAndUpdateSmallProduct(vo);
					}
				}
			}
		}
	}
	@Override
	public void makingWordCloud(BlliPostingVO blliPostingVO) {
		String smallProductId = blliPostingVO.getSmallProductId();
		List<BlliPostingVO> list = adminDAO.makingWordCloud(smallProductId);
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < list.size(); i++) {
			sb.append(list.get(i).getPostingContent());
		}
		HashMap<String, Integer> wordCounting = blliWordCounter.wordCounting(sb);
		Iterator<String> it = wordCounting.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
			int value = wordCounting.get(key);
			BlliWordCloudVO blliWordCloudVO = new BlliWordCloudVO();
			blliWordCloudVO.setSmallProductId(smallProductId);
			blliWordCloudVO.setWord(key);
			blliWordCloudVO.setWordCount(value);
			if(adminDAO.updateWordCloud(blliWordCloudVO)!=0){
				adminDAO.insertWordCloud(blliWordCloudVO);
			}
		}
	}
	@Override
	public void insertAndUpdateWordCloud(ArrayList<BlliPostingVO> blliPostingVOList) {
		Logger logger = Logger.getLogger(getClass());
		if(blliPostingVOList.size()>0){
			HashMap<String, StringBuffer> sbMap = new HashMap<String, StringBuffer>();
			for(int i=0;i<blliPostingVOList.size();i++){
				String smallProductId = blliPostingVOList.get(i).getSmallProductId();
				if(sbMap.get(smallProductId)==null){
					sbMap.put(smallProductId,new StringBuffer());
				}
				String postingContent = adminDAO.selectPostingContentByPostingUrl(blliPostingVOList.get(i));
				logger.error("소제품명: "+smallProductId);
				logger.error("포스팅주소: "+blliPostingVOList.get(i).getPostingUrl());
				logger.error("포스팅 내용: "+postingContent);
				blliPostingVOList.get(i).setPostingContent(postingContent);
				sbMap.get(smallProductId).append(blliPostingVOList.get(i).getPostingContent());
			}
			Iterator<String> it = sbMap.keySet().iterator();
			while(it.hasNext()){
				String smallProductId = it.next();
				System.out.println("분석할 본문 :"+sbMap.get(smallProductId));
				HashMap<String, Integer> wordCounting = blliWordCounter.wordCounting(sbMap.get(smallProductId));
				Iterator<String> it2 = wordCounting.keySet().iterator();
				while(it2.hasNext()){
					String key = it2.next();
					int value = wordCounting.get(key);  
					logger.error("분석된 본문 smallId"+smallProductId+" 분석된 단어 :"+key+" 등장횟수 : "+value);
					BlliWordCloudVO blliWordCloudVO = new BlliWordCloudVO();
					blliWordCloudVO.setSmallProductId(smallProductId);
					blliWordCloudVO.setWord(key);
					blliWordCloudVO.setWordCount(value);
					if(adminDAO.updateWordCloud(blliWordCloudVO)==0){
						adminDAO.insertWordCloud(blliWordCloudVO);
					}
				}
			}
		}
	}

	@Override
	public ArrayList<BlliLogVO> checkLog() {
		ArrayList<BlliLogVO> list = new ArrayList<BlliLogVO>();
		BlliLogVO vo = null;
		ArrayList<BlliDetailException> detailException = new ArrayList<BlliDetailException>();
		BlliDetailException exceptionVO = null;
		int number = 1;
		try {
			String localPath = null;
			if(System.getProperty("os.name").contains("Windows")){
				localPath = "C:\\Users\\"+System.getProperty("user.name")+"\\git\\projectBlli4\\projectBlli4\\src\\main\\webapp\\logFile\\blliLog.log";
			}else{
				//서버 환경일 경우 path
				localPath = "/usr/bin/apache-tomcat-7.0.64/webapps/ROOT/logFile/blliLog.log";
			}
			BufferedReader in = new BufferedReader(new FileReader(localPath));
			String message;
			String exceptionContent = "";
			while ((message = in.readLine()) != null) {
				if(message.startsWith("start")){
					vo = new BlliLogVO();
					vo.setNumber(number++);
					vo.setMethodName(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("발생 일자")){
					vo.setStartTime(message.substring(message.indexOf(":")+2));
				}else if(message.startsWith("실행 시간")){
					if(!exceptionContent.equals("")){
						exceptionVO.setExceptionContent(exceptionContent);
						detailException.add(exceptionVO);
					}
					vo.setRunTime(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("요청자")){
					vo.setExecutor(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("총 대분류 개수")){
					if(vo.getMethodName().equals("insertBigCategory")){
						vo.setCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}else{
						vo.setHighRankCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}
				}else if(message.startsWith("총 중분류 개수")){
					if(vo.getMethodName().equals("insertMidCategory")){
						vo.setCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}else{
						vo.setHighRankCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}
				}else if(message.startsWith("총 소제품 개수")){
					if(vo.getMethodName().equals("insertPosting")){
						vo.setHighRankCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}else{
						vo.setCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}
				}else if(message.startsWith("총 포스팅 개수")){
					vo.setCategoryCount(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("insert")){
					if(message.startsWith("insert한 조건에 맞지 않는 소제품 개수")){
						vo.setDenySmallProductCount(message.substring(message.lastIndexOf(":")+2));
					}else if(message.startsWith("insert하지 않은 조건에 맞지 않는 포스팅 개수")){
						vo.setDenyPostingCount(message.substring(message.lastIndexOf(":")+2));
					}else{
						vo.setInsertCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}
				}else if(message.startsWith("update")){
					if(message.startsWith("update하지 않은 소제품 개수")){
						vo.setNotUpdateProductCount(message.substring(message.lastIndexOf(":")+2));
					}else if(message.startsWith("update하지 않은 포스팅 개수")){
						vo.setNotUpdatePostingCount(message.substring(message.lastIndexOf(":")+2));
					}else{
						vo.setUpdateCategoryCount(message.substring(message.lastIndexOf(":")+2));
					}
				}else if(message.startsWith("confirmed")){
					if(message.startsWith("confirmed -> temptDead")){
						vo.setUpdatePostingStatusToTemptdead(message.substring(message.lastIndexOf(":")+2));
					}else if(message.startsWith("confirmed -> confirmedByAdmin")){
						vo.setUpdateSmallProductStatusToConfirmedByAdmin(message.substring(message.lastIndexOf(":")+2));
					}else{
						vo.setUpdateSmallProductStatusToDead(message.substring(message.lastIndexOf(":")+2));
					}
				}else if(message.startsWith("dead -> dead")){
					vo.setSmallProductStatusDeadTodeadCount(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("dead -> unconfirmed")){
					vo.setSmallProductStatusDeadToUnconfirmed(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("temptDead")){
					vo.setUpdatePostingStatusToConfirmed(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("시간지연")){
					vo.setDelayConnectionCount(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("삭제")){
					vo.setDeletePostingCount(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("Exception 발생 횟수")){
					vo.setExceptionCount(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("Exception이 발생한")){
					if(!exceptionContent.equals("")){
						exceptionVO.setExceptionContent(exceptionContent);
						detailException.add(exceptionVO);
					}
					exceptionVO = new BlliDetailException();
					exceptionVO.setCategoryId(message.substring(message.lastIndexOf(":")+2));
				}else if(message.startsWith("Exception 내용")){
					if(message.length() != 15){
						exceptionVO.setExceptionContent(message.substring(message.indexOf(":")+1));
						detailException.add(exceptionVO);
					}else{
						exceptionContent = "";
					}
				}else if(message.startsWith("###")){
					exceptionContent += message.replaceAll("\"", "'")+"<br>";
				}else if(message.startsWith("end")){
					vo.setDetailException(detailException);
					list.add(vo);
					detailException = new ArrayList<BlliDetailException>();
					/*if(number > 20){
						break;
					}*/
				}
			}
			in.close();
		} catch (IOException e) {
			System.err.println(e); // 에러가 있다면 메시지 출력
			System.exit(1);
		}
		return list;
	}
	/**
	  * @Method Name : checkUserExceptionLog
	  * @Method 설명 :
	  * @작성일 : 2016. 2. 23.
	  * @작성자 : junyoung
	  * @return
	 * @throws IOException 
	 */
	@Override
	public ArrayList<BlliUserExceptionLogVO> checkUserExceptionLog() throws IOException {
		ArrayList<BlliUserExceptionLogVO> list = new ArrayList<BlliUserExceptionLogVO>();
		BlliUserExceptionLogVO vo = null;
		ArrayList<BlliDetailException> detailException = new ArrayList<BlliDetailException>();
		BlliDetailException exceptionVO = null;
		int number = 1;
		BufferedReader in = null;
		try {
			String localPath = null;
			if(System.getProperty("os.name").contains("Windows")){
				localPath = "C:\\Users\\"+System.getProperty("user.name")+"\\git\\projectBlli4\\projectBlli4\\src\\main\\webapp\\logFile\\errorByUser.log";
			}else{
				//서버 환경일 경우 path
				localPath = "/usr/bin/apache-tomcat-7.0.64/webapps/ROOT/logFile/errorByUser.log";
			}
			in = new BufferedReader(new FileReader(localPath));
			String message;
			StringBuffer exceptionContent = new StringBuffer(); 
			while ((message = in.readLine()) != null) {
				if(message.startsWith("------------------Start------------------------")){
					vo = new BlliUserExceptionLogVO();
					vo.setNumber(number++);
				}else if(message.startsWith("발생일자")){
					vo.setOccuredTime(message.substring(message.indexOf(":")+2));
				}else if(message.startsWith("발생한에러")){
					exceptionContent.append(message.substring(message.indexOf(":")+2));
				}else if(message.startsWith("발생메서드")){
					vo.setMethodName(message.substring(message.indexOf(":")+2));
				}else if(message.startsWith("------------------End--------------------------")){
					vo.setEndBorder(message.substring(message.indexOf(":")+2));
					vo.setExceptionContent(exceptionContent.toString());
					list.add(vo);
					exceptionContent.setLength(0);
				}else if(message.startsWith("발생클래스")){
					vo.setClassName(message.substring(message.indexOf(":")+2));
				}else{
					exceptionContent.append(message);
				}
			}
		} catch (IOException e) {
			System.err.println(e); // 에러가 있다면 메시지 출력
			System.exit(1);
		}finally{
			if(in!=null)
				in.close();
		}
		return list;
	}
	/**
	  * @Method Name : snsShareCountUp
	  * @Method 설명 : 공유 횟수를 증가시켜줍니다.
	  * @작성일 : 2016. 2. 18.
	  * @작성자 : junyoung
	  * @param smallProductId
	 */
	@Override
	public void snsShareCountUp(String smallProductId) {
		adminDAO.snsShareCountUp(smallProductId);
	}
	/**
	 * @Method Name : allProductDownLoader
	 * @Method 설명 : db 내의 모든 중분류 제품과 소분류 제품을 다운로드하는 메서드
	 * @작성일 : 2016. 2. 18.
	 * @작성자 : junyoung
	 */
	@Override
	public void allProductDownLoader() {
		List <BlliMidCategoryVO> midCategoryList = adminDAO.selectAllMidCategory();
		List <BlliSmallProductVO> smallProductList = adminDAO.selectAllSmallProduct();
		for (int i = 0; i < midCategoryList.size(); i++) {
			String midCategoryMainPhotoLink = blliFileDownLoader.imgFileDownLoader(midCategoryList.get(i).getMidCategoryMainPhotoLink(), midCategoryList.get(i).getMidCategoryId(), "midCategory");
			midCategoryList.get(i).setMidCategoryMainPhotoLink(midCategoryMainPhotoLink);
			adminDAO.updateMidCategoryMainPhotoLink(midCategoryList.get(i));
		}
		for (int i = 0; i < smallProductList.size(); i++) {
			String smallProductMainPhotoLink = 
					blliFileDownLoader.imgFileDownLoader(smallProductList.get(i).getSmallProductMainPhotoLink(), smallProductList.get(i).getSmallProductId(), "smallProduct");
			smallProductList.get(i).setSmallProductMainPhotoLink(smallProductMainPhotoLink);
			adminDAO.updateSmallProductMainPhotoLink(smallProductList.get(i));
		}
	}
	/**
	  * @Method Name : midCategoryUseWhenModifyBySmallProduct
	  * @Method 설명 : 소제품종류를 활용하여 미드카테고리의 사용시기를 조정한다.
	  * @작성일 : 2016. 2. 18.
	  * @작성자 : junyoung
	 */
	@Override
	public void midCategoryUseWhenModifyBySmallProduct() {
		List <BlliMidCategoryVO> midCategoryList = adminDAO.selectAllMidCategory();
		//컨펌인 소제품들 가운데 중분류 제품 중 사용시기가 가장 큰 것을 뽑아 온다.
		for(int i=0;i<midCategoryList.size();i++){
			BlliMidCategoryVO blliMidCategoryVO = midCategoryList.get(i);
			String midCategoryId = blliMidCategoryVO.getMidCategoryId();
			BlliSmallProductVO blliSmallProductVO = adminDAO.selectMinMaxUseWhenByMidcategoryId(midCategoryId);
			if(blliSmallProductVO!=null){
				blliMidCategoryVO.setWhenToUseMax(blliSmallProductVO.getSmallProductWhenToUseMax());
				blliMidCategoryVO.setWhenToUseMin(blliSmallProductVO.getSmallProductWhenToUseMin());
				adminDAO.updateMinMaxUseWhenByMidcategoryId(blliMidCategoryVO);
			}else{
				blliMidCategoryVO.setWhenToUseMax(-2);
				blliMidCategoryVO.setWhenToUseMin(-2);
				adminDAO.updateMinMaxUseWhenByMidcategoryId(blliMidCategoryVO);
			}
		}
	}
	@Override
	public ArrayList<BlliPostingVO> checkPosting() {
		return (ArrayList<BlliPostingVO>)adminDAO.checkPosting();
	}
	@Override
	public void deletePosting(BlliPostingVO postingVO) {
		adminDAO.deletePosting(postingVO);
		adminDAO.insertPermanentDeadPosting(postingVO);
	}
	@Override
	public void notAdvertisingPosting(BlliPostingVO postingVO) {
		adminDAO.notAdvertisingPosting(postingVO);
	}
	@Override
	public ArrayList<BlliMemberVO> checkMember() {
		return (ArrayList<BlliMemberVO>)adminDAO.checkMember();
	}
	@Override
	public List<BlliPostingVO> selectConfirmedPosting() {
		return adminDAO.selectConfirmedPostingUrlAndSmallProductId();
	}
	@Override
	public void monthlyProductImageDownLoader() {
		List<BlliMonthlyProductVO> list = adminDAO.selectAllMonthlyProduct();
		for(int i=0;i<list.size();i++){
			list.get(i).setBlliMidCategoryVOList(adminDAO.selectMidCategoryByMonthlyProductID(list.get(i).getMonthlyProductId()));
			System.out.println(list.get(i));
			list.get(i).setMonthlyProductPhotoLink(list.get(i).getBlliMidCategoryVOList().get(0).getMidCategoryMainPhotoLink());
			adminDAO.updatMonthlyProductPhotoLink(list.get(i));
		}
	}
	@Override
	public ArrayList<List<HashMap<String, Object>>> managingProductByMonthAge(){
		//개월별로 추천되는 월령별 추천 중분류 리스트
		ArrayList<List<HashMap<String, Object>>> midCategoryListByMonthAge = new ArrayList<List<HashMap<String,Object>>>();
		List<HashMap<String, Object>> midCategoryList = null;
		for(int i=-2;i<0;i++){
			//최소사용시기를 기준으로 월령별 추천 중분류를 출력한다.
			midCategoryList = adminDAO.selectMonthlyMidProductList(i);
			for(int j=0;j<midCategoryList.size();j++){
				midCategoryList.get(j).put("confirmedSmallProductNum", adminDAO.selectConfirmedSmallProductNum(midCategoryList.get(j).get("midCategoryId").toString()));
				midCategoryList.get(j).put("unconfirmedSmallProductNum", adminDAO.selectUnconfirmedSmallProductNum(midCategoryList.get(j).get("midCategoryId").toString()));
				midCategoryList.get(j).put("confirmedbyadminSmallProductNum", adminDAO.selectConfirmedbyadminSmallProductNum(midCategoryList.get(j).get("midCategoryId").toString()));
			}
			midCategoryListByMonthAge.add(midCategoryList);
		}
		System.out.println("추출된 중분류 리스트 : "+midCategoryList);
		
		return midCategoryListByMonthAge;
	}
	@Override
	public List<HashMap<String, String>> selectConfirmedbyadminProductByMidCategoryId(String midCategoryId) {
		List<HashMap<String, String>> resultList = new ArrayList<HashMap<String,String>>();
		List<BlliSmallProductVO> smallProductIdList = adminDAO.selectConfirmedbyadminProductIdListByMidCategoryId(midCategoryId);
		for(int i=0;i<smallProductIdList.size();i++){
			HashMap<String, String> tempMap = new HashMap<String, String>();
			String smallProductId = smallProductIdList.get(i).getSmallProductId();
			tempMap.put("smallProductId", smallProductId);
			tempMap.put("smallProduct", smallProductIdList.get(i).getSmallProduct());
			tempMap.put("smallProductClickNum",smallProductIdList.get(i).getDetailViewCount()+"");
			tempMap.put("totalBlogNum", smallProductIdList.get(i).getSmallProductPostingCount()+"");
			tempMap.put("naverShoppingRank", smallProductIdList.get(i).getNaverShoppingRank()+"");
			
			tempMap.put("buyLinkNum", adminDAO.countBuyLinkNumBySmallProductId(smallProductId));
			tempMap.put("confirmedBlogNum", adminDAO.selectConfirmedBlogNum(smallProductId) );
			tempMap.put("unconfirmedBlogNum", adminDAO.selectUnconfirmedBlogNum(smallProductId));
			
			resultList.add(tempMap);
		} 
		return resultList;
	}
	@Override
	public List<HashMap<String, String>> selectConfirmedProductByMidCategoryId(String midCategoryId) {
		List<HashMap<String, String>> resultList = new ArrayList<HashMap<String,String>>();
		List<BlliSmallProductVO> smallProductIdList = adminDAO.selectConfirmedProductByMidCategoryId(midCategoryId);
		for(int i=0;i<smallProductIdList.size();i++){
			HashMap<String, String> tempMap = new HashMap<String, String>();
			String smallProductId = smallProductIdList.get(i).getSmallProductId();
			tempMap.put("smallProductId", smallProductId);
			tempMap.put("smallProduct", smallProductIdList.get(i).getSmallProduct());
			tempMap.put("smallProductClickNum",smallProductIdList.get(i).getDetailViewCount()+"");
			tempMap.put("totalBlogNum", smallProductIdList.get(i).getSmallProductPostingCount()+"");
			tempMap.put("naverShoppingRank", smallProductIdList.get(i).getNaverShoppingRank()+"");
			
			tempMap.put("buyLinkNum", adminDAO.countBuyLinkNumBySmallProductId(smallProductId));
			tempMap.put("confirmedBlogNum", adminDAO.selectConfirmedBlogNum(smallProductId) );
			tempMap.put("unconfirmedBlogNum", adminDAO.selectUnconfirmedBlogNum(smallProductId));
			
			resultList.add(tempMap);
		} 
		return resultList;
	}
}
