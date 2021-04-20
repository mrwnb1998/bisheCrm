package com.wjj.crm.workbench.service.impl;


import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.utils.UUIDUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.*;
import com.wjj.crm.workbench.domain.*;
import com.wjj.crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    //线索相关的，线索，线索备注，关联活动
    private ClueDao clueDao= SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueRemarkDao clueRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ClueActivityRelationDao clueActivityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);

    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    //交易相关的，交易，交易历史
    private TranDao tranDao=SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao=SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    //联系人相关的，联系人，备注，关联活动
    private ContactsDao contactDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    //客户相关的，客户，客户备注
    private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao=SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);




    @Override
    public boolean save(Clue clue) {
       boolean flag=true;
       int count=clueDao.save(clue);
       if(count!=1){
           flag=false;
       }
       return flag;
    }

    @Override
    public PaginationVo<Clue> pageList(Map<String, Object> map) {
        int total=clueDao.getTotalByCondition(map);
        System.out.println(total);
        //取得dataList
        List<Clue> dataList=clueDao.getClueListByCondition(map);

        //将total,dataList封装到vo中
        PaginationVo<Clue> vo=new PaginationVo<Clue>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo

        return vo;
    }

    @Override
    public Map<String, Object> getUserListAndClue(String id) {
        List<User> uList=userDao.getUserList();
        Clue a=clueDao.getById(id);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);
        return map;
    }

    @Override
    public boolean update(Clue clue) {
        boolean flag=true;
        int count=clueDao.update(clue);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Clue detail(String id) {
        Clue a=clueDao.detail(id);
        return a;
    }

    @Override
    public List<ClueRemark> getRemarkListByCid(String clueId) {
        List<ClueRemark> arlist=clueRemarkDao.getRemarkListByCid(clueId);
        return arlist;
    }

    @Override
    public boolean deleteRemark(String id) {
     boolean flag=true;
     int count=clueRemarkDao.deleteRemarkById(id);
     if(count!=1){
         flag=false;
     }
     return flag;
    }

    @Override
    public boolean updateRemark(ClueRemark ar) {
        boolean flag=true;
        int count=clueRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ClueRemark ar) {
        boolean flag=true;
        int count=clueRemarkDao.saveRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean unbund(String id) {
        boolean flag=true;
        int count=clueActivityRelationDao.unbund(id);
        if(count!=1){
            flag=false;
        }
        return flag;


    }

    @Override
    public boolean bund(String cid, String[] aids) {
        boolean flag=true;
        for(String aid:aids){
            //取得每一个aid和cid做关联
            ClueActivityRelation car=new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(aid);
            car.setClueId(cid);
            //添加关联关系表中的记录
           int count= clueActivityRelationDao.bund(car);
           if(count!=1){
               flag=false;
           }
        }
       return flag;
    }

    @Override
    public boolean convert(String clueId, Tran t, String createBy) {
        String createTime= DateTimeUtil.getSysTime();
        boolean flag=true;
//        (1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
           Clue c=clueDao.getById(clueId);
//        (2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
           String company=c.getCompany();
           Customer customer=customerDao.getCustomerByName(company);
           //如果customer为空，说明以前没有这个客户，需要新建一个,将线索的信息转为客户的信息
           if(customer==null){
               customer=new Customer();
               customer.setId(UUIDUtil.getUUID());
               customer.setAddress(c.getAddress());
               customer.setWebsite(c.getWebsite());
               customer.setPhone(c.getPhone());
               customer.setOwner(c.getOwner());
               customer.setNextContactTime(c.getNextContactTime());
               customer.setName(company);
               customer.setDescription(c.getDescription());
               customer.setCreateTime(createTime);
               customer.setCreateBy(createBy);
               customer.setContactSummary(c.getContactSummary());
               //添加客户
               int count1=customerDao.save(customer);
               if(count1!=1){
                   flag=false;
               }
           }
//        (3) 通过线索对象提取联系人信息，保存联系人
            Contacts con=new Contacts();
            con.setId(UUIDUtil.getUUID());
            con.setSource(c.getSource());
            con.setOwner(c.getOwner());
            con.setNextContactTime(c.getNextContactTime());
            con.setMphone(c.getMphone());
            con.setJob(c.getJob());
            con.setFullname(c.getFullname());
            con.setEmail(c.getEmail());
            con.setDescription(c.getDescription());
            con.setCustomerId(customer.getId());
            con.setCreateTime(createTime);
            con.setCreateBy(createBy);
            con.setContactSummary(c.getContactSummary());
            con.setAppellation(c.getAppellation());
            con.setAddress(c.getAddress());
            //添加联系人
              int count2=contactDao.save(con);
              if(count2!=1){
                  flag=false;
              }
//          (4) 线索备注转换到客户备注以及联系人备注
             List<ClueRemark> clueRemarkList=clueRemarkDao.getRemarkListByCid(clueId);
              for(ClueRemark clueRemark:clueRemarkList){
                  //取出备注信息(主要转换到客户备注和联系人备注的就是这个备注信息)
                  String noteContent = clueRemark.getNoteContent();
                  //创建客户备注对象，添加客户备注
                  CustomerRemark customerRemark=new CustomerRemark();
                  customerRemark.setId(UUIDUtil.getUUID());
                  customerRemark.setCreateBy(createBy);
                  customerRemark.setCreateTime(createTime);
                  customerRemark.setCustomerId(customer.getId());
                  customerRemark.setEditFlag("0");
                  customerRemark.setNoteContent(noteContent);
                  int count3=customerRemarkDao.save(customerRemark);
                  if(count3!=1){
                      flag=false;
                  }
                  //创建联系人备注对象，添加联系人备注 CustomerRemark customerRemark=new CustomerRemark();
                  ContactsRemark contactsRemark=new ContactsRemark();
                  contactsRemark.setId(UUIDUtil.getUUID());
                  contactsRemark.setCreateBy(createBy);
                  contactsRemark.setCreateTime(createTime);
                  contactsRemark.setContactsId(con.getId());
                  contactsRemark.setEditFlag("0");
                  contactsRemark.setNoteContent(noteContent);
                  int count4=contactsRemarkDao.save(contactsRemark);
                  if(count4!=1){
                      flag=false;
                  }

              }

//             (5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
               //查询出与该线索关联的市场活动，查询与市场活动的关联关系列表
               List<ClueActivityRelation> clueActivityRelations= clueActivityRelationDao.getListByClueId(clueId);
              for(ClueActivityRelation clueActivityRelation:clueActivityRelations){
                  //从每一条便利出来的记录中取出关联的市场活动id
                  String activityId=clueActivityRelation.getActivityId();
                  //创建联系人与市场活动的关联关系对象，让第三步生成的联系人与市场活动做关联
                  ContactsActivityRelation contactsActivityRelation=new ContactsActivityRelation();
                  contactsActivityRelation.setId(UUIDUtil.getUUID());
                  contactsActivityRelation.setActivityId(activityId);
                  contactsActivityRelation.setContactsId(con.getId());
                  int count5=contactsActivityRelationDao.save(contactsActivityRelation);
                  if(count5!=1){
                      flag=false;
                  }
              }

//             (6) 如果有创建交易需求，创建一条交易
                   if(t!=null){
                       //Tran t对象以及在ClueController中以及封装了部分信息：
                       //id,money,name,expectedDate,stage,activityId,createBy.createTime
                       //接下来可以通过第一步生成的线索对象c,取出一些信息，继续完成t对象的封装
                       t.setSource(c.getSource());
                       t.setOwner(c.getOwner());
                       t.setNextContactTime(c.getNextContactTime());
                       t.setDescription(c.getDescription());
                       t.setCustomerId(customer.getId());
                       t.setContactSummary(c.getContactSummary());
                       t.setContactsId(con.getId());
                       int count6=tranDao.save(t);
                       if(count6!=1){
                           flag=false;
                       }
            // (7) 如果创建了交易，则创建一条该交易下的交易历史
                       TranHistory th=new TranHistory();
                       th.setId(UUIDUtil.getUUID());
                       th.setCreateTime(createTime);
                       th.setCreateBy(createBy);
                       th.setExpectedDate(t.getExpectedDate());
                       th.setMoney(t.getMoney());
                       th.setStage(t.getStage());
                       th.setTranId(t.getId());
                       int count7=tranHistoryDao.save(th);
                       if(count7!=1){
                           flag=false;
                       }

                   }
 //
//              (8) 删除线索备注
                     for(ClueRemark clueRemark:clueRemarkList){
                         int count8=clueRemarkDao.deleteRemarkById(clueRemark.getId());
                         if(count8!=1){
                             flag=false;
                         }

                  }
//              (9) 删除线索和市场活动的关系
                     for(ClueActivityRelation clueActivityRelation:clueActivityRelations){
                        int count9= clueActivityRelationDao.delete(clueActivityRelation);
                        if(count9!=1){
                            flag=false;
                        }
                  }
//              (10) 删除线索
                   int count10=clueDao.delete(clueId);
                     if(count10!=1){
                         flag=false;
                     }



        return flag;
    }


}
