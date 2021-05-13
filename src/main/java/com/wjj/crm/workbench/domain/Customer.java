package com.wjj.crm.workbench.domain;

import java.sql.Timestamp;

public class Customer {

	private long id;
	private String owner;
	private String name;
	private String website;
	private String phone;
	private long create_by;
	private Timestamp create_time;
	private long update_by;
	private Timestamp update_time;
	private String contact_summary;
	private String next_contactTime;
	private String description;
	private String address;
	private String label;
	private String level;
	private String department;
	private String dream_sale;
	private String true_sale;
	private String is_dealer;
     private int is_deleted;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
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

	public void setCreate_time(Timestamp create_sime) {
		this.create_time = create_sime;
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

	public String getContact_summary() {
		return contact_summary;
	}

	public void setContact_summary(String contact_summary) {
		this.contact_summary = contact_summary;
	}

	public String getNext_contactTime() {
		return next_contactTime;
	}

	public void setNext_contactTime(String next_contactTime) {
		this.next_contactTime = next_contactTime;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getDream_sale() {
		return dream_sale;
	}

	public void setDream_sale(String dream_sale) {
		this.dream_sale = dream_sale;
	}

	public String getTrue_sale() {
		return true_sale;
	}

	public void setTrue_sale(String true_sale) {
		this.true_sale = true_sale;
	}

	public String getIs_dealer() {
		return is_dealer;
	}

	public void setIs_dealer(String is_dealer) {
		this.is_dealer = is_dealer;
	}

	public int getIs_deleted() {
		return is_deleted;
	}

	public void setIs_deleted(int is_deleted) {
		this.is_deleted = is_deleted;
	}
}
