#!/usr/bin/env powershell

# Setup Script para Node.js + Docker + Kubernetes (Windows)

Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Node.js + Docker + Kubernetes - Setup Script   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar Node.js
$nodeExists = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
if ($nodeExists) {
    $nodeVersion = & node --version
    Write-Host "✓ Node.js encontrado: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "⚠ Node.js não encontrado!" -ForegroundColor Yellow
}

# Verificar Docker
$dockerExists = $null -ne (Get-Command docker -ErrorAction SilentlyContinue)
if ($dockerExists) {
    $dockerVersion = & docker --version
    Write-Host "✓ Docker encontrado: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "⚠ Docker não encontrado!" -ForegroundColor Yellow
}

# Verificar kubectl
$kubectlExists = $null -ne (Get-Command kubectl -ErrorAction SilentlyContinue)
if ($kubectlExists) {
    Write-Host "✓ kubectl encontrado" -ForegroundColor Green
} else {
    Write-Host "⚠ kubectl não encontrado!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Escolha uma opção para começar:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1) Executar localmente (Node.js)"
Write-Host "2) Executar com Docker Compose"
Write-Host "3) Executar com Kubernetes"
Write-Host "4) Apenas instalar dependências"
Write-Host "5) Sair"
Write-Host ""

$choice = Read-Host "Digite sua escolha (1-5)"

switch ($choice) {
    "1" {
        Write-Host "Instalando dependências..." -ForegroundColor Cyan
        & npm install
        Write-Host "✓ Dependências instaladas!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Iniciando aplicação..." -ForegroundColor Cyan
        & npm start
    }
    "2" {
        Write-Host "Inicializando Docker Compose..." -ForegroundColor Cyan
        & docker-compose up
    }
    "3" {
        Write-Host "Preparando Kubernetes..." -ForegroundColor Cyan
        & docker build -t nodejs-docker-k8s:latest .
        Write-Host "✓ Imagem built!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Aplicando configurações Kubernetes..." -ForegroundColor Cyan
        & kubectl apply -f k8s/deployment.yaml
        & kubectl apply -f k8s/service.yaml
        Write-Host "✓ Deploy concluído!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Status atual:" -ForegroundColor Cyan
        & kubectl get pods,svc
    }
    "4" {
        Write-Host "Instalando dependências..." -ForegroundColor Cyan
        & npm install
        Write-Host "✓ Dependências instaladas!" -ForegroundColor Green
    }
    "5" {
        Write-Host "Saindo..."
        exit 0
    }
    default {
        Write-Host "Opção inválida!" -ForegroundColor Red
        exit 1
    }
}
