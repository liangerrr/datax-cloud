-- 修复密码脚本
-- 用户密码统一改为: 123456
-- 客户端密码统一改为: 123456

USE `data_cloud`;

-- 更新所有用户密码为 123456 (BCrypt加密)
UPDATE sys_user SET password='$2a$05$szBgiEbSKRMtXIMVGYrWB.QvLoDQH1N2DA/Y5nexs.lN0ql3gYPaC';

-- 更新 oauth 客户端密码为 123456 (BCrypt加密)
UPDATE oauth_client_details SET client_secret='$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi' WHERE client_id='datax';

-- 完成
SELECT '密码修复完成！用户密码: 123456, 客户端密码: 123456' AS message;
