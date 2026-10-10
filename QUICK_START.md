# Quick Start - Inicie em 2 minutos!

## Opção 1: Executar localmente (Sem Docker)

```bash
npm install
npm start
```
Acesse: **http://localhost:3000**

---

## Opção 2: Executar com Docker Compose (Recomendado!)

```bash
docker-compose up
```
Acesse: **http://localhost:3000**

Para parar: `docker-compose down`

---

## Opção 3: Executar com Kubernetes

### Se usar Docker Desktop:
```bash
# Build
docker build -t nodejs-docker-k8s:latest .

# Deploy
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Verificar
kubectl get pods
kubectl get svc
```

Acesse: **http://localhost**

### Se usar Minikube:
```bash
docker build -t nodejs-docker-k8s:latest .
minikube image load nodejs-docker-k8s:latest

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl port-forward svc/nodejs-app-service 3000:80
```

Acesse: **http://localhost:3000**

---

## Próximas Ações para Aprender

1. **Modifique o HTML/CSS/JS** em `public/` e veja as mudanças
2. **Altere o endpoint** em `app.js` e teste com a API
3. **Aumente as replicas** no Kubernetes: `kubectl scale deployment nodejs-app --replicas=5`
4. **Monitore os pods**: `kubectl logs -f <pod-name>`
5. **Teste health checks**: Delete um pod e veja Kubernetes recriar automaticamente

---

## Entendendo a Estrutura

- **Backend**: Node.js Express (app.js)
- **Frontend**: HTML + CSS + JS (public/)
- **Container**: Dockerfile (multi-stage build)
- **Orquestração Local**: docker-compose.yml
- **Orquestração Produção**: k8s/ (deployment + service)

---

## Dúvidas?

Consulte o README.md completo para mais detalhes e comandos úteis!
