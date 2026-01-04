# DataX-Cloud Docker 部署指南

## 环境要求

- Docker 20.0+
- Docker Compose 2.0+
- JDK 1.8
- Maven 3.6+
- 内存建议 8GB+

## 快速部署

### 1. 构建项目

```bash
# 在项目根目录执行
mvn clean package -DskipTests -s settings.xml
```

### 2. 启动服务

```bash
cd docker
docker-compose up -d
```

### 3. 等待服务启动

首次启动需要等待 3-5 分钟，可通过以下方式查看状态：

```bash
# 查看容器状态
docker ps

# 查看 Eureka 注册中心
# 浏览器访问: http://localhost:8610
```

### 4. 访问系统

- 前端地址: http://localhost
- 默认账号: admin
- 默认密码: 123456

## 服务端口说明

| 服务 | 端口 | 说明 |
|------|------|------|
| datax-ui | 80 | 前端界面 |
| datax-eureka | 8610 | 注册中心 |
| datax-config | 8611 | 配置中心 |
| datax-gateway | 8612 | 网关服务 |
| datax-auth | 8613 | 认证服务 |
| datax-system | 8810 | 系统服务 |
| datax-quartz | 8813 | 定时任务 |
| datax-workflow | 8814 | 工作流 |
| datax-metadata | 8820 | 元数据服务 |
| datax-metadata-console | 8821 | SQL工作台 |
| datax-market | 8822 | 数据集市 |
| datax-market-mapping | 8823 | API映射 |
| datax-market-integration | 8824 | 服务集成 |
| datax-standard | 8825 | 数据标准 |
| datax-quality | 8826 | 数据质量 |
| datax-visual | 8827 | 可视化 |
| datax-masterdata | 8828 | 主数据 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |
| RabbitMQ | 5672/15672 | 消息队列 |

## 常用命令

```bash
# 启动所有服务
docker-compose up -d

# 停止所有服务
docker-compose down

# 查看日志
docker logs -f 容器名

# 重启单个服务
docker restart 容器名

# 重新构建并启动
docker-compose up -d --build
```

## 中间件默认配置

| 中间件 | 用户名 | 密码 |
|--------|--------|------|
| MySQL | root | 1234@abcd |
| Redis | - | 1234@abcd |
| RabbitMQ | admin | 1234@abcd |

## 常见问题

### 1. 端口被占用

```bash
# 查看端口占用
lsof -i:端口号

# 停止占用进程或修改 docker-compose.yml 中的端口映射
```

### 2. 服务启动失败

```bash
# 查看服务日志
docker logs 容器名

# 检查 Eureka 注册情况
# 访问 http://localhost:8610
```

### 3. 数据库连接失败

确保 MySQL 容器健康后再启动业务服务：
```bash
docker ps | grep datax-mysql
# 状态应显示 (healthy)
```

### 4. 重新初始化数据库

```bash
# 停止服务
docker-compose down

# 清理数据目录
rm -rf mysql/data/*

# 重新启动
docker-compose up -d
```

## 目录结构

```
docker/
├── docker-compose.yml      # 编排文件
├── Dockerfile-eureka       # Eureka 镜像
├── Dockerfile-config       # Config 镜像
├── Dockerfile-gateway      # Gateway 镜像
├── Dockerfile-auth         # Auth 镜像
├── Dockerfile-service      # 业务服务通用镜像
├── Dockerfile-ui           # 前端镜像
├── mysql/
│   ├── conf/my.cnf         # MySQL 配置
│   ├── init/               # 初始化 SQL 脚本
│   └── data/               # 数据目录(自动生成)
├── redis/
│   └── data/               # 数据目录(自动生成)
└── rabbitmq/
    └── data/               # 数据目录(自动生成)
```
