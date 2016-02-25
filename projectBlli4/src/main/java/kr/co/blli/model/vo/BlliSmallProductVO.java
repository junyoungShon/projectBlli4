package kr.co.blli.model.vo;

import java.util.List;

public class BlliSmallProductVO {
	private String smallProduct;
	private String midCategory;
	private String midCategoryId;
	private String smallProductMaker;
	private int smallProductWhenToUseMin;
	private int smallProductWhenToUseMax;
	private int smallProductDibsCount;
	private String smallProductMainPhotoLink;
	private int smallProductScore;
	private String naverShoppingLink;
	private int naverShoppingRank;
	private int smallProductPostingCount;
	private String productRegisterDay;
	private String smallProductId;
	private int smallProductRanking;
	//16.01.22 추가
	private int isDib;
	//16.02.01 추가
	private String minPrice;
	//16.02.01 추가
	private String searchTime;
	//16.02.05  추가
	private int detailViewCount;
	//16.02.05 추가
	private String productDbInsertDate;
	//16.02.06 추가
	private int dbInsertPostingCount;
	//16.02.07 추가
	private List<BlliWordCloudVO> blliWordCloudVOList;
	//16.02.16추가
	private int snsShareCount;
	//16.02.22 추가
	private List<BlliSmallProductBuyLinkVO> blliSmallProductBuyLinkVOList;
	//16.02.22 추가
	private List<BlliSmallProductVO> otherSmallProductList;
	//16.02.22 추가
	private List<BlliPostingVO> postingList;
	//16.02.25 추가
	private BlliPostingVO postingVO;
	public BlliSmallProductVO() {
		super();
	}
	public String getSmallProduct() {
		return smallProduct;
	}
	public void setSmallProduct(String smallProduct) {
		this.smallProduct = smallProduct;
	}
	public String getMidCategory() {
		return midCategory;
	}
	public void setMidCategory(String midCategory) {
		this.midCategory = midCategory;
	}
	public String getMidCategoryId() {
		return midCategoryId;
	}
	public void setMidCategoryId(String midCategoryId) {
		this.midCategoryId = midCategoryId;
	}
	public String getSmallProductMaker() {
		return smallProductMaker;
	}
	public void setSmallProductMaker(String smallProductMaker) {
		this.smallProductMaker = smallProductMaker;
	}
	public int getSmallProductWhenToUseMin() {
		return smallProductWhenToUseMin;
	}
	public void setSmallProductWhenToUseMin(int smallProductWhenToUseMin) {
		this.smallProductWhenToUseMin = smallProductWhenToUseMin;
	}
	public int getSmallProductWhenToUseMax() {
		return smallProductWhenToUseMax;
	}
	public void setSmallProductWhenToUseMax(int smallProductWhenToUseMax) {
		this.smallProductWhenToUseMax = smallProductWhenToUseMax;
	}
	public int getSmallProductDibsCount() {
		return smallProductDibsCount;
	}
	public void setSmallProductDibsCount(int smallProductDibsCount) {
		this.smallProductDibsCount = smallProductDibsCount;
	}
	public String getSmallProductMainPhotoLink() {
		return smallProductMainPhotoLink;
	}
	public void setSmallProductMainPhotoLink(String smallProductMainPhotoLink) {
		this.smallProductMainPhotoLink = smallProductMainPhotoLink;
	}
	public int getSmallProductScore() {
		return smallProductScore;
	}
	public void setSmallProductScore(int smallProductScore) {
		this.smallProductScore = smallProductScore;
	}
	public String getNaverShoppingLink() {
		return naverShoppingLink;
	}
	public void setNaverShoppingLink(String naverShoppingLink) {
		this.naverShoppingLink = naverShoppingLink;
	}
	public int getNaverShoppingRank() {
		return naverShoppingRank;
	}
	public void setNaverShoppingRank(int naverShoppingRank) {
		this.naverShoppingRank = naverShoppingRank;
	}
	public int getSmallProductPostingCount() {
		return smallProductPostingCount;
	}
	public void setSmallProductPostingCount(int smallProductPostingCount) {
		this.smallProductPostingCount = smallProductPostingCount;
	}
	public String getProductRegisterDay() {
		return productRegisterDay;
	}
	public void setProductRegisterDay(String productRegisterDay) {
		this.productRegisterDay = productRegisterDay;
	}
	public String getSmallProductId() {
		return smallProductId;
	}
	public void setSmallProductId(String smallProductId) {
		this.smallProductId = smallProductId;
	}
	public int getSmallProductRanking() {
		return smallProductRanking;
	}
	public void setSmallProductRanking(int smallProductRanking) {
		this.smallProductRanking = smallProductRanking;
	}
	public int getIsDib() {
		return isDib;
	}
	public void setIsDib(int isDib) {
		this.isDib = isDib;
	}
	public String getMinPrice() {
		return minPrice;
	}
	public void setMinPrice(String minPrice) {
		this.minPrice = minPrice;
	}
	public String getSearchTime() {
		return searchTime;
	}
	public void setSearchTime(String searchTime) {
		this.searchTime = searchTime;
	}
	public int getDetailViewCount() {
		return detailViewCount;
	}
	public void setDetailViewCount(int detailViewCount) {
		this.detailViewCount = detailViewCount;
	}
	public String getProductDbInsertDate() {
		return productDbInsertDate;
	}
	public void setProductDbInsertDate(String productDbInsertDate) {
		this.productDbInsertDate = productDbInsertDate;
	}
	public int getDbInsertPostingCount() {
		return dbInsertPostingCount;
	}
	public void setDbInsertPostingCount(int dbInsertPostingCount) {
		this.dbInsertPostingCount = dbInsertPostingCount;
	}
	public List<BlliWordCloudVO> getBlliWordCloudVOList() {
		return blliWordCloudVOList;
	}
	public void setBlliWordCloudVOList(List<BlliWordCloudVO> blliWordCloudVOList) {
		this.blliWordCloudVOList = blliWordCloudVOList;
	}
	public int getSnsShareCount() {
		return snsShareCount;
	}
	public void setSnsShareCount(int snsShareCount) {
		this.snsShareCount = snsShareCount;
	}
	public List<BlliSmallProductBuyLinkVO> getBlliSmallProductBuyLinkVOList() {
		return blliSmallProductBuyLinkVOList;
	}
	public void setBlliSmallProductBuyLinkVOList(
			List<BlliSmallProductBuyLinkVO> blliSmallProductBuyLinkVOList) {
		this.blliSmallProductBuyLinkVOList = blliSmallProductBuyLinkVOList;
	}
	public List<BlliSmallProductVO> getOtherSmallProductList() {
		return otherSmallProductList;
	}
	public void setOtherSmallProductList(
			List<BlliSmallProductVO> otherSmallProductList) {
		this.otherSmallProductList = otherSmallProductList;
	}
	public List<BlliPostingVO> getPostingList() {
		return postingList;
	}
	public void setPostingList(List<BlliPostingVO> postingList) {
		this.postingList = postingList;
	}
	public BlliPostingVO getPostingVO() {
		return postingVO;
	}
	public void setPostingVO(BlliPostingVO postingVO) {
		this.postingVO = postingVO;
	}
	@Override
	public String toString() {
		return "BlliSmallProductVO [smallProduct=" + smallProduct
				+ ", midCategory=" + midCategory + ", midCategoryId="
				+ midCategoryId + ", smallProductMaker=" + smallProductMaker
				+ ", smallProductWhenToUseMin=" + smallProductWhenToUseMin
				+ ", smallProductWhenToUseMax=" + smallProductWhenToUseMax
				+ ", smallProductDibsCount=" + smallProductDibsCount
				+ ", smallProductMainPhotoLink=" + smallProductMainPhotoLink
				+ ", smallProductScore=" + smallProductScore
				+ ", naverShoppingLink=" + naverShoppingLink
				+ ", naverShoppingRank=" + naverShoppingRank
				+ ", smallProductPostingCount=" + smallProductPostingCount
				+ ", productRegisterDay=" + productRegisterDay
				+ ", smallProductId=" + smallProductId
				+ ", smallProductRanking=" + smallProductRanking + ", isDib="
				+ isDib + ", minPrice=" + minPrice + ", searchTime="
				+ searchTime + ", detailViewCount=" + detailViewCount
				+ ", productDbInsertDate=" + productDbInsertDate
				+ ", dbInsertPostingCount=" + dbInsertPostingCount
				+ ", blliWordCloudVOList=" + blliWordCloudVOList
				+ ", snsShareCount=" + snsShareCount
				+ ", blliSmallProductBuyLinkVOList="
				+ blliSmallProductBuyLinkVOList + ", otherSmallProductList="
				+ otherSmallProductList + ", postingList=" + postingList
				+ ", postingVO=" + postingVO + "]";
	}
}
