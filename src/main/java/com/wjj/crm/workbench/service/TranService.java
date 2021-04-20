package com.wjj.crm.workbench.service;


import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Tran;

import java.util.Map;

public interface TranService {
    boolean save(Tran t, String customerName);


    PaginationVo<Tran> pageList(Map<String, Object> map);

    Tran detail(String id);
}
