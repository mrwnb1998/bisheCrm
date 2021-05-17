package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.ChannelRemark;
import com.wjj.crm.workbench.domain.MaterialRemark;

import java.util.List;

/**
 * @author wjj
 */
public interface MaterialRemarkDao {

    List<MaterialRemark> getRemarkListByCid(String materialId);

    int deleteRemarkById(String id);

    int saveRemark(MaterialRemark ar);

    int updateRemark(MaterialRemark ar);
}
