package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.ChannelDao;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.ChannelService;

import java.util.List;
import java.util.Map;

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

    @Override
    public PaginationVo<Channel> pageList(Map<String, Object> map) {
        int total=channelDao.getTotalByCondition(map);
        System.out.println(total);
        //取得dataList
        List<Channel> dataList=channelDao.getChannelListByCondition(map);

        //将total,dataList封装到vo中
        PaginationVo<Channel> vo=new PaginationVo<Channel>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public Channel getChannelById(String id) {
       Channel channel=channelDao.getChannelById(id);
       return channel;
    }

    @Override
    public boolean update(Channel c) {
        boolean flag=true;
        int count=channelDao.update(c);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag=true;
        int count=channelDao.delete(ids);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Customer> sum(Map<String, Object> map) {
        int total=channelDao.getTotalByCondition(map);
        System.out.println(total);
        //取得dataList
        List<Customer> dataList=channelDao.sum(map);
        //将total,dataList封装到vo中
        PaginationVo<Customer> vo=new PaginationVo<Customer>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //返回vo
        return vo;
    }

    @Override
    public List<Channel> getChannelListByCid(String id) {
        List<Channel> clist=channelDao.getChannelListByCid(id);
        return clist;
    }
}
