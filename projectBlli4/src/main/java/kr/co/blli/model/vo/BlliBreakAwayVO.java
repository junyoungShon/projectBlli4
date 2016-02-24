package kr.co.blli.model.vo;

public class BlliBreakAwayVO {
	private String memberId;
	private String breakAwayReason;
	private String breakAwayDate;
	public BlliBreakAwayVO(String memberId, String breakAwayReason,
			String breakAwayDate) {
		super();
		this.memberId = memberId;
		this.breakAwayReason = breakAwayReason;
		this.breakAwayDate = breakAwayDate;
	}
	public BlliBreakAwayVO() {
		super();
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getBreakAwayReason() {
		return breakAwayReason;
	}
	public void setBreakAwayReason(String breakAwayReason) {
		this.breakAwayReason = breakAwayReason;
	}
	public String getBreakAwayDate() {
		return breakAwayDate;
	}
	public void setBreakAwayDate(String breakAwayDate) {
		this.breakAwayDate = breakAwayDate;
	}
	@Override
	public String toString() {
		return "BlliBreakAwayVO [memberId=" + memberId + ", breakAwayReason="
				+ breakAwayReason + ", breakAwayDate=" + breakAwayDate + "]";
	}
}
