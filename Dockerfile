# 1. 基础镜像：直接使用原项目推荐的官方镜像
FROM logvar/danmu-api:latest

# 2. 切换到 root 用户以获得配置目录和软链接的最高权限
USER root

# 3. 创建 Hugging Face 专用的持久化存储挂载目录（/data）
# 确保容器有读写权限（Hugging Face 容器默认以 uid 1000 运行）
RUN mkdir -p /data/config /data/.cache \
    && chown -R 1000:1000 /data

# 4. 暴露 Hugging Face 默认的 7860 端口
EXPOSE 7860

# 5. 核心启动脚本（完全等价替代你的 docker-compose 挂载逻辑）：
# - 首次启动时：如果持久化目录中没有 .env，则自动创建一个并写入你在网页端配置的 TOKEN 和 ADMIN_TOKEN
# - 动态软链接：将项目的 /app/config 和 /app/.cache 链接到持久化分区 /data 下
# - 端口自适应：强制指定程序启动在 7860 端口
CMD ["sh", "-c", "\
    if [ ! -f /data/config/.env ]; then \
        echo 'TOKEN='${TOKEN:-87654321} > /data/config/.env && \
        echo 'ADMIN_TOKEN='${ADMIN_TOKEN} >> /data/config/.env; \
    fi; \
    rm -rf /app/config && ln -s /data/config /app/config; \
    rm -rf /app/.cache && ln -s /data/.cache /app/.cache; \
    python main.py --port 7860\
    "]
