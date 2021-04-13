package com.wjj.crm.workbench.service.impl;


import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.ClueDao;
import com.wjj.crm.workbench.domain.Clue;
import com.wjj.crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao= SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

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
}
