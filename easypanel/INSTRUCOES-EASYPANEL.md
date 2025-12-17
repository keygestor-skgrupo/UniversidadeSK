# Universidade SK - Configuração EasyPanel

## O Problema
O EasyPanel está usando um **template Frappe** que roda seu próprio script `init.sh`,
ignorando completamente nossa imagem Docker customizada.

## A Solução
Criar um app usando **Docker Compose** diretamente, não um template.

---

## Passo a Passo

### 1. No EasyPanel, delete o app atual
- Acesse seu projeto no EasyPanel
- Delete o app "universidade-sk" existente (se houver)

### 2. Criar novo app como "Docker Compose"
- Clique em **"+ Create"** ou **"Add Service"**
- Selecione **"Docker Compose"** (NÃO selecione template Frappe!)
- Ou selecione **"Docker"** > **"Docker Image"**

### 3. Se usar Docker Compose:
Cole o conteúdo do arquivo `docker-compose.easypanel.yml`:

```yaml
version: "3.8"

services:
  universidade-sk:
    image: williamferreirati/universidade-sk:latest
    container_name: universidade-sk-app
    restart: unless-stopped
    depends_on:
      - mariadb
      - redis-cache
      - redis-queue
    environment:
      - SITE_NAME=capacita.skgrupo.com
      - DB_HOST=mariadb
      - DB_PORT=3306
      - DB_ROOT_PASSWORD=frappe_root_password
      - REDIS_CACHE=redis://redis-cache:6379
      - REDIS_QUEUE=redis://redis-queue:6379
      - REDIS_SOCKETIO=redis://redis-queue:6379
      - SOCKETIO_PORT=9000
    ports:
      - "8000:8000"
      - "9000:9000"
    volumes:
      - sites_data:/home/frappe/frappe-bench/sites
      - logs_data:/home/frappe/frappe-bench/logs

  mariadb:
    image: mariadb:10.6
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=frappe_root_password
      - MYSQL_CHARACTER_SET_SERVER=utf8mb4
      - MYSQL_COLLATION_SERVER=utf8mb4_unicode_ci
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
      - --skip-character-set-client-handshake
    volumes:
      - mariadb_data:/var/lib/mysql

  redis-cache:
    image: redis:alpine
    restart: unless-stopped

  redis-queue:
    image: redis:alpine
    restart: unless-stopped

volumes:
  sites_data:
  logs_data:
  mariadb_data:
```

### 4. Se usar Docker Image diretamente:
Configure assim:
- **Image**: `williamferreirati/universidade-sk:latest`
- **Ports**: 8000, 9000
- **Environment Variables**:
  ```
  SITE_NAME=capacita.skgrupo.com
  DB_HOST=<hostname-do-mariadb-no-easypanel>
  DB_PORT=3306
  DB_ROOT_PASSWORD=<sua-senha>
  REDIS_CACHE=redis://<hostname-redis>:6379
  REDIS_QUEUE=redis://<hostname-redis>:6379
  ```

### 5. Configurar Domínio
- Em "Domains", adicione: `capacita.skgrupo.com`
- Ative SSL/HTTPS
- Aponte o DNS do domínio para o IP do seu VPS

---

## Importante: Criar serviços separados se necessário

Se o EasyPanel não suportar Docker Compose multi-serviço, crie 3 apps separados:

### App 1: MariaDB
- **Image**: `mariadb:10.6`
- **Environment**:
  - `MYSQL_ROOT_PASSWORD=frappe_root_password`
- **Volume**: Persistente para `/var/lib/mysql`

### App 2: Redis
- **Image**: `redis:alpine`
- Não precisa de configuração especial

### App 3: Universidade SK (App Principal)
- **Image**: `williamferreirati/universidade-sk:latest`
- **Ports**: 8000, 9000
- **Environment**:
  - `SITE_NAME=capacita.skgrupo.com`
  - `DB_HOST=<nome-do-app-mariadb>.internal` (ou hostname interno do EasyPanel)
  - `DB_PORT=3306`
  - `DB_ROOT_PASSWORD=frappe_root_password`
  - `REDIS_CACHE=redis://<nome-do-app-redis>.internal:6379`
  - `REDIS_QUEUE=redis://<nome-do-app-redis>.internal:6379`
- **Depends on**: mariadb, redis

---

## Verificar se está funcionando

Após deploy, os logs devem mostrar:
```
===========================================
UNIVERSIDADE SK - Iniciando...
===========================================
Verificando MariaDB...
MariaDB está pronto!
Verificando Redis...
Redis está pronto!
...
```

E NÃO deve mostrar:
- `init.sh`
- `bench init`
- `Getting frappe`
- `Installing frappe`

Se ainda mostrar esses, o EasyPanel não está usando nossa imagem.

---

## Alternativa: Deploy Direto no VPS (sem EasyPanel)

Se o EasyPanel continuar problemático, você pode fazer deploy direto:

```bash
# No VPS, via SSH
git clone https://github.com/keygestor-skgrupo/UniversidadeSK.git /opt/universidade-sk
cd /opt/universidade-sk
docker compose up -d
```

Isso garante que vai usar nossa configuração, não a do EasyPanel.
