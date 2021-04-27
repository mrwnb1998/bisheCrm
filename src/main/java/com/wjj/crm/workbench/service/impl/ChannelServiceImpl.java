package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.workbench.dao.ChannelDao;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.service.ChannelService;

public class ChannelServiceImpl implements ChannelService {

    private ChannelDao channelDao= SqlSessionUtil.getSqlSession().getMapper(ChannelDao.class);

    @Override
    public boolean save(Channel c) {
        boolean flag=true;
        int count=channelDao.save(c);
        if(count!=1){
            flag=false;
        }
return flag;
    }
}
