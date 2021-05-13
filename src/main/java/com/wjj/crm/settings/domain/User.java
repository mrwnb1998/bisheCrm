package com.wjj.crm.settings.domain;

import java.sql.Timestamp;

/**
 * @author wjj
 *关于登录的验证问题
 * 登录不仅需要验证用户名密码，List<User> list= select * from tbl_user where loginact=? and loginpwd=?
 * 如果为空，则用户不存在，不为空继续验证后面的
 * 还需要验证失效时间，锁定状态，ip地址，
 *
 *
 */
public class User {
    private String id ;       //用户id,主键
    private String loginAct;  //用户账户 ，
    private String name;      //用户真实姓名
    private String loginPwd ;  //用户密码
    private String email ;    //邮箱
    private String expireTime; //失效时间，失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。'
    private String lockState ; //锁定状态，0表示锁定，1表示启用
    private String department;    //部门编号
    private String allowIps ;  //IP地址允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。
    private String createTime; //创建时间
    private String createBy;   //由谁创建
    private String editTime ;  //修改时间
    private String editBy;     //由谁修改

    public User() {

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getname() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(String expireTime) {
        this.expireTime = expireTime;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }
};
