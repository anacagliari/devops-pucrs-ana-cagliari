# Relatório Fase 1 - Integração Contínua e Infraestrutura como Código

## 1. Pipeline de Integração Contínua (CI)

### 1.1 Visão Geral
Implementação de pipeline CI automatizado com:
- Build e testes automatizados
- Análise de qualidade de código
- Provisionamento de infraestrutura AWS

### 1.2 Fluxo do Pipeline

```
[Push para Main]
    ↓
[Build e Testes] ──→ [Análise de Qualidade]
    ↓                       ↓
    └───────────────────────┘
            ↓
    [Provisionar Infraestrutura - Terraform]
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

#### Job 3: Terraform (IaC)
- Inicialização do Terraform
- Validação da configuração
- Provisionamento de recursos AWS:
  - EC2 instance (t2.micro)
  - Security Group (HTTP + SSH)
  - User data para instalação do Nginx
- Output do IP público da instância

#### Job 4: Notificação
- Resumo de todas as etapas concluídas
- Confirmação de build e infraestrutura

---

## 2. Infraestrutura como Código

### 2.1 Recursos Terraform

**Security Group:**
- Ingress: HTTP (80) e SSH (22)
- Egress: Todo tráfego permitido
- Tags: `projeto-devops-ana-cagliari`

**EC2 Instance:**
- AMI: Amazon Linux 2 (ami-0157af9aea2eef346)
- Instance Type: t2.micro (Free Tier)
- User Data: Script de instalação do Nginx
- Key Pair para acesso SSH

**Outputs:**
- IP público da instância
- ID da instância

### 2.2 Variáveis
- `aws_region`: us-east-1
- `ami_id`: ami-0157af9aea2eef346
- `instance_type`: t2.micro
- `key_name`: Configurável via secrets

---

## 3. Testes e Validações

### 3.1 Testes Unitários
- Framework: Karma + Jasmine
- Execução: ChromeHeadless (CI)
- Cobertura: 100% do AppComponent

---

## 4. Resultados Obtidos

### 4.1 Métricas
- **Tempo de Pipeline (CI):** ~1-2 minutos
- **Tempo de Pipeline (CI + IaC):** ~4-5 minutos
- **Tamanho do Bundle:** ~280kB

---

## 8. Conclusão

### 8.1 Objetivos Alcançados
- Pipeline CI funcional e automatizado
- Infraestrutura provisionada via Terraform
- Testes unitários implementados
- Análise de segurança integrada
- Documentação completa

---

**Autor:** Ana Caroline Cagliari Cappellari  
**Disciplina:** DevOps na Prática  
**Instituição:** PUCRS  
**Data:** Novembro 2025
