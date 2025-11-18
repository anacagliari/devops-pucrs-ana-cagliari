# Fluxograma DevOps - Pipeline Completo

## Visão Geral do Fluxo

```mermaid
graph TB
    A[Desenvolvedor faz Push] --> B[GitHub Repository]
    B --> C{Evento Disparado}
    C -->|Push to Main| D[GitHub Actions]
    C -->|Pull Request| D
    
    D --> E[Job 1: Build e Testes]
    D --> F[Job 2: Qualidade]
    
    E --> G{Testes Passaram?}
    F --> H{Auditoria OK?}
    
    G -->|Não| Z[❌ Pipeline Falha]
    H -->|Não| Z
    
    G -->|Sim| I[Job 3: Build Docker]
    H -->|Sim| I
    
    I --> J[Docker Build]
    J --> K[Docker Push]
    K --> L[Docker Hub Registry]
    
    I --> M{É Main Branch?}
    M -->|Não| Y[✅ Pipeline Completo]
    M -->|Sim| N[Job 4: Terraform]
    
    N --> O[Terraform Init]
    O --> P[Terraform Validate]
    P --> Q[Terraform Apply]
    Q --> R[Recursos AWS Criados]
    
    R --> S[Job 5: Deploy]
    S --> T[SSH para EC2]
    T --> U[Instalar Docker]
    U --> V[Pull Image]
    V --> W[Run Container]
    W --> X[Health Check]
    
    X --> Y[✅ Pipeline Completo]
```

## Detalhamento dos Jobs

### 1. Build e Testes

```mermaid
graph LR
    A[Checkout] --> B[Setup Node.js]
    B --> C[npm install]
    C --> D[npm test]
    D --> E[npm build]
    E --> F[Upload Artifacts]
```

### 2. Análise de Qualidade

```mermaid
graph LR
    A[Checkout] --> B[Setup Node.js]
    B --> C[npm install]
    C --> D[npm audit]
    D --> E[npm outdated]
```

### 3. Build Docker

```mermaid
graph LR
    A[Checkout] --> B[Docker Buildx]
    B --> C[Login Docker Hub]
    C --> D[Extract Metadata]
    D --> E[Build Multi-stage]
    E --> F[Push to Registry]
```

### 4. Terraform (IaC)

```mermaid
graph LR
    A[Checkout] --> B[AWS Credentials]
    B --> C[Setup Terraform]
    C --> D[terraform init]
    D --> E[terraform validate]
    E --> F[terraform apply]
    F --> G[Output IP]
```

### 5. Deploy para EC2

```mermaid
graph LR
    A[Checkout] --> B[Setup SSH]
    B --> C[Wait Instance]
    C --> D[Install Docker]
    D --> E[Stop Old Container]
    E --> F[Pull New Image]
    F --> G[Run Container]
    G --> H[Health Check]
```

## Arquitetura da Infraestrutura

```mermaid
graph TB
    subgraph "AWS Cloud"
        subgraph "VPC"
            SG[Security Group<br/>HTTP: 80<br/>SSH: 22]
            
            subgraph "EC2 Instance"
                Docker[Docker Engine]
                Container[Nginx Container<br/>Angular App]
            end
        end
    end
    
    Internet[Internet] -->|HTTP:80| SG
    Developer[Developer] -->|SSH:22| SG
    SG --> Docker
    Docker --> Container
    
    DH[Docker Hub] -.->|Pull Image| Docker
    GH[GitHub Actions] -.->|Deploy| Docker
    TF[Terraform] -.->|Provisiona| EC2
```

## Fluxo de Dados

```mermaid
sequenceDiagram
    participant Dev as Desenvolvedor
    participant GH as GitHub
    participant GA as GitHub Actions
    participant DH as Docker Hub
    participant TF as Terraform
    participant AWS as AWS
    participant EC2 as EC2 Instance
    
    Dev->>GH: git push origin main
    GH->>GA: Trigger Pipeline
    
    GA->>GA: Build & Test
    GA->>GA: Quality Check
    
    GA->>GA: Docker Build
    GA->>DH: Push Image
    
    GA->>TF: terraform apply
    TF->>AWS: Create Resources
    AWS-->>TF: Instance IP
    
    GA->>EC2: SSH Connect
    EC2->>DH: Pull Image
    EC2->>EC2: Run Container
    
    EC2-->>GA: Health Check OK
    GA-->>Dev: Deploy Success ✅
```

## Timeline do Pipeline

```
┌───────────────────────────────────────────────────┐
│  Timeline Aproximada do Pipeline (8-10 minutos)   │
├───────────────────────────────────────────────────┤
│                                                   │
│  0min ─┬─ Build & Test (2-3 min)                  │
│        ├─ Quality Check (1 min)                   │
│        │                                          │
│  3min ─┴─ Docker Build (2 min)                    │
│                                                   │
│  5min ─┬─ Terraform Apply (1-2 min)               │
│        │                                          │
│  7min ─┴─ Deploy to EC2 (2-3 min)                 │
│           ├─ Install Docker                       │
│           ├─ Pull Image                           │
│           ├─ Run Container                        │
│           └─ Health Check                         │
│                                                   │
│ 10min ─── Pipeline Complete                       │
└───────────────────────────────────────────────────┘
```
