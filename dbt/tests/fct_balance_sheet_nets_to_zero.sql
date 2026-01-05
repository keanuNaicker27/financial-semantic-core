-- The total of all G/L entries must always be zero in a double-entry system
SELECT
    SUM(amount) as total_balance
FROM {{ ref('int_rgs_standardization') }}
HAVING ABS(SUM(amount)) > 0.001 -- Allowing for minor rounding diffs
