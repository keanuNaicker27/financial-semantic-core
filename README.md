# Financial-Semantic-Core

### **The Global Standard for Automated Financial Governance**

## Overview

The **Financial-Semantic-Core** is the intelligence layer of the Sentinel ecosystem. It transforms fragmented, proprietary ERP data (e.g., Dynamics 365) into a unified, **Auditor-Ready** data model.

By implementing the **Standardized Audit Schema (SAS)**, this repository ensures that financial data is portable, transparent, and compliant across any cloud environment (**Azure, AWS, or GCP**).

---

## Architecture: The "Logic-First" Philosophy

To eliminate vendor lock-in, we decouple **Transformation Logic** from the **Cloud Infrastructure**.

* **Core Engine:** Powered by `dbt`, treating SQL as a first-class software engineering citizen.
* **Medallion Structure:**
* **S10 (Bronze):** Raw ERP ingestion and schema normalization.
* **S30 (Silver):** The **SAS Mapping Engine** (Normalizing local G/L accounts to Global Standards).
* **S50 (Gold):** Immutable Audit Trails with built-in SHA-256 record hashing.


* **Portability:** Includes "Cloud Blueprints" to deploy the same logic across **Azure Data Factory**, **AWS Glue**, and **GCP Workflows**.

---

## Governance & Security

This repository is the "Source of Truth" for the **Sentinel Governance Engine**.

* **Data Contracts:** Strict YAML-defined schemas ensure the **Continuous Auditor API** never receives malformed data.
* **Audit Integrity:** Every record is assigned a `sas_audit_id` (Surrogate Key), ensuring a perfect lineage from the ERP system to the final report.
* **Automatic Quality Gates:** Custom SQL tests prevent the "Gold" layer from populating if the balance sheet doesn't net to zero.

---

## Repository Structure

* **`/dbt`**: The heart of the transformation logic and SAS mapping.
* **`/integration-blueprints`**: Ready-to-use orchestration templates for **Azure, AWS, and GCP**.
* **`/docs`**: Comprehensive **SAS Mapping Specs** and **Auditor API** documentation.
* **`/architecture`**: Mermaid diagrams detailing the medallion data flow and multi-cloud strategy.

---

## Quick Start

This project uses a `Makefile` to simplify the developer experience:

```bash
# 1. Install dbt dependencies
make install

# 2. Build the SAS core (Seed, Run, Test)
make build

# 3. View the generated Data Dictionary
make docs

# 4. Run multi-cloud validation
make run-azure  # or make run-aws

```

---

## The "Golden Trio" Portfolio

This project is part of a 3-tier enterprise ecosystem:

1. **[Cloud-Infrastructure-Mesh]**: The Secure Multi-Cloud Vessel (IaC).
2. **[Sentinel-Governance-Engine]**: The Security & FinOps Guard (Python).
3. **[Financial-Semantic-Core]**: The Standardized Business Value (SAS/dbt).

