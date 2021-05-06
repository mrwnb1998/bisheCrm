package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Task;
import com.wjj.crm.workbench.domain.TaskRemark;

import java.util.List;

/**
 * @author wjj
 */
public interface TaskRemarkDao {
    List<TaskRemark> getRemarkListByTid(String id);

    int deleteRemarkById(String id);

    int updateRemark(TaskRemark ar);

    int saveRemark(TaskRemark ar);

    int getCountByTids(String[] ids);

    int deleteByTids(String[] ids);
}
