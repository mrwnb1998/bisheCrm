package com.wjj.crm.settings.service.impl;

import com.wjj.crm.settings.dao.UserDao;
import com.wjj.crm.settings.domain.User;
import com.wjj.crm.settings.service.UserService;
import com.wjj.crm.utils.DateTimeUtil;
import com.wjj.crm.utils.SqlSessionUtil;

import javax.security.auth.login.LoginException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author wjj
 */
public class UserServiceImpl implements UserService {
    private UserDao userdao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String, String> map = new HashMap<String, String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user=userdao.login(map);
        if(user==null){
throw new LoginException("账号密码错误");
        }
//如果程序能够成功的执行到此，则说明账号密码正确
        //需要继续向下验证其他三项
        //验证失效时间
        String expierTime=user.getExpireTime();
        String currentTime= DateTimeUtil.getSysTime();
        if(expierTime.compareTo(currentTime)<0){
            throw new LoginException("账号已失效");
        }
        //判断锁定状态
        String lockstate=user.getLockState();
        if("0".equals(lockstate)){
            throw new LoginException("账号已锁定");
        }
        //判断ip地址
        String allowip=user.getAllowIps();

        if(!allowip.contains(ip)){
            throw new LoginException("ip已限制");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList=userdao.getUserList();
        return uList;
    }
}
