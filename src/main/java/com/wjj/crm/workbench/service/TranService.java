package com.wjj.crm.workbench.service;


import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.ClueRemark;
import com.wjj.crm.workbench.domain.Tran;
import com.wjj.crm.workbench.domain.TranHistory;
import com.wjj.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface TranService {
    boolean save(Tran t, String customerName);


    PaginationVo<Tran> pageList(Map<String, Object> map);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);

    Map<String, Object> getCharts();

    List<Map<String, Object>> getSourceCharts();

    List<TranRemark> getRemarkListByCid(String tranId);

    boolean deleteRemark(String id);

    boolean updateRemark(TranRemark ar);

    boolean saveRemark(TranRemark ar);

    List<Tran> getTranListByCustomerId(String customerId);

    Map<String,Object> getTranById(String id);

    boolean update(Tran c);

    boolean delete(String[] ids);
}
