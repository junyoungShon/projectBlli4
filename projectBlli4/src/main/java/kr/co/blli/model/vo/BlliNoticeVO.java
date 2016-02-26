package kr.co.blli.model.vo;

public class BlliNoticeVO {
	
	private String babyName;
	private String scheduleDate;
	private String scheduleTitle;
	private String scheduleCheckState;
	private long noticeDate;
	private int leftDays;
	private String babyPhoto;
	
	public BlliNoticeVO() {
		super();
	}

	public String getBabyName() {
		return babyName;
	}

	public void setBabyName(String babyName) {
		this.babyName = babyName;
	}

	public String getScheduleDate() {
		return scheduleDate;
	}

	public void setScheduleDate(String scheduleDate) {
		this.scheduleDate = scheduleDate;
	}

	public String getScheduleTitle() {
		return scheduleTitle;
	}

	public void setScheduleTitle(String scheduleTitle) {
		this.scheduleTitle = scheduleTitle;
	}

	public String getScheduleCheckState() {
		return scheduleCheckState;
	}

	public void setScheduleCheckState(String scheduleCheckState) {
		this.scheduleCheckState = scheduleCheckState;
	}

	public long getNoticeDate() {
		return noticeDate;
	}

	public void setNoticeDate(long noticeDate) {
		this.noticeDate = noticeDate;
	}

	public int getLeftDays() {
		return leftDays;
	}

	public void setLeftDays(int leftDays) {
		this.leftDays = leftDays;
	}

	public String getBabyPhoto() {
		return babyPhoto;
	}

	public void setBabyPhoto(String babyPhoto) {
		this.babyPhoto = babyPhoto;
	}

	@Override
	public String toString() {
		return "BlliNoticeVO [babyName=" + babyName + ", scheduleDate="
				+ scheduleDate + ", scheduleTitle=" + scheduleTitle
				+ ", scheduleCheckState=" + scheduleCheckState
				+ ", noticeDate=" + noticeDate + ", leftDays=" + leftDays
				+ ", babyPhoto=" + babyPhoto + "]";
	}
	
}
