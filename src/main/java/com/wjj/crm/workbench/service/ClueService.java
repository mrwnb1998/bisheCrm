package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Clue;

import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);
}
