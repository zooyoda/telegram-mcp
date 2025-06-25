FROM python:3.10-slim

RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g supergateway

WORKDIR /app

COPY requirements.txt .

# Устанавливаем Python-зависимости (включая mcp[cli]>=1.9.4 из requirements.txt)
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Переустанавливаем MCP на последнюю версию, чтобы гарантировать актуальность
RUN pip install --no-cache-dir --upgrade "mcp[cli]>=1.9.4"

COPY . .

RUN ls -l /app
RUN pip show mcp && echo "MCP version: $(pip show mcp | grep Version)"
RUN pip freeze
RUN pip check

EXPOSE 8004

CMD ["python", "main.py"]

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8004/sse || exit 1
