# 1. 顺着原作者，使用官方 Node.js 镜像
FROM node:22-alpine

# 2. 设置工作目录
WORKDIR /app

# 3. 复制依赖并安装
COPY package*.json ./
RUN npm install

# 4. 复制源码
COPY danmu_api/ ./danmu_api/

# 5. 暴露端口
EXPOSE 7860

# 6. 核心启动脚本（已更新你的专属 Token）：
# 启动前把网页端配置的变量准确写入 config/.env，然后用 node 启动服务
CMD ["sh", "-c", "\
    mkdir -p config && \
    echo 'TOKEN='${TOKEN:-yjk69258244} > config/.env && \
    echo 'ADMIN_TOKEN='${ADMIN_TOKEN} >> config/.env; \
    node danmu_api/server.js --port 7860\
    "]
