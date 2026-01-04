#!/bin/bash

# DataX-Cloud Docker 停止脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "DataX-Cloud Docker 停止脚本"
echo "=========================================="

cd "$PROJECT_ROOT"

case "${1:-all}" in
    all)
        echo ">>> 停止所有服务..."
        docker-compose -f docker/docker-compose.yml down
        ;;
    clean)
        echo ">>> 停止所有服务并清理数据卷..."
        docker-compose -f docker/docker-compose.yml down -v
        ;;
    *)
        echo "使用方法: ./stop.sh [all|clean]"
        echo "  all   - 停止所有服务 (保留数据)"
        echo "  clean - 停止所有服务并清理数据卷"
        ;;
esac

echo ""
echo ">>> 完成!"
