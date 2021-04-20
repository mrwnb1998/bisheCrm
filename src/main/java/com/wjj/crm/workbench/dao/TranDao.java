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
}
