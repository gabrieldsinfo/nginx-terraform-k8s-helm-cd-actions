# Projeto CD - Terraform + Helm + Kind via GitHub Actions

Este projeto automatiza o deploy de uma aplicação Nginx em Kubernetes usando Terraform e Helm, executado inteiramente no GitHub Actions. Utiliza o Kind para criar um cluster Kubernetes temporário dentro do ambiente do GitHub runner.

---

## Objetivo

- Demonstrar infraestrutura como código (IaC) com Terraform para gerenciar namespace e release Helm.
- Automatizar o deploy usando GitHub Actions.
- Utilizar Kind para simular cluster Kubernetes no pipeline CI/CD.
- Fazer deploy de um chart Helm customizado (`nginx-chart`) com a aplicação Nginx.

---

## Tecnologias usadas

- **Terraform:** Gerencia recursos Kubernetes (namespace) e Helm Release.
- **Helm:** Gerencia deploy da aplicação Nginx como chart.
- **Kind:** Cria cluster Kubernetes local no ambiente do runner do GitHub Actions.
- **GitHub Actions:** Pipeline CI/CD que cria o cluster, roda Terraform e Helm para deploy.

---

## Estrutura do projeto

nginx-terraform-docker-k8s-helm-cd-actions/
├── terraform/
│ └── main.tf # Definição do provider, namespace e helm_release
├── helm/
│ └── nginx-chart/ # Chart Helm do Nginx com templates e values.yaml
├── .github/
│ └── workflows/
│ └── cd.yaml # Workflow GitHub Actions que executa todo o deploy
├── README.md # Documentação do projeto

---

## Como funciona o deploy no GitHub Actions

- A cada push para a branch `main`, o workflow é disparado.
- O workflow cria o cluster Kind, instala as ferramentas, executa o Terraform para criar o namespace e deploy do Helm chart.
- Ao final, lista os pods e serviços no namespace.
- Todo o ambiente é descartado ao fim da execução, mantendo o runner limpo.

---

## Fluxo do GitHub Actions (`.github/workflows/cd.yaml`)

1. **Checkout** do código.
2. **Criação do cluster Kind** (`kind create cluster`) para simular Kubernetes no runner.
3. Define a variável de ambiente `KUBECONFIG` apontando para o arquivo gerado pelo Kind (`~/.kube/config`).
4. Instala as ferramentas **Helm** e **Terraform**.
5. Executa comandos Terraform (`init`, `validate`, `apply`) usando o provider Kubernetes e Helm, que usam o kubeconfig padrão para se conectar ao cluster Kind.
6. Verifica os recursos criados no namespace `nginx-terraform` com `kubectl get all`.

---

## Detalhes importantes

- O `main.tf` do Terraform usa o caminho padrão `~/.kube/config` para acessar o cluster Kubernetes, que é onde o Kind salva o arquivo kubeconfig.
- No workflow, não é necessário passar explicitamente a variável `TF_VAR_kubeconfig_path`, pois o Terraform já tem o default correto.
- O namespace `nginx-terraform` é criado via Terraform para isolar a aplicação no cluster.
- O Helm release aponta para o chart local `../helm/nginx-chart`, que contém o template para deploy do Nginx.
- O serviço é exposto via tipo `ClusterIP`, acessível dentro do cluster.

---
> 📘 Projeto para fins de estudo e demonstração de boas práticas DevOps.
