FROM docker.io/oven/bun:1.3.13-slim AS build

ENV ASTRO_TELEMETRY_DISABLED=1

WORKDIR /app

COPY package.json bun.lock ./

RUN --mount=type=cache,target=/root/.bun/install/cache bun install --frozen-lockfile

COPY astro.config.mjs tsconfig.json ./
COPY src ./src

RUN bun run build

FROM docker.io/library/nginx:1.31.4-alpine

COPY --from=build /app/dist/client/ /usr/share/nginx/html/

EXPOSE 80
