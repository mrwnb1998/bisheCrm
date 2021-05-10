package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.domain.ContactsRemark;
import com.wjj.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface ContactsService {

    List<Contacts> getContactsListByName(String cname);

    PaginationVo<Contacts> pageList(Map<String, Object> map);

    boolean save(Contacts t, String customerName);

    boolean update(Contacts clue);

    Map<String, Object> getUserListAndContacts(String id);

    boolean delete(String[] ids);

    Contacts detail(String id);

    List<ContactsRemark> getRemarkListByCid(String contactsId);

    boolean saveRemark(ContactsRemark ar);

    boolean updateRemark(ContactsRemark ar);

    boolean deleteRemark(String id);
}
