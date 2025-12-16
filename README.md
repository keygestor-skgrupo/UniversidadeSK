# Universidade SK - Frappe LMS Customizado

Plataforma de aprendizado da Universidade SK baseada no Frappe LMS com customizações visuais.

## Cores da Marca

- **Vermelho SK**: `#E31837`
- **Azul Marinho SK**: `#1B365D`

## Deploy no EasyPanel

### Passo 1: Configurar Fonte Git

1. No EasyPanel, acesse o serviço `frappe-lms`
2. Vá em **Fonte** > **Git**
3. Configure:
   - **URL do Repositório**: `https://github.com/keygestor-skgrupo/UniversidadeSK.git`
   - **Ramo**: `main`
   - **Caminho de Build**: `/`
4. Clique em **Salvar**

### Passo 2: Configurar Variáveis de Ambiente

Em **Ambiente**, adicione:

```
SITE_NAME=capacita.skgrupo.com
ADMIN_PASSWORD=sua_senha_segura
MARIADB_ROOT_PASSWORD=senha_do_banco
MARIADB_HOST=frappe-lms-mariadb
REDIS_CACHE=redis://frappe-lms-redis:6379/0
REDIS_QUEUE=redis://frappe-lms-redis:6379/1
REDIS_SOCKETIO=redis://frappe-lms-redis:6379/2
```

### Passo 3: Deploy

Clique em **Implantar** e aguarde o build.

## Estrutura do Projeto

```
UniversidadeSK/
├── Dockerfile                 # Build da imagem
├── docker-compose.yml         # Orquestração local
├── docker/
│   └── entrypoint.sh          # Script de inicialização
├── frontend/
│   ├── src/
│   │   ├── index.css          # Estilos globais SK
│   │   ├── styles/
│   │   │   └── theme.css      # Sistema de temas
│   │   └── components/
│   │       └── Icons/
│   │           └── SKLogo.vue # Componente logo
│   ├── public/
│   │   └── images/
│   │       └── sk-logo.png    # Logo PNG
│   └── tailwind.config.js     # Cores Tailwind
├── scripts/
│   ├── deploy.sh              # Deploy manual
│   └── apply-styles.sh        # Aplicar estilos
└── README.md
```

## Funcionalidades

- Tema claro/escuro com cores SK
- Botões vermelhos SK (substituindo preto padrão)
- Animações suaves (fade, slide, scale)
- Cards com efeito hover
- Scrollbar customizada
- Loading skeleton animado
- Efeito glassmorphism
- Suporte a Português Brasil

## Desenvolvimento Local

```bash
# Clonar repositório
git clone https://github.com/keygestor-skgrupo/UniversidadeSK.git
cd UniversidadeSK

# Copiar variáveis de ambiente
cp .env.example .env

# Subir containers
docker-compose up -d

# Acessar
# http://localhost:8000
```

## Atualizações

Para atualizar as customizações:

1. Faça as alterações nos arquivos
2. Commit e push para o GitHub
3. No EasyPanel, clique em **Implantar** novamente

O EasyPanel vai rebuildar a imagem com as novas customizações.

## Credenciais Padrão

- **URL**: https://capacita.skgrupo.com
- **Usuário**: Administrator
- **Senha**: (definida em ADMIN_PASSWORD)

## Suporte

Para dúvidas ou problemas, abra uma issue no repositório.
