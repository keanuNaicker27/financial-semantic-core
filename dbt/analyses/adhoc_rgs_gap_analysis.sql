-- This query identifies G/L accounts currently in use in BC 
-- that have NOT yet been mapped to an RGS code.
-- Output used by the Finance Team to update the mapping seed.

SELECT 
    gl_account_no, 
    description, 
    SUM(amount) as unmapped_volume
FROM {{ ref('stg_bc_gl_entries') }}
LEFT JOIN {{ ref('seed_rgs_mapping_v35') }} rgs
    ON gl_account_no = rgs.internal_account_no
WHERE rgs.rgs_code IS NULL
GROUP BY 1, 2
HAVING SUM(amount) != 0
