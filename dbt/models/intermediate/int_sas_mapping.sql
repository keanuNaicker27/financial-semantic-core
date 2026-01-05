{{ config(
    materialized='table',
    unique_key='sas_audit_id',
    description="Maps proprietary ERP Ledger entries to the Global Standardized Audit Schema (SAS)."
) }}

WITH stg_entries AS (
    -- Import the cleaned raw ledger data from Business Central
    SELECT * FROM {{ ref('stg_bc_gl_entries') }}
),

sas_reference AS (
    -- Import the Standardized Audit Schema mapping from our seed file
    SELECT * FROM {{ ref('seed_sas_mapping_v1') }}
)

SELECT
    -- 1. Unique Identification & Audit Lineage
    -- Generating a unique hash for every mapped transaction to ensure immutability
    {{ dbt_utils.generate_surrogate_key([
        'e.entry_no', 
        'm.sas_code'
    ]) }} AS sas_audit_id,
    
    e.entry_no AS source_transaction_id,
    e.posting_date,
    e.document_no,

    -- 2. SAS Standardization Layer
    -- This is where proprietary ERP codes are converted to global audit codes
    m.sas_code,
    m.sas_label_en,
    m.sas_category,
    
    -- 3. Financial Logic & Normalization
    -- We ensure the amount is clearly defined for downstream financial reports
    e.gl_account_no AS internal_account_code,
    e.amount AS amount_base_currency,
    
    -- 4. Governance Metadata
    -- Flagging when this transformation occurred for the audit trail
    CURRENT_TIMESTAMP AS standardized_at,
    '{{ invocation_id }}' AS dbt_run_id

FROM stg_entries e
INNER JOIN sas_reference m 
    ON e.gl_account_no = m.internal_account_no

/* ARCHITECT NOTE: 
  We use an INNER JOIN here to ensure the S30 layer only contains 
  validated, mapped financial data. Any unmapped accounts are 
  captured by the 'adhoc_sas_gap_analysis' query for the finance team.
*/
