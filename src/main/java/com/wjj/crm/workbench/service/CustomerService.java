package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.domain.CustomerRemark;

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

    Map<String, Object> detail(String id);

    Map<String, Object> getSourceCharts();

    List<CustomerRemark> getRemarkListByCid(String customerId);

    boolean deleteRemark(String id);

    boolean saveRemark(CustomerRemark ar);

    boolean updateRemark(CustomerRemark ar);

    Map<String, Object> getUserListAndContacts(String id);

    boolean update(Customer clue);

    boolean delete(String[] ids);
}
