package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * @author wjj
 */
public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    List<CustomerRemark> getRemarkListByCid(String customerId);

    int deleteRemarkById(String id);

    int saveRemark(CustomerRemark ar);

    int updateRemark(CustomerRemark ar);
}
