# Этап 1: Сборка приложения
FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --omit=dev --no-audit --no-fund

COPY . .

# Этап 2: Финальный образ с ffmpeg
FROM tigefa/ffmpeg

WORKDIR /app

# Копируем Node.js runtime и базовые библиотеки
COPY --from=node:20-bookworm-slim /usr/local/bin/node /usr/local/bin/node
COPY --from=node:20-bookworm-slim /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:20-bookworm-slim /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node:20-bookworm-slim /usr/local/bin/npx /usr/local/bin/npx

# Копируем необходимые библиотеки для Node.js
COPY --from=node:20-bookworm-slim /lib/x86_64-linux-gnu/libstdc++.so.6 /lib/x86_64-linux-gnu/
COPY --from=node:20-bookworm-slim /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/

# Создаем симлинки (на всякий случай)
RUN ln -s /usr/local/bin/node /usr/bin/node && \
    ln -s /usr/local/bin/npm /usr/bin/npm

# Копируем собранное приложение из builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app .

EXPOSE 3000
CMD ["node", "app.js"]
