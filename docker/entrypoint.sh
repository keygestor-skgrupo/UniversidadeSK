#!/bin/bash
set -e

echo "==========================================="
echo "UNIVERSIDADE SK - Iniciando..."
echo "Imagem customizada com branding SK"
echo "==========================================="

BENCH_DIR="/home/frappe/frappe-bench"

cd ${BENCH_DIR}

# Funções de utilidade
wait_for_db() {
    echo "Verificando MariaDB em ${MARIADB_HOST:-mariadb}:${MARIADB_PORT:-3306}..."
    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if mysql -h "${MARIADB_HOST:-mariadb}" -P "${MARIADB_PORT:-3306}" -u root -p"${MARIADB_ROOT_PASSWORD:-123}" -e "SELECT 1" &>/dev/null; then
            echo "MariaDB esta pronto!"
            return 0
        fi
        echo "Aguardando MariaDB... tentativa $attempt/$max_attempts"
        sleep 5
        attempt=$((attempt + 1))
    done

    echo "ERRO: MariaDB nao respondeu apos $max_attempts tentativas"
    return 1
}

wait_for_redis() {
    local redis_url="${1:-redis://redis:6379}"
    local redis_host=$(echo $redis_url | sed 's|redis://||' | cut -d: -f1)
    local redis_port=$(echo $redis_url | sed 's|redis://||' | cut -d: -f2)
    redis_port=${redis_port:-6379}

    echo "Verificando Redis em ${redis_host}:${redis_port}..."
    local max_attempts=20
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if redis-cli -h "$redis_host" -p "$redis_port" ping &>/dev/null; then
            echo "Redis esta pronto!"
            return 0
        fi
        echo "Aguardando Redis... tentativa $attempt/$max_attempts"
        sleep 3
        attempt=$((attempt + 1))
    done

    echo "AVISO: Redis nao respondeu, continuando mesmo assim..."
    return 0
}

# Aguardar servicos
echo ""
echo "--- Verificando dependencias ---"
wait_for_db
wait_for_redis "${REDIS_CACHE:-redis://redis:6379}"

# Configurar Redis e MariaDB externos
echo ""
echo "--- Configurando conexoes ---"

if [ -n "$MARIADB_HOST" ]; then
    echo "Configurando MARIADB_HOST: $MARIADB_HOST"
    bench set-config -g db_host "$MARIADB_HOST"
fi

if [ -n "$REDIS_CACHE" ]; then
    echo "Configurando REDIS_CACHE: $REDIS_CACHE"
    bench set-config -g redis_cache "$REDIS_CACHE"
fi

if [ -n "$REDIS_QUEUE" ]; then
    echo "Configurando REDIS_QUEUE: $REDIS_QUEUE"
    bench set-config -g redis_queue "$REDIS_QUEUE"
fi

if [ -n "$REDIS_SOCKETIO" ]; then
    echo "Configurando REDIS_SOCKETIO: $REDIS_SOCKETIO"
    bench set-config -g redis_socketio "$REDIS_SOCKETIO"
fi

# Verificar se o site existe
SITE_NAME="${SITE_NAME:-capacita.skgrupo.com}"

echo ""
echo "--- Verificando site: ${SITE_NAME} ---"

if [ ! -d "sites/${SITE_NAME}" ]; then
    echo "==========================================="
    echo "Criando novo site: ${SITE_NAME}"
    echo "==========================================="

    bench new-site ${SITE_NAME} \
        --db-host ${MARIADB_HOST:-mariadb} \
        --db-port ${MARIADB_PORT:-3306} \
        --db-root-username ${MARIADB_ROOT_USER:-root} \
        --db-root-password ${MARIADB_ROOT_PASSWORD:-123} \
        --admin-password ${ADMIN_PASSWORD:-admin} \
        --no-mariadb-socket \
        --force

    echo "Instalando app LMS..."
    bench --site ${SITE_NAME} install-app lms

    echo "Configurando site..."
    bench --site ${SITE_NAME} set-config developer_mode 0
    bench --site ${SITE_NAME} set-config language "pt-BR"

    echo "Site criado com sucesso!"
else
    echo "Site ${SITE_NAME} ja existe"
fi

bench use ${SITE_NAME}

# Aplicar migracoes se necessario
echo ""
echo "--- Aplicando migracoes ---"
bench --site ${SITE_NAME} migrate 2>/dev/null || echo "Migracoes aplicadas ou nenhuma pendente"
bench --site ${SITE_NAME} clear-cache

echo ""
echo "==========================================="
echo "UNIVERSIDADE SK LMS"
echo "==========================================="
echo "Site: ${SITE_NAME}"
echo "Admin: Administrator / ${ADMIN_PASSWORD:-admin}"
echo "Porta Web: 8000"
echo "Porta SocketIO: 9000"
echo "==========================================="
echo ""

# Executar comando passado
exec "$@"
