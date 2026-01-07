-- 数据应用模块表结构
-- 版本：V1.1.0
-- 描述：新增数据应用相关表（分析报告归档、共享目录、共享申请审批）

-- 1. 分析报告归档表
CREATE TABLE IF NOT EXISTS `dap_analysis_report` (
    `id` VARCHAR(64) NOT NULL COMMENT '主键ID',
    `report_title` VARCHAR(200) NOT NULL COMMENT '报告标题',
    `report_type` VARCHAR(50) DEFAULT NULL COMMENT '报告类型：daily/weekly/monthly/special',
    `report_summary` VARCHAR(1000) DEFAULT NULL COMMENT '报告摘要',
    `report_file_url` VARCHAR(500) DEFAULT NULL COMMENT '报告文件路径',
    `author_id` VARCHAR(64) DEFAULT NULL COMMENT '作者ID',
    `author_name` VARCHAR(100) DEFAULT NULL COMMENT '作者姓名',
    `author_dept` VARCHAR(100) DEFAULT NULL COMMENT '作者部门',
    `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签',
    `view_count` INT DEFAULT 0 COMMENT '查看次数',
    `status` CHAR(1) DEFAULT '1' COMMENT '状态：1正常 0删除',
    `create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT NULL COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    KEY `idx_report_type` (`report_type`),
    KEY `idx_author_id` (`author_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分析报告归档表';

-- 2. 共享数据目录表
CREATE TABLE IF NOT EXISTS `dap_share_catalog` (
    `id` VARCHAR(64) NOT NULL COMMENT '主键ID',
    `asset_id` VARCHAR(64) DEFAULT NULL COMMENT '关联元数据表ID',
    `asset_name` VARCHAR(200) NOT NULL COMMENT '资产名称',
    `asset_desc` VARCHAR(1000) DEFAULT NULL COMMENT '资产描述',
    `owner_dept_id` VARCHAR(64) DEFAULT NULL COMMENT '责任部门ID',
    `owner_dept_name` VARCHAR(100) DEFAULT NULL COMMENT '责任部门名称',
    `owner_id` VARCHAR(64) DEFAULT NULL COMMENT '数据责任人ID',
    `owner_name` VARCHAR(100) DEFAULT NULL COMMENT '数据责任人姓名',
    `share_status` CHAR(1) DEFAULT '1' COMMENT '共享状态：1可共享 0不可共享',
    `status` CHAR(1) DEFAULT '1' COMMENT '状态：1正常 0删除',
    `create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT NULL COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    KEY `idx_asset_id` (`asset_id`),
    KEY `idx_owner_dept_id` (`owner_dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='共享数据目录表';

-- 3. 共享申请表
CREATE TABLE IF NOT EXISTS `dap_share_apply` (
    `id` VARCHAR(64) NOT NULL COMMENT '主键ID',
    `apply_no` VARCHAR(50) DEFAULT NULL COMMENT '申请编号',
    `catalog_id` VARCHAR(64) NOT NULL COMMENT '共享目录ID',
    `asset_name` VARCHAR(200) DEFAULT NULL COMMENT '资产名称',
    `apply_reason` VARCHAR(500) DEFAULT NULL COMMENT '申请理由',
    `use_scenario` VARCHAR(500) DEFAULT NULL COMMENT '使用场景',
    `use_period_end` DATE DEFAULT NULL COMMENT '使用期限',
    `applicant_id` VARCHAR(64) DEFAULT NULL COMMENT '申请人ID',
    `applicant_name` VARCHAR(100) DEFAULT NULL COMMENT '申请人姓名',
    `applicant_dept_id` VARCHAR(64) DEFAULT NULL COMMENT '申请部门ID',
    `applicant_dept_name` VARCHAR(100) DEFAULT NULL COMMENT '申请部门名称',
    `status` VARCHAR(20) DEFAULT 'pending' COMMENT '状态：pending待审批/approved已通过/rejected已拒绝',
    `create_by` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT NULL COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    KEY `idx_catalog_id` (`catalog_id`),
    KEY `idx_applicant_id` (`applicant_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='共享申请表';

-- 4. 共享审批记录表
CREATE TABLE IF NOT EXISTS `dap_share_approve` (
    `id` VARCHAR(64) NOT NULL COMMENT '主键ID',
    `apply_id` VARCHAR(64) NOT NULL COMMENT '申请ID',
    `approver_id` VARCHAR(64) DEFAULT NULL COMMENT '审批人ID',
    `approver_name` VARCHAR(100) DEFAULT NULL COMMENT '审批人姓名',
    `approve_result` VARCHAR(20) DEFAULT NULL COMMENT '审批结果：approved/rejected',
    `approve_opinion` VARCHAR(500) DEFAULT NULL COMMENT '审批意见',
    `approve_time` DATETIME DEFAULT NULL COMMENT '审批时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_apply_id` (`apply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='共享审批记录表';

-- 5. 共享授权记录表
CREATE TABLE IF NOT EXISTS `dap_share_auth` (
    `id` VARCHAR(64) NOT NULL COMMENT '主键ID',
    `apply_id` VARCHAR(64) DEFAULT NULL COMMENT '申请ID',
    `catalog_id` VARCHAR(64) DEFAULT NULL COMMENT '共享目录ID',
    `grantee_id` VARCHAR(64) DEFAULT NULL COMMENT '被授权人ID',
    `grantee_name` VARCHAR(100) DEFAULT NULL COMMENT '被授权人姓名',
    `grantee_dept_id` VARCHAR(64) DEFAULT NULL COMMENT '被授权部门ID',
    `grantee_dept_name` VARCHAR(100) DEFAULT NULL COMMENT '被授权部门名称',
    `valid_start` DATE DEFAULT NULL COMMENT '有效期开始',
    `valid_end` DATE DEFAULT NULL COMMENT '有效期结束',
    `status` CHAR(1) DEFAULT '1' COMMENT '状态：1有效 0已撤销',
    `revoke_reason` VARCHAR(500) DEFAULT NULL COMMENT '撤销原因',
    `revoke_time` DATETIME DEFAULT NULL COMMENT '撤销时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_apply_id` (`apply_id`),
    KEY `idx_catalog_id` (`catalog_id`),
    KEY `idx_grantee_id` (`grantee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='共享授权记录表';

-- 6. API调用统计日表
CREATE TABLE IF NOT EXISTS `market_api_stats_daily` (
    `id` VARCHAR(64) NOT NULL COMMENT '主键ID',
    `api_id` VARCHAR(64) NOT NULL COMMENT '服务ID',
    `stats_date` DATE NOT NULL COMMENT '统计日期',
    `call_count` INT DEFAULT 0 COMMENT '调用次数',
    `success_count` INT DEFAULT 0 COMMENT '成功次数',
    `fail_count` INT DEFAULT 0 COMMENT '失败次数',
    `avg_response_time` INT DEFAULT NULL COMMENT '平均响应时间(ms)',
    `max_response_time` INT DEFAULT NULL COMMENT '最大响应时间(ms)',
    `min_response_time` INT DEFAULT NULL COMMENT '最小响应时间(ms)',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_api_date` (`api_id`, `stats_date`),
    KEY `idx_stats_date` (`stats_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='API调用统计日表';

-- 7. 扩展 market_api 表，增加服务状态字段
ALTER TABLE `market_api` 
    ADD COLUMN IF NOT EXISTS `service_status` VARCHAR(20) DEFAULT 'draft' COMMENT '服务状态：draft草稿/published已发布/offline已下线',
    ADD COLUMN IF NOT EXISTS `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',
    ADD COLUMN IF NOT EXISTS `offline_time` DATETIME DEFAULT NULL COMMENT '下线时间',
    ADD COLUMN IF NOT EXISTS `offline_reason` VARCHAR(500) DEFAULT NULL COMMENT '下线原因';
