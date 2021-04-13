package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.ActivityDao;
import com.wjj.crm.workbench.dao.ActivityRemarkDao;
import com.wjj.crm.workbench.domain.Activity;
import com.wjj.crm.workbench.domain.ActivityRemark;
import com.wjj.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityDaoRemark= SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public boolean save(Activity a) {
boolean flag=true;
int count=activityDao.save(a);
if(count!=1){
    flag=false;
}
        return flag;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        //取得total
int total=activityDao.getTotalByCondition(map);
        //取得dataList
List<Activity> dataList=activityDao.getActivityListByCondition(map);

        //将total,dataList封装到vo中
PaginationVo<Activity> vo=new PaginationVo<Activity>();
vo.setTotal(total);
vo.setDataList(dataList);
        //返回vo

        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag=true;
        //查询出需要删除的备注的数量
           int count1=activityDaoRemark.getCountByAids();
        //杀出备注，返回收到影响的条数（实际删除的数量）
           int count2=activityDaoRemark.deleteByAids();
           if(count1!=count2){
               flag=false;
           }
        //删除市场活动

        int count3=activityDao.delete(ids);
           if(count3!=ids.length){
               flag=false;
           }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
         List<User> uList=userDao.getUserList();
         Activity a=activityDao.getById(id);
         Map<String,Object> map=new HashMap<String, Object>();
         map.put("uList",uList);
         map.put("a",a);
         return map;

    }

    @Override
    public boolean update(Activity a) {
        boolean flag=true;
        int count=activityDao.update(a);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
       Activity a= activityDao.detail(id);
        return a;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {
       List<ActivityRemark> arlist=activityDaoRemark.getRemarkListByAid(activityId);
       return arlist;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityDaoRemark.deleteById(id);
        if (count!= 1) {
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        boolean flag=true;
       int count=activityDaoRemark.saveRemark(ar);
       if(count!=1){
           flag=false;
       }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        boolean flag=true;
        int count=activityDaoRemark.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }


}
