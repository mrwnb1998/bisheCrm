package com.wjj.crm.settings.service;

import com.wjj.crm.settings.domain.User;

import javax.security.auth.login.LoginException;
import java.util.List;

/**
 * @author wjj
 */
public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
