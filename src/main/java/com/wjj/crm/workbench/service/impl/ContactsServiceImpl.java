package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.ContactsDao;
import com.wjj.crm.workbench.dao.ContactsRemarkDao;
import com.wjj.crm.workbench.dao.CustomerDao;
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.domain.ContactsRemark;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private CustomerDao customerDao= SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private ContactsRemarkDao contactsRemarkDao= SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    @Override
    public List<Contacts> getContactsListByName(String cname) {
       List<Contacts> cList=contactsDao.getContactsListByName(cname);
       return cList;
    }

    @Override
    public PaginationVo<Contacts> pageList(Map<String, Object> map) {
        //取得total
        int total=contactsDao.getTotalByCondition(map);
        //取得dataList
        List<Contacts> dataList=contactsDao.getCustomerListByCondition(map);

        //将total,dataList封装到vo中
        PaginationVo<Contacts> vo=new PaginationVo<Contacts>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public boolean save(Contacts t, String customerName) {
        boolean flag=true;

        Customer customer=customerDao.getCustomerByName(customerName);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(t.getCreateBy());
            customer.setCreateTime(t.getCreateTime());
            customer.setNextContactTime(t.getNextContactTime());
            customer.setOwner(t.getOwner());
            int count1=customerDao.save(customer);
            if(count1!=1){
                flag=false;
            }
        }
        t.setCustomerId(customer.getId());
        int count2=contactsDao.save(t);
        if(count2!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean update(Contacts clue) {
        boolean flag=true;
        int count=contactsDao.update(clue);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndContacts(String id) {
        List<User> uList=userDao.getUserList();
       Contacts a=contactsDao.getById(id);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);
        return map;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag=true;
        int count3=contactsDao.delete(ids);
        if(count3!=ids.length){
            flag=false;
        }

        return flag;
    }

    @Override
    public Contacts detail(String id) {
        Contacts a=contactsDao.detail(id);
        return a;
    }

    @Override
    public List<ContactsRemark> getRemarkListByCid(String contactsId) {
        List<ContactsRemark> arlist=contactsRemarkDao.getRemarkListByCid(contactsId);
        return arlist;
    }

    @Override
    public boolean saveRemark(ContactsRemark ar) {
        boolean flag=true;
        int count=contactsRemarkDao.save(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ContactsRemark ar) {
        boolean flag=true;
        int count=contactsRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=contactsRemarkDao.deleteRemark(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }
}
