{{ config(
    description="Maps Business Central G/L Entries to SAS 3.5 standardized codes."
) }}

WITH gl_entries AS (
    SELECT * FROM {{ ref('stg_bc_gl_entries') }}
),

sas_mapping AS (
    SELECT * FROM {{ ref('seed_sas_mapping_v35') }}
)

SELECT
    -- Dimensions
    e.entry_no,
    e.posting_date,
    e.document_no,
    
    -- Business Central Context
    e.gl_account_no AS internal_account_code,
    e.description AS internal_description,

    -- sas Mapping (The Standardization)
    m.sas_code,
    m.sas_label_nl,
    m.sas_category, -- e.g., 'Activa', 'Passiva', 'Baten'

    -- Financial Measures
    e.amount,
    e.debit_amount,
    e.credit_amount,
    
    -- Audit Metadata
    {{ dbt_utils.generate_surrogate_key(['e.entry_no', 'm.sas_code']) }} as audit_hash_id

FROM gl_entries e
LEFT JOIN sas_mapping m 
    ON e.gl_account_no = m.internal_account_no

-- Flagging unmapped accounts for the Data Quality team
WHERE m.sas_code IS NOT NULL 
   OR e.amount != 0
