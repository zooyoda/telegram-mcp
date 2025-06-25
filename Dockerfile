FROM python:3.10-slim

RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g supergateway

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN ls -l /app

#RUN useradd -m appuser && chown -R appuser:appuser /app
#USER appuser

RUN pip install --upgrade "mcp[cli]"

RUN pip show mcp && echo "MCP version: $(pip show mcp | grep Version)"

EXPOSE 8004

# Для отладки сначала запусти просто Python:
CMD ["python", "main.py"]

# После успешной отладки верни запуск supergateway:
#CMD ["supergateway", "--stdio", "python", "main.py", "--port", "8004"]

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8004/sse || exit 1
