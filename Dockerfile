# ============================================
# UNIVERSIDADE SK - Frappe LMS Customizado
# ============================================
FROM frappe/bench:latest

# Argumentos de build
ARG FRAPPE_BRANCH=version-15
ARG LMS_BRANCH=develop
ARG PYTHON_VERSION=3.11
ARG NODE_VERSION=18

# Variáveis de ambiente
ENV FRAPPE_BRANCH=${FRAPPE_BRANCH}
ENV LMS_BRANCH=${LMS_BRANCH}
ENV BENCH_DIR=/home/frappe/frappe-bench

USER frappe
WORKDIR /home/frappe

# Inicializar bench
RUN bench init ${BENCH_DIR} \
    --frappe-branch ${FRAPPE_BRANCH} \
    --python python${PYTHON_VERSION} \
    --skip-redis-config-generation \
    && cd ${BENCH_DIR} \
    && bench get-app lms --branch ${LMS_BRANCH}

WORKDIR ${BENCH_DIR}

# Copiar customizações SK
COPY --chown=frappe:frappe frontend/src/index.css apps/lms/frontend/src/index.css
COPY --chown=frappe:frappe frontend/src/styles/theme.css apps/lms/frontend/src/styles/theme.css
COPY --chown=frappe:frappe frontend/tailwind.config.js apps/lms/frontend/tailwind.config.js
COPY --chown=frappe:frappe frontend/public/images/sk-logo.png apps/lms/frontend/public/images/sk-logo.png

# Criar diretório de componentes e copiar logo
RUN mkdir -p apps/lms/frontend/src/components/Icons \
    && mkdir -p apps/lms/frontend/public/images

COPY --chown=frappe:frappe frontend/src/components/Icons/SKLogo.vue apps/lms/frontend/src/components/Icons/SKLogo.vue

# Build dos assets
RUN cd ${BENCH_DIR} \
    && bench build --app lms

# Copiar entrypoint customizado
COPY --chown=frappe:frappe docker/entrypoint.sh /home/frappe/entrypoint.sh
RUN chmod +x /home/frappe/entrypoint.sh

# Expor portas
EXPOSE 8000 9000

# Entrypoint
ENTRYPOINT ["/home/frappe/entrypoint.sh"]
CMD ["bench", "start"]
