FROM python:3.10-slim

RUN apt-get update && apt-get install -y nodejs npm
RUN npm install -g supergateway

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8004

CMD sh -c "npx -y supergateway --stdio python main.py --port 8004"

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8004/sse || exit 1
