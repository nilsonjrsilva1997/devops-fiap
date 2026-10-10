# Node.js + Docker + Kubernetes

Aplicação simples para aprender Docker e Kubernetes com Node.js, Express, HTML, CSS e JavaScript.

## Estrutura do Projeto

```
.
├── app.js                 # Aplicação Express
├── package.json          # Dependências do projeto
├── Dockerfile            # Build da imagem Docker
├── docker-compose.yml    # Orquestração local com Docker
├── .dockerignore         # Arquivos ignorados no Docker
├── .gitignore            # Arquivos ignorados no Git
├── public/               # Arquivos estáticos (Frontend)
│   ├── index.html        # Página principal
│   ├── style.css         # Estilos
│   └── script.js         # Lógica do frontend
└── k8s/                  # Configurações Kubernetes
    ├── deployment.yaml   # Deployment
    └── service.yaml      # Service
```

## Como Executar

### 1. Sem Docker (Desenvolvimento Local)

```bash
# Instalar dependências
npm install

# Iniciar servidor
npm start

# Acessar: http://localhost:3000
```

### 2. Com Docker (Uma Imagem)

```bash
# Build da imagem
docker build -t nodejs-docker-k8s .

# Executar container
docker run -p 3000:3000 nodejs-docker-k8s

# Acessar: http://localhost:3000
```

### 3. Com Docker Compose (Recomendado para Desenvolvimento)

```bash
# Iniciar serviço
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar
docker-compose down

# Acessar: http://localhost:3000
```

### 4. Com Kubernetes (Para Produção)

#### Pré-requisitos:
- Docker Desktop com Kubernetes ativado, OU
- Minikube instalado, OU
- Cluster Kubernetes real

#### Passos:

```bash
# 1. Build da imagem e carregar no cluster (se usando Minikube)
docker build -t nodejs-docker-k8s:latest .

# Se usar Minikube, executar:
minikube image load nodejs-docker-k8s:latest

# 2. Aplicar Deployment
kubectl apply -f k8s/deployment.yaml

# 3. Aplicar Service
kubectl apply -f k8s/service.yaml

# 4. Verificar status
kubectl get pods
kubectl get services

# 5. Acessar a aplicação
# Docker Desktop: http://localhost
# Minikube: kubectl port-forward svc/nodejs-app-service 3000:80
#           Então: http://localhost:3000
```

## Endpoint da API

### GET /api/mensagem

Retorna uma mensagem JSON com informações do servidor:

```json
{
  "mensagem": "Olá do Backend!",
  "timestamp": "2024-01-15T10:30:45.123Z",
  "status": "conectado"
}
```

## Variáveis de Ambiente

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `PORT` | 3000 | Porta do servidor |
| `NODE_ENV` | production | Ambiente (development/production) |

## Comandos Úteis - Docker

```bash
# Ver todas as imagens
docker images

# Ver todos os containers
docker ps -a

# Ver logs de um container
docker logs <container_id>

# Remover imagem
docker rmi nodejs-docker-k8s

# Remover container
docker rm <container_id>

# Acessar bash do container
docker exec -it <container_id> /bin/sh
```

## Comandos Úteis - Kubernetes

```bash
# Ver todos os resources
kubectl get all

# Ver detalhes do deployment
kubectl describe deployment nodejs-app

# Ver logs de um pod
kubectl logs <pod_name>

# Escalar deployment
kubectl scale deployment nodejs-app --replicas=3

# Port-forward
kubectl port-forward svc/nodejs-app-service 3000:80

# Deletar todos os resources
kubectl delete deployment,service -l app=nodejs-docker-k8s

# Aplicar/Atualizar recursos
kubectl apply -f k8s/

# Remover recursos
kubectl delete -f k8s/
```

## O que Você vai Aprender

- Criar aplicação Node.js com Express
- Servir arquivos estáticos (HTML, CSS, JS)
- Criar endpoints de API
- Containerizar com Docker
- Usar Docker Compose
- Fazer deploy em Kubernetes
- Configurar Deployment e Service
- Health checks e probes
- Limites de recursos

## Troubleshooting

### Porta 3000 já está em uso
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# macOS/Linux
lsof -i :3000
kill -9 <PID>
```

### Erro de conexão no Kubernetes
```bash
# Verificar se os pods estão rodando
kubectl get pods

# Ver detalhes do erro
kubectl describe pod <pod_name>

# Ver logs
kubectl logs <pod_name>
```

### Container não inicia
```bash
# Ver logs detalhados
docker logs <container_id>

# Verificar se a porta está aberta
docker port <container_id>
```

## 📖 Recursos Adicionais

- [Node.js Docs](https://nodejs.org/docs/)
- [Express.js Guide](https://expressjs.com/)
- [Docker Docs](https://docs.docker.com/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

## 📄 Licença

MIT
