package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Material;
import com.wjj.crm.workbench.domain.MaterialRemark;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface MaterialService {

    boolean save(Material m);

    PaginationVo<Material> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String,Object> detail(String id);

    List<MaterialRemark> getRemarkListByCid(String materialId);

    boolean deleteRemark(String id);

    boolean saveRemark(MaterialRemark ar);

    boolean updateRemark(MaterialRemark ar);

    Material getMaterialById(String id);

    boolean update(Material m);
}
