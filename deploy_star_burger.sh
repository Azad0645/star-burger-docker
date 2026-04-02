#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/opt/projects/star-burger-docker"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "==> Переход в папку проекта"
cd "$PROJECT_DIR"

if [ -f "$PROJECT_DIR/.env" ]; then
  log "==> Загрузка переменных окружения из .env"
  set -a
  . "$PROJECT_DIR/.env"
  set +a
fi

log "==> Обновление кода из git"
git pull

log "==> Сборка и запуск контейнеров"
docker compose up --build -d

log "==> Применение миграций"
docker compose run --rm backend python manage.py migrate

log "==> Сбор статики"
docker compose run --rm backend python manage.py collectstatic --noinput

log "Деплой завершён успешно"
