package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.HandHistory;
import com.wjj.crm.workbench.domain.Material;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface MaterialDao {

    int save(Material m);

    int getTotalByCondition(Map<String, Object> map);

    List<Material> getMaterialListByCondition(Map<String, Object> map);

    int delete(String[] ids);
}
