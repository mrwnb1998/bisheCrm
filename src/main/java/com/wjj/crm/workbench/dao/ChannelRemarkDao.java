package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.ChannelRemark;
import com.wjj.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * @author wjj
 */
public interface ChannelRemarkDao {

    List<ChannelRemark> getRemarkListByCid(String channelId);

    int deleteRemarkById(String id);

    int saveRemark(ChannelRemark ar);

    int updateRemark(ChannelRemark ar);
}
