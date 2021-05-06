package com.wjj.crm.workbench.domain;

/**
 * @author wjj
 */
public class Channel {
    private long id;
    private String name;
    private long customer_id;
    private long contacts_id;
    private String  type;
    private String department;
    private String platform;
    private String address;
    private long  dream_sale;
    private long  true_sale;
    private Customer customer;
    private  Contacts contacts;

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Contacts getContacts() {
        return contacts;
    }

    public void setContacts(Contacts contacts) {
        this.contacts = contacts;
    }

    public long getTrue_sale() {
        return true_sale;
    }

    public void setTrue_sale(long true_sale) {
        this.true_sale = true_sale;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(long customer_id) {
        this.customer_id = customer_id;
    }

    public long getContacts_id() {
        return contacts_id;
    }

    public void setContacts_id(long contacts_id) {
        this.contacts_id = contacts_id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public long getDream_sale() {
        return dream_sale;
    }

    public void setDream_sale(long dream_sale) {
        this.dream_sale = dream_sale;
    }




}
