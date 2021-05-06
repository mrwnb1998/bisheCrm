package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer customer);

    List<String> getCustomerName(String name);

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getCustomerListByCondition(Map<String, Object> map);

    List<Customer> getCustomerListName(String aname);
}
