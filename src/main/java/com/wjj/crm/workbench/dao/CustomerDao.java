package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Customer;

import java.util.List;

/**
 * @author wjj
 */
public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer customer);

    List<String> getCustomerName(String name);
}
