package com.wjj.crm.workbench.dao;


import com.wjj.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

/**
 * @author wjj
 */
public interface ClueActivityRelationDao {


    int unbund(String id);

    int bund(ClueActivityRelation car);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);
}
