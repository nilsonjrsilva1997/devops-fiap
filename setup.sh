#!/bin/bash

# Cores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Node.js + Docker + Kubernetes - Setup Script   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se Node.js está instalado
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠ Node.js não encontrado. Instalando dependências localmente...${NC}"
else
    echo -e "${GREEN}✓ Node.js encontrado: $(node -v)${NC}"
fi

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠ Docker não encontrado. Você precisará de Docker para usar os containers.${NC}"
else
    echo -e "${GREEN}✓ Docker encontrado: $(docker --version)${NC}"
fi

# Verificar se kubectl está instalado
if ! command -v kubectl &> /dev/null; then
    echo -e "${YELLOW}⚠ kubectl não encontrado. Você precisará de Kubernetes para orquestração.${NC}"
else
    echo -e "${GREEN}✓ kubectl encontrado: $(kubectl version --client --short 2>/dev/null || echo 'instalado')${NC}"
fi

echo ""
echo -e "${BLUE}Escolha uma opção para começar:${NC}"
echo ""
echo "1) Executar localmente (Node.js)"
echo "2) Executar com Docker Compose"
echo "3) Executar com Kubernetes"
echo "4) Apenas instalar dependências"
echo "5) Sair"
echo ""
read -p "Digite sua escolha (1-5): " choice

case $choice in
    1)
        echo -e "${BLUE}Instalando dependências...${NC}"
        npm install
        echo -e "${GREEN}✓ Dependências instaladas!${NC}"
        echo ""
        echo -e "${BLUE}Iniciando aplicação...${NC}"
        npm start
        ;;
    2)
        echo -e "${BLUE}Inicializando Docker Compose...${NC}"
        docker-compose up
        ;;
    3)
        echo -e "${BLUE}Preparando Kubernetes...${NC}"
        docker build -t nodejs-docker-k8s:latest .
        echo -e "${GREEN}✓ Imagem built!${NC}"
        echo ""
        echo -e "${BLUE}Aplicando configurações Kubernetes...${NC}"
        kubectl apply -f k8s/deployment.yaml
        kubectl apply -f k8s/service.yaml
        echo -e "${GREEN}✓ Deploy concluído!${NC}"
        echo ""
        echo -e "${BLUE}Status atual:${NC}"
        kubectl get pods,svc
        ;;
    4)
        echo -e "${BLUE}Instalando dependências...${NC}"
        npm install
        echo -e "${GREEN}✓ Dependências instaladas!${NC}"
        ;;
    5)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida!"
        exit 1
        ;;
esac
