package com.wjj.crm.settings.service;

import com.wjj.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author wjj
 */
public interface DicService {
    Map<String, List<DicValue>> getAll();
}
