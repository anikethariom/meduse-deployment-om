
# Medusa Backend Deployment Project

## Overview

This project demonstrates the deployment of the Medusa open-source headless commerce platform using AWS services such as ECS Fargate, RDS for PostgreSQL, and an Elastic Load Balancer. The infrastructure is managed using Terraform, and the CI/CD pipeline is configured using GitHub Actions.

## Project Structure

- `.github/workflows/deploy.yml`: GitHub Actions workflow to automate deployment.
- `terraform/`: Contains all Terraform configuration files.
  - `main.tf`: Main Terraform configuration file that ties all resources together.
  - `provider.tf`: AWS provider configuration.
  - `ecs.tf`: ECS cluster, task definitions, and service configuration.
  - `rds.tf`: RDS PostgreSQL database setup.
  - `elb.tf`: Elastic Load Balancer configuration.
- `medusa-backend/`: Medusa backend configuration, including Dockerfile, package.json, and Medusa-specific files.
- `README.md`: This documentation file.

## Deployment Steps

### Step 1: Setting Up the Environment

1. **Clone the repository** to your local machine or server:
   ```bash
   git clone https://github.com/anikethariom/medusa-deployment-om.git
   cd medusa-deployment-om
