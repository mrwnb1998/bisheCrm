package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.ContactsDao;
import com.wjj.crm.workbench.dao.CustomerDao;
import com.wjj.crm.workbench.dao.TranDao;
import com.wjj.crm.workbench.dao.TranHistoryDao;
import com.wjj.crm.workbench.domain.Contacts;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.domain.Tran;
import com.wjj.crm.workbench.domain.TranHistory;
import com.wjj.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public class TranServiceImpl implements TranService {
          private TranDao tranDao= SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
          private TranHistoryDao tranHistoryDao= SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
          private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
          private ContactsDao contactsDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);

    @Override
    public boolean save(Tran t, String customerName) {
        /*
        * 交易添加业务
        *在做添加之前，参数t里面少了客户的主键，customerId
        * 所以先处理客户相关的需求
        * （1）判断customerName,根据客户名称进行精确查询
        *      如果有这个客户，则取出这个客户的id，封装到t对象中
        *      如果没有这个客户，则在客户表新建一条客户信息，然后将新建的客户id取出，封装到t对象中
        *  （2）经过以上操作，t对象中的信息就全了，需要执行添加操作
        * （3）添加交易完毕后，需要创建一条交易历史
         */

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
        int count2=tranDao.save(t);
        if(count2!=1){
            flag=false;
        }
        TranHistory th=new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateBy(t.getCreateBy());
        th.setCreateTime(t.getCreateTime());
        int count3=tranHistoryDao.save(th);
        if(count3!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Tran> pageList(Map<String, Object> map) {
        int total=tranDao.getTotalByCondition(map);
        List<Tran> dataList=tranDao.getTranListByCondition(map);
//        String customerName=customerDao.getCustomerNameByTran();
//        String contactsName=contactsDao.getContactsNameByTran();
//        Map<String,Object> pmap=new HashMap<String, Object>();
//        pmap.put("total",total);
//        pmap.put("dataList",dataList);
//        pmap.put("contactsName",contactsName);
//        pmap.put("customerName",customerName);
        PaginationVo<Tran> vo=new PaginationVo<Tran>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }

    @Override
    public Tran detail(String id) {
        Tran t=tranDao.detail(id);
        return t;
    }
}
