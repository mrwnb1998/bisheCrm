package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Channel;
import com.wjj.crm.workbench.domain.ChannelRemark;
import com.wjj.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface ChannelService {
    boolean save(Channel c);

    PaginationVo<Channel> pageList(Map<String, Object> map);

    Channel getChannelById(String id);

    boolean update(Channel c);

    boolean delete(String[] ids);

    PaginationVo<Customer> sum(Map<String, Object> map);

    List<Channel> getChannelListByCid(String id);

    Map<String, Object> getSourceCharts(String id);

    Channel detail(String id);

    List<ChannelRemark> getRemarkListByCid(String channelId);

    boolean deleteRemark(String id);

    boolean saveRemark(ChannelRemark ar);

    boolean updateRemark(ChannelRemark ar);
}
