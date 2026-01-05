{% macro generate_audit_hash(columns) %}
    -- Generates a consistent MD5/SHA256 hash for audit reconciliation
    {{ dbt_utils.surrogate_key(columns) }}
{% endmacro %}
