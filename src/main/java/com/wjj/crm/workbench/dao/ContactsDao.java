package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface ContactsDao {

    int save(Contacts con);

    List<Contacts> getContactsListByName(String cname);

    void hand(String id);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getCustomerListByCondition(Map<String, Object> map);

    Contacts getById(String id);

    int update(Contacts clue);

    int delete(String[] ids);

    Contacts detail(String id);
}
