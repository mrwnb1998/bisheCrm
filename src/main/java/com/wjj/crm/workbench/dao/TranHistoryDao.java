package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.TranHistory;

import java.util.List;

/**
 * @author wjj
 */
public interface TranHistoryDao {

    int save(TranHistory th);

    List<TranHistory> getHistoryListByTranId(String tranId);
}
