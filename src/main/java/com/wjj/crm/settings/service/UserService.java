package com.wjj.crm.settings.service;

import com.wjj.crm.settings.domain.User;
import com.wjj.crm.vo.PaginationVo;

import javax.security.auth.login.LoginException;
import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();

    PaginationVo<User> pageList(Map<String, Object> map);

    boolean hand(String id);

    boolean updatePwd(User u);

    User getUserById(String id);
}
