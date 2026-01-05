# Auditor API & Data Handoff Specification

## Handoff Architecture
Standardized data is pushed from the **S50 (Gold)** layer to the **AWS Audit Vault** in **Parquet** format. This ensures high compression and schema enforcement.

## Schema Definition (S50_Audit_Trail)

| Field | Type | Description | Sample Value |
| :--- | :--- | :--- | :--- |
| `event_id` | UUID | Unique hash of the transaction | `550e8400-e29b...` |
| `posting_date` | ISO8601 | Date of entry | `2024-03-15` |
| `sas_code` | String | Standardized SAS v3.5 code | `BEveVrdVor` |
| `amount_eur` | Decimal | Value in EUR (normalized) | `1250.50` |
| `fingerprint` | SHA256 | Immutable record signature | `a3f2b1...` |

## Integrity Guarantee
Every export includes a `manifest.json` containing:
1.  **Row Count:** Total records in the batch.
2.  **Control Total:** Sum of all `amount_eur` (must net to zero for G/L exports).
3.  **Merkle Root:** A hash tree of all transaction signatures to detect mid-flight tampering.
