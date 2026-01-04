# DataX-Cloud Docker Makefile

.PHONY: help build start stop restart logs status clean init-sql

# 默认目标
help:
	@echo "DataX-Cloud Docker 命令:"
	@echo ""
	@echo "  make build        - 构建后端并生成 Docker 镜像"
	@echo "  make build-backend- 仅构建后端 Maven 项目"
	@echo "  make build-images - 仅构建 Docker 镜像"
	@echo "  make init-sql     - 初始化 SQL 文件"
	@echo "  make start        - 启动所有服务"
	@echo "  make start-infra  - 启动基础设施"
	@echo "  make start-core   - 启动核心服务"
	@echo "  make start-lite   - 启动精简版 (开发用)"
	@echo "  make stop         - 停止所有服务"
	@echo "  make restart      - 重启所有服务"
	@echo "  make status       - 查看服务状态"
	@echo "  make logs         - 查看所有日志"
	@echo "  make logs-core    - 查看核心服务日志"
	@echo "  make clean        - 停止并清理所有数据"
	@echo ""

# 构建
build:
	@./build.sh all

build-backend:
	@./build.sh backend

build-images:
	@./build.sh images

# 初始化 SQL
init-sql:
	@./init-sql.sh

# 启动
start:
	@./start.sh all

start-infra:
	@./start.sh infra

start-core:
	@./start.sh core

start-lite:
	@docker-compose -f docker-compose-lite.yml up -d

# 停止
stop:
	@./stop.sh all

# 重启
restart: stop start

# 状态
status:
	@docker-compose -f docker-compose.yml ps

# 日志
logs:
	@./logs.sh all

logs-core:
	@./logs.sh core

logs-infra:
	@./logs.sh infra

# 清理
clean:
	@./stop.sh clean
	@rm -rf jars/
	@echo "清理完成"
