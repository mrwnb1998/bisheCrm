package com.wjj.crm.workbench.service;

import com.wjj.crm.workbench.domain.HandHistory;

import java.util.List;

/**
 * @author wjj
 */
public interface HandHistoryService {

    boolean save(HandHistory handHistory);

    List<HandHistory> getgetHandHistory();
}
