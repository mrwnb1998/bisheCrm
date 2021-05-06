package com.wjj.crm.workbench.dao;

import com.wjj.crm.workbench.domain.Task;

import java.util.List;
import java.util.Map;

public interface TaskDao {
    int getTotalByCondition(Map<String, Object> map);

    List<Task> getTaskListByCondition(Map<String, Object> map);

    Task getTaskById(String id);

    int save(Task t);

    int update(Task t);

    int delete(String[] ids);
}
