# Relatório Fase 2 - Entrega Contínua, Monitoramento e Segurança

## 1. Pipeline de Entrega Contínua (CD)

### 1.1 Visão Geral
O pipeline foi expandido para incluir entrega contínua automatizada, integrando:
- Build e testes automatizados
- Análise de qualidade e segurança
- Containerização com Docker
- Provisionamento de infraestrutura
- Deploy automatizado para AWS EC2

### 1.2 Fluxo do Pipeline

```
[Push para Main]
    ↓
[Build e Testes] ──→ [Análise de Qualidade]
    ↓                       ↓
    └───────────────────────┘
            ↓
    [Build Docker Image]
            ↓
    [Push para Docker Hub]
            ↓
    [Provisionar Infraestrutura - Terraform]
            ↓
    [Deploy para EC2]
            ↓
    [Health Check]
            ↓
    [Notificação de Sucesso]
```

### 1.3 Componentes do Pipeline

#### Job 1: Build e Testes
- Checkout do código
- Setup do Node.js 22
- Instalação de dependências
- Execução de testes unitários (Karma + Jasmine)
- Build de produção
- Upload de artefatos

#### Job 2: Análise de Qualidade
- Auditoria de segurança (`npm audit`)
- Verificação de dependências desatualizadas
- Validação de vulnerabilidades críticas

#### Job 3: Build Docker
- Build multi-stage da imagem
- Tagging com SHA do commit e `latest`
- Push para Docker Hub
- Cache otimizado com GitHub Actions

#### Job 4: Terraform (IaC)
- Inicialização do Terraform
- Validação da configuração
- Provisionamento de recursos AWS:
  - EC2 instance (t2.micro)
  - Security Group (HTTP + SSH)
  - User data para instalação do Docker
- Output do IP público da instância

#### Job 5: Deploy
- Configuração SSH
- Instalação do Docker na EC2
- Pull da imagem Docker
- Stop de containers antigos
- Start do novo container
- Health check da aplicação

#### Job 6: Notificação
- Resumo de todas as etapas
- URL de acesso à aplicação

---

## 2. Containerização e Orquestração

### 2.1 Dockerfile Multi-stage

**Estágio 1: Build**
```dockerfile
FROM node:22-alpine AS build
- Instalação de dependências
- Build de produção
- Otimização de assets
```

**Estágio 2: Runtime**
```dockerfile
FROM nginx:alpine
- Servidor web leve
- Cópia dos arquivos buildados
- Configuração customizada do Nginx
```

### 2.2 Docker Compose
Arquivo [docker-compose.yml](../docker-compose.yml) para orquestração local:
- Bind de portas (8080:80)
- Restart automático
- Build context configurado

### 2.3 Nginx Configuration
Configuração otimizada em [nginx.conf](../nginx.conf):
- Suporte a SPA (Single Page Application)
- Cache de assets estáticos
- Compressão Gzip
- Headers de segurança

---

## 3. Infraestrutura como Código

### 3.1 Recursos Terraform

**Security Group:**
- Ingress: HTTP (80) e SSH (22)
- Egress: Todo tráfego permitido
- Tags de identificação

**EC2 Instance:**
- AMI: Amazon Linux 2
- Instance Type: t2.micro (Free Tier)
- User Data: Script de instalação do Docker
- Key Pair para acesso SSH

**Outputs:**
- IP público da instância
- ID da instância

### 3.2 Variáveis
- `aws_region`: us-east-1
- `ami_id`: ami-0157af9aea2eef346
- `instance_type`: t2.micro
- `key_name`: Configurável via secrets

---

## 4. Segurança Implementada

### 4.1 Pipeline
- Auditoria de dependências
- Scan de vulnerabilidades críticas
- Secrets gerenciados via GitHub Secrets
- Chaves SSH privadas não expostas

### 4.2 Infraestrutura
- Security Groups restritivos
- SSH apenas com chave privada
- HTTPS preparado para implementação futura

### 4.3 Containers
- Imagens oficiais e verificadas
- Multi-stage build (reduz superfície de ataque)
- Container rootless preparado

---

## 5. Testes Implementados

### 5.1 Testes Unitários
- Framework: Karma + Jasmine
- Execução: ChromeHeadless (CI/CD)
- Cobertura: Componentes Angular

### 5.2 Validações de Pipeline
- Validação de build de produção
- Health check HTTP após deploy
- Verificação de status do container

---

## 6. Resultados Obtidos

### 6.1 Métricas
- **Tempo de Pipeline:** ~8-10 minutos
- **Tamanho da Imagem:** ~50MB
- **Tempo de Deploy:** ~2 minutos

### 6.2 Benefícios
- Deploy automatizado e confiável
- Infraestrutura versionada e reproduzível
- Rollback facilitado (versões anteriores no Docker Hub)
- Redução de erros manuais
- Ambiente de produção consistente

---

## 7. Melhorias Futuras

### 7.1 Monitoramento
- [ ] Prometheus para coleta de métricas
- [ ] Grafana para visualização
- [ ] Alertas via Slack/Discord/Teams

### 7.2 Testes Avançados
- [ ] Testes E2E com Cypress
- [ ] Testes de carga

### 7.3 Deploy Estratégico
- [ ] Blue-Green Deployment
- [ ] Canary Release

### 7.4 Orquestração
- [ ] Kubernetes
- [ ] Auto-scaling
- [ ] Load Balancer

---

## 8. Conclusão

O projeto implementou com sucesso uma pipeline completa de CI/CD, incluindo:
- Integração contínua com testes e validações
- Entrega contínua com deploy automatizado
- Containerização com Docker
- Infraestrutura como código com Terraform
- Segurança integrada no pipeline

---

---

**Autor:** Ana Caroline Cagliari Cappellari  
**Disciplina:** DevOps na Prática  
**Instituição:** PUCRS
**Data:** Novembro 2025
