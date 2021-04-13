package com.wjj.crm.settings.dao;

import com.wjj.crm.settings.domain.DicValue;

import java.util.List;

/**
 * @author wjj
 */
public interface DicValueDao {
    List<DicValue> getListByCode(String code);
}
