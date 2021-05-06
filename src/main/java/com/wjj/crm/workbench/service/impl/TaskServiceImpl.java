package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.CustomerDao;
import com.wjj.crm.workbench.dao.TaskDao;
import com.wjj.crm.workbench.dao.TaskRemarkDao;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.domain.Task;
import com.wjj.crm.workbench.domain.TaskRemark;
import com.wjj.crm.workbench.service.CustomerService;
import com.wjj.crm.workbench.service.TaskService;

import java.util.List;
import java.util.Map;

public class TaskServiceImpl implements TaskService {
 private TaskDao taskDao=SqlSessionUtil.getSqlSession().getMapper(TaskDao.class);
    private TaskRemarkDao taskRemarkDao=SqlSessionUtil.getSqlSession().getMapper(TaskRemarkDao.class);
    @Override
    public PaginationVo<Task> pageList(Map<String, Object> map) {
        //取得total
        int total=taskDao.getTotalByCondition(map);
        //取得dataList
        List<Task> dataList=taskDao.getTaskListByCondition(map);

        //将total,dataList封装到vo中
        PaginationVo<Task> vo=new PaginationVo<Task>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public Task detail(String id) {
        Task t=taskDao.getTaskById(id);
        return t;
    }

    @Override
    public List<TaskRemark> getRemarkListByTid(String id) {
        List<TaskRemark> dataList=taskRemarkDao.getRemarkListByTid(id);
        return dataList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=taskRemarkDao.deleteRemarkById(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(TaskRemark ar) {
        boolean flag=true;
        int count=taskRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(TaskRemark ar) {
        boolean flag=true;
        int count=taskRemarkDao.saveRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean save(Task t) {
        boolean flag=true;
        int count=taskDao.save(t);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean update(Task t) {
        boolean flag=true;
        int count=taskDao.update(t);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Task getTaskById(String id) {
        Task t=taskDao.getTaskById(id);
        return t;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag=true;
        //查询出需要删除的备注的数量
        int count1=taskRemarkDao.getCountByTids(ids);
        //杀出备注，返回收到影响的条数（实际删除的数量）
        int count2=taskRemarkDao.deleteByTids(ids);
        if(count1!=count2){
            flag=false;
        }
        //删除市场活动

        int count3=taskDao.delete(ids);
        if(count3!=ids.length){
            flag=false;
        }

        return flag;
    }


//    public boolean save(Customer c) {
//        boolean flag=true;
//        int count=taskDao.save(c);
//        if(count!=1){
//            flag=false;
//        }
//        return flag;
//    }
}
