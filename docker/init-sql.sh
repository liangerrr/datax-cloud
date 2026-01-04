#!/bin/bash

# 初始化 SQL 文件脚本
# 将部署说明中的 SQL 文件复制到 MySQL 初始化目录

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SQL_SOURCE="$PROJECT_ROOT/部署说明"
SQL_TARGET="$SCRIPT_DIR/mysql/init"

echo "=========================================="
echo "初始化 SQL 文件"
echo "=========================================="

# 创建目标目录
mkdir -p "$SQL_TARGET"

# 复制 SQL 文件并添加序号前缀确保执行顺序
if [ -f "$SQL_SOURCE/data_cloud.sql" ]; then
    echo ">>> 复制 data_cloud.sql..."
    cp "$SQL_SOURCE/data_cloud.sql" "$SQL_TARGET/01-data_cloud.sql"
fi

if [ -f "$SQL_SOURCE/tables_mysql_innodb.sql" ]; then
    echo ">>> 复制 tables_mysql_innodb.sql (Quartz)..."
    # 添加 USE 语句
    echo "USE data_cloud_quartz;" > "$SQL_TARGET/02-quartz.sql"
    cat "$SQL_SOURCE/tables_mysql_innodb.sql" >> "$SQL_TARGET/02-quartz.sql"
fi

if [ -f "$SQL_SOURCE/foodmart2.sql" ]; then
    echo ">>> 复制 foodmart2.sql..."
    echo "USE foodmart2;" > "$SQL_TARGET/03-foodmart2.sql"
    cat "$SQL_SOURCE/foodmart2.sql" >> "$SQL_TARGET/03-foodmart2.sql"
fi

if [ -f "$SQL_SOURCE/robot.sql" ]; then
    echo ">>> 复制 robot.sql..."
    echo "USE robot;" > "$SQL_TARGET/04-robot.sql"
    cat "$SQL_SOURCE/robot.sql" >> "$SQL_TARGET/04-robot.sql"
fi

echo ""
echo ">>> SQL 文件初始化完成!"
echo ">>> 文件位置: $SQL_TARGET"
ls -la "$SQL_TARGET"
