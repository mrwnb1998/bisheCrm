package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Material;

import java.util.Map;

public interface MaterialService {

    boolean save(Material m);

    PaginationVo<Material> pageList(Map<String, Object> map);

    boolean delete(String[] ids);
}
