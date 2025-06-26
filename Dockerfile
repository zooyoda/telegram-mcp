FROM python:3.10-slim

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    nodejs \
    npm \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Установка supergateway
RUN npm install -g supergateway

# Рабочая директория
WORKDIR /app

# Копирование и установка Python-зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade "mcp[cli]>=1.9.4"

# Копирование исходного кода
COPY . .

# Диагностика
RUN echo "Содержимое рабочей директории:" && ls -la && \
    echo "Версия MCP:" && pip show mcp | grep Version

# Настройка переменных окружения
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8

# Запуск через npx для гарантированной работы stdio
CMD ["npx", "-y", "supergateway", "--stdio", "python", "main.py", "--port", "8004"]

# HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8004/sse || exit 1
