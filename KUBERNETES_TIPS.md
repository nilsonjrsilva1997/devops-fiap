# Dicas para Desenvolvimento com Kubernetes

## Usando Docker Desktop com Kubernetes

### Ativar Kubernetes no Docker Desktop

1. Abra **Docker Desktop**
2. Vá para **Settings** → **Kubernetes**
3. Marque "Enable Kubernetes"
4. Clique "Apply & Restart"
5. Aguarde a inicialização (alguns minutos)

Verificar:
```bash
kubectl cluster-info
```

### Build e Deploy rápido

```bash
# Build da imagem (será automaticamente disponível no Kubernetes)
docker build -t nodejs-docker-k8s:latest .

# Deploy
kubectl apply -f k8s/

# Ver pods
kubectl get pods

# Acessar via localhost
# A porta é mapeada automaticamente
# http://localhost (Porta 80 do Service → 3000 do Pod)
```

---

## Usando Minikube

### Instalação (se necessário)

```bash
# Windows (Chocolatey)
choco install minikube

# macOS (Homebrew)
brew install minikube

# Linux (via curl)
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Iniciar Minikube

```bash
# Iniciar o cluster
minikube start

# Verificar status
minikube status

# Ver IP do Minikube
minikube ip
```

### Build e Deploy com Minikube

```bash
# Build da imagem
docker build -t nodejs-docker-k8s:latest .

# Carregar imagem no Minikube (IMPORTANTE!)
minikube image load nodejs-docker-k8s:latest

# Deploy
kubectl apply -f k8s/

# Ver pods
kubectl get pods

# Port-forward para acessar a aplicação
kubectl port-forward svc/nodejs-app-service 3000:80

# Acessar via: http://localhost:3000
```

### Parar Minikube

```bash
minikube stop

# Ou deletar completamente
minikube delete
```

---

## Debugging no Kubernetes

### Ver logs de um pod

```bash
# Últimas 50 linhas
kubectl logs <pod-name>

# Seguir logs em tempo real
kubectl logs -f <pod-name>

# Todos os pods de um deployment
kubectl logs -l app=nodejs-docker-k8s -f

# Logs de um container específico
kubectl logs <pod-name> -c nodejs-app
```

### Executar comandos dentro de um pod

```bash
# Acessar bash/sh do pod
kubectl exec -it <pod-name> -- /bin/sh

# Executar comando único
kubectl exec <pod-name> -- ls -la
```

### Inspecionar recursos

```bash
# Detalhes completos de um pod
kubectl describe pod <pod-name>

# Detalhes de um deployment
kubectl describe deployment nodejs-app

# Detalhes de um service
kubectl describe service nodejs-app-service
```

### Listar recursos

```bash
# Todos os recursos no namespace atual
kubectl get all

# Apenas pods
kubectl get pods

# Pods com detalhes
kubectl get pods -o wide

# Services
kubectl get services

# Deployments
kubectl get deployments

# Com labels/seletores
kubectl get pods -l app=nodejs-docker-k8s
```

---

## Escalar Aplicação

### Aumentar número de replicas

```bash
# Editar deployment
kubectl scale deployment nodejs-app --replicas=5

# Ver replicas
kubectl get deployment nodejs-app
```

### Verificar que todos os pods estão rodando

```bash
kubectl get pods -w  # -w para "watch" (tempo real)
```

---

## 🔄 Atualizar Aplicação (Rolling Update)

### Método 1: Editar Deployment

```bash
kubectl edit deployment nodejs-app

# Modificar a imagem na seção .spec.template.spec.containers[0].image
# Salvar e sair (vim: :wq)

# Kubernetes fará rolling update automaticamente
```

### Método 2: Aplicar nova configuração

```bash
# Modificar k8s/deployment.yaml
# Depois:
kubectl apply -f k8s/deployment.yaml

# Ver progresso
kubectl rollout status deployment nodejs-app
```

### Ver histórico de rollouts

```bash
kubectl rollout history deployment nodejs-app

# Reverter para versão anterior
kubectl rollout undo deployment nodejs-app
```

---

## 🧹 Limpeza

### Deletar deployment e service

```bash
# Deletar tudo
kubectl delete -f k8s/

# Deletar especificamente
kubectl delete deployment nodejs-app
kubectl delete service nodejs-app-service
```

### Deletar pods específicos (para testar auto-recovery)

```bash
kubectl delete pod <pod-name>

# Kubernetes recria automaticamente
```

---

## 📊 Monitoramento

### Ver eventos do cluster

```bash
kubectl get events --sort-by='.lastTimestamp'
```

### Verificar status dos nodes

```bash
kubectl get nodes

# Detalhes de um node
kubectl describe node <node-name>
```

---

## 💡 Dicas Úteis

1. **Usar kubectl alias**:
   ```bash
   alias k=kubectl
   # Depois: k get pods
   ```

2. **Autocomplete (bash/zsh)**:
   ```bash
   kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
   ```

3. **Contextos múltiplos**:
   ```bash
   kubectl config get-contexts
   kubectl config use-context <context-name>
   ```

4. **Namespace customizado**:
   ```bash
   kubectl create namespace dev
   kubectl apply -f k8s/ -n dev
   ```

5. **YAML dry-run** (verificar antes de aplicar):
   ```bash
   kubectl apply -f k8s/ --dry-run=client
   ```

---

## 🐛 Problemas Comuns

### Pod em CrashLoopBackOff
- Verificar logs: `kubectl logs <pod-name>`
- Verificar image: `kubectl describe pod <pod-name>`
- Verificar recursos: `kubectl top pods`

### Service não responde
- Verificar endpoint: `kubectl get endpoints <service-name>`
- Testar connectivity: `kubectl run -it --rm debug --image=alpine --restart=Never -- sh`
- Verificar seletor: `kubectl get pods -l app=nodejs-docker-k8s`

### Imagem não encontrada
- Build local: `docker build -t nodejs-docker-k8s:latest .`
- Se Minikube: `minikube image load nodejs-docker-k8s:latest`
- Verificar imagePullPolicy no deployment

---

## 📚 Próximos Passos

1. Adicionar **ConfigMaps** para variáveis de ambiente
2. Adicionar **Secrets** para dados sensíveis
3. Criar **Ingress** para roteamento
4. Configurar **Resource Quotas**
5. Adicionar **Persistent Volumes** para dados
6. Implementar **Health Checks** mais robustos
7. Configurar **Auto-scaling** (HPA)
8. Adicionar **Network Policies**

---

## 📖 Recursos

- [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Minikube Docs](https://minikube.sigs.k8s.io/)
- [Docker Desktop + Kubernetes](https://docs.docker.com/desktop/kubernetes/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
