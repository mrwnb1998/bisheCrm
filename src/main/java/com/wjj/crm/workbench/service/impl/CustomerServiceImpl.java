package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.CustomerDao;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.CustomerService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao= SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

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
    public Customer detail(String id) {
        Customer a=customerDao.detail(id);
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
}
