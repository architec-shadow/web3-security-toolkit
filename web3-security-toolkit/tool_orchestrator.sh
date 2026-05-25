#!/bin/bash

# =====================================================================
# ARCHITEC-SHADOW - SECURITY TOOLING ORCHESTRATOR (DOCKERIZED TRIAGE)
# =====================================================================

# Colores para la terminal (UX Profesional)
GREEN='\0033[0;32m'
RED='\0033[0;31m'
BLUE='\0033[0;34m'
NC='\0033[0m' # No Color

TARGET_DIR=$1

if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}[!] Error: Debes especificar la ruta absoluta del código a auditar.${NC}"
    echo -e "Uso: ./tool_orchestrator.sh /ruta/al/proyecto/smart-contracts"
    exit 1
fi

echo -e "${BLUE}[*] Inicializando Pipeline de Auditoría Automatizada para: $TARGET_DIR${NC}"
echo -e "${BLUE}[*] Entorno operativo: Aislado vía Docker Containers${NC}"
echo "---------------------------------------------------------------------"

# Crear directorio temporal para outputs en el toolkit
mkdir -p ./raw_outputs

# --- EJECUCIÓN DE SLITHER (Análisis Estático de Solidity clásico) ---
echo -e "${GREEN}[+] Ejecutando Slither Security Scan...${NC}"
docker run --rm -v "$TARGET_DIR":/share trailofbits/eth-security-toolbox:latest \
    bash -c "cd /share && slither . --json /share/slither_raw.json" 2>/dev/null

if [ -f "$TARGET_DIR/slither_raw.json" ]; then
    mv "$TARGET_DIR/slither_raw.json" ./raw_outputs/slither_$(date +%F).json
    echo -e "${GREEN}[✓] Slither finalizado con éxito. Reporte guardado en ./raw_outputs/${NC}"
else
    echo -e "${RED}[!] Advertencia: Slither no generó JSON (Verificar si el proyecto compila correctamente).${NC}"
fi

# --- EJECUCIÓN DE ADERYN (Analizador Estático en Rust para Web3 de alta velocidad) ---
echo -e "${GREEN}[+] Ejecutando Aderyn AST Scanner...${NC}"
# Usamos la imagen oficial de Cyfrin Aderyn para extraer vulnerabilidades lógicas rápidas
docker run --rm -v "$TARGET_DIR":/share cyfrin/aderyn:latest \
    --root /share --output /share/aderyn_raw.md 2>/dev/null

if [ -f "$TARGET_DIR/aderyn_raw.md" ]; then
    mv "$TARGET_DIR/aderyn_raw.md" ./raw_outputs/aderyn_$(date +%F).md
    echo -e "${GREEN}[✓] Aderyn finalizado con éxito. Reporte Markdown guardado en ./raw_outputs/${NC}"
else
    echo -e "${RED}[!] Advertencia: Aderyn no pudo procesar el AST del proyecto.${NC}"
fi

echo "---------------------------------------------------------------------"
echo -e "${BLUE}[*] Pipeline Terminado. Listo para ejecución de Parsers de limpieza.${NC}"
