#!/bin/bash

# 日志查看脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

SERVICE=${1:-all}
LINES=${2:-100}

case "$SERVICE" in
    all)
        docker-compose -f docker/docker-compose.yml logs -f --tail=$LINES
        ;;
    infra)
        docker-compose -f docker/docker-compose.yml logs -f --tail=$LINES mysql redis rabbitmq
        ;;
    core)
        docker-compose -f docker/docker-compose.yml logs -f --tail=$LINES datax-eureka datax-config datax-gateway datax-auth
        ;;
    *)
        docker-compose -f docker/docker-compose.yml logs -f --tail=$LINES $SERVICE
        ;;
esac
