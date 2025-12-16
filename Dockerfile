# ============================================
# UNIVERSIDADE SK - Frappe LMS Customizado
# ============================================
FROM frappe/bench:latest

# Argumentos de build
ARG FRAPPE_BRANCH=version-15
ARG LMS_BRANCH=develop

# Variáveis de ambiente
ENV BENCH_DIR=/home/frappe/frappe-bench

USER frappe
WORKDIR /home/frappe

# Inicializar bench e instalar LMS
RUN bench init ${BENCH_DIR} \
    --frappe-branch ${FRAPPE_BRANCH} \
    --python python3.11 \
    --skip-redis-config-generation \
    && cd ${BENCH_DIR} \
    && bench get-app lms --branch ${LMS_BRANCH}

WORKDIR ${BENCH_DIR}

# Criar diretórios necessários para customizações
RUN mkdir -p apps/lms/frontend/src/styles \
    && mkdir -p apps/lms/frontend/src/components/Icons \
    && mkdir -p apps/lms/frontend/public/images

# Copiar CSS customizado SK
COPY --chown=frappe:frappe frontend/src/styles/sk-custom.css apps/lms/frontend/src/styles/sk-custom.css

# Copiar tailwind.config.js com cores SK
COPY --chown=frappe:frappe frontend/tailwind.config.js apps/lms/frontend/tailwind.config.js

# Copiar logo SK
COPY --chown=frappe:frappe frontend/public/images/sk-logo.png apps/lms/frontend/public/images/sk-logo.png

# INJETAR import do CSS SK no index.css original (adicionar ao final)
RUN echo "" >> apps/lms/frontend/src/index.css \
    && echo "/* Universidade SK Customizations */" >> apps/lms/frontend/src/index.css \
    && echo "@import './styles/sk-custom.css';" >> apps/lms/frontend/src/index.css

# Build do LMS com customizações
RUN bench build --app lms

# Copiar entrypoint customizado
COPY --chown=frappe:frappe docker/entrypoint.sh /home/frappe/entrypoint.sh
RUN chmod +x /home/frappe/entrypoint.sh

# Expor portas
EXPOSE 8000 9000

# Entrypoint
ENTRYPOINT ["/home/frappe/entrypoint.sh"]
CMD ["bench", "start"]
