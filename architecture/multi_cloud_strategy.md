# Multi-Cloud Portability Strategy

## The Philosophy: "Logic is Independent of Infrastructure"
To avoid vendor lock-in and high migration costs, this semantic core is designed to be **Cloud-Agnostic**. The core IP (SQL transformations and RGS mapping logic) lives in **dbt**, while the orchestration is handled by native cloud services.

## The Integration Blueprints

### 1. Azure (Primary Production)
* **Engine:** Azure SQL / Synapse.
* **Orchestration:** Azure Data Factory (ADF) triggers dbt-core running in an Azure Container Instance (ACI).
* **Identity:** Managed Identity for passwordless connection.

### 2. AWS (Compliance & DR)
* **Engine:** AWS Athena / Redshift.
* **Orchestration:** AWS Glue Python Shell running dbt-core.
* **Reasoning:** Leveraging S3 for low-cost, immutable storage of historical audit trails (WORM).

### 3. GCP (Analytics & ML)
* **Engine:** BigQuery.
* **Orchestration:** Cloud Workflows + Cloud Run.
* **Reasoning:** Utilizing BigQuery's native ML capabilities for financial anomaly detection.

## Portability Guarantees
- **SQL Dialect:** We utilize `dbt-utils` cross-database macros to ensure logic runs on T-SQL (Azure) and Postgres/Redshift (AWS) with zero code changes.
- **Data Contracts:** Every layer is governed by YAML schemas, ensuring that even if the database changes, the **Schema Contract** remains fixed.

## Diagram
```mermaid
graph TD
    subgraph "DBT CORE (The Brain)"
        DBT[Semantic Models & RGS Mapping]
    end

    subgraph "Azure Environment"
        ADF[Azure Data Factory] -->|Triggers| DBT
        DBT -->|Writes| SQL[(Azure SQL)]
    end

    subgraph "AWS Environment"
        GLUE[AWS Glue] -->|Triggers| DBT
        DBT -->|Writes| ATH[(Athena/S3)]
    end

    subgraph "GCP Environment"
        WRK[GCP Workflows] -->|Triggers| DBT
        DBT -->|Writes| BQ[(BigQuery)]
    end
