package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.HandHistoryDao;
import com.wjj.crm.workbench.dao.MaterialDao;
import com.wjj.crm.workbench.dao.MaterialRemarkDao;
import com.wjj.crm.workbench.domain.HandHistory;
import com.wjj.crm.workbench.domain.Material;
import com.wjj.crm.workbench.domain.MaterialRemark;
import com.wjj.crm.workbench.service.HandHistoryService;
import com.wjj.crm.workbench.service.MaterialService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public class MaterialServiceImpl implements MaterialService {
    private MaterialDao materialDao = SqlSessionUtil.getSqlSession().getMapper(MaterialDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private MaterialRemarkDao materialRemarkDao = SqlSessionUtil.getSqlSession().getMapper(MaterialRemarkDao.class);


    @Override
    public boolean save(Material m) {
        boolean flag=true;
       int count=materialDao.save(m);
       if(count!=1){
           flag=false;
       }
       return flag;
    }

    @Override
    public PaginationVo<Material> pageList(Map<String, Object> map) {
        //取得total
        int total=materialDao.getTotalByCondition(map);
        //取得dataList
        List<Material> dataList=materialDao.getMaterialListByCondition(map);

        //将total,dataList封装到vo中
        PaginationVo<Material> vo=new PaginationVo<Material>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
       boolean flag=true;
       int count=materialDao.delete(ids);
       if(count!=ids.length){
           flag=false;
       }
       return flag;
    }

    @Override
    public Map<String,Object> detail(String id) {

        Map<String,Object> map=new HashMap<String, Object>();
        Material a=materialDao.getMaterialById(id);
        User u1=userDao.getUserById(Long.toString(a.getCreate_by()));
        User u2=userDao.getUserById(Long.toString(a.getUpdate_by()));
        map.put("a",a);
        map.put("u1",u1);
        map.put("u2",u2);
       return map;
    }

    @Override
    public List<MaterialRemark> getRemarkListByCid(String materialId) {
        List<MaterialRemark> arlist=materialRemarkDao.getRemarkListByCid(materialId);
        return arlist;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=materialRemarkDao.deleteRemarkById(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(MaterialRemark ar) {
        boolean flag=true;
        int count=materialRemarkDao.saveRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(MaterialRemark ar) {
        boolean flag=true;
        int count=materialRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Material getMaterialById(String id) {
       Material m=materialDao.getMaterialById(id);
       return  m;
    }

    @Override
    public boolean update(Material m) {
        boolean flag=true;
        int count=materialDao.update(m);
        if(count!=1){
            flag=false;
        }
        return flag;
    }
}
