{{ config(
    materialized='table',
    tags=['audit_ready']
) }}

SELECT
    entry_no,
    posting_date,
    rgs_code,
    rgs_label_nl,
    amount,
    -- Staff move: Adding a hash for "Immutable Identity"
    -- This ensures the auditor can verify if a record was tampered with
    {{ dbt_utils.generate_surrogate_key(['entry_no', 'amount', 'posting_date']) }} as record_fingerprint
FROM {{ ref('int_rgs_standardization') }}
WHERE rgs_code IS NOT NULL
