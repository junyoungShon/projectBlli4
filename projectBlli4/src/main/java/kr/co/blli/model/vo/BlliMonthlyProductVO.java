package kr.co.blli.model.vo;

import java.util.List;

public class BlliMonthlyProductVO {
	private String monthlyProduct;
	private String monthlyProductId;
	private String minUsableMonth;
	private String maxUsableMonth;
	private String monthlyProductInst;
	private String monthlyProductPhotoLink;
	private List<BlliMidCategoryVO> blliMidCategoryVOList;
	public BlliMonthlyProductVO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getMonthlyProduct() {
		return monthlyProduct;
	}
	public void setMonthlyProduct(String monthlyProduct) {
		this.monthlyProduct = monthlyProduct;
	}
	public String getMonthlyProductId() {
		return monthlyProductId;
	}
	public void setMonthlyProductId(String monthlyProductId) {
		this.monthlyProductId = monthlyProductId;
	}
	public String getMinUsableMonth() {
		return minUsableMonth;
	}
	public void setMinUsableMonth(String minUsableMonth) {
		this.minUsableMonth = minUsableMonth;
	}
	public String getMaxUsableMonth() {
		return maxUsableMonth;
	}
	public void setMaxUsableMonth(String maxUsableMonth) {
		this.maxUsableMonth = maxUsableMonth;
	}
	public String getMonthlyProductInst() {
		return monthlyProductInst;
	}
	public void setMonthlyProductInst(String monthlyProductInst) {
		this.monthlyProductInst = monthlyProductInst;
	}
	public String getMonthlyProductPhotoLink() {
		return monthlyProductPhotoLink;
	}
	public void setMonthlyProductPhotoLink(String monthlyProductPhotoLink) {
		this.monthlyProductPhotoLink = monthlyProductPhotoLink;
	}
	public List<BlliMidCategoryVO> getBlliMidCategoryVOList() {
		return blliMidCategoryVOList;
	}
	public void setBlliMidCategoryVOList(
			List<BlliMidCategoryVO> blliMidCategoryVOList) {
		this.blliMidCategoryVOList = blliMidCategoryVOList;
	}
	@Override
	public String toString() {
		return "BlliMonthlyProductVO [monthlyProduct=" + monthlyProduct
				+ ", monthlyProductId=" + monthlyProductId
				+ ", minUsableMonth=" + minUsableMonth + ", maxUsableMonth="
				+ maxUsableMonth + ", monthlyProductInst=" + monthlyProductInst
				+ ", monthlyProductPhotoLink=" + monthlyProductPhotoLink
				+ ", blliMidCategoryVOList=" + blliMidCategoryVOList + "]";
	}
	
	
}
