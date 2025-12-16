#!/bin/bash

# ============================================
# UNIVERSIDADE SK - Script de Deploy
# Aplica customizações no Frappe LMS
# ============================================

set -e

echo "=========================================="
echo "  Universidade SK - Deploy de Customizações"
echo "=========================================="

# Diretório do bench
BENCH_DIR="/home/frappe/frappe-bench"
REPO_DIR="/tmp/sk-custom"

# Verificar se estamos no diretório correto
if [ ! -d "$BENCH_DIR/apps/lms" ]; then
    echo "ERRO: Diretório do LMS não encontrado em $BENCH_DIR/apps/lms"
    exit 1
fi

cd $BENCH_DIR

echo "[1/6] Fazendo backup dos arquivos originais..."
mkdir -p /tmp/sk-backup
cp apps/lms/frontend/src/index.css /tmp/sk-backup/ 2>/dev/null || true
cp apps/lms/frontend/tailwind.config.js /tmp/sk-backup/ 2>/dev/null || true

echo "[2/6] Copiando index.css customizado..."
cp $REPO_DIR/frontend/src/index.css apps/lms/frontend/src/index.css

echo "[3/6] Copiando theme.css..."
mkdir -p apps/lms/frontend/src/styles
cp $REPO_DIR/frontend/src/styles/theme.css apps/lms/frontend/src/styles/theme.css

echo "[4/6] Copiando tailwind.config.js..."
cp $REPO_DIR/frontend/tailwind.config.js apps/lms/frontend/tailwind.config.js

echo "[5/6] Copiando componentes Vue..."
mkdir -p apps/lms/frontend/src/components/Icons
cp $REPO_DIR/frontend/src/components/Icons/SKLogo.vue apps/lms/frontend/src/components/Icons/SKLogo.vue 2>/dev/null || true

# Copiar logo se existir
if [ -f "$REPO_DIR/frontend/public/images/sk-logo.png" ]; then
    echo "[5.5/6] Copiando logo..."
    mkdir -p apps/lms/frontend/public/images
    cp $REPO_DIR/frontend/public/images/sk-logo.png apps/lms/frontend/public/images/sk-logo.png
fi

echo "[6/6] Executando build do frontend..."
bench build --app lms

echo ""
echo "=========================================="
echo "  Deploy concluído com sucesso!"
echo "=========================================="

# Limpar cache
echo "Limpando cache..."
bench --site all clear-cache 2>/dev/null || true

echo ""
echo "As customizações foram aplicadas!"
echo "Acesse: https://capacita.skgrupo.com/lms"
