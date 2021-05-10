package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface TranDao {

    int save(Tran t);

    int getTotalByCondition(Map<String, Object> map);

    List<Tran> getTranListByCondition(Map<String, Object> map);

    Tran detail(String id);

    int changeStage(Tran t);

    int getTotal();

    List<Map<String, Object>> getCharts();

    List<Map<String, Object>> getSourceCharts();

    void hand(String id);
}
