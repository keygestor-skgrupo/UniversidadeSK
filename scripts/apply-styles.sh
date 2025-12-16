#!/bin/bash

# ============================================
# Script simplificado para aplicar estilos SK
# Execute dentro do container frappe-lms
# ============================================

BENCH_DIR="/home/frappe/frappe-bench"

cd $BENCH_DIR

echo "Aplicando estilos Universidade SK..."

# Criar diretório de estilos se não existir
mkdir -p apps/lms/frontend/src/styles

# Criar arquivo de customização simples
cat > apps/lms/frontend/src/styles/sk-custom.css << 'CSSEOF'
/* Universidade SK - Cores Personalizadas */
:root {
  --sk-red: #E31837;
  --sk-red-dark: #B81430;
  --sk-navy: #1B365D;
  --primary: #E31837;
  --btn-primary-bg: #E31837;
}

/* Botões vermelhos SK */
button[class*="variant-solid"],
.bg-ink-gray-9,
.bg-surface-gray-6,
.bg-surface-gray-7 {
  background-color: #E31837 !important;
  border-color: #E31837 !important;
}

button[class*="variant-solid"]:hover,
.bg-ink-gray-9:hover {
  background-color: #B81430 !important;
  border-color: #B81430 !important;
}

/* Checkbox e Toggle */
input[type="checkbox"]:checked,
input[type="radio"]:checked,
[role="switch"][aria-checked="true"] {
  background-color: #E31837 !important;
  border-color: #E31837 !important;
}

/* Links */
.text-ink-blue-link {
  color: #E31837 !important;
}

/* Tabs ativos */
[role="tab"][aria-selected="true"] {
  border-color: #E31837 !important;
  color: #E31837 !important;
}

/* Progress bar */
[role="progressbar"] > div {
  background-color: #E31837 !important;
}

/* Cards hover */
.course-card:hover,
.batch-card:hover,
[class*="Card"]:hover {
  border-color: #E31837 !important;
}

/* Animação suave */
button, .btn, [role="button"] {
  transition: all 0.3s ease;
}

button:active, .btn:active {
  transform: scale(0.98);
}
CSSEOF

# Adicionar import no index.css se não existir
if ! grep -q "sk-custom.css" apps/lms/frontend/src/index.css; then
    sed -i "1i @import './styles/sk-custom.css';" apps/lms/frontend/src/index.css
    echo "Import adicionado ao index.css"
fi

echo "Build do frontend..."
bench build --app lms

echo "Limpando cache..."
bench --site all clear-cache 2>/dev/null || true

echo ""
echo "Estilos SK aplicados com sucesso!"
