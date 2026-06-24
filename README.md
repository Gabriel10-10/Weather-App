# Remix Weather App — Cloud DevOps Pipeline

A fully automated CI/CD pipeline for deploying a containerized Remix Weather Application to Azure Kubernetes Service (AKS), with Terraform managing all infrastructure as code and GitHub Actions driving every stage of the pipeline.

---

## Key Capabilities

- **Terraform IaC** — Provisions Azure infrastructure (AKS cluster, ACR, networking)
- **Static Analysis** — `fmt`, `validate`, and `tfsec` run on every push
- **Linting & Planning** — `tflint` and `terraform plan` run on pull requests to `main`
- **Apply on Merge** — `terraform apply` runs automatically when PRs merge to `main`
- **Docker Build & Push** — App image built and pushed to ACR, tagged with commit SHA
- **AKS Deployment** — Deploys to **test** on PR, **production** on merge to `main`

---

## GitHub Actions Workflows

### 1. `terraform-static-analysis.yml` — Static Code Analysis
**Trigger:** Push to any branch

- `terraform fmt` — enforces formatting standards
- `terraform validate` — checks configuration validity
- `tfsec` — scans for security misconfigurations

### 2. `terraform-plan.yml` — Lint & Plan
**Trigger:** Pull request to `main`

- `tflint` — lints Terraform files for best practices and provider-specific rules
- `terraform plan` — previews infrastructure changes before merge

### 3. `terraform-apply.yml` — Apply Infrastructure
**Trigger:** Push to `main` (merged pull request)

- Runs `terraform apply -auto-approve` to provision or update Azure infrastructure

### 4. `docker-build-push.yml` — Build & Push Docker Image
**Trigger:** Pull request to `main`, only when application code changes (`app/**`)

- Builds the Docker image and pushes it to Azure Container Registry (ACR)
- Tags the image with the commit SHA (e.g., `weatherapp:abc1234`)

### 5. `deploy.yml` — Deploy to AKS
**Trigger:** Application code changes (`app/**`) only

- **Test environment** → on pull request to `main`
- **Production environment** → on push to `main`

---

## Setup

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AZURE_CREDENTIALS` | Service principal JSON for Azure authentication |
| `ACR_LOGIN_SERVER` | ACR hostname (e.g., `myregistry.azurecr.io`) |
| `ACR_USERNAME` | ACR admin username |
| `ACR_PASSWORD` | ACR admin password |
| `AKS_CLUSTER_NAME` | Name of the AKS cluster |
| `AKS_RESOURCE_GROUP` | Resource group containing the AKS cluster |
| `ARM_CLIENT_ID` | Azure service principal client ID (for Terraform) |
| `ARM_CLIENT_SECRET` | Azure service principal secret (for Terraform) |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure tenant ID |

### Terraform Backend

Remote state is stored in an Azure Storage Account. Update the backend config in `terraform/` to point to your storage account and container before running any workflows.

---

## Running the Pipeline

1. **Open a PR** to `main` — triggers static analysis, tflint, terraform plan, Docker build, and test deployment
2. **Merge the PR** — triggers terraform apply and production deployment
3. **Push to any branch** — triggers static analysis only

> Workflows are path-filtered so infrastructure-only changes do not trigger app deployments and vice versa.

---

## Screenshots

**Actions workflows**

![Actions workflows](https://github.com/user-attachments/assets/dc98a47e-a93d-43f9-a50f-c5b3c540b6cf)

**AKS LoadBalancer External IP**

![AKS LoadBalancer](https://github.com/user-attachments/assets/df867271-c2c4-409a-aa70-8b866e2b6204)

**Test Environment**

![Test Environment](https://github.com/user-attachments/assets/454e9308-70d4-44ce-8e04-d5d6ec947e77)

---

## Cleanup

```bash
cd terraform/
terraform destroy -auto-approve
```

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-static-analysis.yml
│       ├── terraform-plan.yml
│       ├── terraform-apply.yml
│       ├── docker-build-push.yml
│       └── deploy.yml
├── app/          # Remix Weather Application source
├── terraform/    # Terraform infrastructure code
├── k8s/          # Kubernetes manifests (test + prod)
└── README.md
```

## Tech Stack

`Terraform` `GitHub Actions` `Docker` `Azure Kubernetes Service` `Azure Container Registry` `tfsec` `tflint` `Remix` `Node.js`
