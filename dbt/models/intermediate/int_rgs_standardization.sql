{{ config(
    description="Maps Business Central G/L Entries to RGS 3.5 standardized codes."
) }}

WITH gl_entries AS (
    SELECT * FROM {{ ref('stg_bc_gl_entries') }}
),

rgs_mapping AS (
    SELECT * FROM {{ ref('seed_rgs_mapping_v35') }}
)

SELECT
    -- Dimensions
    e.entry_no,
    e.posting_date,
    e.document_no,
    
    -- Business Central Context
    e.gl_account_no AS internal_account_code,
    e.description AS internal_description,

    -- RGS Mapping (The Standardization)
    m.rgs_code,
    m.rgs_label_nl,
    m.rgs_category, -- e.g., 'Activa', 'Passiva', 'Baten'

    -- Financial Measures
    e.amount,
    e.debit_amount,
    e.credit_amount,
    
    -- Audit Metadata
    {{ dbt_utils.generate_surrogate_key(['e.entry_no', 'm.rgs_code']) }} as audit_hash_id

FROM gl_entries e
LEFT JOIN rgs_mapping m 
    ON e.gl_account_no = m.internal_account_no

-- Flagging unmapped accounts for the Data Quality team
WHERE m.rgs_code IS NOT NULL 
   OR e.amount != 0
