package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Activity;
import com.wjj.crm.workbench.domain.HandHistory;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface HandHistoryDao {


    int save(HandHistory handHistory);

    List<HandHistory> getgetHandHistory();
}
