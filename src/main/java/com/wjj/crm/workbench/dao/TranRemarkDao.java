package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.ClueRemark;
import com.wjj.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    List<TranRemark> getRemarkListByCid(String tranId);

    int deleteRemarkById(String id);

    int updateRemark(TranRemark ar);

    int saveRemark(TranRemark ar);
}
