package com.wjj.crm.workbench.dao;


import com.wjj.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface ClueDao {


    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue getById(String id);

    int update(Clue clue);

    Clue detail(String id);

    int delete(String clueId);

    void hand(String id);

    int deletes(String[] ids);
}
