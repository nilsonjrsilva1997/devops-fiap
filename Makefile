.PHONY: help install dev build docker-build docker-run docker-stop k8s-deploy k8s-delete k8s-logs k8s-scale clean

# Cor para output
BLUE := \033[0;34m
GREEN := \033[0;32m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)╔════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║     Node.js + Docker + Kubernetes - Makefile      ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Desenvolvimento Local:$(NC)"
	@echo "  make install          - Instalar dependências"
	@echo "  make dev              - Rodar aplicação localmente"
	@echo ""
	@echo "$(GREEN)Docker:$(NC)"
	@echo "  make build            - Build imagem Docker"
	@echo "  make run              - Rodar com Docker"
	@echo "  make stop             - Parar container Docker"
	@echo "  make compose-up       - Iniciar com Docker Compose"
	@echo "  make compose-down     - Parar Docker Compose"
	@echo ""
	@echo "$(GREEN)Kubernetes:$(NC)"
	@echo "  make k8s-deploy       - Deploy no Kubernetes"
	@echo "  make k8s-delete       - Deletar deployment do Kubernetes"
	@echo "  make k8s-status       - Ver status do Kubernetes"
	@echo "  make k8s-logs         - Ver logs dos pods"
	@echo "  make k8s-scale        - Escalar replicas (make k8s-scale REPLICAS=5)"
	@echo ""
	@echo "$(GREEN)Utilitários:$(NC)"
	@echo "  make clean            - Limpar containers, images e node_modules"
	@echo ""

install:
	@echo "$(BLUE)Instalando dependências...$(NC)"
	npm install

dev:
	@echo "$(BLUE)Iniciando aplicação em desenvolvimento...$(NC)"
	npm start

build:
	@echo "$(BLUE)Building imagem Docker...$(NC)"
	docker build -t nodejs-docker-k8s:latest .
	@echo "$(GREEN)✓ Build concluído!$(NC)"

run: build
	@echo "$(BLUE)Iniciando container Docker...$(NC)"
	docker run -p 3000:3000 --name nodejs-app nodejs-docker-k8s:latest

stop:
	@echo "$(BLUE)Parando container Docker...$(NC)"
	docker stop nodejs-app || true
	docker rm nodejs-app || true
	@echo "$(GREEN)✓ Container parado!$(NC)"

compose-up:
	@echo "$(BLUE)Iniciando Docker Compose...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Serviço iniciado! Acesse: http://localhost:3000$(NC)"

compose-down:
	@echo "$(BLUE)Parando Docker Compose...$(NC)"
	docker-compose down
	@echo "$(GREEN)✓ Serviço parado!$(NC)"

k8s-deploy: build
	@echo "$(BLUE)Preparando para deploy no Kubernetes...$(NC)"
	@echo "$(BLUE)Carregando imagem no Kubernetes...$(NC)"
	@echo "$(BLUE)Aplicando deployment e service...$(NC)"
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/service.yaml
	@echo "$(GREEN)✓ Deploy concluído!$(NC)"
	@echo "$(GREEN)Use 'make k8s-status' para verificar o status$(NC)"

k8s-delete:
	@echo "$(BLUE)Deletando deployment do Kubernetes...$(NC)"
	kubectl delete -f k8s/ || true
	@echo "$(GREEN)✓ Deployment deletado!$(NC)"

k8s-status:
	@echo "$(BLUE)Status do Kubernetes:$(NC)"
	@echo ""
	@echo "Deployments:"
	@kubectl get deployments
	@echo ""
	@echo "Pods:"
	@kubectl get pods -l app=nodejs-docker-k8s
	@echo ""
	@echo "Services:"
	@kubectl get services

k8s-logs:
	@echo "$(BLUE)Logs dos pods:$(NC)"
	@kubectl logs -l app=nodejs-docker-k8s -f --tail=50

k8s-scale:
	@echo "$(BLUE)Escalando deployment para $(REPLICAS) replicas...$(NC)"
	@kubectl scale deployment nodejs-app --replicas=$(REPLICAS)
	@echo "$(GREEN)✓ Escalado!$(NC)"

clean:
	@echo "$(BLUE)Limpando ambiente...$(NC)"
	docker stop nodejs-app || true
	docker rm nodejs-app || true
	docker rmi nodejs-docker-k8s:latest || true
	docker-compose down -v || true
	rm -rf node_modules || true
	@echo "$(GREEN)✓ Limpeza concluída!$(NC)"

.DEFAULT_GOAL := help
