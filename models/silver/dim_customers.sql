{{ config(materialized='table') }}

SELECT
    customer_id,
    TRIM(UPPER(first_name)) as first_name,
    TRIM(UPPER(last_name)) as last_name,
    LOWER(TRIM(email)) as email,
    TO_DATE(signup_date) as signup_date,
    CASE
        WHEN subscription_type = 'Premium' THEN 'PREMIUM'
        WHEN subscription_type = 'Standard' THEN 'STANDARD'  
        WHEN subscription_type = 'Basic' THEN 'BASIC'
        ELSE 'UNKNOWN'
    END as subscription_type_clean,
    CURRENT_TIMESTAMP() as processed_at
FROM {{ source('raw_data', 'raw_customers') }}
WHERE email IS NOT NULL
