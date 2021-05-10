package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.workbench.dao.HandHistoryDao;
import com.wjj.crm.workbench.domain.HandHistory;
import com.wjj.crm.workbench.service.HandHistoryService;

import java.util.List;

/**
 * @author wjj
 */
public class HandHistoryServiceImpl implements HandHistoryService {
    private HandHistoryDao handHistoryDao = SqlSessionUtil.getSqlSession().getMapper(HandHistoryDao.class);


    @Override
    public boolean save(HandHistory handHistory) {
        boolean f = true;
        int count = handHistoryDao.save(handHistory);
        if(count!=1){
            f=false;
        }
        return f;
    }

    @Override
    public List<HandHistory> getgetHandHistory() {
        List<HandHistory> hlist=handHistoryDao.getgetHandHistory();
        return hlist;
    }
}
