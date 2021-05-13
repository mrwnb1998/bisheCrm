package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Clue;
import com.wjj.crm.workbench.domain.ClueRemark;
import com.wjj.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    Map<String, Object> detail(String id);

    List<ClueRemark> getRemarkListByCid(String clueId);

    boolean deleteRemark(String id);

    boolean updateRemark(ClueRemark ar);

    boolean saveRemark(ClueRemark ar);

    boolean unbund(String id);

    boolean bund(String cid, String[] aids);


    boolean convert(String clueId, Tran t, String createBy);

    boolean delete(String[] ids);
}
