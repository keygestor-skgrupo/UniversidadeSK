# Universidade SK - Customizações LMS

Customizações do Frappe LMS para a plataforma Universidade SK.

## Cores da Marca

- **Vermelho SK**: `#E31837`
- **Azul Marinho SK**: `#1B365D`

## Estrutura do Projeto

```
UniversidadeSK/
├── frontend/
│   ├── src/
│   │   ├── index.css          # Estilos globais customizados
│   │   ├── styles/
│   │   │   └── theme.css      # Variáveis de tema
│   │   └── components/
│   │       └── Icons/
│   │           └── SKLogo.vue # Componente do logo
│   ├── public/
│   │   └── images/
│   │       └── sk-logo.png    # Logo PNG
│   └── tailwind.config.js     # Configuração Tailwind
├── scripts/
│   └── deploy.sh              # Script de deploy
└── README.md
```

## Deploy no EasyPanel

### Configuração Automática

1. Clone este repositório no servidor
2. Execute o script de deploy:

```bash
cd /home/frappe/frappe-bench
git clone https://github.com/SEU_USUARIO/UniversidadeSK.git /tmp/sk-custom
bash /tmp/sk-custom/scripts/deploy.sh
```

### Webhook de Deploy

Configure o webhook no EasyPanel para disparar automaticamente:
```
http://seu-servidor:3000/api/deploy/SEU_TOKEN
```

## Funcionalidades

- Tema claro/escuro com cores SK
- Animações suaves (fade, slide, scale)
- Botões vermelhos SK (substituindo preto)
- Cards com hover effect
- Scrollbar customizada
- Loading skeleton animado
- Efeito glassmorphism

## Idioma

Configure o idioma para Português Brasil nas configurações do Frappe:
1. Acesse: Setup > System Settings
2. Defina "Language" como "pt-BR"
