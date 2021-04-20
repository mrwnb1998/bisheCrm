package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @author wjj
 */
public interface ContactsDao {

    int save(Contacts con);

    List<Contacts> getContactsListByName(String cname);
}
