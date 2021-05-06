package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Activity;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface ChannelDao {

    int save(Channel c);

    int getTotalByCondition(Map<String, Object> map);

    List<Channel> getChannelListByCondition(Map<String, Object> map);

    Channel getChannelById(String id);

    int update(Channel c);

    int delete(String[] ids);

    List<Customer> sum(Map<String, Object> map);

    List<Channel> getChannelListByCid(String id);
}
