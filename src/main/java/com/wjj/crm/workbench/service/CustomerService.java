package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface CustomerService {
    List<String> getCustomerName(String name);

    PaginationVo<Customer> pageList(Map<String, Object> map);

    boolean save(Customer c);

    List<Customer> getCustomerListName(String aname);

    Customer detail(String id);

    Map<String, Object> getSourceCharts();
}
