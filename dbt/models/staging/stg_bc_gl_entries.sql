{{ config(materialized='view') }}

WITH raw_source AS (
    SELECT * FROM {{ source('business_central', 'gl_entries') }}
)

SELECT
    -- Casting proprietary types to standard SQL types
    CAST("Entry_No_" AS INT) as entry_no,
    CAST("Posting_Date" AS DATE) as posting_date,
    "Document_No_" as document_no,
    "G_L_Account_No_" as gl_account_no,
    "Description" as description,
    
    -- Normalizing amounts (BC often stores these as separate signs)
    CAST("Amount" AS DECIMAL(18,4)) as amount,
    CAST("Debit_Amount" AS DECIMAL(18,4)) as debit_amount,
    CAST("Credit_Amount" AS DECIMAL(18,4)) as credit_amount,
    
    -- Metadata for lineage
    CURRENT_TIMESTAMP as ingested_at
FROM raw_source
