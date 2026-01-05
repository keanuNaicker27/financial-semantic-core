# Financial Data Lifecycle (S10 -> S50)

This repository follows the **Medallion Architecture** to transform raw Dynamics 365 Business Central data into RGS-standardized audit trails.


## [S10] Staging Layer (Bronze)
* **Purpose:** Raw ingestion from Business Central OData APIs.
* **Logic:** Minimal transformation. Column renaming for readability and data type casting (e.g., converting proprietary BC date formats to standard SQL timestamps).
* **Persistence:** View-only in Dev; Table-backed in Prod for lineage.

## [S30] Intermediate Layer (Silver)
* **Purpose:** The **Standardization Engine**.
* **Logic:** * **RGS Mapping:** Joins the `gl_entries` with the `seed_rgs_mapping` table.
    * **Deduplication:** Handling BC's "Close Income Statement" entries to avoid double-counting.
    * **Currency Normalization:** All amounts converted to EUR based on daily ECB rates.
* **Constraint:** Every record must have a valid RGS Level 4 reference.

## [S50] Marts Layer (Gold)
* **Purpose:** Auditor-Ready Data Products.
* **Logic:** Aggregated views (Balance Sheet, P&L) and the **Continuous Auditor Export**.
* **Format:** Optimized for Parquet export to the AWS Audit Vault via the Cloud Mesh.

## Diagram
```mermaid
 graph LR
    subgraph "S10 - Bronze (Staging)"
        BC[BC OData] -->|Ingest| STG[stg_bc_gl_entries]
    end

    subgraph "S30 - Silver (Intermediate)"
        STG -->|RGS Mapping| RGS[int_rgs_standardization]
        SEED[(RGS 3.5 Seed)] --> RGS
    end

    subgraph "S50 - Gold (Marts)"
        RGS -->|Validation| AUD[fct_auditor_export]
        RGS -->|Agg| PNL[fct_profit_loss]
    end

    subgraph "Sentinel Integration"
        AUD -.->|Contract Test| SENT[Sentinel Governance]
    end
