package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.ContactsRemark;

import java.util.List;

/**
 * @author wjj
 */
public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    List<ContactsRemark> getRemarkListByCid(String contactsId);

    int updateRemark(ContactsRemark ar);

    int deleteRemark(String id);
}
