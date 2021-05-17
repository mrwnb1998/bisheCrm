package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.CustomerDao;
import com.wjj.crm.workbench.dao.CustomerRemarkDao;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.domain.CustomerRemark;
import com.wjj.crm.workbench.service.CustomerService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao= SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao= SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public List<String> getCustomerName(String name) {
        List<String> sList=customerDao.getCustomerName(name);
        return sList;
    }

    @Override
    public PaginationVo<Customer> pageList(Map<String, Object> map) {
        //取得total
        int total=customerDao.getTotalByCondition(map);
        //取得dataList
        List<Customer> dataList=customerDao.getCustomerListByCondition(map);

        //将total,dataList封装到vo中
        PaginationVo<Customer> vo=new PaginationVo<Customer>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo

        return vo;
    }

    @Override
    public boolean save(Customer c) {
        boolean flag=true;
        int count=customerDao.save(c);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public List<Customer> getCustomerListName(String aname) {
        List<Customer> slist=customerDao.getCustomerListName(aname);
        return slist;
    }

    @Override
    public Map<String, Object> detail(String id) {
        Customer c=customerDao.detail(id);
        long create_by =c.getCreate_by();
        long update_by =c.getUpdate_by();
        User u1=userDao.getUserById(Long.toString(create_by));
        User u2=userDao.getUserById(Long.toString(update_by));
        Map<String, Object> a=new HashMap<String, Object>();
        a.put("c",c);
        a.put("u1",u1);
        a.put("u2",u2);
        return a;
    }

    @Override
    public Map<String, Object> getSourceCharts() {
        Map<String, Object> data=new HashMap<String, Object>();
        List<Map<String, Object>> dataList=customerDao.getSourceCharts();
        List<String> data1=new ArrayList<String>();
        List<Integer> data2=new ArrayList<Integer>();
        //判断dataList是否为空。不为空则遍历
        if(dataList!=null&&dataList.size()>0){
         for(Map<String, Object> m:dataList) {
             data1.add(m.get("department").toString());
             data2.add(Integer.parseInt(m.get("total").toString()));
         }
        }
        data.put("data1",data1);
        data.put("data2",data2);
        return data;
    }

    @Override
    public List<CustomerRemark> getRemarkListByCid(String customerId) {
        List<CustomerRemark> arlist=customerRemarkDao.getRemarkListByCid(customerId);
        return arlist;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=customerRemarkDao.deleteRemarkById(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(CustomerRemark ar) {
        boolean flag=true;
        int count=customerRemarkDao.save(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(CustomerRemark ar) {
        boolean flag=true;
        int count=customerRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndContacts(String id) {
        List<User> uList=userDao.getUserList();
        Customer a=customerDao.detail(id);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);
        return map;
    }

    @Override
    public boolean update(Customer clue) {
       boolean flag=true;
       int count=customerDao.update(clue);
       if(count!=1){
           flag=false;
       }
       return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag=true;
        int count3=customerDao.delete(ids);
        if(count3!=ids.length){
            flag=false;
        }

        return flag;
    }
}
