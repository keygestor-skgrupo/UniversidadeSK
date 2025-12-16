#!/bin/bash
# ============================================
# UNIVERSIDADE SK - Script de Deploy no VPS
# ============================================

set -e

echo "============================================"
echo "UNIVERSIDADE SK - Deploy Script"
echo "============================================"

# Configurações
REPO_URL="https://github.com/keygestor-skgrupo/UniversidadeSK.git"
DEPLOY_DIR="/opt/universidade-sk"
SITE_NAME="capacita.skgrupo.com"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[1/6] Parando containers existentes...${NC}"
cd $DEPLOY_DIR 2>/dev/null && docker compose down 2>/dev/null || true
docker stop $(docker ps -q --filter "name=universidade-sk") 2>/dev/null || true
docker rm $(docker ps -aq --filter "name=universidade-sk") 2>/dev/null || true

echo -e "${YELLOW}[2/6] Limpando imagens antigas...${NC}"
docker rmi $(docker images -q --filter "reference=*universidade-sk*") 2>/dev/null || true

echo -e "${YELLOW}[3/6] Clonando/Atualizando repositório...${NC}"
if [ -d "$DEPLOY_DIR" ]; then
    cd $DEPLOY_DIR
    git fetch origin
    git reset --hard origin/main
else
    git clone $REPO_URL $DEPLOY_DIR
    cd $DEPLOY_DIR
fi

echo -e "${YELLOW}[4/6] Verificando arquivos customizados...${NC}"
echo "Checando index.html..."
head -5 frontend/index.html
echo ""

echo -e "${YELLOW}[5/6] Build da imagem Docker (sem cache)...${NC}"
docker compose build --no-cache

echo -e "${YELLOW}[6/6] Iniciando containers...${NC}"
docker compose up -d

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Deploy concluído!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Aguarde alguns minutos para inicialização completa."
echo "Verifique os logs com: docker compose logs -f"
echo ""
echo "Site: https://$SITE_NAME"
