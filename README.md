# Remix Weather App — Cloud DevOps Pipeline

A fully automated CI/CD pipeline for deploying a Remix-based Weather Application to Azure Kubernetes Service (AKS), using Terraform for infrastructure-as-code and GitHub Actions for all automation.

---

## Team Members

| Name | GitHub |
|------|--------|
| Ahmed Boudouh | [@AhmedBoudouh](https://github.com/AhmedBoudouh) |
| Soufiane Mouss | [@SoufianeMouss](https://github.com/SoufianeMouss) |
| Damis Gabriel Manfouo | [@Gabriel10-10](https://github.com/Gabriel10-10) |
| Ramy Maarouf | [@RamyMaarouf](https://github.com/RamyMaarouf) |

---

## Project Overview

This project provisions and deploys a containerized Remix Weather Application using a fully automated GitHub Actions CI/CD pipeline. Infrastructure is managed with Terraform and hosted on Azure (AKS + ACR).

### Key Capabilities

- **Terraform IaC** — Provisions Azure infrastructure (AKS cluster, ACR, networking)
- **Static Analysis** — `fmt`, `validate`, and `tfsec` run on every push
- **Linting & Planning** — `tflint` and `terraform plan` run on pull requests to `main`
- **Apply on Merge** — `terraform apply` runs automatically when PRs merge to `main`
- **Docker Build & Push** — Weather App image is built and pushed to ACR on PR (tagged with commit SHA)
- **AKS Deployment** — App deploys to **test** on PR, **production** on merge to `main`

---

## GitHub Actions Workflows

### 1. `terraform-static-analysis.yml` — Static Code Analysis
**Trigger:** Push to any branch

Runs the following checks against all Terraform code:
- `terraform fmt` — enforces formatting standards
- `terraform validate` — checks configuration validity
- `tfsec` — scans for security misconfigurations

---

### 2. `terraform-plan.yml` — Lint & Plan
**Trigger:** Pull request to `main`

- `tflint` — lints Terraform files for best practices and provider-specific rules
- `terraform plan` — previews infrastructure changes before merge

---

### 3. `terraform-apply.yml` — Apply Infrastructure
**Trigger:** Push to `main` (i.e., merged pull request)

- Runs `terraform apply -auto-approve` to provision or update Azure infrastructure

---

### 4. `docker-build-push.yml` — Build & Push Docker Image
**Trigger:** Pull request to `main`, only when application code changes (`app/**`)

- Builds the Remix Weather App Docker image
- Pushes the image to Azure Container Registry (ACR)
- Tags the image with the commit SHA (e.g., `weatherapp:abc1234`)

---

### 5. `deploy.yml` — Deploy to AKS
**Trigger:** Application code changes only (`app/**`)
- **Test environment** → on pull request to `main`
- **Production environment** → on push to `main` (merged PR)

Deploys the tagged Docker image to the appropriate AKS namespace using `kubectl`.

---

## Prerequisites & Setup

### Required GitHub Secrets

Configure the following secrets in your repository (`Settings → Secrets and variables → Actions`):

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

Remote state is stored in an Azure Storage Account. Ensure the backend config in `terraform/` points to your storage account and container before running any workflows.

---

## Running the Pipeline

1. **Open a PR** to `main` — triggers static analysis, tflint, terraform plan, Docker build, and test deployment
2. **Merge the PR** — triggers terraform apply and production deployment
3. **Push directly to any branch** — triggers static analysis only

> All workflows are path-filtered where applicable so that infrastructure-only changes don't trigger app deployments and vice versa.

---

## Workflow Screenshots

[Actions workflows]<img width="1920" height="939" alt="Screenshot 2026-04-22 at 10 23 29 AM" src="https://github.com/user-attachments/assets/dc98a47e-a93d-43f9-a50f-c5b3c540b6cf" />

[AKS LoadBalancer External IP]<img width="944" height="371" alt="image" src="https://github.com/user-attachments/assets/df867271-c2c4-409a-aa70-8b866e2b6204" />

[Test Environment]<img width="1264" height="930" alt="image (2)" src="https://github.com/user-attachments/assets/454e9308-70d4-44ce-8e04-d5d6ec947e77" />

---

## Clean Up

Once you have submitted your project, delete all Azure resources to avoid overuse charges:

```bash
# Destroy all Terraform-managed resources
cd terraform/
terraform destroy -auto-approve
```

Or delete the resource group directly from the Azure Portal / CLI:

```bash
az group delete --name <your-resource-group> --yes --no-wait
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
├── app/                  # Remix Weather Application source
├── terraform/            # Terraform infrastructure code
├── k8s/                  # Kubernetes manifests (test + prod)
└── README.md
```

---

*CST8918 — DevOps: Infrastructure as Code | Algonquin College*
