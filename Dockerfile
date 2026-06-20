# 1. 基础镜像：直接使用原项目推荐的官方镜像
FROM logvar/danmu-api:latest

USER root

# 2. 暴露端口
EXPOSE 7860

# 3. 核心启动脚本：
# 直接在容器内的 /app/config/.env 写入你在网页端配置的变量
# 并且强制程序启动在 7860 端口
CMD ["sh", "-c", "\
    mkdir -p /app/config && \
    echo 'TOKEN='${TOKEN:-87654321} > /app/config/.env && \
    echo 'ADMIN_TOKEN='${ADMIN_TOKEN} >> /app/config/.env; \
    python main.py --port 7860\
    "]
