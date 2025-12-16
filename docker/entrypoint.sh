#!/bin/bash
set -e

BENCH_DIR="/home/frappe/frappe-bench"

cd ${BENCH_DIR}

# Configurar Redis e MariaDB externos
if [ -n "$MARIADB_HOST" ]; then
    bench set-config -g db_host "$MARIADB_HOST"
fi

if [ -n "$REDIS_CACHE" ]; then
    bench set-config -g redis_cache "$REDIS_CACHE"
fi

if [ -n "$REDIS_QUEUE" ]; then
    bench set-config -g redis_queue "$REDIS_QUEUE"
fi

if [ -n "$REDIS_SOCKETIO" ]; then
    bench set-config -g redis_socketio "$REDIS_SOCKETIO"
fi

# Verificar se o site existe
SITE_NAME="${SITE_NAME:-universidade.localhost}"

if [ ! -d "sites/${SITE_NAME}" ]; then
    echo "=========================================="
    echo "Criando site ${SITE_NAME}..."
    echo "=========================================="

    bench new-site ${SITE_NAME} \
        --db-host ${MARIADB_HOST:-mariadb} \
        --db-port ${MARIADB_PORT:-3306} \
        --db-root-username ${MARIADB_ROOT_USER:-root} \
        --db-root-password ${MARIADB_ROOT_PASSWORD:-root} \
        --admin-password ${ADMIN_PASSWORD:-admin} \
        --no-mariadb-socket \
        --force

    bench --site ${SITE_NAME} install-app lms
    bench --site ${SITE_NAME} set-config developer_mode 1

    # Configurar idioma Português Brasil
    bench --site ${SITE_NAME} set-config language "pt-BR"
fi

bench use ${SITE_NAME}

# Aplicar migrações se necessário
bench --site ${SITE_NAME} migrate 2>/dev/null || true
bench --site ${SITE_NAME} clear-cache

echo "=========================================="
echo "Universidade SK LMS está pronto!"
echo "Site: ${SITE_NAME}"
echo "=========================================="

# Executar comando passado
exec "$@"
