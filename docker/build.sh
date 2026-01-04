#!/bin/bash

# DataX-Cloud Docker 构建脚本
# 使用方法: ./build.sh [all|backend|frontend|infra]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "DataX-Cloud Docker 构建脚本"
echo "=========================================="

# 创建jars目录
mkdir -p "$SCRIPT_DIR/jars"

# 构建后端
build_backend() {
    echo ""
    echo ">>> 构建后端 Maven 项目..."
    cd "$PROJECT_ROOT"
    
    # 设置 JAVA_HOME 为 JDK 8 (如果存在)
    if [ -d "/Users/lc/Library/Java/JavaVirtualMachines/corretto-1.8.0_462/Contents/Home" ]; then
        export JAVA_HOME="/Users/lc/Library/Java/JavaVirtualMachines/corretto-1.8.0_462/Contents/Home"
        export PATH="$JAVA_HOME/bin:$PATH"
        echo ">>> 使用 JDK 8: $JAVA_HOME"
    fi
    
    # 使用项目根目录的 settings.xml
    mvn clean package -DskipTests -q -s "$PROJECT_ROOT/settings.xml"
    
    echo ">>> 复制 JAR 文件到 docker/jars 目录..."
    
    # 基础服务
    cp datax-eureka/target/datax-eureka.jar "$SCRIPT_DIR/jars/"
    cp datax-config/target/datax-config.jar "$SCRIPT_DIR/jars/"
    cp datax-gateway/target/datax-gateway.jar "$SCRIPT_DIR/jars/"
    cp datax-auth/target/datax-auth.jar "$SCRIPT_DIR/jars/"
    
    # 业务服务
    cp datax-modules/system-service-parent/system-service/target/system-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/quartz-service-parent/quartz-service/target/quartz-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/workflow-service-parent/workflow-service/target/workflow-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/file-service-parent/file-service/target/file-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/email-service-parent/email-service/target/email-service.jar "$SCRIPT_DIR/jars/"
    
    # 数据治理服务
    cp datax-modules/data-metadata-service-parent/data-metadata-service/target/data-metadata-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-metadata-service-parent/data-metadata-service-console/target/data-metadata-service-console.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-market-service-parent/data-market-service/target/data-market-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-market-service-parent/data-market-service-mapping/target/data-market-service-mapping.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-market-service-parent/data-market-service-integration/target/data-market-service-integration.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-standard-service-parent/data-standard-service/target/data-standard-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-quality-service-parent/data-quality-service/target/data-quality-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-visual-service-parent/data-visual-service/target/data-visual-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/data-masterdata-service-parent/data-masterdata-service/target/data-masterdata-service.jar "$SCRIPT_DIR/jars/"
    cp datax-modules/codegen-service-parent/codegen-service/target/codegen-service.jar "$SCRIPT_DIR/jars/"
    
    echo ">>> 后端构建完成!"
}

# 构建Docker镜像
build_images() {
    echo ""
    echo ">>> 构建 Docker 镜像..."
    cd "$PROJECT_ROOT"
    
    docker-compose -f docker/docker-compose.yml build
    
    echo ">>> Docker 镜像构建完成!"
}

# 启动基础设施
start_infra() {
    echo ""
    echo ">>> 启动基础设施 (MySQL, Redis, RabbitMQ)..."
    cd "$PROJECT_ROOT"
    
    docker-compose -f docker/docker-compose.yml up -d mysql redis rabbitmq
    
    echo ">>> 等待基础设施启动..."
    sleep 30
    
    echo ">>> 基础设施启动完成!"
}

# 显示帮助
show_help() {
    echo ""
    echo "使用方法: ./build.sh [命令]"
    echo ""
    echo "命令:"
    echo "  all       - 构建所有 (后端 + Docker镜像)"
    echo "  backend   - 仅构建后端 Maven 项目"
    echo "  images    - 仅构建 Docker 镜像"
    echo "  infra     - 启动基础设施"
    echo "  help      - 显示帮助"
    echo ""
}

# 主逻辑
case "${1:-all}" in
    all)
        build_backend
        build_images
        ;;
    backend)
        build_backend
        ;;
    images)
        build_images
        ;;
    infra)
        start_infra
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
echo "构建完成!"
echo "=========================================="
