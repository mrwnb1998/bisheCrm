package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * @author wjj
 */
public interface ClueRemarkDao {

    int deleteRemarkById(String id);

    List<ClueRemark> getRemarkListByCid(String clueId);

    int updateRemark(ClueRemark ar);

    int saveRemark(ClueRemark ar);

}
