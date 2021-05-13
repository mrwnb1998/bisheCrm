package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.HandHistoryDao;
import com.wjj.crm.workbench.dao.MaterialDao;
import com.wjj.crm.workbench.domain.HandHistory;
import com.wjj.crm.workbench.domain.Material;
import com.wjj.crm.workbench.service.HandHistoryService;
import com.wjj.crm.workbench.service.MaterialService;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public class MaterialServiceImpl implements MaterialService {
    private MaterialDao materialDao = SqlSessionUtil.getSqlSession().getMapper(MaterialDao.class);


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
}
