# DataX-Cloud Docker 部署指南

## 环境要求

- Docker 20.0+
- Docker Compose 2.0+
- JDK 1.8
- Maven 3.6+
- IntelliJ IDEA（推荐）
- 内存建议 8GB+

## 安装 Docker

### Windows 系统

1. 下载 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. 双击安装包，按提示完成安装
3. 安装完成后重启电脑
4. 启动 Docker Desktop，等待右下角图标变为绿色
5. 打开 PowerShell 或 CMD，验证安装：
   ```powershell
   docker --version
   docker-compose --version
   ```

> **注意**: Windows 需要开启 WSL2 或 Hyper-V，安装程序会自动提示

### macOS 系统

1. 下载 [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
2. 双击 `.dmg` 文件，将 Docker 拖入 Applications
3. 启动 Docker，等待顶部状态栏图标显示运行中
4. 打开终端验证：
   ```bash
   docker --version
   docker-compose --version
   ```

### Linux 系统 (Ubuntu/Debian)

```bash
# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 添加当前用户到 docker 组（免 sudo）
sudo usermod -aG docker $USER

# 重新登录后验证
docker --version
docker-compose --version
```

## 前期准备工作

### 1. 克隆项目

**Windows (PowerShell/CMD):**
```powershell
git clone <项目地址>
cd datax-cloud
```

**macOS/Linux:**
```bash
git clone <项目地址>
cd datax-cloud
```

### 2. IDEA 打开项目

1. 打开 IntelliJ IDEA
2. 选择 `File` → `Open`
3. 选择 `datax-cloud` 项目根目录，点击 `OK`
4. 等待 IDEA 索引完成

### 3. 配置 JDK

1. 打开 `File` → `Project Structure` (快捷键: `Cmd+;` 或 `Ctrl+Alt+Shift+S`)
2. 选择 `Project` 选项卡
3. `SDK` 选择 JDK 1.8（如果没有，点击 `Add SDK` → `Download JDK` 下载）
4. `Language level` 选择 `8`
5. 点击 `Apply` → `OK`

### 4. 配置 Maven

1. 打开 `File` → `Settings` (Mac: `IntelliJ IDEA` → `Preferences`)
2. 搜索 `Maven`，选择 `Build, Execution, Deployment` → `Build Tools` → `Maven`
3. 配置以下选项：
   - `Maven home path`: 选择本地 Maven 安装目录（如 `/usr/local/apache-maven-3.6.3`）
   - `User settings file`: 勾选 `Override`，选择项目根目录下的 `settings.xml`
   - `Local repository`: 可选，指定本地仓库路径
4. 点击 `Apply` → `OK`

### 5. 刷新 Maven 依赖

1. 打开右侧 `Maven` 工具窗口
2. 点击刷新按钮 `Reload All Maven Projects`
3. 等待依赖下载完成（首次可能需要较长时间）

### 6. 安装 Lombok 插件（如未安装）

1. 打开 `File` → `Settings` → `Plugins`
2. 搜索 `Lombok`
3. 点击 `Install` 安装
4. 重启 IDEA

## 快速部署

### 1. 构建项目

**Windows (PowerShell/CMD):**
```powershell
mvn clean package -DskipTests -s settings.xml
```

**macOS/Linux:**
```bash
mvn clean package -DskipTests -s settings.xml
```

或在 IDEA 中：
1. 打开右侧 `Maven` 工具窗口
2. 展开 `datax-cloud` → `Lifecycle`
3. 按住 `Ctrl` 选择 `clean` 和 `package`
4. 右键选择 `Run Maven Build`
5. 在弹出的配置中添加参数: `-DskipTests -s settings.xml`

### 2. 启动服务

**Windows (PowerShell/CMD):**
```powershell
cd docker
docker-compose up -d
```

**macOS/Linux:**
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

**Windows (PowerShell/CMD):**
```powershell
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

**macOS/Linux:**
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

**Windows (PowerShell):**
```powershell
# 停止服务
docker-compose down

# 清理数据目录
Remove-Item -Recurse -Force mysql\data\*

# 重新启动
docker-compose up -d
```

**macOS/Linux:**
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
