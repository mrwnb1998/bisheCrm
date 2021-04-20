package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.workbench.dao.ContactsDao;
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.service.ContactsService;

import java.util.List;

public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);

    @Override
    public List<Contacts> getContactsListByName(String cname) {
       List<Contacts> cList=contactsDao.getContactsListByName(cname);
       return cList;
    }
}
