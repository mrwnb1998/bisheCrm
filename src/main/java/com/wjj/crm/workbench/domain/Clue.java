package com.wjj.crm.workbench.domain;

import java.sql.Timestamp;

public class Clue {

	private long id;	//主键
	private String full_name;	//全名（人的名字）
	private String appellation;	//称呼
	private String owner;	//所有者
	private String company;	//公司名称
	private String job;	//职业
	private String email;	//邮箱
	private String phone;	//公司电话
	private String website;	//公司网站
	private String mphone;	//手机
	private String state;	//状态
	private String source;	//来源
	private long create_by;	//创建人
	private Timestamp create_time;	//创建时间
	private long update_by;	//修改人
	private Timestamp update_time;	//修改时间
	private String description;	//描述
	private String contact_summary;	//联系纪要
	private String next_contact_time;	//下次联系时间
	private String address;	//地址
	private int is_deleted;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getFull_name() {
		return full_name;
	}

	public void setFull_name(String full_name) {
		this.full_name = full_name;
	}

	public String getAppellation() {
		return appellation;
	}

	public void setAppellation(String appellation) {
		this.appellation = appellation;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getJob() {
		return job;
	}

	public void setJob(String job) {
		this.job = job;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	public String getMphone() {
		return mphone;
	}

	public void setMphone(String mphone) {
		this.mphone = mphone;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public long getCreate_by() {
		return create_by;
	}

	public void setCreate_by(long create_by) {
		this.create_by = create_by;
	}

	public Timestamp getCreate_time() {
		return create_time;
	}

	public void setCreate_time(Timestamp create_time) {
		this.create_time = create_time;
	}

	public long getUpdate_by() {
		return update_by;
	}

	public void setUpdate_by(long update_by) {
		this.update_by = update_by;
	}

	public Timestamp getUpdate_time() {
		return update_time;
	}

	public void setUpdate_time(Timestamp update_time) {
		this.update_time = update_time;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getContact_summary() {
		return contact_summary;
	}

	public void setContact_summary(String contact_summary) {
		this.contact_summary = contact_summary;
	}

	public String getNext_contact_time() {
		return next_contact_time;
	}

	public void setNext_contact_time(String next_contact_time) {
		this.next_contact_time = next_contact_time;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getIs_deleted() {
		return is_deleted;
	}

	public void setIs_deleted(int is_deleted) {
		this.is_deleted = is_deleted;
	}
}
