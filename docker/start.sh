#!/bin/bash

# DataX-Cloud Docker 启动脚本
# 使用方法: ./start.sh [all|infra|core|services|ui]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "DataX-Cloud Docker 启动脚本"
echo "=========================================="

cd "$PROJECT_ROOT"

# 启动基础设施
start_infra() {
    echo ""
    echo ">>> 启动基础设施..."
    docker-compose -f docker/docker-compose.yml up -d mysql redis rabbitmq
    echo ">>> 等待基础设施就绪 (30秒)..."
    sleep 30
}

# 启动核心服务
start_core() {
    echo ""
    echo ">>> 启动核心服务 (Eureka, Config, Gateway, Auth)..."
    docker-compose -f docker/docker-compose.yml up -d datax-eureka
    echo ">>> 等待 Eureka 启动 (30秒)..."
    sleep 30
    
    docker-compose -f docker/docker-compose.yml up -d datax-config
    echo ">>> 等待 Config 启动 (20秒)..."
    sleep 20
    
    docker-compose -f docker/docker-compose.yml up -d datax-gateway datax-auth
    echo ">>> 等待 Gateway 和 Auth 启动 (20秒)..."
    sleep 20
}

# 启动业务服务
start_services() {
    echo ""
    echo ">>> 启动业务服务..."
    docker-compose -f docker/docker-compose.yml up -d \
        datax-system \
        datax-quartz \
        datax-workflow \
        datax-metadata \
        datax-metadata-console \
        datax-market \
        datax-market-mapping \
        datax-market-integration \
        datax-standard \
        datax-quality \
        datax-visual \
        datax-masterdata
    echo ">>> 业务服务启动中..."
}

# 启动前端
start_ui() {
    echo ""
    echo ">>> 启动前端..."
    docker-compose -f docker/docker-compose.yml up -d datax-ui
}

# 启动全部
start_all() {
    start_infra
    start_core
    start_services
    start_ui
}

# 显示状态
show_status() {
    echo ""
    echo ">>> 服务状态:"
    docker-compose -f docker/docker-compose.yml ps
}

# 显示帮助
show_help() {
    echo ""
    echo "使用方法: ./start.sh [命令]"
    echo ""
    echo "命令:"
    echo "  all       - 启动所有服务 (默认)"
    echo "  infra     - 仅启动基础设施 (MySQL, Redis, RabbitMQ)"
    echo "  core      - 启动核心服务 (Eureka, Config, Gateway, Auth)"
    echo "  services  - 启动业务服务"
    echo "  ui        - 启动前端"
    echo "  status    - 查看服务状态"
    echo "  help      - 显示帮助"
    echo ""
}

# 主逻辑
case "${1:-all}" in
    all)
        start_all
        show_status
        ;;
    infra)
        start_infra
        ;;
    core)
        start_core
        ;;
    services)
        start_services
        ;;
    ui)
        start_ui
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        show_help
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "启动完成!"
echo ""
echo "访问地址:"
echo "  前端: http://localhost"
echo "  Eureka: http://localhost:8610"
echo "  Gateway: http://localhost:8612"
echo "  RabbitMQ: http://localhost:15672"
echo "=========================================="
