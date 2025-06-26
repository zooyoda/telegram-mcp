FROM python:3.10-slim

RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g supergateway

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Диагностика
RUN ls -la /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8

# Запуск напрямую (без supergateway)
CMD ["python", "main.py"]

# Критично: запуск через npx, чтобы supergateway был PID 1
#CMD ["npx", "-y", "supergateway", "--stdio", "python", "main.py", "--port", "8004"]

# Если потребуется, потом вернёшь запуск через supergateway
# CMD ["npx", "-y", "supergateway", "--stdio", "python", "main.py", "--port", "8004"]

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8004/sse || exit 1
