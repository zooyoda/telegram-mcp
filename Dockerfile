# Используем Debian-based образ для совместимости с Telethon
FROM python:3.10-slim

# Устанавливаем Node.js и npm
RUN apt-get update && apt-get install -y nodejs npm

# Устанавливаем supergateway глобально
RUN npm install -g supergateway

# Рабочая директория
WORKDIR /app

# Копируем зависимости
COPY requirements.txt .

# Устанавливаем Python-зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем исходный код
COPY . .

# Создаем non-root пользователя
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Экспортируем порт для SSE
EXPOSE 8004

# Исправленная команда запуска (как в оригинале)
CMD ["npx", "supergateway", "--stdio", "python", "main.py", "--port", "8004"]

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8004/sse || exit 1

