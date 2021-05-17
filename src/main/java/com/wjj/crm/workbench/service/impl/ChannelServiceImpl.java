package com.wjj.crm.workbench.service.impl;

import com.wjj.crm.utils.SqlSessionUtil;
import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.dao.ChannelDao;
import com.wjj.crm.workbench.dao.ChannelRemarkDao;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.domain.ChannelRemark;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.service.ChannelService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChannelServiceImpl implements ChannelService {

    private ChannelDao channelDao= SqlSessionUtil.getSqlSession().getMapper(ChannelDao.class);
    private ChannelRemarkDao channelRemarkDao= SqlSessionUtil.getSqlSession().getMapper(ChannelRemarkDao.class);


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

    @Override
    public Map<String, Object> getSourceCharts(String id) {
        Map<String, Object> data=new HashMap<String, Object>();
        List<Map<String, Object>> dataList=channelDao.getSourceCharts(id);
        List<String> data1=new ArrayList<String>();
        List<Integer> data2=new ArrayList<Integer>();
        List<Integer> data3=new ArrayList<Integer>();
        //判断dataList是否为空。不为空则遍历
        if(dataList!=null&&dataList.size()>0){
            for(Map<String, Object> m:dataList) {
                data1.add(m.get("name").toString());
                data2.add(Integer.parseInt(m.get("dream_sale").toString()));
                data3.add(Integer.parseInt(m.get("true_sale").toString()));
            }
        }
        data.put("data1",data1);
        data.put("data2",data2);
        data.put("data3",data3);
        return data;
    }

    @Override
    public Channel detail(String id) {
        Channel a=channelDao.getChannelById(id);
        return a;
    }

    @Override
    public List<ChannelRemark> getRemarkListByCid(String customerId) {
        List<ChannelRemark> arlist=channelRemarkDao.getRemarkListByCid(customerId);
        return arlist;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=channelRemarkDao.deleteRemarkById(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ChannelRemark ar) {
        boolean flag=true;
        int count=channelRemarkDao.saveRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ChannelRemark ar) {
        boolean flag=true;
        int count=channelRemarkDao.updateRemark(ar);
        if(count!=1){
            flag=false;
        }
        return flag;
    }
}
