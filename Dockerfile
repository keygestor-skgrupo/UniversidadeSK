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

# Copiar CSS customizado SK para pasta pública do LMS
COPY --chown=frappe:frappe lms_custom/public/css/sk-theme.css apps/lms/lms/public/css/sk-theme.css

# Copiar logo SK
RUN mkdir -p apps/lms/lms/public/images
COPY --chown=frappe:frappe frontend/public/images/sk-logo.png apps/lms/lms/public/images/sk-logo.png

# Adicionar CSS SK ao hooks.py do LMS (método oficial do Frappe)
RUN sed -i 's/web_include_css = "lms.bundle.css"/web_include_css = ["lms.bundle.css", "\/assets\/lms\/css\/sk-theme.css"]/' apps/lms/lms/hooks.py || \
    echo 'web_include_css = ["lms.bundle.css", "/assets/lms/css/sk-theme.css"]' >> apps/lms/lms/hooks.py

# Build do LMS
RUN bench build --app lms

# Copiar entrypoint customizado
COPY --chown=frappe:frappe docker/entrypoint.sh /home/frappe/entrypoint.sh
RUN chmod +x /home/frappe/entrypoint.sh

# Expor portas
EXPOSE 8000 9000

# Entrypoint
ENTRYPOINT ["/home/frappe/entrypoint.sh"]
CMD ["bench", "start"]
