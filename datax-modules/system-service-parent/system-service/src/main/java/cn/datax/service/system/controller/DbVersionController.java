package cn.datax.service.system.controller;

import cn.datax.common.base.BaseController;
import cn.datax.common.core.R;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.MigrationInfo;
import org.flywaydb.core.api.MigrationInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据库版本管理控制器
 *
 * @author datax
 * @since 2026-01-07
 */
@Api(tags = {"数据库版本管理"})
@RestController
@RequestMapping("/db/version")
public class DbVersionController extends BaseController {

    @Autowired
    private Flyway flyway;

    /**
     * 获取当前数据库版本
     */
    @ApiOperation(value = "获取当前数据库版本", notes = "返回当前数据库的版本号和迁移历史")
    @GetMapping("/current")
    public R getCurrentVersion() {
        MigrationInfoService infoService = flyway.info();
        MigrationInfo current = infoService.current();
        
        Map<String, Object> result = new HashMap<>();
        if (current != null) {
            result.put("version", current.getVersion().toString());
            result.put("description", current.getDescription());
            result.put("installedOn", current.getInstalledOn());
            result.put("state", current.getState().toString());
        } else {
            result.put("version", "未初始化");
            result.put("description", "数据库尚未进行版本管理");
        }
        
        return R.ok().setData(result);
    }

    /**
     * 获取所有迁移历史
     */
    @ApiOperation(value = "获取迁移历史", notes = "返回所有已执行的数据库迁移记录")
    @GetMapping("/history")
    public R getMigrationHistory() {
        MigrationInfoService infoService = flyway.info();
        MigrationInfo[] all = infoService.all();
        
        List<Map<String, Object>> history = new ArrayList<>();
        for (MigrationInfo info : all) {
            Map<String, Object> item = new HashMap<>();
            item.put("version", info.getVersion() != null ? info.getVersion().toString() : "N/A");
            item.put("description", info.getDescription());
            item.put("type", info.getType().toString());
            item.put("state", info.getState().toString());
            item.put("installedOn", info.getInstalledOn());
            item.put("executionTime", info.getExecutionTime());
            history.add(item);
        }
        
        return R.ok().setData(history);
    }

    /**
     * 获取待执行的迁移
     */
    @ApiOperation(value = "获取待执行迁移", notes = "返回尚未执行的数据库迁移脚本")
    @GetMapping("/pending")
    public R getPendingMigrations() {
        MigrationInfoService infoService = flyway.info();
        MigrationInfo[] pending = infoService.pending();
        
        List<Map<String, Object>> pendingList = new ArrayList<>();
        for (MigrationInfo info : pending) {
            Map<String, Object> item = new HashMap<>();
            item.put("version", info.getVersion().toString());
            item.put("description", info.getDescription());
            item.put("script", info.getScript());
            pendingList.add(item);
        }
        
        return R.ok().setData(pendingList);
    }
}
