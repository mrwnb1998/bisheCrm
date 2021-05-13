package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.*;
import com.wjj.crm.workbench.domain.*;
import com.wjj.crm.workbench.service.TranService;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
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
    private TranRemarkDao tranRemarkDao= SqlSessionUtil.getSqlSession().getMapper(TranRemarkDao.class);

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
            customer.setName(customerName);
            customer.setCreate_by(Long.parseLong(t.getCreateBy()));
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Timestamp create_time=new Timestamp(System.currentTimeMillis());
            create_time=Timestamp.valueOf(t.getCreateTime());
            customer.setCreate_time(create_time);
            customer.setNext_contactTime(t.getNextContactTime());
            customer.setOwner(t.getOwner());
            int count1=customerDao.save(customer);
            if(count1!=1){
                flag=false;
            }
        }
        t.setCustomerId(Long.toString(customer.getId()));
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

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
       List<TranHistory> thList= tranHistoryDao.getHistoryListByTranId(tranId);
        return thList;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag=true;
        int count=tranDao.changeStage(t);
        if(count!=1){
            flag=false;
        }
        //交易阶段改变后成城交易历史
        TranHistory th=new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(t.getStage());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        //th.setPossibility(t.getPossibility());
        //添加交易历史
        int count2=tranHistoryDao.save(th);
        if(count2!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        //取得total
          int total=tranDao.getTotal();
        //取得dataList
         List<Map<String,Object>> dataList= tranDao.getCharts();

        //将total和dataList保存在map中
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("total",total);
        map.put("dataList",dataList);

        return map;
    }

    @Override
    public List<Map<String, Object>> getSourceCharts() {
        List<Map<String,Object>> dataList= tranDao.getSourceCharts();
        return dataList;
    }

    @Override
    public List<TranRemark> getRemarkListByCid(String tranId) {
        List<TranRemark> arList=tranRemarkDao.getRemarkListByCid(tranId);
        return arList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=tranRemarkDao.deleteRemarkById(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(TranRemark ar) {
        boolean flag=true;
        int count=tranRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(TranRemark ar) {
        boolean flag=true;
        int count=tranRemarkDao.saveRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }
}
