package com.wjj.crm.settings.dao;

import com.wjj.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface UserDao {

    User login(Map<String, String> map);

    List<User> getUserList();

    int getTotalByCondition(Map<String, Object> map);

    List<User> getUserListByCondition(Map<String, Object> map);

    void hand(String id);
}
