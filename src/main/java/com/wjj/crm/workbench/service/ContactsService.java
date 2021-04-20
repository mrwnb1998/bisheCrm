package com.wjj.crm.workbench.service;

import com.wjj.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {

    List<Contacts> getContactsListByName(String cname);
}
