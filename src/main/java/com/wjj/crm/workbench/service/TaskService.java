package com.wjj.crm.workbench.service;

import com.wjj.crm.vo.PaginationVo;
import com.wjj.crm.workbench.domain.Customer;
import com.wjj.crm.workbench.domain.Task;
import com.wjj.crm.workbench.domain.TaskRemark;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface TaskService {

    PaginationVo<Task> pageList(Map<String, Object> map);

    Task detail(String id);

    List<TaskRemark> getRemarkListByTid(String id);

    boolean deleteRemark(String id);

    boolean updateRemark(TaskRemark ar);

    boolean saveRemark(TaskRemark ar);

    boolean save(Task t);

    boolean update(Task t);

    Task getTaskById(String id);

    boolean delete(String[] ids);
}
