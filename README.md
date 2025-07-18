# Projeto Nginx-Terraform-K8s-Helm-CD-Actions

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

## Pré-requisitos

Para rodar o projeto localmente (fora do GitHub Actions), você precisa:

- [Docker](https://docs.docker.com/get-docker/) instalado.  
- [Kind](https://kind.sigs.k8s.io/) para criar clusters Kubernetes locais.  
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) para interagir com o cluster.  
- [Terraform](https://www.terraform.io/downloads.html) instalado.  
- [Helm](https://helm.sh/docs/intro/install/) instalado.

---

## Como usar (localmente)

1. Crie o cluster Kind (exemplo com nome):  
    ```bash
    kind create cluster --name meu-cluster
    ```

2. Defina a variável de ambiente `KUBECONFIG` apontando para o arquivo padrão do Kind:  
    ```bash
    export KUBECONFIG=~/.kube/config
    ```

3. (Opcional) Liste os clusters Kind disponíveis:  
    ```bash
    kubectl config get-contexts
    ```

4. (Opcional) Veja qual contexto está ativo:  
    ```bash
    kubectl config current-context
    ```

5. (Opcional) Mude para o contexto/cluster desejado (caso tenha mais de um cluster):  
    ```bash
    kubectl config use-context kind-meu-cluster
    ```

6. Execute o Terraform para provisionar namespace e fazer deploy do Helm chart:  
    ```bash
    terraform init
    terraform apply
    ```

7. Verifique o deploy:  
    ```bash
    kubectl get pods -n nginx-terraform
    kubectl get svc -n nginx-terraform
    ```

---

Se os pods estiverem em status `Running` e os serviços criados, seu deploy foi realizado com sucesso!  
A partir daqui, você pode acessar sua aplicação via Kubernetes ou continuar evoluindo seu pipeline CI/CD.

---
> 📘 Projeto para fins de estudo e demonstração de boas práticas DevOps.
