{{ config(materialized="table") }}

select
    customer_id,
    trim(upper(first_name)) as first_name,
    trim(upper(last_name)) as last_name,
    lower(trim(email)) as email,
    to_date(signup_date) as signup_date,
    case
        when subscription_type = 'Premium'
        then 'PREMIUM'
        when subscription_type = 'Standard'
        then 'STANDARD'
        when subscription_type = 'Basic'
        then 'BASIC'
        else 'UNKNOWN'
    end as subscription_type_clean,
    current_timestamp() as processed_at
from {{ source("raw_data", "raw_customers") }}
where email is not null
